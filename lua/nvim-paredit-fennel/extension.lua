local traversal = require("nvim-paredit.utils.traversal")
local common = require("nvim-paredit.utils.common")

local M = {}

local form_types = {
  "list",
  "let",
  "fn",
  "for",
  "local",
  "table",
  "sequential_table",
  "quoted_list",
  "let_clause",
  "sequential_table_binding",
  "parameters",
  "each",
}

M.whitespace_chars = { " ", "," }

local function find_next_parent_form(current_node)
  if common.included_in_table(form_types, current_node:type()) then
    return current_node
  end

  local parent = current_node:parent()
  if parent then
    return find_next_parent_form(parent)
  end

  return current_node
end

function M.get_node_root(node)
  local search_point = node
  if M.node_is_form(node) then
    search_point = node:parent()
  end

  local root = find_next_parent_form(search_point)
  return traversal.find_root_element_relative_to(root, node)
end

function M.unwrap_form(node)
  if common.included_in_table(form_types, node:type()) then
    return node
  end
  local child = node:named_child(0)
  if child then
    return M.unwrap_form(child)
  end
end

function M.node_is_form(node)
  if M.unwrap_form(node) then
    return true
  else
    return false
  end
end

function M.node_is_comment(node)
  return node:type() == "comment"
end

function M.get_form_edges(node)
  local node_range = { node:range() }

  local form = M.unwrap_form(node)
  local form_range = { form:range() }

  local left_range = { node_range[1], node_range[2] }
  left_range[3] = form_range[1]
  left_range[4] = form_range[2] + 1

  local right_range = { form:range() }
  right_range[1] = right_range[3]
  right_range[2] = right_range[4] - 1

  local left_text = vim.api.nvim_buf_get_text(0, left_range[1], left_range[2], left_range[3], left_range[4], {})
  local right_text = vim.api.nvim_buf_get_text(0, right_range[1], right_range[2], right_range[3], right_range[4], {})

  return {
    left = {
      text = left_text[1],
      range = left_range,
    },
    right = {
      text = right_text[1],
      range = right_range,
    },
  }
end

return M
