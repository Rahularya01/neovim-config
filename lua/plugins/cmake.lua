return {
	"Civitasv/cmake-tools.nvim",
	event = "VeryLazy",
	opts = {
		cmake_build_directory = "build",
		cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
		cmake_build_options = {},
		cmake_console_size = 10, -- 10 lines
		cmake_show_console = "always", -- "always", "only_on_error"
		cmake_dap_configuration = { -- debug settings for cmake
			name = "cpp",
			type = "codelldb",
			request = "launch",
			stopOnEntry = false,
			runInTerminal = true,
			console = "integratedTerminal",
		},
	},
	keys = {
		{ "<leader>cg", "<cmd>CMakeGenerate<CR>", desc = "CMake Generate" },
		{ "<leader>cb", "<cmd>CMakeBuild<CR>", desc = "CMake Build" },
		{ "<leader>cr", "<cmd>CMakeRun<CR>", desc = "CMake Run" },
		{ "<leader>cd", "<cmd>CMakeDebug<CR>", desc = "CMake Debug" },
	},
}
