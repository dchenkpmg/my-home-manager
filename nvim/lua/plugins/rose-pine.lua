return {
  -- add rose-pine
  { "rose-pine/neovim", name = "rose-pine", enabled = true, opts = { styles = { transparency = true } } },

  -- Configure LazyVim to load rose-pine
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
