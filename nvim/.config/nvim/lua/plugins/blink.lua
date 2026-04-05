return {
  {
    "saghen/blink.cmp",
    opts = {
      -- blink.cmp의 cmdline 자동완성 비활성화
      -- → 네이티브 vim wildmenu(bash 스타일)가 동작하도록
      cmdline = {
        enabled = false,
      },
    },
  },
}
