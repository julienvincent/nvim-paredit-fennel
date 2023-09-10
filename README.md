## nvim-paredit-fennel

**EXPERIMENTAL**

Provides a language extension implementation to [nvim-paredit](https://github.com/julienvincent/nvim-paredit) for the Fennel programming language

## Usage

```lua
{
  "julienvincent/nvim-paredit-fennel",
  dependencies = { "julienvincent/nvim-paredit" },
  ft = { "fennel" },
  config = function()
    local paredit_fennel = require("nvim-paredit-fennel")
    paredit_fennel.setup()
  end
}
```
