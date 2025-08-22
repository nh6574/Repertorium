--- MOD CONFIG

SMODS.Atlas({
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34
})

SMODS.current_mod.optional_features = { cardareas = {} }

SMODS.current_mod.description_loc_vars = function()
    return { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.2 }
end

SMODS.current_mod.ui_config = {
    bg_colour = HEX("1A780566"),
    back_colour = HEX("1E7A0A"),
    tab_button_colour = HEX("1E7A0A"),
    collection_option_cycle_colour = HEX("1E7A0A"),
}
