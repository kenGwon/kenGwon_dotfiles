-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  pattern = { "*" },                -- 모든 파일 확장자에 대하여 적용
  callback = function()
    vim.opt_local.tabstop = 4       -- 실제 탭 폭 (tab 문자 폭)
    vim.opt_local.shiftwidth = 4    -- 자동 들여쓰기 폭
    vim.opt_local.softtabstop = 4   -- 탭 키 누를 때 공백 크기
    vim.opt_local.expandtab = false -- 탭을 스페이스로 변환하지 않음 (탭문자 사용)
  end,
})

vim.g.autoformat = false -- neovim auto formatting 비활성화

vim.opt.list = false -- 탭/공백 특수문자 표시 비활성화
vim.opt.ttimeoutlen = 10 -- Esc 키 딜레이 최소화
