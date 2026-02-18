local user = "tkolleh"
user = user:sub(1, 1):upper() .. user:sub(2)
local custom_question_header = "  " .. user .. " "
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  cmd = "CopilotChat",
  build = "make tiktoken", -- Only on MacOS or Linux
  opts = {
    question_header = custom_question_header,
    answer_header = "  Copilot ",
    window = {
      width = 0.4,
    },
  },
}
