--- MOD CONFIG

SMODS.Atlas({
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34
})

loc_colour()
G.ARGS.LOC_COLOURS.joy_mod = G.ARGS.LOC_COLOURS.joy_mod or HEX("F4A6C7")

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

SMODS.current_mod.custom_ui = function(modNodes)
    --modNodes[1].nodes[1].config.colour = HEX("1E7A0A")

    modNodes[#modNodes + 1] = {
        n = G.UIT.R,
        config = {
            padding = 0.2,
            align = "cm",
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    padding = 0.2,
                    align = "cm",
                },
                nodes = {
                    UIBox_button({
                        colour = G.C.RED,
                        minw = 3.85,
                        button = "repertorium_github",
                        label = { localize('k_repertorium_github') }
                    })
                }
            },
            {
                n = G.UIT.C,
                config = {
                    padding = 0.2,
                    align = "cm",
                },
                nodes = {
                    UIBox_button({
                        colour = G.C.BLUE,
                        minw = 3.85,
                        button = "repertorium_discord",
                        label = { localize('k_repertorium_discord') }
                    })
                }
            },
        }
    }
end

function G.FUNCS.repertorium_discord(e)
    love.system.openURL("https://discord.gg/Ac5FKpQCRV")
end

function G.FUNCS.repertorium_github(e)
    love.system.openURL("https://github.com/nh6574/Repertorium")
end
