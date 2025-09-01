local M = {}

local ImgStrategies = {}

---@param chat CodeCompanion.Chat
---@param id string
---@param input string
function ImgStrategies.openai(chat, id, input)
  return {
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
end

---@param chat CodeCompanion.Chat
---@param id string
---@param input string
function ImgStrategies.anthropic(chat, id, input)
  return {
    {
      type = "text",
      text = "the user is sharing this image with you. be ready for a query or task regarding this image",
    },
    {
      type = "image",
      source = {
        type = "base64",
        media_type = "image/png",
        data = input,
      },
    },
  }
end

local URIStrategies = {}
function URIStrategies.openai(base64)
  local paste = require("img-clip.paste")
  local prefix = paste.get_base64_prefix()

  return prefix .. base64
end

function URIStrategies.anthropic(base64)
  return base64
end

local default_model = "claude-sonnet-4-20250514"
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
  local new_message = ImgStrategies[chat.adapter.name](chat, id, input)

  local constants = require("codecompanion.config").config.constants
  -- chat:add_message({
  --   role = constants.USER_ROLE,
  --   content = vim.fn.json_encode(new_message),
  -- }, { reference = id, visible = false })

  chat:add_reference({
    role = constants.USER_ROLE,
    content = vim.fn.json_encode(new_message),
  }, "adapter.image_url", id)
end

---@param chat CodeCompanion.Chat
function M.slash_paste_image(chat)
  local clipboard = require("img-clip.clipboard")
  local base64res = clipboard.get_base64_encoded_image()
  local url = URIStrategies[chat.adapter.name](base64res)
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

function M.get_openai_adapter()
  local openai = require("codecompanion.adapters.http.openai")

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

function M.get_anthropic_adapter()
  local anthropic = require("codecompanion.adapters.http.anthropic")
  local idx = 1

  return require("codecompanion.adapters").extend("anthropic", {
    handlers = {
      form_parameters = function(self, params, messages)
        local result = anthropic.handlers.form_parameters(self, params, messages)
        return result
      end,
      form_messages = function(self, messages)
        local result = anthropic.handlers.form_messages(self, messages)

        M.map(result.messages, function(v)
          -- Check if content is an array table
          if type(v.content) == "table" and v.content[idx] then
            -- Access the first element (idx-indexed) text field
            local first_element = v.content[idx]


            if first_element and first_element.text then
              local ok, json_res = pcall(function()
                return vim.fn.json_decode(first_element.text)
              end)
              if ok then
                -- Replace the entire content with the decoded JSON
                v.content = json_res
                return v
              end
            end
          else
            -- Handle string content (fallback for non-array cases)
            local ok, json_res = pcall(function()
              return vim.fn.json_decode(v.content)
            end)
            if ok then
              v.content = json_res
              return v
            end
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
      extended_thinking = {
        default = false,
      },
    },
  })
end
return M
