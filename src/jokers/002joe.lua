--- For the Sake of Tomorrow #3
SMODS.Atlas {
    key = "002joe",
    path = "002joe.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "joe",
    atlas = "002joe",
    discovered = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.xmult, "#3" } }
    end,
    config = {
        extra = {
            mult = 20,
            mult_mod = 4,
            xmult = 4
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.mult <= 0 then
                return {
                    xmult = card.ability.extra.xmult,
                    message = localize("k_repertorium_cross"),
                    colour = G.C.RED
                }
            end
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.after and not context.blueprint then
            if card.ability.extra.mult <= 0 then
                card.ability.extra.mult = 20
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.children.center:set_sprite_pos({ x = 0, y = 0 })
                        return true
                    end
                }))
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
            if card.ability.extra.mult <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.children.center:set_sprite_pos({ x = 1, y = 0 })
                        return true
                    end
                }))
            end
            return {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod } },
                colour = G.C.RED
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        if card.ability.extra.mult == 0 then
            card.children.center:set_sprite_pos({ x = 1, y = 0 })
        end
    end,
    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                {
                    border_nodes = {
                        { ref_table = "card.joker_display_values", ref_value = "x_symbol" },
                        { ref_table = "card.joker_display_values", ref_value = "x_mult",  retrigger_type = "exp" },
                    }
                },
                { ref_table = "card.joker_display_values", ref_value = "plus_symbol", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult",        retrigger_type = "mult", colour = G.C.MULT }
            },
            calc_function = function(card)
                local in_play = not not next(G.play.cards)
                card.joker_display_values.x_symbol = in_play and card.joker_display_values.x_symbol or
                    (card.ability.extra.mult <= 0 and 'X' or '')
                card.joker_display_values.x_mult = in_play and card.joker_display_values.x_mult or
                    (card.ability.extra.mult <= 0 and card.ability.extra.xmult or '')
                card.joker_display_values.plus_symbol = in_play and card.joker_display_values.plus_symbol or
                    (card.ability.extra.mult > 0 and '+' or '')
                card.joker_display_values.mult = in_play and card.joker_display_values.mult or
                    (card.ability.extra.mult > 0 and card.ability.extra.mult or '')
            end,
            style_function = function(card, text, reminder_text, extra)
                if text and text.children[1] then
                    local in_play = not not next(G.play.cards)
                    text.children[1].config.colour = in_play and text.children[1].config.colour or
                        (card.ability.extra.mult <= 0 and G.C.MULT or G.C.CLEAR)
                end
                return false
            end
        }
    end
}
