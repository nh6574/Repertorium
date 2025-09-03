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
    end
}
