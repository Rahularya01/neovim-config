
local vscode = require("vscode")
local map = vim.keymap.set

local function action(name, opts)
  opts = opts or {}
  return function()
    vscode.action(name, opts)
  end
end

map({ "n", "x" }, "<C-h>", action("workbench.action.navigateLeft"), { desc = "Focus left", silent = true })
map({ "n", "x" }, "<C-l>", action("workbench.action.navigateRight"), { desc = "Focus right", silent = true })
map({ "n", "x" }, "<C-j>", action("workbench.action.navigateDown"), { desc = "Focus down", silent = true })
map({ "n", "x" }, "<C-k>", action("workbench.action.navigateUp"), { desc = "Focus up", silent = true })

map(
  { "n", "x" },
  "<S-l>",
  action("workbench.action.nextEditorInGroup"),
  { desc = "Next editor in group", silent = true }
)
map(
  { "n", "x" },
  "<S-h>",
  action("workbench.action.previousEditorInGroup"),
  { desc = "Previous editor in group", silent = true }
)

map("n", "<C-x>", action("workbench.action.closeActiveEditor"), { desc = "Close active editor", silent = true })

map({ "n", "x" }, "<A-S-j>", action("editor.action.moveLinesDownAction"), { desc = "Move lines down", silent = true })
map({ "n", "x" }, "<A-S-k>", action("editor.action.moveLinesUpAction"), { desc = "Move lines up", silent = true })

map({ "n", "x" }, "<C-n>", function()
  vscode.with_insert(function()
    vscode.action("editor.action.addSelectionToNextFindMatch")
  end)
end, { desc = "Add selection to next find match", silent = true })

map(
  { "n", "x" },
  "<C-\\>",
  action("workbench.action.terminal.toggleTerminal"),
  { desc = "Toggle terminal", silent = true }
)

map("n", "gD", action("editor.action.revealDeclaration"), { desc = "Go to declaration", silent = true })
map("n", "gi", action("editor.action.goToImplementation"), { desc = "Go to implementation", silent = true })
map("n", "gr", action("editor.action.goToReferences"), { desc = "Go to references", silent = true })
map("n", "gd", action("editor.action.revealDefinition"), { desc = "Go to definition", silent = true })
map("n", "gy", action("editor.action.goToTypeDefinition"), { desc = "Go to type definition", silent = true })
map("n", "K", action("editor.action.showHover"), { desc = "Hover", silent = true })
map("n", "gl", action("editor.action.showHover"), { desc = "Hover", silent = true })
map("n", "]d", action("editor.action.marker.next"), { desc = "Next diagnostic", silent = true })
map("n", "[d", action("editor.action.marker.prev"), { desc = "Previous diagnostic", silent = true })

map("n", "<leader>w", action("workbench.action.files.save"), { desc = "Save file", silent = true })
map("n", "<leader>bd", action("workbench.action.closeActiveEditor"), { desc = "Close editor", silent = true })
map("n", "<leader>bc", function()
  vscode.call("workbench.action.closeAllEditors")
  vscode.call("workbench.files.action.focusFilesExplorer")
end, {
  desc = "Close all editors",
  silent = true,
})
map("n", "<leader>e", action("workbench.action.toggleSidebarVisibility"), { desc = "Toggle sidebar", silent = true })
map("n", "<leader>ae", action("composer.openModelToggle"), { desc = "Composer model toggle", silent = true })
map("n", "<leader>ff", action("workbench.action.quickOpen"), { desc = "Quick open", silent = true })
map("n", "<leader>.", action("workbench.action.showAllEditors"), { desc = "Show all editors", silent = true })
map("n", "<leader>sg", action("workbench.action.findInFiles"), { desc = "Find in files", silent = true })
map("n", "<leader>/", action("workbench.action.findInFiles"), { desc = "Find in files", silent = true })
map("n", "<leader>s/", action("actions.find"), { desc = "Find in buffer", silent = true })
map("n", "<leader><S-s>", action("workbench.action.replaceInFiles"), { desc = "Replace in files", silent = true })
map("n", "<leader>sp", action("editor.action.startFindReplaceAction"), { desc = "Find replace", silent = true })
map("n", "<leader>cs", action("workbench.action.gotoSymbol"), { desc = "Go to symbol", silent = true })
map("n", "<leader>rn", action("editor.action.rename"), { desc = "Rename symbol", silent = true })
map("n", "<leader>ca", action("editor.action.codeAction"), { desc = "Code action", silent = true })
map("n", "<leader>oi", action("editor.action.sourceAction"), { desc = "Source action", silent = true })
map("n", "<leader>ld", action("editor.action.showHover"), { desc = "Line diagnostics / hover", silent = true })
map("n", "<leader>xx", action("workbench.actions.view.problems"), { desc = "Problems panel", silent = true })
map("n", "<leader>lg", action("workbench.view.scm"), { desc = "Source control", silent = true })
map("n", "<leader>lb", action("git.checkout"), { desc = "Git checkout", silent = true })
map("n", "<leader>hs", action("git.stageSelectedRanges"), { desc = "Stage selected ranges", silent = true })
map("n", "<leader>hr", action("git.revertSelectedRanges"), { desc = "Revert selected ranges", silent = true })
map("n", "<leader>hd", action("git.openChange"), { desc = "Open change", silent = true })
map("n", "<leader>v", action("workbench.action.splitEditorRight"), { desc = "Split editor right", silent = true })
map("n", "<leader>tt", action("workbench.action.terminal.toggleTerminal"), { desc = "Toggle terminal", silent = true })
map("n", "<leader>fr", action("revealFileInOS"), { desc = "Reveal in OS", silent = true })
map("n", "<leader>op", action("opencode.openTerminal"), { desc = "OpenCode terminal", silent = true })
map("n", "<leader>on", action("opencode.openNewTerminal"), { desc = "OpenCode new terminal", silent = true })
map("n", "<leader>oa", action("opencode.addFilepathToTerminal"), { desc = "Add path to terminal", silent = true })
map("n", "<leader>cc", action("chatgpt.openSidebar"), { desc = "ChatGPT sidebar", silent = true })
map("n", "<leader>cf", action("chatgpt.addFileToThread"), { desc = "ChatGPT add file", silent = true })
map("n", "<leader>ct", action("chatgpt.addToThread"), { desc = "ChatGPT add to thread", silent = true })

map("v", "<leader>cf", action("chatgpt.addFileToThread"), { desc = "ChatGPT add file", silent = true })
map("v", "<leader>ct", action("chatgpt.addToThread"), { desc = "ChatGPT add to thread", silent = true })
map("v", "<leader>oa", action("opencode.addFilepathToTerminal"), { desc = "Add path to terminal", silent = true })

map("n", "-", action("oil-code.open"), { desc = "Oil Code open", silent = true })
map("n", "<leader>or", action("oil-code.refresh"), { desc = "Oil Code refresh", silent = true })
map("n", "`", action("oil-code.cd"), { desc = "Oil Code cd", silent = true })
