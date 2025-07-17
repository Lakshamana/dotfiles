local M = {}

local default_model = "gpt-4.1"
local available_models = {
  "google/gemini-2.0-flash-001",
  "google/gemini-2.5-pro-preview-03-25",
  "anthropic/claude-3.7-sonnet",
  "anthropic/claude-3.5-sonnet",
  "openai/gpt-4o-mini",
  "openai/gpt-4.1",
}
local current_model = default_model

function M.select_model()
  vim.ui.select(available_models, {
    prompt = "Select  Model:",
  }, function(choice)
    if choice then
      current_model = choice
      vim.notify("Selected model: " .. current_model)
    end
  end)
end

---@param chat CodeCompanion.Chat
---@param id string
---@param input string
function M.add_image(chat, id, input)
  local new_message = {
    {
      type = "text",
      text = "the user is sharing this image with you. be ready for a query or task regarding this image",
    },
    {
      type = "image_url",
      image_url = {
        url = input,
      },
    },
  }

  local constants = require("codecompanion.config").config.constants
  chat:add_message({
    role = constants.USER_ROLE,
    content = vim.fn.json_encode(new_message),
  }, { reference = id, visible = false })

  chat.references:add({
    id = id,
    source = "adapter.image_url",
  })
end

---@Param chat CodeCompanion.Chat
function M.slash_paste_image(chat)
  local clipboard = require("img-clip.clipboard")
  local paste = require("img-clip.paste")
  local prefix = paste.get_base64_prefix()
  local base64res = clipboard.get_base64_encoded_image()
  local url = prefix .. base64res
  local hash = vim.fn.sha256(url)
  local id = "<pasted_image>" .. hash:sub(1, 16) .. "</pasted_image>"
  M.add_image(chat, id, url)
end

function M.get_slash_commands()
  return {
    ["image_paste"] = {
      callback = M.slash_paste_image,
      description = "add image from clipboard",
    },
  }
end

function M.map(tbl, fn)
	local result = {}
	for i, v in ipairs(tbl) do
		result[i] = fn(v, i)
	end
	return result
end

function M.get_adapter()
	local openai = require("codecompanion.adapters.openai")
	return require("codecompanion.adapters").extend("openai", {
		handlers = {
			form_parameters = function(self, params, messages)
				local result = openai.handlers.form_parameters(self, params, messages)
				return result
			end,
			form_messages = function(self, messages)
				local result = openai.handlers.form_messages(self, messages)

				M.map(result.messages, function(v)
					local ok, json_res = pcall(function()
						return vim.fn.json_decode(v.content)
					end, "not a json")
					if ok then
						v.content = json_res
						return v
					end
					return v
				end)

				return result
			end,
		},
		schema = {
			model = {
				default = current_model,
			},
		},
	})
end

return M
