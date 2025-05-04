return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- auto show blame at EOL
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 300,
			ignore_whitespace = false,
		},
		-- include time after the date:
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d %H:%M> • <summary>",

		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- your existing mappings…
			map("n", "]h", gs.next_hunk, "Next Hunk")
			map("n", "[h", gs.prev_hunk, "Prev Hunk")
			map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage Hunk (visual)")
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset Hunk (visual)")
			map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
			map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
			map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
			map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
			map("n", "<leader>hd", gs.diffthis, "Diff This")
			map("n", "<leader>hD", function()
				gs.diffthis("~")
			end, "Diff This ~")
			map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle Blame")
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
		end,
	},
}
