--- For the Sake of Tomorrow #3

SMODS.Joker {
    key = "joe",
    discovered = true,
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
                    xmult = card.ability.extra.xmult
                }
            end
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.after and not context.blueprint then
            if card.ability.extra.mult <= 0 then
                card.ability.extra.mult = 20
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
            return {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod } },
                colour = G.C.RED
            }
        end
    end
}
