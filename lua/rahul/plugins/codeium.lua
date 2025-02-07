return {
  "Exafunction/codeium.nvim",
  config = function()
    require("codeium").setup({
      -- configurable options
      virtual_text = {
        enabled = true
      }
    })
  end
}
