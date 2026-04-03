return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
      transparent = false,
      italic_comments = true,
      group_overrides = {
        -- 전처리기 키워드 (#define, #include, #ifdef 등): 회색
        ["@keyword.directive"]        = { fg = "#808080" },
        ["@keyword.directive.define"] = { fg = "#808080" },
        ["@keyword.import"]           = { fg = "#808080" },
        ["@keyword.import.c"]         = { fg = "#808080" },
        ["@keyword.import.cpp"]       = { fg = "#808080" },
        -- LSP semantic token 전처리기 키워드: 회색
        ["@lsp.type.keyword.c"]       = { fg = "#808080" },
        ["@lsp.type.keyword.cpp"]     = { fg = "#808080" },
        -- label: 흰색
        ["@label"]                    = { fg = "#FFFFFF" },
        ["@label.c"]                  = { fg = "#FFFFFF" },
        ["@label.cpp"]                = { fg = "#FFFFFF" },
        -- constant (enum 값 등): number와 동일한 색상
        ["@constant"]                   = { fg = "#B5CEA8" },
        ["@constant.c"]                 = { fg = "#B5CEA8" },
        ["@constant.cpp"]               = { fg = "#B5CEA8" },
        ["@lsp.type.enumMember.c"]      = { fg = "#B5CEA8" },
        ["@lsp.type.enumMember.cpp"]    = { fg = "#B5CEA8" },
        -- 함수 파라미터: 회색
        ["@variable.parameter"]       = { fg = "#808080" },
        ["@variable.parameter.c"]     = { fg = "#808080" },
        ["@variable.parameter.cpp"]   = { fg = "#808080" },
        ["@lsp.type.parameter.c"]     = { fg = "#808080" },
        ["@lsp.type.parameter.cpp"]   = { fg = "#808080" },
        -- 매크로 이름 (정의 및 사용 시): purple
        ["@lsp.type.macro.c"]         = { fg = "#c1b0d8" },
        ["@lsp.type.macro.cpp"]       = { fg = "#c1b0d8" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
