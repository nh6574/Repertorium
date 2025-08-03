SMODS.Joker {
    key = "erika",
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { "Diamonds", card.ability.extra.mult, card.ability.extra.mult_mod, "Diamond" } }
    end,
    config = {
        extra = {
            mult = 1,
            mult_mod = 1
        }
    }
}
