require "nvchad.autocmds"

-- создаём группу (без pattern/callback)
local gofmt_group = vim.api.nvim_create_augroup("GoFmt", { clear = true })

-- создаём автокоманду в этой группе
vim.api.nvim_create_autocmd("BufWritePre", {
  group = gofmt_group,
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- грузит плагин tinygo.nvim только если есть "tiny" надпись в открытом файле
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" },{
  pattern = "*.go",
  callback = function()
    local filename = vim.fn.expand("%:t")
    if filename:match("tiny") then
      require("lazy").load({plugins = { "tinygo.nvim" }})
    end
  end,
})
