-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 외부에서 파일이 변경되면 자동으로 버퍼에 반영
vim.opt.autoread = true
vim.opt.updatetime = 1000

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- 1초마다 타이머로 checktime 호출 (포커스 이동 없이도 실시간 반영)
local timer = vim.uv.new_timer()
timer:start(1000, 1000, function()
  vim.schedule(function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end)
end)

