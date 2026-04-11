# vim-gotoword

Helix-style word jumping for Vim.

`vim-gotoword` overlays two-letter tags on words visible in the current window,
waits for a two-key input, then jumps your cursor to the selected target.

![demo](demo.png)

## Features

- Fast in-window navigation with a single command: `:GotoWord`
- Two-letter labels rendered directly in the visible text
- Fold-aware rendering (closed folds are preserved)

## Installation

Use your preferred plugin manager.

`vim-plug`:

```vim
Plug 'cirnovsky/vim-gotoword'
```

`packer.nvim`:

```lua
use 'cirnovsky/vim-gotoword'
```

## Usage

Add a mapping:

```vim
nnoremap gw <cmd>GotoWord<CR>
```

Then:

1. Trigger `gw` (or run `:GotoWord` directly).
2. Type the 2-character label shown on the target word.
3. Cursor jumps to that word.

## Command

- `:GotoWord`: start jump mode for the current window.

## Highlight Group

You can customize labels with global options:

```vim
" GUI
" Accepts hex color
let g:gotoword_guifg = '#cdd6f4'
let g:gotoword_guibg = '#313244'

" Terminal
" Accepts color number only
let g:gotoword_ctermfg = 'White'
let g:gotoword_ctermbg = 'DarkBlue'

" Font attribute
" bold, underline, reverse, italic, NONE, etc.
let g:gotoword_gui = 'underline'
let g:gotoword_cterm = 'underline'
```

## Known Issues

- The plugin rewrites visible buffer text temporarily, then undoes it.  So it has potentially risk of destructing your content, if the plugin or VIM close unexpectedly.

## Help

After installation, see Vim help:

```vim
:help vim-gotoword
```
