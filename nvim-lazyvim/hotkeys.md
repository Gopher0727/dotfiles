# LazyVim Hotkeys

> LazyVim 默认 + 自定义快捷键

---

## LSP

| Key          | Mode | Action                | 来源    |
| ------------ | ---- | --------------------- | ------- |
| `gd`         | n    | Go to Definition      | LazyVim |
| `gD`         | n    | Go to Declaration     | 自定义  |
| `gr`         | n    | References            | LazyVim |
| `gI`         | n    | Go to Implementation  | LazyVim |
| `gy`         | n    | Go to Type Definition | LazyVim |
| `K`          | n    | Hover Documentation   | LazyVim |
| `gK`         | n    | Signature Help        | LazyVim |
| `]]` / `[[`  | n    | Next/Prev Reference   | LazyVim |
| `<leader>cr` | n    | Rename Symbol         | LazyVim |
| `<leader>co` | n    | Organize Imports      | LazyVim |
| `<leader>cl` | n    | Lsp Info              | LazyVim |
| `<leader>cm` | n    | Mason                 | LazyVim |

## Find / Picker

| Key               | Mode | Action          | 来源    |
| ----------------- | ---- | --------------- | ------- |
| `<leader><space>` | n    | Find Files      | LazyVim |
| `<leader>/`       | n    | Grep (Live)     | LazyVim |
| `<leader>ff`      | n    | Find Files      | 自定义  |
| `<leader>fg`      | n    | Live Grep       | 自定义  |
| `<leader>fb`      | n    | Buffers         | 自定义  |
| `<leader>fh`      | n    | Help Tags       | 自定义  |
| `<leader>fr`      | n    | Recent Files    | LazyVim |
| `<leader>fc`      | n    | Commands        | 自定义  |
| `<leader>fp`      | n    | Projects        | LazyVim |
| `<leader>:`       | n    | Command History | LazyVim |
| `<leader>,`       | n    | Switch Buffer   | LazyVim |

## Code Action (fzf)

| Key          | Mode | Action            | 来源   |
| ------------ | ---- | ----------------- | ------ |
| `<leader>fi` | n    | Code Action (fzf) | 自定义 |
| `<leader>fo` | n    | Organize Imports  | 自定义 |

## File Tree

| Key          | Mode | Action            | 来源   |
| ------------ | ---- | ----------------- | ------ |
| `<leader>e`  | n    | Toggle Explorer   | 自定义 |
| `<leader>fe` | n    | Find File in Tree | 自定义 |
| `<leader>fl` | n    | Collapse Tree     | 自定义 |

## Buffer

| Key          | Mode | Action                 | 来源    |
| ------------ | ---- | ---------------------- | ------- |
| `<S-h>`      | n    | Prev Buffer            | LazyVim |
| `<S-l>`      | n    | Next Buffer            | LazyVim |
| `<leader>bd` | n    | Delete Buffer          | LazyVim |
| `<leader>bo` | n    | Delete Other Buffers   | LazyVim |
| `<leader>bb` | n    | Switch to Other Buffer | LazyVim |

## Window

| Key          | Mode | Action             | 来源    |
| ------------ | ---- | ------------------ | ------- |
| `<C-h>`      | n    | Go to Left Window  | LazyVim |
| `<C-j>`      | n    | Go to Lower Window | LazyVim |
| `<C-k>`      | n    | Go to Upper Window | LazyVim |
| `<C-l>`      | n    | Go to Right Window | LazyVim |
| `<leader>-`  | n    | Split Below        | LazyVim |
| `<leader>\|` | n    | Split Right        | LazyVim |
| `<leader>wd` | n    | Delete Window      | LazyVim |
| `<leader>wm` | n    | Toggle Zoom        | LazyVim |

## Tab

| Key                  | Mode | Action       | 来源    |
| -------------------- | ---- | ------------ | ------- |
| `<leader>n`          | n    | New Tab      | 自定义  |
| `<leader>h`          | n    | Previous Tab | 自定义  |
| `<leader>l`          | n    | Next Tab     | 自定义  |
| `<leader><tab><tab>` | n    | New Tab      | LazyVim |
| `<leader><tab>d`     | n    | Close Tab    | LazyVim |
| `<leader><tab>]`     | n    | Next Tab     | LazyVim |
| `<leader><tab>[`     | n    | Previous Tab | LazyVim |

## Git

| Key           | Mode | Action         | 来源    |
| ------------- | ---- | -------------- | ------- |
| `<leader>gg`  | n    | Lazygit        | LazyVim |
| `<leader>gs`  | n    | Git Status     | LazyVim |
| `<leader>gb`  | n    | Git Blame      | LazyVim |
| `<leader>gd`  | n    | Git Diff       | LazyVim |
| `<leader>gl`  | n    | Git Log        | LazyVim |
| `]h` / `[h`   | n    | Next/Prev Hunk | LazyVim |
| `<leader>ghs` | n, x | Stage Hunk     | LazyVim |
| `<leader>ghr` | n, x | Reset Hunk     | LazyVim |
| `<leader>ghp` | n    | Preview Hunk   | LazyVim |

## Format / Lint

| Key          | Mode | Action                    | 来源    |
| ------------ | ---- | ------------------------- | ------- |
| `<leader>cf` | n    | Format File               | 自定义  |
| `<leader>cF` | n    | Format Injected Languages | LazyVim |

## Diagnostic

| Key          | Mode | Action                | 来源    |
| ------------ | ---- | --------------------- | ------- |
| `]d` / `[d`  | n    | Next/Prev Diagnostic  | LazyVim |
| `]e` / `[e`  | n    | Next/Prev Error       | LazyVim |
| `]w` / `[w`  | n    | Next/Prev Warning     | LazyVim |
| `<leader>cd` | n    | Line Diagnostics      | LazyVim |
| `<leader>xx` | n    | Diagnostics (Trouble) | LazyVim |
| `<leader>xq` | n    | Quickfix List         | LazyVim |

## Search

| Key          | Mode | Action              | 来源    |
| ------------ | ---- | ------------------- | ------- |
| `<leader>sg` | n    | Grep                | LazyVim |
| `<leader>sw` | n, x | Grep Word/Selection | LazyVim |
| `<leader>sr` | n, x | Search & Replace    | LazyVim |
| `<leader>ss` | n    | LSP Symbols         | LazyVim |
| `<leader>sk` | n    | Keymaps             | LazyVim |
| `<leader>sh` | n    | Help Pages          | LazyVim |

## UI Toggle

| Key          | Mode | Action                  | 来源    |
| ------------ | ---- | ----------------------- | ------- |
| `<leader>ud` | n    | Undotree                | 自定义  |
| `<leader>uh` | n    | Toggle Inlay Hints      | LazyVim |
| `<leader>uw` | n    | Toggle Wrap             | LazyVim |
| `<leader>us` | n    | Toggle Spelling         | LazyVim |
| `<leader>ul` | n    | Toggle Line Numbers     | LazyVim |
| `<leader>uL` | n    | Toggle Relative Numbers | LazyVim |
| `<leader>uf` | n    | Toggle Auto Format      | LazyVim |
| `<leader>uz` | n    | Toggle Zen Mode         | LazyVim |
| `<leader>uC` | n    | Colorscheme Picker      | LazyVim |
| `<leader>un` | n    | Dismiss Notifications   | LazyVim |

## Editing

| Key          | Mode    | Action                    | 来源    |
| ------------ | ------- | ------------------------- | ------- |
| `H`          | n, v    | Go to Start of Line       | 自定义  |
| `L`          | n, v    | Go to End of Line         | 自定义  |
| `<A-j>`      | n, i, v | Move Line Down            | LazyVim |
| `<A-k>`      | n, i, v | Move Line Up              | LazyVim |
| `<M-up>`     | n, v    | Move Line/Selection Up    | 自定义  |
| `<M-down>`   | n, v    | Move Line/Selection Down  | 自定义  |
| `<M-S-up>`   | n, v    | Copy Line/Selection Above | 自定义  |
| `<M-S-down>` | n, v    | Copy Line/Selection Below | 自定义  |
| `<C-s>`      | i, n    | Save File                 | LazyVim |
| `gcc`        | n       | Toggle Comment            | LazyVim |
| `s`          | n, x, o | Flash Jump                | LazyVim |

## Completion

| Key       | Mode | Action                        | 来源    |
| --------- | ---- | ----------------------------- | ------- |
| `<Tab>`   | i    | Accept Supermaven / Show Menu | 自定义  |
| `<S-Tab>` | i    | Select Previous               | 自定义  |
| `<CR>`    | i    | Accept Selected               | LazyVim |
| `<C-e>`   | i    | Hide Menu                     | LazyVim |

## Terminal (ToggleTerm)

| Key          | Mode | Action              | 来源   |
| ------------ | ---- | ------------------- | ------ |
| `<leader>tt` | n    | Float Terminal      | 自定义 |
| `<leader>tf` | n    | Float Terminal      | 自定义 |
| `<leader>tv` | n    | Vertical Terminal   | 自定义 |
| `<leader>th` | n    | Horizontal Terminal | 自定义 |
| `<Esc><Esc>` | t    | Close Terminal      | 自定义 |

## Markdown

| Key          | Mode | Action           | 来源   |
| ------------ | ---- | ---------------- | ------ |
| `<leader>mp` | n    | Markdown Preview | 自定义 |
| `<leader>mP` | n    | Close Preview    | 自定义 |

## Snippets (Scissors)

| Key          | Mode | Action       | 来源   |
| ------------ | ---- | ------------ | ------ |
| `<leader>sa` | n, x | Add Snippet  | 自定义 |
| `<leader>se` | n    | Edit Snippet | 自定义 |

## Utility

| Key          | Mode | Action                  | 来源    |
| ------------ | ---- | ----------------------- | ------- |
| `<leader>as` | n    | Toggle Auto-Save        | 自定义  |
| `<leader>l`  | n    | Lazy (Plugin Manager)   | LazyVim |
| `<leader>qq` | n    | Quit All                | LazyVim |
| `<leader>?`  | n    | Buffer Keymaps          | LazyVim |
| `q`          | n    | Close (help/qf/trouble) | LazyVim |
