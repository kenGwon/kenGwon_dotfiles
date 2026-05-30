return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      picker = {
        sources = {
          files = {
            hidden = true,
            no_ignore = true,
          },
          grep = {
            hidden = true,
            no_ignore = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
