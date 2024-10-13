## nvim-paredit-fennel

> [!WARNING]
>
> This is now deprecated as of nvim-paredit@1.0.0
>
> The language-extensions API has been removed and fennel support has now been directly added to nvim-paredit.

**EXPERIMENTAL**

Provides a language extension implementation to [nvim-paredit](https://github.com/julienvincent/nvim-paredit) for the Fennel programming language

## Installation 

### Using [folke/lazy.vim](https://github.com/folke/lazy.nvim)

```lua
{
  "julienvincent/nvim-paredit-fennel",
  dependencies = { "julienvincent/nvim-paredit" },
  ft = { "fennel" },
  config = function()
    require("nvim-paredit-fennel").setup()
  end
}
```
