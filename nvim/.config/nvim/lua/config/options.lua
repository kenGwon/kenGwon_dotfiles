-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- background를 명시하지 않으면 nvim이 시작 시 OSC 10/11로 터미널에 색상을 질의함.
-- tmux + SSH 환경에서는 이 질의의 응답이 왕복 지연으로 인해 nvim 종료 후에 도착해
-- bash 프롬프트에 raw 이스케이프 문자열이 그대로 찍히는 문제가 있었음. 질의 자체를
-- 막기 위해 명시적으로 지정 (colorscheme.lua의 vscode.nvim style = "dark"와 일치).
vim.opt.background = "dark"

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
vim.g.lazyvim_fix_whitespace = false -- 저장 시 trailing whitespace 자동 제거 비활성화

vim.opt.clipboard = "unnamedplus"		-- 시스템 클립보드 동기화
vim.opt.list = false -- 탭/공백 특수문자 표시 비활성화
vim.opt.ttimeoutlen = 10 -- Esc 키 딜레이 최소화

vim.opt.wildmenu = true                   -- wildmenu 활성화
vim.opt.wildmode = "list:longest,list"    -- bash처럼: 목록 표시 + 최장 공통 매치, 그 다음 탭은 재목록
vim.opt.wildoptions = "fuzzy"             -- fuzzy 매칭 활성화 (pum 제거: 팝업 순회 방식 비활성화)
