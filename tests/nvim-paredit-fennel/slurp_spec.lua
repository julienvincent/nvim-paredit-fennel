local paredit = require("nvim-paredit.api")

local prepare_buffer = require("tests.nvim-paredit-fennel.utils").prepare_buffer
local expect_all = require("tests.nvim-paredit-fennel.utils").expect_all
local expect = require("tests.nvim-paredit-fennel.utils").expect

describe("slurping forward", function()
  vim.api.nvim_buf_set_option(0, "filetype", "fennel")
  local parser = vim.treesitter.get_parser(0)

  it("should slurp forward different form types", function()
    expect_all(paredit.slurp_forwards, {
      {
        "list",
        before_content = "() a",
        before_cursor = { 1, 1 },
        after_content = "( a)",
        after_cursor = { 1, 1 },
      },
      {
        "vector",
        before_content = "[] a",
        before_cursor = { 1, 1 },
        after_content = "[ a]",
        after_cursor = { 1, 1 },
      },
      {
        "quoted list",
        before_content = "`() a",
        before_cursor = { 1, 2 },
        after_content = "`( a)",
        after_cursor = { 1, 2 },
      },
    })
  end)

  it("should skip comments", function()
    prepare_buffer({
      content = { "()", ";; comment", "a" },
      cursor = { 1, 1 },
    })
    paredit.slurp_forwards()
    expect({
      content = { "(", ";; comment", "a)" },
      cursor = { 1, 0 },
    })
  end)

  it("should recursively slurp the next sibling", function()
    prepare_buffer({
      content = "(()) 1 2",
      cursor = { 1, 2 },
    })

    paredit.slurp_forwards()
    expect({
      content = "(() 1) 2",
      cursor = { 1, 2 },
    })

    parser:parse()

    paredit.slurp_forwards()
    expect({
      content = "(( 1)) 2",
      cursor = { 1, 2 },
    })

    parser:parse()

    paredit.slurp_forwards()
    expect({
      content = "(( 1) 2)",
      cursor = { 1, 2 },
    })

    parser:parse()

    paredit.slurp_forwards()
    expect({
      content = "(( 1 2))",
      cursor = { 1, 2 },
    })
  end)

  it("should follow the bracket with cursor", function()
    prepare_buffer({
      content = "() 1 2",
      cursor = { 1, 1 },
    })
    paredit.slurp_forwards({ cursor_behaviour = "follow" })
    expect({
      content = "( 1) 2",
      cursor = { 1, 3 },
    })
  end)
end)
