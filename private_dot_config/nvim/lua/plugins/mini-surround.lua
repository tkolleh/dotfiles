--
-- motions to for surrounding text objects
--
return {
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    enabled = true,
    -- mappings here all match mini.surround's own defaults (sa/sd/sf/sF/sh/sr)
    -- and are left unset. `update_n_lines` is not a real mappings key in the
    -- installed version (mini/surround.lua's mappings default has no such
    -- field) -- left out rather than set to a key that's silently ignored.
    opts = {},
  },
}
