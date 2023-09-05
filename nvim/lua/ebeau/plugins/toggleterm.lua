local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
    size = 30,
    open_mapping = [[<c-`>]],
    autochdir = false,
    hide_numbers = true,
    shade_terminals = true,
	shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = "horizontal",
	close_on_exit = true,
	shell = vim.o.shell,
})