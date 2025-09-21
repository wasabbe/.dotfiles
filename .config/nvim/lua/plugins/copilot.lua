return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  build = ":Copilot auth",
  opts = {
    suggestion = {
      enabled = false,
      auto_trigger = false,
    },
    panel = { enabled = false },
    filetypes = {
      yaml = true,
      markdown = true,
      help = true,
    },
  },
}
