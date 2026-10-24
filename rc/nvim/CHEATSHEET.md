# Neovim shortcut cheat sheet

These are the custom mappings in this configuration. Update this sheet whenever
you add, remove, or change a mapping.

## How to read the keys

- **Leader = Space.** `<leader>pv` means tap Space, then p, then v.
- Use lowercase letters. You do not need Shift for these leader mappings.
- Tap sequence keys one after another; do not hold them together.
- **Ctrl+n** means hold Ctrl and press n.
- Press **Esc** to return to Normal mode before using a Normal-mode shortcut.

## Explorer, saving, and leaving the file

Defined in [lua/config/keymaps.lua](lua/config/keymaps.lua).

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → p → v** | Open the directory explorer (netrw) without saving. |
| Normal | **Space → p → w** | Save the current file, then leave it for the directory explorer. |

Opening the explorer does not discard unsaved edits. If saving fails, the
save-and-explore shortcut stops before opening the explorer.

## Modes

| Mode | Keys | Action |
| --- | --- | --- |
| Insert | **Ctrl+c** | Return to Normal mode, like Esc. |

## Markdown rendering

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → p → m** | Toggle rendered Markdown on or off. |

Markdown renders automatically in Normal mode. Insert mode shows the source;
the cursor line also shows source by default to make editing easier.
Run `:RenderMarkdown preview` for a rendered view beside the source.
Rendering uses Neovim's `markdown` and `markdown_inline` Tree-sitter parsers.
If a future machine does not include them, install those parsers before using
this plugin. Run `:checkhealth render-markdown` to check the requirements.

## Autocomplete

Completion is configured in [after/plugin/cmp.lua](after/plugin/cmp.lua).
These shortcuts work in Insert mode with the completion plugin loaded.

| Keys | Action |
| --- | --- |
| **Ctrl+Space** | Request completion suggestions. |
| **Ctrl+n** | Select the next suggestion. |
| **Ctrl+p** | Select the previous suggestion. |
| **Ctrl+y** | Accept the selected suggestion, or the first if none is selected. |
| **Ctrl+e** | Close the completion menu. |

Suggestions currently come from the language server. A matching server must be
installed and attached to the file for language completion to work.

## UndoTree

Defined in [lua/config/keymaps.lua](lua/config/keymaps.lua).

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → u** | Open or close the undo history tree. |

Undo history is stored persistently under Neovim's data directory. When the
UndoTree panel is open, these commands help you move around it:

| Keys | Action |
| --- | --- |
| **Ctrl+w, h** | Move to the UndoTree panel on the left. |
| **Ctrl+w, l** | Move back to the file panel on the right. |
| **j / k** | Move down or up through undo entries when the UndoTree panel is focused. |
| **Enter** | Select the highlighted undo state. |
| **q** | Close the UndoTree panel (or its help screen). |
| **?** | Show UndoTree's built-in help. |
| **Ctrl+w, >** | Make the current panel wider. |
| **Ctrl+w, <** | Make the current panel narrower. |
| **Ctrl+w, =** | Make split panels equal width. |

You can also resize it directly with `:vertical resize 35`. Replace `35` with
the width you prefer. Press **Space → u** again to close the panel.

## Fuzzy finding

Defined in [lua/config/keymaps.lua](lua/config/keymaps.lua) using Telescope.

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → f → f** | Find files in the current working directory. |
| Normal | **Space → f → g** | Search text in files with ripgrep. |
| Normal | **Space → f → b** | Find an open buffer. |
| Normal | **Space → f → h** | Search Neovim help. |

Inside a Telescope picker, type to filter, use **Ctrl+n / Ctrl+p** to move,
press **Enter** to open the selection, and press **Esc** to close it. `live_grep`
requires the `rg` command.

## Harpoon

Defined in [lua/config/keymaps.lua](lua/config/keymaps.lua).

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → h → a** | Add the current file to Harpoon. |
| Normal | **Space → h → m** | Open the Harpoon file list. |
| Normal | **Space → h → 1** | Jump to Harpoon file 1. |
| Normal | **Space → h → 2** | Jump to Harpoon file 2. |
| Normal | **Space → h → 3** | Jump to Harpoon file 3. |
| Normal | **Space → h → 4** | Jump to Harpoon file 4. |

Harpoon is useful for a small set of files you visit repeatedly in a project.

## Additional plugins

These plugins are configured in `after/plugin/` and their shortcuts are
defined in `lua/config/keymaps.lua`.

### Cloak

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → c → t** | Toggle masking of supported secret values. |

### Colorizer

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → c → c** | Toggle inline color previews. |

### Fugitive (Git)

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → g → s** | Open Git status. |
| Normal | **Space → g → d** | Open a split showing the Git diff. |
| Normal | **Space → g → b** | Show Git blame for the current file. |

### Trouble

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → x → x** | Toggle the LSP diagnostics list. |
| Normal | **Space → x → q** | Toggle the quickfix list. |

### Refactoring

Use these in Visual mode after selecting code:

| Mode | Keys | Action |
| --- | --- | --- |
| Visual | **Space → r → e** | Extract the selected code. |
| Visual | **Space → r → f** | Extract the selection to a file. |
| Visual | **Space → r → v** | Extract the selection to a variable. |
| Normal | **Space → r → i** | Inline the variable under the cursor. |

### Zen Mode

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | **Space → z → z** | Toggle the focused editing layout. |

## Clipboard and registers

Neovim has its own registers, while the `+` register is the desktop system
clipboard. These mappings let you choose where text goes.

| Mode | Keys | Action |
| --- | --- | --- |
| Normal/Visual | **y** | Yank using Neovim's normal registers. |
| Normal/Visual | **Space → y** | Yank to the system clipboard. |
| Normal | **Space → Y** | Yank the current line to the system clipboard. |
| Normal/Visual | **Space → p** | Paste without replacing the clipboard. |
| Normal/Visual | **Space → d** | Delete without replacing the clipboard. |

You can also use the registers directly:

```vim
"+y       Yank to the system clipboard
"+p       Paste from the system clipboard
"0p       Paste the most recent yank from Neovim's yank register
"ayy      Yank a line into named register a
"ap       Paste from named register a
```

If system clipboard copying does not work, run `:checkhealth vim.provider`.
Neovim may need a clipboard provider such as `wl-copy`/`wl-paste` on Wayland or
`xclip`/`xsel` on X11.

## Check a mapping

Run these commands inside Neovim:

```vim
:verbose nmap <Space>pv
:verbose nmap <Space>pw
:verbose nmap <Space>pm
:verbose nmap <Space>u
:verbose nmap <Space>ff
:verbose nmap <Space>fg
:verbose nmap <Space>fb
:verbose nmap <Space>fh
:verbose nmap <Space>ha
:verbose nmap <Space>hm
:verbose nmap <Space>h1
:verbose nmap <Space>h2
:verbose nmap <Space>h3
:verbose nmap <Space>h4
:verbose nmap <Space>ct
:verbose nmap <Space>cc
:verbose nmap <Space>gs
:verbose nmap <Space>gd
:verbose nmap <Space>gb
:verbose nmap <Space>xx
:verbose nmap <Space>xq
:verbose xmap <Space>re
:verbose xmap <Space>rf
:verbose xmap <Space>rv
:verbose nmap <Space>ri
:verbose nmap <Space>zz
:verbose nmap <Space>y
:verbose nmap <Space>Y
:verbose xmap <Space>p
:verbose nmap <Space>d
```

They show the current mappings and where they were defined. If you see
`No mapping found`, the configuration may not be loaded in that session.

## Open this sheet

From the project root, inside Neovim:

```vim
:e rc/nvim/CHEATSHEET.md
```

After installing a version that includes this sheet:

```vim
:e ~/.config/nvim/CHEATSHEET.md
```
