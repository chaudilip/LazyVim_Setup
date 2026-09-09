# Windows Setup — craftzdog-style Neovim + Terminal

Reproduction guide for this machine's development environment on Windows 11.
Based on [craftzdog/dotfiles](https://github.com/craftzdog/dotfiles) (formerly
`dotfiles-public`), adapted for Windows + PowerShell.

> ## Guiding principle: **DO NOT REMOVE ANYTHING — ONLY UPDATE**
>
> Every step below is additive. Existing plugins, language parsers, LazyVim
> extras, colorschemes, keybindings, and PowerShell modules are preserved.
> Where something conflicted, it was **moved to a new key**, never deleted.
> Where a tool was outdated, it was **updated**, never uninstalled.
>
> If you extend this setup, keep that rule.

---

## 1. Prerequisites

| Tool | Version used | Install |
|---|---|---|
| Neovim | 0.12.2 (MSI) / 0.12.5 (scoop) | `scoop install neovim` |
| Windows Terminal | — | preinstalled |
| PowerShell 7 | 7.5.4 | `scoop install pwsh` |
| Node.js | — | nvm4w |
| Git | 2.51 | Git for Windows |

### Scoop packages

```powershell
scoop install 7zip curl delta fd fzf gcc gh jq lazygit make mingw neovim ripgrep sudo
```

`delta` powers git diffs. `fd`, `fzf`, `ripgrep` power the pickers.
`mingw` provides a modern 64-bit GCC (see section 6 — this matters).

### Font

**PlemolJP Console NF** — the same Nerd Font craftzdog uses.
Download from [PlemolJP releases](https://github.com/yuru7/PlemolJP), install
the `PlemolJPConsoleNF-*.ttf` files.

---

## 2. Windows Terminal

`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

### Color scheme

Add to the `schemes` array. This is a translation of craftzdog's Ghostty
`Solarized Dark - Vivid` theme — an HSLuv lightness boost of 0.3 over base
Solarized, matching `solarized-osaka.nvim`'s `vivid` style so terminal and
editor agree.

```json
{
  "name": "Solarized Osaka Vivid",
  "background": "#031219",  "foreground": "#91a8aa",
  "cursorColor": "#91a8aa", "selectionBackground": "#002831",
  "black": "#002831",       "brightBlack": "#6e8b95",
  "red": "#f86265",         "brightRed": "#fb5c41",
  "green": "#94b109",       "brightGreen": "#6e8b95",
  "yellow": "#d49a0a",      "brightYellow": "#7895a0",
  "blue": "#529ef9",        "brightBlue": "#91a8aa",
  "purple": "#f8579a",      "brightPurple": "#8987d3",
  "cyan": "#32b9aa",        "brightCyan": "#9fb2b2",
  "white": "#f0ebdc",       "brightWhite": "#fdf7e7"
}
```

> Solarized deliberately repurposes bright green/yellow/blue as grey UI tones.
> `brightGreen` being grey is correct, not a bug.

### Profile defaults

```json
"defaults": {
  "colorScheme": "Solarized Osaka Vivid",
  "font": { "face": "PlemolJP Console NF", "size": 13 },
  "opacity": 85,
  "useAcrylic": true,
  "cursorShape": "filledBox",
  "padding": "8"
}
```

Also set `defaultProfile` to the **PowerShell 7** GUID (not Windows PowerShell 5.1).

`opacity: 85` + `useAcrylic` approximates craftzdog's Ghostty
`background-opacity = 0.85` + `background-blur-radius = 20`. It will not match
exactly — the blur is done by the macOS compositor and has no Windows
equivalent. This is an OS difference, not a missing setting.

**Keep the old scheme in the array.** Switching back is then a one-word edit.

---

## 3. Neovim

Config lives in `%LOCALAPPDATA%\nvim` (this repo). LazyVim + lazy.nvim.

### 3.1 Colorscheme — enable `vivid`

`lua/plugins/colorscheme.lua`:

```lua
{
  "craftzdog/solarized-osaka.nvim",
  lazy = true,
  priority = 1000,
  opts = function()
    return {
      transparent = true,
      style = "vivid",   -- <-- added
    }
  end,
},
```

`vivid` was added upstream after commit `f675d9a`. If your `lazy-lock.json`
pins an older commit, run `:Lazy update solarized-osaka.nvim` first or the
option is silently ignored.

Because `transparent = true`, Neovim paints **no background** — what you see
behind the text is the terminal. That is why section 2 must match, or the two
clash.

### 3.2 Treesitter compiler fix (Windows only)

`lua/config/options.lua`, appended:

```lua
if vim.fn.has("win32") == 1 then
  for _, cc in ipairs({
    vim.fn.expand("~/scoop/apps/mingw/current/bin/gcc.exe"),
    vim.fn.expand("~/scoop/apps/gcc/current/bin/gcc.exe"),
  }) do
    if vim.fn.executable(cc) == 1 then
      vim.env.CC = cc
      break
    end
  end
end
```

**Why:** see section 6. nvim-treesitter `main` compiles via the Rust `cc`
crate, which honours `$CC`. LazyVim actively blocks the older `compilers`
override, so `$CC` is the correct lever. Scoped to Neovim — the system PATH is
untouched.

### 3.3 oil.nvim

New file `lua/plugins/oil.lua`. Config copied verbatim from craftzdog's
`feat/late-2026` branch. oil edits the filesystem as a normal buffer.

```lua
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    lazy = false,  -- required for default_file_explorer to take over netrw
    keys = {
      {
        "sf",
        function()
          require("oil").open_float(nil, { preview = {} })
        end,
        desc = "Toggle file explorer (oil)",
      },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
        { "permissions", highlight = "Type" },
        { "size", highlight = "String" },
        { "mtime", highlight = "Keyword" },
      },
      keymaps = {
        ["h"] = { "actions.parent", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
      },
      view_options = { show_hidden = true },
      float = {
        padding = 8,
        border = "rounded",
        win_options = { winblend = 0 },
        max_width = 200,
      },
      preview_win = { update_on_cursor_moved = true },
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = true,
      },
    },
  },
}
```

> **Windows note:** the `permissions` column renders **blank** — it is
> Unix-oriented and Windows has no equivalent. `icon`, `size`, `mtime` work
> normally. Left in place to stay faithful to the upstream config.

### 3.4 Keybinding conflict — resolved by MOVING, not removing

`sf` was already bound to telescope-file-browser in `lua/plugins/editor.lua`
(craftzdog's older binding, from before he adopted oil). Both are kept:

| Key | Action | Change |
|---|---|---|
| `sf` | oil floating explorer | **new** |
| `sb` | telescope file browser | **moved** from `sf` |
| `<leader>e` | neo-tree | unchanged |

In `lua/plugins/editor.lua`, the telescope `file_browser` entry's key changed
from `"sf"` to `"sb"`. Nothing was deleted.

Existing `s`-prefix window bindings are untouched:
`ss` split, `sv` vsplit, `sh` `sj` `sk` `sl` window navigation.

---

## 4. PowerShell

### 4.1 Structure — one config, two loaders

Windows ships two PowerShells with **different, non-configurable** profile
paths. The fix is a one-line stub in each that sources a shared config —
the same pattern craftzdog uses.

```
        ~\.config\powershell\user_profile.ps1     <-- THE config, edit this
                        ^
          ______________|_______________
         |                              |
Documents\PowerShell\          Documents\WindowsPowerShell\
  Microsoft.PowerShell_profile.ps1   profile.ps1
     (PowerShell 7)                     (Windows PowerShell 5.1)
```

Both stubs contain exactly:

```powershell
. $env:USERPROFILE\.config\powershell\user_profile.ps1
```

### 4.2 Modules

```powershell
Install-Module posh-git, PSFzf, Terminal-Icons, z -Scope CurrentUser
```

> ### Gotcha that will bite you
>
> PowerShell 7's default `PSModulePath` includes the **machine-wide** Windows
> PowerShell folder (`C:\Program Files\WindowsPowerShell\Modules`) but **not**
> the **per-user** one (`Documents\WindowsPowerShell\Modules`).
>
> A module installed years ago for PowerShell 5.1 is therefore invisible to
> PowerShell 7, and you get:
>
> ```
> Import-Module: The specified module 'posh-git' was not loaded because
> no valid module file was found in any module directory.
> ```
>
> Fix: install it again with `-Scope CurrentUser` from **pwsh 7**, which
> writes to `Documents\PowerShell\Modules`. The 5.1 copy stays — nothing
> is removed, both shells work.
>
> When diagnosing this, note that a child process **inherits** `PSModulePath`
> from its parent. To see the true default, reset it first:
> `$env:PSModulePath = $null; pwsh -NoProfile -Command '$env:PSModulePath'`

### 4.3 `user_profile.ps1`

Key contents — guarded imports so a missing module warns instead of erroring:

```powershell
function Import-IfAvailable([string]$Name) {
  if (Get-Module -ListAvailable -Name $Name -EA SilentlyContinue) {
    Import-Module $Name -EA SilentlyContinue
    return $true
  }
  Write-Warning "Module '$Name' not found for PowerShell $($PSVersionTable.PSVersion.Major). Install with: Install-Module $Name -Scope CurrentUser"
  return $false
}

Import-IfAvailable posh-git | Out-Null

$omp_config = Join-Path $PSScriptRoot ".\takuya.omp.json"
oh-my-posh init pwsh --config $omp_config | Invoke-Expression

Import-IfAvailable Terminal-Icons | Out-Null

# PSReadLine - guarded: these throw when stdout is redirected / non-interactive
if ($Host.UI.SupportsVirtualTerminal -and -not [Console]::IsOutputRedirected) {
  Set-PSReadLineOption -EditMode Emacs
  Set-PSReadLineOption -BellStyle None
  Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
  Set-PSReadLineOption -PredictionSource History
}

if (Import-IfAvailable PSFzf) {
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
}

$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
# Set-Alias grep findstr   # shadows real grep - left commented

$env:PATH += ';.\node_modules\.bin'
$env:PATH += ";$env:USERPROFILE\.cargo\bin"

# See section 6
$modernGcc = "$env:USERPROFILE\scoop\apps\mingw\current\bin"
if (Test-Path "$modernGcc\gcc.exe") { $env:PATH = "$modernGcc;$env:PATH" }

# fzf colors - solarized-osaka.nvim extras/fzf/solarized_osaka_dark.sh
$env:FZF_DEFAULT_OPTS = "--highlight-line --info=inline-right --ansi --layout=reverse --border=none " +
  "--color=bg+:#002c38,bg:#001419,border:#063540,fg:#9eabac,gutter:#001419,header:#c94c16," +
  "hl+:#c94c16,hl:#c94c16,info:#637981,marker:#c94c16,pointer:#c94c16,prompt:#c94c16," +
  "query:#9eabac:regular,scrollbar:#063540,separator:#063540,spinner:#c94c16"

function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
```

### 4.4 Prompt theme

`~\.config\powershell\takuya.omp.json` — craftzdog's oh-my-posh theme, from
`dot_config/powershell/takuya.omp.json` on his `feat/late-2026` branch.

To use your own instead, change one line:

```powershell
$omp_config = Join-Path $PSScriptRoot ".\dilip.omp.json"
```

---

## 5. Git, delta, lazygit, commitizen

### delta

```powershell
scoop install delta
```

`~\.config\git\delta.gitconfig` — craftzdog's exact styling:

```ini
[delta]
    line-numbers = true
    side-by-side = false
    features = decorations
    syntax-theme = Monokai Extended
[delta "interactive"]
    keep-plus-minus-markers = true
[delta "decorations"]
    commit-decoration-style = blue ol
    commit-style = raw
    file-style = omit
    hunk-header-decoration-style = blue box
    hunk-header-file-style = red
    hunk-header-line-number-style = "#067a00"
    hunk-header-style = file line-number syntax
```

Wire it in (does **not** touch existing `user` / `credential` settings):

```powershell
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global include.path "~/.config/git/delta.gitconfig"
```

### lazygit

`%LOCALAPPDATA%\lazygit\config.yml`:

```yaml
customCommands:
  - key: "C"
    command: "git cz"
    description: "commit with commitizen"
    context: "files"
    loadingText: "opening commitizen commit tool"
    output: terminal
gui:
  mouseEvents: false
```

lazygit inherits terminal ANSI colors, so section 2 makes it Solarized
automatically.

### commitizen

```powershell
npm install -g commitizen cz-git
```

`~\.czrc`:

```json
{ "path": "cz-git" }
```

Then `git cz` for guided conventional commits, or `C` inside lazygit.

---

## 6. The `C:\MinGW` problem (important)

### Symptom

Treesitter parsers fail to build, or build and then fail to load.

### Cause

`C:\MinGW` is a **32-bit-only** MinGW.org install with **GCC 6.3.0 (Dec 2016)**.
It sits in the **machine** PATH, ahead of every modern toolchain.

```
C:\MinGW\bin\gcc.exe          -dumpmachine: mingw32            -> 32-bit
scoop\apps\mingw\...\gcc.exe  -dumpmachine: x86_64-w64-mingw32 -> 64-bit
```

Neovim is a 64-bit process. **A 32-bit DLL cannot load into a 64-bit process.**
Verified by compiling the same file with each:

```
C:\MinGW gcc 6.3.0  ->  PE32  ... Intel i386   (32-bit)
scoop gcc 15.2.0    ->  PE32+ ... x86-64       (64-bit)
nvim.exe            ->  PE32+ ... x86-64
```

So this is an architecture mismatch, not merely an old compiler.

### Workarounds applied (no admin needed)

1. **Neovim** — `vim.env.CC` in `lua/config/options.lua` (section 3.2)
2. **PowerShell** — PATH prepend in `user_profile.ps1` (section 4.3)

### Proper fix (needs an elevated shell)

Still outstanding. Git Bash, `cmd`, and VS Code build tasks continue to get the
32-bit compiler until this is done.

```powershell
$p = [Environment]::GetEnvironmentVariable('Path','Machine')
$p | Set-Content "$env:USERPROFILE\PATH-Machine-backup.txt"
$new = ($p -split ';' | Where-Object { $_ -and $_ -notmatch '^C:\\MinGW\\bin\\?$' }) -join ';'
[Environment]::SetEnvironmentVariable('Path', $new, 'Machine')
```

This removes only the **PATH entry**. `C:\MinGW` stays on disk (237 MB), so
32-bit builds remain available via the full path. **Nothing is deleted.**

Also worth removing while elevated: `C:\msys64\mingw64\bin` appears in PATH
twice and the directory does not exist.

---

## 7. Keybindings and commands

### Neovim

| Key | Action |
|---|---|
| `sf` | oil — floating file manager with preview |
| `sb` | telescope file browser |
| `<leader>e` | neo-tree |
| `ss` / `sv` | split / vsplit |
| `sh` `sj` `sk` `sl` | window navigation |

Inside oil: `<CR>` open, `h` / `-` parent, `q` close, `<C-p>` preview,
`g?` help, `g.` toggle hidden, `gs` sort, `gx` open externally,
`<C-s>` / `<C-h>` / `<C-t>` vsplit / split / tab.

oil edits the filesystem as text — rename by editing a line, create by adding
one (trailing `/` = directory), delete with `dd`, move by cut/paste between oil
buffers, then `:w` to apply. LSP updates imports on rename.

### PowerShell

| Key / command | Action |
|---|---|
| `Ctrl+r` | fuzzy history search (fzf) |
| `Ctrl+f` | fuzzy file picker |
| `Ctrl+a` / `Ctrl+e` | line start / end (Emacs mode) |
| `z <name>` | jump to a frecent directory |
| `which <cmd>` | resolve a command's path |
| `vim` `ll` `g` `tig` `less` | aliases |
| `git cz` | conventional commit prompt |

---

## 8. Verification

```powershell
delta --version                       # 0.19.2
gcc --version                         # 15.2.0, NOT 6.3.0
nvim --version | Select -First 1      # 0.12.x
Get-Command z, delta, oh-my-posh | Select Name, Source
git config --get core.pager           # delta
```

```bash
nvim --headless -c 'lua vim.defer_fn(function()
  print(vim.g.colors_name,
        require("solarized-osaka.config").options.style,
        vim.env.CC)
  vim.cmd("qa") end, 3000)'
# expect: solarized-osaka  vivid  ...\scoop\apps\mingw\current\bin\gcc.exe
```

---

## 9. Known gotchas

| Symptom | Cause | Fix |
|---|---|---|
| `Import-Module: ... not loaded` | module installed for PS 5.1 user path only | reinstall with `-Scope CurrentUser` from pwsh 7 (4.2) |
| `z is not recognized` | same as above | `Install-Module z -Scope CurrentUser` |
| `attempt to call field 'is_window_valid' (a nil value)` | `:Lazy update` run inside a live Neovim; old module cached in memory while new source loaded | restart Neovim |
| `sf` opens the wrong thing | key bound in two plugin specs | check **all** of `lua/plugins/*.lua`, not just `config/keymaps.lua` |
| Treesitter parsers fail to build | 32-bit GCC 6.3.0 first in PATH | section 6 |
| Colors look wrong despite the right colorscheme | `transparent = true` means the terminal palette shows through | section 2 |
| Terminal not as translucent as macOS | Windows has no equivalent of the macOS compositor blur | not fixable |

---

## 10. Upstream reference

- Dotfiles: <https://github.com/craftzdog/dotfiles> (the old
  `dotfiles-public` URL 301-redirects here)
- `master` — LazyVim-based, the lineage this config forked from
- `feat/late-2026` — full rewrite: chezmoi, `vim.pack` instead of lazy.nvim,
  native `vim.lsp.config` / `vim.lsp.enable`, blink.cmp, snacks, oil.nvim.
  **Not adopted here** — migrating would cost the 30 LazyVim extras.
  oil.nvim was backported from it individually.
- Colorscheme: <https://github.com/craftzdog/solarized-osaka.nvim>
  (ships generated themes for Windows Terminal, delta, fzf, lazygit and more
  under `extras/`)
