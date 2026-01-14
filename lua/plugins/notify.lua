return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	priority = 1000, -- Load early to replace default notifications
	config = function()
		-- Function to get background color, with fallback
		local function get_bg_color()
			-- Try to get from Normal highlight group
			local ok, hl = pcall(vim.api.nvim_get_hl_by_name, "Normal", true)
			if ok and hl.background then
				return string.format("#%06x", hl.background)
			end
			-- Try to get from NormalFloat (often used for floating windows)
			ok, hl = pcall(vim.api.nvim_get_hl_by_name, "NormalFloat", true)
			if ok and hl.background then
				return string.format("#%06x", hl.background)
			end
			-- Fallback to terminal background or black
			return "#000000"
		end

		require("notify").setup({
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
			stages = "fade_in_slide_out",
			background_colour = get_bg_color(),
		})
		vim.notify = require("notify")
	end,
}
