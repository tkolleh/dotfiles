-- API key is resolved once per Neovim process (not per completion request) via
-- ~/.local/bin/ck-ai-gateway-token, which checks the token stored in 1Password for
-- expiry and transparently refreshes it (gcloud + the AI Gateway's /token endpoint,
-- writing the new token back to 1Password) before printing it. First resolution may
-- trigger a 1Password Touch ID prompt on Neovim's own process; the result is cached
-- in this local for the rest of the session.
local cached_api_key = nil

local function get_api_key()
  if cached_api_key then
    return cached_api_key
  end

  -- Neovim 0.12's native nvim_echo(kind="progress") is NOT used here: confirmed live
  -- that noice.nvim swallows it with zero visible output -- noice's only route for
  -- kind="progress" is hardcoded to LSP-sourced progress (noice/lsp/progress.lua),
  -- and anything outside that event/kind pairing is dropped silently. vim.notify is
  -- the alternative confirmed to actually render, via noice's existing views.mini route.
  vim.notify("minuet-ai: resolving API key...", vim.log.levels.INFO)

  local result = vim.fn.system({ "ck-ai-gateway-token" })

  if vim.v.shell_error ~= 0 then
    vim.notify("minuet-ai: failed to resolve API key via `ck-ai-gateway-token`: " .. result, vim.log.levels.ERROR)
    return ""
  end

  cached_api_key = result:gsub("\n$", "")

  vim.notify("minuet-ai: API key ready", vim.log.levels.INFO)

  return cached_api_key
end

local default_open_ai = {
  end_point = "https://ai-gateway.aitools.creditkarma.com/v1/chat/completions",
  name = "Credit Karma",
  model = "gpt-5.6-luna",
  api_key = get_api_key,
  stream = true,
}

-- Deferred load, gated behind `<leader>ae` / `:MinuetEnable`.
--
-- Previously this spec listed "saghen/blink.cmp" under `dependencies`, which
-- made lazy.nvim load minuet-ai.nvim as soon as blink.cmp's own extra-spec
-- event (InsertEnter/CmdlineEnter, set by LazyVim's coding/blink extra) fired
-- -- i.e. on the first insert-mode entry of any session, regardless of this
-- spec's own `keys`. `keys` never got a chance to be the trigger because the
-- plugin had already loaded by the time any key was pressed.
--
-- `cmd = { "MinuetEnable" }` below makes lazy.nvim register a stub
-- `:MinuetEnable` user command up front (lazy/core/handler/cmd.lua) that,
-- when run, loads this plugin (running `opts` below) and then re-dispatches
-- `:MinuetEnable` expecting a *real* command of that name to exist post-load
-- -- so the user command of the same name is (re-)defined for real inside
-- `opts`, below the lazy stub's one-shot delegation.
--
-- This intentionally does NOT also flip on minuet's auto_complete/auto-trigger
-- behavior -- enabling only loads the plugin and exposes its keymaps/`:Minuet`
-- subcommands/blink source; ghost-text and automatic popups stay off until
-- invoked manually (<leader>aa duet predict, <A-y> blink map, etc.).
return {
  "milanglacier/minuet-ai.nvim",
  cmd = { "MinuetEnable" },
  keys = {
    { "<leader>ae", "<cmd>MinuetEnable<cr>", mode = "n", desc = "Minuet enable" },
    { "<leader>aa", "<cmd>Minuet duet predict<cr>", mode = "n", desc = "Minuet duet predict" },
    { "<leader>ay", "<cmd>Minuet duet apply<cr>", mode = "n", desc = "Minuet duet apply" },
    { "<leader>an", "<cmd>Minuet duet dismiss<cr>", mode = "n", desc = "Minuet duet dismiss" },
  },
  opts = function(_, opts)
    opts.provider = "openai_compatible"
    -- the maximum total characters of the context before and after the cursor
    -- 16000 characters typically equate to approximately 4,000 tokens for
    -- LLMs.
    opts.context_window = 60000
    opts.provider_options = vim.tbl_deep_extend("force", opts.provider_options or {}, {
      openai_compatible = default_open_ai,
    })
    -- Default request_timeout (3s) is shorter than gpt-5.6-luna's observed reasoning
    -- time on real-world prompts (confirmed 4.1s round-trip against this gateway for a
    -- realistic TypeScript completion). minuet treats a curl --max-time timeout (exit
    -- code 28) as an acceptable partial response rather than an error (utils.lua
    -- stream_decode), so a too-short timeout silently produces "returns no text on
    -- streaming" instead of a visible failure -- this was the root cause of <A-y>
    -- appearing to do nothing with no error shown.
    opts.request_timeout = 10

    -- `:Minuet duet predict` ("predict the next edit") is a separate feature with its
    -- own provider/provider_options, defaulting to Gemini (minuet/duet/config.lua) --
    -- confirmed via the "API key not valid" error duet raised when invoked with no
    -- GEMINI_API_KEY set. Point it at the same Credit Karma gateway and key instead of
    -- leaving duet's unrelated Gemini default in place. Only the connection fields are
    -- overridden; duet's own system/few_shots/chat_input prompt templates (shipped in
    -- make_openai_compatible_options()) are left as-is.
    opts.duet = vim.tbl_deep_extend("force", opts.duet or {}, {
      provider = "openai_compatible",
      provider_options = opts.provider_options,
    })

    -- Real `:MinuetEnable`, defined once the plugin has actually loaded (via
    -- the `cmd` lazy-load trigger above). lazy.nvim's cmd handler deletes its
    -- own stub command and re-dispatches `:MinuetEnable` immediately after
    -- loading, expecting a command of that exact name to exist by then --
    -- this is it. Re-running after the first enable is a harmless no-op.
    --
    -- Setting this flag is all that's needed: blink-cmp.lua's `sources.default`
    -- is a function, re-evaluated live on every completion request (not
    -- memoized at setup), so the very next completion already sees "minuet"
    -- in the enabled provider list with no reload/restart required.
    vim.api.nvim_create_user_command("MinuetEnable", function()
      vim.g.minuet_enabled = true
      vim.notify("minuet-ai: enabled", vim.log.levels.INFO)
    end, {})

    return opts
  end,
}
