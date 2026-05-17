return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim", -- This is the magic "shortcut" plugin
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- 1. Setup Mason-DAP to handle the TS adapter automatically
      -- 2. Setup the UI
      dapui.setup()

      -- 3. The only "manual" part you really want: Auto-open the UI
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    keys = {
      -- Toggle the UI manually
      { "<leader>du", function() require("dapui").toggle() end,          desc = "DAP UI Toggle" },

      -- Essential debugging keys
      { "<leader>da", function() require("dap").toggle_breakpoint() end, desc = "DAP - Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,          desc = "DAP - Continue" },
    },
  }
}
