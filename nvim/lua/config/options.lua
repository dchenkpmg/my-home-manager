vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true -- Line numbers
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Highlight current line
opt.wrap = false -- Don't wrap lines
opt.scrolloff = 4 -- Keep 4 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Indentation
opt.tabstop = 2 -- Tab width
opt.shiftwidth = 2 -- Indent width
opt.softtabstop = 2 -- Soft tab stop NOT IN LAZYVIM
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Smart auto-indenting
opt.autoindent = true -- Copy indent from current line NOT IN LAZYVIM

-- Search settings
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Case sensitive if uppercase in search
opt.hlsearch = false -- Don't highlight search results NOT IN LAZYVIM
opt.incsearch = true -- Show matches as you type NOT IN LAZYVIM
opt.inccommand = "nosplit" -- Preview substitutions in the current buffer

-- Visual settings
opt.termguicolors = true -- Enable 24-bit colors
opt.signcolumn = "yes" -- Always show sign column
opt.showmatch = true -- Highlight matching brackets NOT IN LAZYVIM
opt.matchtime = 2 -- How long to show matching bracket NOT IN LAZYVIM
opt.cmdheight = 1 -- Command line height NOT IN LAZYVIM
opt.showmode = false -- Don't show mode in command line
opt.pumheight = 10 -- Popup menu height
opt.pumblend = 10 -- Popup menu transparency
opt.winblend = 0 -- Floating window transparency NOT IN LAZYVIM
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.concealcursor = "" -- Don't hide cursor line markup NOT IN LAZYVIM
opt.synmaxcol = 300 -- Syntax highlighting limit NOT IN LAZYVIM
opt.ruler = false -- Disable the default ruler
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.winminwidth = 5 -- Minimum window width

-- File handling
opt.backup = false -- Don't create backup files NOT IN LAZYVIM
opt.writebackup = false -- Don't create backup before writing NOT IN LAZYVIM
opt.swapfile = false -- Don't create swap files NOT IN LAZYVIM
opt.undofile = true -- Persistent undo
opt.undolevels = 10000
opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory NOT IN LAZYVIM
opt.updatetime = 200 -- Faster completion
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.ttimeoutlen = 0 -- Key code timeout NOT IN LAZYVIM
opt.autoread = true -- Auto reload files changed outside vim NOT IN LAZYVIM
opt.autowrite = true -- Auto save
opt.sessionoptions = {
	"blank",
	"buffers",
	"curdir",
	"folds",
	"help",
	"tabpages",
	"winsize",
	"winpos",
	"terminal",
	"localoptions",
}

-- Behavior settings
opt.hidden = true -- Allow hidden buffers NOT IN LAZYVIM
opt.errorbells = false -- No error bells NOT IN LAZYVIM
opt.backspace = "indent,eol,start" -- Better backspace behavior NOT IN LAZYVIM
opt.autochdir = false -- Don't auto change directory NOT IN LAZYVIM
opt.iskeyword:append("-") -- Treat dash as part of word NOT IN LAZYVIM
opt.path:append("**") -- include subdirectories in search NOT IN LAZYVIM
opt.selection = "exclusive" -- Selection behavior NOT IN LAZYVIM
opt.mouse = "a" -- Enable mouse support
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.modifiable = true -- Allow buffer modifications NOT IN LAZYVIM
opt.encoding = "UTF-8" -- Set encoding NOT IN LAZYVIM
opt.spelllang = { "en" }

-- Folding settings
opt.smoothscroll = true
vim.wo.foldmethod = "expr" -- NOT IN LAZYVIM
opt.foldlevel = 99 -- Start with all folds open
opt.foldtext = ""
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Split behavior
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right
opt.splitkeep = "screen"

-- Command-line completion
opt.wildmenu = true -- NOT IN LAZYVIM
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" }) -- NOT IN LAZYVIM

-- Better diff options
opt.diffopt:append("linematch:60") -- NOT IN LAZYVIM

-- Performance improvements
opt.redrawtime = 10000 -- NOT IN LAZYVIM
opt.maxmempattern = 20000 -- NOT IN LAZYVIM

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir") -- NOT IN LAZYVIM
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

vim.g.autoformat = true
vim.g.trouble_lualine = true

opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.list = true
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })

vim.g.markdown_recommended_style = 0

vim.filetype.add({ -- NOT IN LAZYVIM
	extension = {
		env = "dotenv",
	},
	filename = {
		[".env"] = "dotenv",
		["env"] = "dotenv",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})
