return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html", -- Ensures html parser is installed for problem descriptions
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim", -- required by telescope
		"MunifTanjim/nui.nvim",

		-- optional
		"nvim-treesitter/nvim-treesitter",
		"rcarriga/nvim-notify", -- Nice notifications for LeetCode
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- Change this to your preferred language (e.g., "cpp", "java", "golang", "python3")
		lang = "cpp",

		-- Domain to use: "com" or "cn"
		domain = "com",

		-- Argument to pass when launching directly (nvim --cmd "let g:leetcode_arg='leetcode.nvim'")
		arg = "leetcode.nvim",

		-- Directory where questions will be stored
		directory = vim.fn.stdpath("data") .. "/leetcode",

		-- Console logging
		logging = true,

		injector = {
			-- Inject specific setup for your language here if needed
			["python3"] = {
				before = true,
			},
			["cpp"] = {
				before = { "#include <bits/stdc++.h>", "using namespace std;" },
				after = "int main() { return 0; }",
			},
		},
	},
}
