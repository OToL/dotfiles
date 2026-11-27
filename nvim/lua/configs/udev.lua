local M = {}
local label -- cached M.preset_label() text

M.setup = function()
    -- UnrealDev passes this config on to the suite modules:
    -- it silences all logging by default, UBT/UCM read their own .ubtrc/.ucmrc instead of the shared .unlrc.json,
    -- and pickers default to telescope, too slow for the ~150k engine files
    require("UnrealDev").setup({
        logging = { level = "info", echo = { level = "warn" }, notify = { level = "error" } },
        project = { localrc_filename = ".unlrc.json" },
        ui = { picker = { mode = "fzf-lua" }, grep_picker = { mode = "fzf-lua" } },
    })

    -- workspace revision for UNL's auto-refresh, queried on every BufReadPost: keep it for git (rev-parse is cheap);
    -- elsewhere UNL falls through to svn and `p4 changes -m1 #have` (a full have-list scan, 15-20s here),
    -- so skip it: refresh manually with :UNL refresh after syncing
    local vcs = require("UNL.vcs")
    local get_current_hash = vcs.get_current_hash
    vcs.get_current_hash = function(root)
        if root and vim.fs.root(root, ".git") then return get_current_hash(root) end
        return nil
    end

    -- the scanner (unl-server) checks the workspace revision itself with `p4 changes -m1 -s submitted <root>/...`,
    -- the latest submit by anyone, so nearly every refresh takes its "incremental game refresh" path, which returns
    -- before the engine walk: start it without p4 on PATH so it falls back to a full, mtime-based walk
    local jobstart = vim.fn.jobstart
    vim.fn.jobstart = function(cmd, opts)
        if type(cmd) == "table" and tostring(cmd[1]):match("unl%-server[^/\\]*$") then
            local is_win = vim.fn.has("win32") == 1
            local sep, exe = is_win and ";" or ":", is_win and "p4.exe" or "p4"
            local dirs = vim.tbl_filter(function(dir)
                return not vim.uv.fs_stat(vim.fs.joinpath(dir, exe))
            end, vim.split(vim.env.PATH or "", sep, { trimempty = true }))
            opts = vim.tbl_extend("force", opts or {}, {
                env = vim.tbl_extend("force", (opts or {}).env or {}, { PATH = table.concat(dirs, sep) }),
            })
        end
        return jobstart(cmd, opts)
    end

    -- workspace root layout (Engine/ + HighballGame/ side by side): UNL only searches parent folders
    -- for a .uproject, so fall back to "uproject" from the workspace .unlrc.json
    local project = require("UNL.finder.project")
    local find_project = project.find_project
    project.find_project = function(start_path, opts)
        local res = find_project(start_path, opts)
        if res then return res end
        local uproject = require("UNL.config").get("UNL").uproject
        if uproject and vim.uv.fs_stat(uproject) then
            uproject = vim.fs.normalize(uproject)
            return { root = vim.fs.dirname(uproject), uproject = uproject }
        end
    end
    -- these call the module's local locate(), not find_project, so route them through the fallback
    project.find_project_root = function(p, o) local r = project.find_project(p, o); return r and r.root end
    project.find_project_file = function(p, o) local r = project.find_project(p, o); return r and r.uproject end
    project.find_from_current_buffer = function(o)
        local path = vim.api.nvim_buf_get_name(0)
        return project.find_project(path ~= "" and path or vim.uv.cwd(), o)
    end

    -- macOS: UNL has no engine lookup; offer the cwd if it is an engine root,
    -- else engine_path from the workspace .unlrc.json
    local installed = require("UNL.finder.engine_installed")
    local find = installed.find
    installed.find = function()
        local engines = find()
        local path = vim.fn.isdirectory("Engine") == 1 and vim.fn.getcwd() or require("UEP.config").get().engine_path
        if path then
            table.insert(engines, 1, { version = "", path = path, type = "Source", label = "Workspace engine" })
        end
        return engines
    end

    -- side-by-side projects: UNL only looks for an engine in the project's parent folders unless
    -- given an override, which most callers omit; use engine_path from the workspace .unlrc.json
    local engine = require("UNL.finder.engine")
    local find_engine_root = engine.find_engine_root
    engine.find_engine_root = function(uproject, opts)
        opts = opts or {}
        opts.engine_override_path = opts.engine_override_path or require("UNL.config").get("UNL").engine_path
        return find_engine_root(uproject, opts)
    end

    -- UBT's launch.sh needs dotnet on PATH and a prebuilt UBT; run the engine's RunUBT.sh instead
    -- (cmd = { launch.sh, engine_root, ubt args... })
    local runner = require("UBT.job.runner")
    local start = runner.start
    runner.start = function(name, cmd, opts)
        if cmd[1]:match("launch%.sh$") then
            cmd = vim.list_extend({ cmd[2] .. "/Engine/Build/BatchFiles/RunUBT.sh" }, cmd, 3)
        end
        return start(name, cmd, opts)
    end

    -- UBT records sources using UE_INLINE_GENERATED_CPP_BY_NAME under their .gen.cpp:
    -- point those entries back to the real source (listed at the end of the entry's response file),
    -- then restart clangd to load the new database
    require("UNL.event.events").subscribe(require("UNL.event.types").ON_AFTER_GENERATE_COMPILE_DATABASE, function(result)
        if not result.success then return end
        local db_path = require("UNL.finder").project.find_project_root(vim.uv.cwd()) .. "/compile_commands.json"
        local db = vim.json.decode(table.concat(vim.fn.readfile(db_path), "\n"))
        for _, entry in ipairs(db) do
            if entry.file:match("%.gen%.cpp$") then
                -- object file is .obj on Windows, .o elsewhere
                local source = vim.fs.basename(entry.output):gsub("%.obj$", ""):gsub("%.o$", "")
                local rsp = io.open(vim.fs.joinpath(entry.directory, entry.command:match('@"(.-)"')))
                if rsp then
                    rsp:seek("end", -math.min(1024, rsp:seek("end")))
                    local path = rsp:read("a"):match('"([^"]*/' .. vim.pesc(source) .. ')"')
                    rsp:close()
                    if path then
                        entry.file = vim.fs.normalize(path:sub(1, 1) == "/" and path or vim.fs.joinpath(entry.directory, path))
                    end
                end
            end
        end
        vim.fn.writefile(vim.split(vim.json.encode(db, { indent = "  " }), "\n"), db_path)
        vim.cmd("lsp restart clangd")
    end)

    -- refresh the statusline preset label when the cwd or the UBT preset changes
    local function refresh()
        label = nil
        vim.cmd.redrawstatus()
    end
    vim.api.nvim_create_autocmd("DirChanged", { callback = refresh })
    local context = require("UBT.context")
    local set = context.set
    context.set = function(...)
        local ok = set(...)
        refresh()
        return ok
    end
end

-- statusline text for the current UBT preset (last used, else preset_target), "" outside an Unreal project;
-- cached since the statusline redraws constantly
M.preset_label = function()
    if not label then
        local ok, preset = pcall(function()
            if require("UNL.finder").project.find_project_root(vim.uv.cwd()) then
                return require("UBT.context").get("last_preset") or require("UNL.config").get("UBT").preset_target
            end
        end)
        label = ok and preset and ("UE " .. preset:gsub(" ", " · ")) or ""
    end
    return label
end

return M
