-- Disable expensive plugins when loading a large file
return {
    'LunarVim/bigfile.nvim',
    event = 'BufReadPre',
    opts = {
        filesize = 100, -- size of the file in MiB, the plugin round file sizes to the closest MiB
    },
    config = function(_, opts)
        require('bigfile').setup(opts)
    end
}
