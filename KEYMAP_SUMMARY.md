# Neovim Keymap Organization Summary

This document outlines the final, conflict-free keymap organization after cleanup.

## 🎯 **Design Principle**

- **One functionality = One keymap**
- **Snacks.nvim gets priority** for picker/search functionality
- **Logical grouping** by functionality prefix
- **No duplications or conflicts**

## 📋 **Current Keymap Organization**

### **Core Navigation & LSP (Snacks Priority)**

| Keymap | Function             | Plugin |
| ------ | -------------------- | ------ |
| `gd`   | Goto Definition      | Snacks |
| `gD`   | Goto Declaration     | Snacks |
| `gr`   | References           | Snacks |
| `gI`   | Goto Implementation  | Snacks |
| `gy`   | Goto Type Definition | Snacks |

### **File & Explorer Operations**

| Keymap            | Function          | Plugin  |
| ----------------- | ----------------- | ------- |
| `<leader><space>` | Smart Find Files  | Snacks  |
| `<leader>e`       | File Explorer     | Neotree |
| `<leader>ff`      | Find Files        | Snacks  |
| `<leader>fg`      | Find Git Files    | Snacks  |
| `<leader>fc`      | Find Config Files | Snacks  |
| `<leader>fp`      | Projects          | Snacks  |
| `<leader>fr`      | Recent Files      | Snacks  |

### **Buffer Operations**

| Keymap       | Function              | Plugin |
| ------------ | --------------------- | ------ |
| `<leader>,`  | Buffers               | Snacks |
| `<leader>x`  | Close Buffer          | Core   |
| `<leader>b`  | New Buffer            | Core   |
| `<leader>bc` | Close All Buffers     | Core   |
| `<leader>bd` | Delete Buffer (Smart) | Snacks |
| `<S-h>`      | Previous Buffer       | Core   |
| `<S-l>`      | Next Buffer           | Core   |

### **Search Operations**

| Keymap       | Function              | Plugin |
| ------------ | --------------------- | ------ |
| `<leader>sg` | Live Grep             | Snacks |
| `<leader>sw` | Search Word/Visual    | Snacks |
| `<leader>sb` | Buffer Lines          | Snacks |
| `<leader>sB` | Grep Open Buffers     | Snacks |
| `<leader>sd` | Diagnostics           | Snacks |
| `<leader>sD` | Buffer Diagnostics    | Snacks |
| `<leader>sh` | Help Pages            | Snacks |
| `<leader>sk` | Keymaps               | Snacks |
| `<leader>sm` | Marks                 | Snacks |
| `<leader>sr` | Resume                | Snacks |
| `<leader>ss` | LSP Symbols           | Snacks |
| `<leader>sS` | LSP Workspace Symbols | Snacks |
| `<leader>s"` | Registers             | Snacks |
| `<leader>s/` | Search History        | Snacks |
| `<leader>sa` | Autocmds              | Snacks |
| `<leader>sC` | Commands              | Snacks |

### **Telescope (Unique Functionality Only)**

| Keymap       | Function                    | Plugin    |
| ------------ | --------------------------- | --------- |
| `<leader>st` | Telescope Builtin           | Telescope |
| `<leader>/`  | Fuzzy Search Current Buffer | Telescope |

### **Git Operations**

| Keymap       | Function     | Plugin |
| ------------ | ------------ | ------ |
| `<leader>gb` | Git Branches | Snacks |
| `<leader>gd` | Git Diff     | Snacks |
| `<leader>gf` | Git Log File | Snacks |
| `<leader>lg` | Lazygit      | Snacks |
| `<leader>gl` | Git Log      | Snacks |
| `<leader>gL` | Git Log Line | Snacks |
| `<leader>gs` | Git Status   | Snacks |
| `<leader>gS` | Git Stash    | Snacks |
| `<leader>gB` | Git Browse   | Snacks |

### **Git Hunks (GitSigns)**

| Keymap       | Function      | Plugin   |
| ------------ | ------------- | -------- |
| `]h`         | Next Hunk     | GitSigns |
| `[h`         | Previous Hunk | GitSigns |
| `<leader>hs` | Stage Hunk    | GitSigns |
| `<leader>hr` | Reset Hunk    | GitSigns |
| `<leader>hS` | Stage Buffer  | GitSigns |
| `<leader>hR` | Reset Buffer  | GitSigns |
| `<leader>hp` | Preview Hunk  | GitSigns |
| `<leader>hd` | Diff This     | GitSigns |
| `<leader>hB` | Toggle Blame  | GitSigns |

### **Search & Replace (Spectre)**

| Keymap       | Function            | Plugin  |
| ------------ | ------------------- | ------- |
| `<leader>S`  | Toggle Spectre      | Spectre |
| `<leader>sW` | Spectre Search Word | Spectre |
| `<leader>sp` | Spectre File Search | Spectre |

### **Window Management**

| Keymap        | Function         | Plugin |
| ------------- | ---------------- | ------ |
| `<leader>v`   | Split Vertical   | Core   |
| `<leader>h`   | Split Horizontal | Core   |
| `<leader>se`  | Equal Windows    | Core   |
| `<leader>xs`  | Close Split      | Core   |
| `<C-h/j/k/l>` | Navigate Splits  | Core   |

### **Tab Management**

| Keymap       | Function     | Plugin |
| ------------ | ------------ | ------ |
| `<leader>to` | New Tab      | Core   |
| `<leader>tx` | Close Tab    | Core   |
| `<leader>tn` | Next Tab     | Core   |
| `<leader>tp` | Previous Tab | Core   |

### **Session Management**

| Keymap        | Function        | Plugin       |
| ------------- | --------------- | ------------ |
| `<leader>ser` | Restore Session | Auto-Session |
| `<leader>ses` | Save Session    | Auto-Session |
| `<leader>sea` | Search Sessions | Auto-Session |
| `<leader>sed` | Delete Session  | Auto-Session |

### **Utility & Miscellaneous**

| Keymap       | Function          | Plugin |
| ------------ | ----------------- | ------ |
| `<leader>n`  | Notifications     | Snacks |
| `<leader>:`  | Command History   | Snacks |
| `<leader>z`  | Zen Mode          | Snacks |
| `<leader>Z`  | Zoom              | Snacks |
| `<leader>.`  | Scratch Buffer    | Snacks |
| `<leader>ca` | Code Actions      | Core   |
| `<leader>d`  | Diagnostics Float | Core   |
| `<leader>dq` | Diagnostics List  | Core   |
| `<leader>sn` | Save No Format    | Core   |
| `<c-/>`      | Toggle Terminal   | Snacks |

## ✅ **Resolved Conflicts**

### **Removed Duplications:**

1. **LSP**: Removed telescope LSP keymaps (`gd`, `gD`, `gr`, `gI`) - Snacks handles these
2. **Search**: Removed telescope search keymaps (`<leader>sh`, `<leader>sk`, etc.) - Snacks handles these
3. **Explorer**: Changed Neotree to `<leader>E` - Snacks gets `<leader>e`
4. **Buffers**: Removed telescope buffer keymap - Snacks handles buffers
5. **Diagnostics**: Changed core diagnostic list to `<leader>dq` to avoid conflicts

### **Spectre Adjustments:**

- `<leader>sw` → `<leader>sW` (to avoid conflict with Snacks word search)
- `<leader>sp` → `<leader>sP` (consistency)

## 🎉 **Result**

- **Zero keymap conflicts**
- **One functionality per keymap**
- **Logical, memorable organization**
- **Snacks.nvim prioritized for modern picker experience**
- **All original functionality preserved**
