return {
  "lalitmee/browse.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local browse = require("browse")
    local keymap = vim.keymap

    browse.setup({
      provider = "google", -- google, duckduckgo, bing, brave
      icons = {
        bookmark_alias = "  ",
        bookmarks_prompt = "󰂺 ",
        grouped_bookmarks = "",
      }
    })

    local bookmarks = {
      ["AI"] = {
        ["NEE.AI"] = "https://ai.nee.com/chat/v2/welcome",
        ["Copilot"] = "https://github.com/copilot"
      },
      ["Tools"] = {
        ["SDP Templates"] = "https://sdp.nee.com/create",
        ["SDP Runners"] = "https://sdp.nee.com/runner-settings"
      },
      ["AWS"] = {
        ["AWS CDK API Reference"] = "https://docs.aws.amazon.com/cdk/api/v2/docs/aws-construct-library.html",
        ["AWS SDK"] = "https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/introduction/",
      },
      ["Languages"] = {
        ["TypeScript"] = "https://www.typescriptlang.org/docs/handbook/intro.html",
        ["Bash"] = "https://www.gnu.org/software/bash/manual/bash.html",
      },
    }

    local function command(name, rhs, opts)
      opts = opts or {}
      vim.api.nvim_create_user_command(name, rhs, opts)
    end

    command("Google", function()
      browse.input_search()
    end, {})

    command("GitHub", function()
      local github = {
        ["NEE Repo search "] = "https://github.com/search?q=org:NextEraEnergy+%s&type=repositories",
        ["NEE code search"] = "https://github.com/search?q=org:NextEraEnergy+%s&type=code",
        ["NEE actions Repo search "] = "https://github.com/search?q=org:nee-actions+%s&type=repositories",
        ["NEE actions code search"] = "https://github.com/search?q=org:nee-actions+%s&type=code",
        ["Code search"] = "https://github.com/search?q=%s&type=code",
        ["Repo search "] = "https://github.com/search?q=%s&type=repositories",
      }

      browse.open_manual_bookmarks({ bookmarks = github, prompt_title = "GitHub Search" })
    end, {})

    command("Confluence", function()
      local confluence = { "https://confluence.nexteraenergy.com/dosearchsite.action?queryString=%s" }
      browse.open_manual_bookmarks({ bookmarks = confluence, prompt_title = "Confluence Search" })
    end, {})

    command("Bookmarks", function()
      browse.open_manual_bookmarks({ bookmarks = bookmarks })
    end)

    -- keymaps
    keymap.set("n", "<leader>ss", ":Google<CR>")
    keymap.set("n", "<leader>sg", ":GitHub<CR>")
    keymap.set("n", "<leader>sc", ":Confluence<CR>")
    keymap.set("n", "<leader>sb", ":Bookmarks<CR>")
  end,
}
