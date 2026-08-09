return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "t32" },
    },
    init = function()
      -- Trace32 PRACTICE scripts; the t32 parser is registered for filetype "trace32"
      vim.filetype.add({ extension = { cmm = "trace32" } })
    end,
  },
}
