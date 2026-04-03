-- bootstrap lazy.nvim, LazyVim and your plugins

vim.opt.clipboard = "unnamed,unnamedplus" --시스템 클립보드 사용

vim.opt.number = true          -- 절대 라인 넘버 표시
vim.opt.relativenumber = true  -- 상대적 라인 넘버 (점프 시 유용)

require("config.lazy")
require("config.keymaps")
