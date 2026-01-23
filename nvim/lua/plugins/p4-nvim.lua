return {
  'rmccord7/p4.nvim',
  dependencies = {
    'nvim-neotest/nvim-nio', -- Used for async
    'nvim-telescope/telescope.nvim', -- Used for picker
    {
      "ColinKennedy/mega.cmdparse", -- Used for plugin command parsing
      dependencies = { "ColinKennedy/mega.logging" },
      version = "v1.*",
    },
  },
}
