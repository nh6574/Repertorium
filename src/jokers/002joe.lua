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
    }
}
