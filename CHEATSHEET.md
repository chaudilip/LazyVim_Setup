# Neovim Cheatsheet - Devaslife Config

> Leader key = `Space`

---

## Modes

| Key | Action |
|-----|--------|
| `i` | Enter Insert mode (before cursor) |
| `a` | Enter Insert mode (after cursor) |
| `I` | Insert at beginning of line |
| `A` | Insert at end of line |
| `o` | New line below + Insert mode |
| `O` | New line above + Insert mode |
| `v` | Visual mode (character select) |
| `V` | Visual Line mode (select whole lines) |
| `Ctrl+v` | Visual Block mode (column select) |
| `Esc` | Back to Normal mode |
| `:` | Command mode |
| `R` | Replace mode |

---

## Cursor Movement

### Basic

| Key | Action |
|-----|--------|
| `h` | Left |
| `j` | Down |
| `k` | Up |
| `l` | Right |
| `0` | Beginning of line |
| `^` | First non-blank character |
| `$` | End of line |
| `gg` | Top of file |
| `G` | Bottom of file |
| `{number}G` | Go to line number |
| `%` | Jump to matching bracket `(){}[]` |
| `Ctrl+m` | Jumplist forward |

### Word Movement

| Key | Action |
|-----|--------|
| `w` | Next word start |
| `b` | Previous word start |
| `e` | Next word end |
| `ge` | Previous word end |
| `W` | Next WORD start (skips punctuation) |
| `B` | Previous WORD start |
| `E` | Next WORD end |

### Find on Line

| Key | Action |
|-----|--------|
| `f{char}` | Jump **to** next `char` |
| `F{char}` | Jump **to** previous `char` |
| `t{char}` | Jump **before** next `char` |
| `T{char}` | Jump **after** previous `char` |
| `;` | Repeat last f/t forward |
| `,` | Repeat last f/t backward |

### Scrolling

| Key | Action |
|-----|--------|
| `Ctrl+d` | Scroll half page down |
| `Ctrl+u` | Scroll half page up |
| `Ctrl+f` | Scroll full page down |
| `Ctrl+b` | Scroll full page up |
| `zz` | Center cursor on screen |
| `zt` | Cursor to top of screen |
| `zb` | Cursor to bottom of screen |

---

## Selection (Visual Mode)

| Key | Action |
|-----|--------|
| `v` | Start character selection |
| `V` | Start line selection |
| `Ctrl+v` | Start block/column selection |
| `viw` | Select inner word |
| `viW` | Select inner WORD |
| `vi"` | Select inside `"..."` |
| `vi'` | Select inside `'...'` |
| `vi(` | Select inside `(...)` |
| `vi{` | Select inside `{...}` |
| `vi[` | Select inside `[...]` |
| `vit` | Select inside HTML tag |
| `vap` | Select paragraph (with blank lines) |
| `vip` | Select inner paragraph |
| `Ctrl+a` | **Select all** (entire file) |
| `gv` | Re-select last visual selection |
| `o` | Jump to other end of selection (in visual) |

### Expand Selection Trick

```
viw   ->  select word
         press v again to deselect, or
         use o to jump to other end
```

---

## Multi-Cursor (vim-visual-multi)

| Key | Action |
|-----|--------|
| `Ctrl+n` | Select word under cursor, press again for next occurrence |
| `Ctrl+Down` | Add cursor below |
| `Ctrl+Up` | Add cursor above |
| `q` | Skip current and go to next match |
| `Q` | Remove current cursor |
| `Tab` | Switch between cursor/extend mode |
| `n` / `N` | Get next/previous occurrence |
| `Esc` | Exit multi-cursor |

### Example: Rename a variable everywhere

```
1. Place cursor on variable name
2. Ctrl+n  (selects it)
3. Ctrl+n  (selects next occurrence)
4. Ctrl+n  (repeat for all)
5. c       (change all at once)
6. Type new name
7. Esc
```

---

## Text Objects (the `i` and `a` system)

Use with any operator: `d` (delete), `c` (change), `y` (yank), `v` (select)

| Text Object | Inner `i` (inside) | Around `a` (includes delimiters) |
|-------------|---------------------|----------------------------------|
| Word | `diw` delete word | `daw` delete word + space |
| WORD | `diW` | `daW` |
| Sentence | `dis` | `das` |
| Paragraph | `dip` | `dap` |
| `"double quotes"` | `di"` | `da"` |
| `'single quotes'` | `di'` | `da'` |
| `` `backticks` `` | `` di` `` | `` da` `` |
| `(parentheses)` | `di(` or `dib` | `da(` or `dab` |
| `{curly braces}` | `di{` or `diB` | `da{` or `daB` |
| `[brackets]` | `di[` | `da[` |
| `<angle>` | `di<` | `da<` |
| HTML tag | `dit` | `dat` |

### Examples

```
"hello world"     cursor inside ->  di"  ->  ""
"hello world"     cursor inside ->  da"  ->  (deleted entirely)
(foo, bar, baz)   cursor inside ->  di(  ->  ()
<div>content</div> cursor inside -> dit  ->  <div></div>
```

---

## Editing

### Basic Operations

| Key | Action |
|-----|--------|
| `x` | Delete character (doesn't affect register) |
| `r{char}` | Replace character under cursor |
| `~` | Toggle case of character |
| `J` | Join line below to current |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Repeat last command |

### Delete

| Key | Action |
|-----|--------|
| `dd` | Delete entire line |
| `D` | Delete to end of line |
| `dw` | Delete word backwards (custom, preserves register) |
| `diw` | Delete inner word |
| `di"` | Delete inside quotes |
| `di(` | Delete inside parentheses |
| `dt{char}` | Delete until `char` |
| `d$` | Delete to end of line |
| `d0` | Delete to beginning of line |
| `Space d` | Delete without yanking (custom) |
| `Space D` | Delete to end without yanking (custom) |

### Change (delete + enter Insert mode)

| Key | Action |
|-----|--------|
| `cc` | Change entire line |
| `C` | Change to end of line |
| `ciw` | Change inner word |
| `ci"` | Change inside quotes |
| `ci(` | Change inside parentheses |
| `ci{` | Change inside braces |
| `cit` | Change inside HTML tag |
| `ct{char}` | Change until `char` |
| `Space c` | Change without yanking (custom) |
| `Space C` | Change to end without yanking (custom) |

### Copy (Yank) & Paste

| Key | Action |
|-----|--------|
| `yy` | Yank (copy) line |
| `yiw` | Yank inner word |
| `yi"` | Yank inside quotes |
| `y$` | Yank to end of line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `Space p` | Paste from yank register (custom, after) |
| `Space P` | Paste from yank register (custom, before) |

> **Tip:** `Space p` always pastes what you *yanked*, even after deleting something. Normal `p` pastes whatever was last deleted/changed.

### Increment / Decrement

| Key | Action |
|-----|--------|
| `+` | Increment number under cursor (custom) |
| `-` | Decrement number under cursor (custom) |
| `Ctrl+a` | Increment (dial.nvim: numbers, booleans, dates, let/const) |
| `Ctrl+x` | Decrement (dial.nvim) |

### Move Lines

| Key | Action |
|-----|--------|
| `Alt+Up` | Move current line up |
| `Alt+Down` | Move current line down |

---

## Surround (nvim-surround)

### Add Surround

| Keys | Before | After |
|------|--------|-------|
| `ysiw"` | `hello` | `"hello"` |
| `ysiw'` | `hello` | `'hello'` |
| `ysiw)` | `hello` | `(hello)` |
| `ysiw(` | `hello` | `( hello )` |
| `ysiw]` | `hello` | `[hello]` |
| `ysiw}` | `hello` | `{hello}` |
| `ysiw`` ` | `hello` | `` `hello` `` |
| `yss"` | `hello world` | `"hello world"` (entire line) |

> Closing bracket `)]}` = no spaces. Opening bracket `([{` = spaces inside.

### Change Surround

| Keys | Before | After |
|------|--------|-------|
| `cs"'` | `"hello"` | `'hello'` |
| `cs'(` | `'hello'` | `( hello )` |
| `cs({` | `(hello)` | `{ hello }` |
| `cs"<div>` | `"hello"` | `<div>hello</div>` |

### Delete Surround

| Keys | Before | After |
|------|--------|-------|
| `ds"` | `"hello"` | `hello` |
| `ds(` | `(hello)` | `hello` |
| `ds{` | `{hello}` | `hello` |
| `dst` | `<div>hello</div>` | `hello` |

### Visual Mode Surround

```
1. viw         (select word)
2. S"          (surround with quotes)

1. V           (select line)
2. S{          (surround with braces)
```

---

## Search & Replace

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search word under cursor (forward) |
| `#` | Search word under cursor (backward) |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all with confirmation |
| `:s/old/new/g` | Replace all in current line |
| `:IncRename` | Incremental rename (inc-rename.nvim) |

---

## Comments (NERDCommenter)

| Key | Action |
|-----|--------|
| `cc` | Comment current line / selection |
| `cu` | Uncomment current line / selection |

In visual mode, select lines first then `cc` / `cu`.

---

## Tabs

| Key | Action |
|-----|--------|
| `te` | New tab |
| `tc` | Close tab |
| `Tab` | Next tab |
| `Shift+Tab` | Previous tab |

---

## Windows / Splits

### Create

| Key | Action |
|-----|--------|
| `ss` | Horizontal split |
| `sv` | Vertical split |
| `Space t` | Open terminal |

### Navigate

| Key | Action |
|-----|--------|
| `sh` | Move to left window |
| `sj` | Move to down window |
| `sk` | Move to up window |
| `sl` | Move to right window |

### Resize

| Key | Action |
|-----|--------|
| `Ctrl+w <Left>` | Decrease width |
| `Ctrl+w <Right>` | Increase width |
| `Ctrl+w <Up>` | Increase height |
| `Ctrl+w <Down>` | Decrease height |
| `Ctrl+w =` | Equal size all windows |

---

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `;f` | Find files (respects .gitignore) |
| `;r` | Live grep (search text in all files) |
| `\\` | List open buffers |
| `;t` | Help tags |
| `;;` | Resume last picker |
| `;e` | List diagnostics |
| `;s` | List Treesitter symbols |
| `;c` | LSP incoming calls |
| `sf` | File browser (current buffer dir) |
| `Space fP` | Find plugin files |

### Inside Telescope

| Key | Action |
|-----|--------|
| `Ctrl+n` / `Ctrl+p` | Next / Previous item |
| `Ctrl+u` | Scroll up 10 items (file browser) |
| `Ctrl+d` | Scroll down 10 items (file browser) |
| `Enter` | Open selected |
| `Esc` | Close telescope |
| `/` | Start typing (file browser, normal mode) |
| `N` | Create new file (file browser) |
| `h` | Go to parent dir (file browser) |

---

## LSP (Language Server)

### Navigation

| Key | Action |
|-----|--------|
| `gd` | Go to definition (Telescope) |
| `gr` | Go to references (Telescope) |
| `gi` | Go to implementations (Telescope) |
| `gt` | Go to type definitions (Telescope) |
| `K` | Hover documentation |
| `Ctrl+j` | Go to next diagnostic |
| `Alt+e` | Open diagnostic float |

### Actions

| Key | Action |
|-----|--------|
| `Space ca` | Code action |
| `Space cr` | Rename symbol |
| `Space cf` | Format document |
| `Space i` | Toggle inlay hints |
| `:ToggleAutoformat` | Toggle auto-format on save |

---

## Git (gitsigns.nvim + git.nvim)

### Navigation

| Key | Action |
|-----|--------|
| `]c` | Next git hunk |
| `[c` | Previous git hunk |

### Hunk Actions

| Key | Action |
|-----|--------|
| `Space hs` | Stage hunk |
| `Space hr` | Reset hunk |
| `Space hS` | Stage entire buffer |
| `Space hR` | Reset entire buffer |
| `Space hp` | Preview hunk (popup) |
| `Space hi` | Preview hunk inline |
| `Space hb` | Blame line (full) |
| `Space hd` | Diff this file |
| `Space hD` | Diff against `~` (last commit) |
| `Space hq` | Send hunks to quickfix |
| `Space hQ` | Send ALL hunks to quickfix |

### Toggles

| Key | Action |
|-----|--------|
| `Space tb` | Toggle line blame |
| `Space tw` | Toggle word diff |

### Git Browser

| Key | Action |
|-----|--------|
| `Space gb` | Git blame window |
| `Space go` | Open in git repository (browser) |

### Text Object

| Key | Action |
|-----|--------|
| `ih` | Select git hunk (works with `d`, `y`, `v`) |

---

## Copilot

| Key | Action |
|-----|--------|
| `Ctrl+l` | Accept suggestion |
| `Alt+l` | Accept word |
| `Alt+Shift+l` | Accept line |
| `Alt+]` | Next suggestion |
| `Alt+[` | Previous suggestion |
| `Ctrl+]` | Dismiss suggestion |

---

## Completion (nvim-cmp / blink.cmp)

| Key | Action |
|-----|--------|
| `Ctrl+Space` | Trigger completion manually |
| `Tab` | Next completion item / expand snippet |
| `Shift+Tab` | Previous completion item |
| `Enter` | Confirm selection |
| `Ctrl+e` | Close completion menu |

---

## Buffers

| Key | Action |
|-----|--------|
| `Space th` | Close hidden buffers |
| `Space tu` | Close unnamed buffers |
| `Space bd` | Delete current buffer |

---

## File Explorer (Neo-tree / LazyVim default)

| Key | Action |
|-----|--------|
| `Space e` | Toggle file explorer |
| `Space E` | Toggle file explorer (cwd) |

---

## Zen Mode

| Key | Action |
|-----|--------|
| `Space z` | Toggle Zen Mode (distraction-free) |

---

## Refactoring

| Key | Action |
|-----|--------|
| `Space r` | Replace hex with HSL (normal mode) |
| `Space r` | Refactoring menu (visual mode, select code first) |
| `Space cc` | Generate annotation/docstring (Neogen) |
| `:IncRename {new}` | Incremental rename |

---

## Diagnostics & Trouble

| Key | Action |
|-----|--------|
| `Space xx` | Toggle Trouble (diagnostics list) |
| `Space xw` | Workspace diagnostics |
| `Space xd` | Document diagnostics |
| `Space xl` | Location list |
| `Space xq` | Quickfix list |

---

## Mini.Bracketed (Jump with `[` and `]`)

| Key | Action |
|-----|--------|
| `[n` / `]n` | Previous / Next treesitter node |
| `[b` / `]b` | Previous / Next buffer |
| `[c` / `]c` | Previous / Next comment (or git hunk) |
| `[d` / `]d` | Previous / Next diagnostic |
| `[i` / `]i` | Previous / Next indent change |
| `[j` / `]j` | Previous / Next jump |
| `[l` / `]l` | Previous / Next location |
| `[o` / `]o` | Previous / Next oldfile |
| `[t` / `]t` | Previous / Next treesitter |
| `[u` / `]u` | Previous / Next undo |

---

## Common Workflows

### Rename a variable across the file

```
Option 1: Multi-cursor
  Ctrl+n  ->  Ctrl+n (repeat)  ->  c  ->  type new name  ->  Esc

Option 2: LSP rename
  Space cr  ->  type new name  ->  Enter

Option 3: Search & replace
  :%s/oldName/newName/g  ->  Enter
```

### Wrap a word in quotes/brackets

```
ysiw"       ->  word  ->  "word"
ysiw(       ->  word  ->  ( word )
ysiw)       ->  word  ->  (word)
```

### Change quotes type

```
cs"'        ->  "word"  ->  'word'
cs'`        ->  'word'  ->  `word`
```

### Delete surrounding brackets

```
ds(         ->  (word)  ->  word
ds"         ->  "word"  ->  word
```

### Change content inside brackets/quotes

```
ci"         ->  "old text"  ->  ""  (now in insert mode, type new text)
ci(         ->  (old text)  ->  ()  (now in insert mode)
ci{         ->  {old text}  ->  {}  (now in insert mode)
```

### Select and operate on a function call

```
vib         ->  select inside parentheses  foo(|this part|)
dib         ->  delete inside parentheses  foo()
cib         ->  change inside parentheses  foo(|cursor|)
```

### Move a block of code

```
V           ->  select lines with j/k
Alt+Up      ->  move block up
Alt+Down    ->  move block down
```

### Comment multiple lines

```
V           ->  select lines with j/k
cc          ->  comment them all
cu          ->  uncomment them all
```

### Quick find and open a file

```
;f          ->  type filename  ->  Enter
```

### Search text across all files

```
;r          ->  type search term  ->  select result  ->  Enter
```

### Stage specific git changes

```
]c / [c     ->  navigate to hunk
Space hp    ->  preview what changed
Space hs    ->  stage this hunk
```

---

## Code Folding

Your config uses Treesitter-based folding (`foldmethod=expr`), so folds follow code structure (functions, classes, blocks, etc.).

### Basic Folding

| Key | Action |
|-----|--------|
| `za` | **Toggle** fold under cursor (open/close) |
| `zo` | Open fold under cursor |
| `zc` | Close fold under cursor |
| `zO` | Open fold recursively (all nested folds too) |
| `zC` | Close fold recursively |
| `zR` | **Open ALL** folds in file |
| `zM` | **Close ALL** folds in file |
| `zA` | Toggle fold recursively |

### Fold Navigation

| Key | Action |
|-----|--------|
| `zj` | Move to next fold |
| `zk` | Move to previous fold |
| `[z` | Go to start of current fold |
| `]z` | Go to end of current fold |

### Fold Levels

| Key | Action |
|-----|--------|
| `zm` | Fold more (reduce fold level by 1) |
| `zr` | Fold less (increase fold level by 1) |
| `zM` | Close everything (level 0) |
| `zR` | Open everything (max level) |

### Fold Creation (manual)

| Key | Action |
|-----|--------|
| `zf{motion}` | Create fold over motion |
| `zf` (visual) | Fold selected lines |
| `zd` | Delete fold under cursor |
| `zE` | Delete all folds in file |

### Common Workflows

```
-- Collapse everything then expand what you need:
zM              close all folds
zo              open the one you need
zO              open it and all its children

-- Quick peek inside a function:
zc              close the function fold
za              toggle it back open

-- Working on a big file, hide everything except your section:
zM              close all
zr              open one level (shows top-level items)
zo              open the specific block you want

-- Fold a visual selection:
V (select lines) -> zf    creates a manual fold
```

---

## Save & Quit

| Key | Action |
|-----|--------|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:qa` | Quit all |
| `ZZ` | Save and quit (shortcut) |
| `ZQ` | Quit without saving (shortcut) |

---

## Useful Commands

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/tool installer |
| `:LspInfo` | Show active LSP servers |
| `:checkhealth` | Check Neovim health |
| `:ToggleAutoformat` | Toggle format on save |
| `:ZenMode` | Toggle distraction-free mode |
| `:IncRename {name}` | Rename symbol incrementally |
| `:Noice` | View message history |
