--- Lovely Angels

SMODS.Joker {
    key = "dirtypair",
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, self.key)
        return { vars = { card.ability.extra.xmult, numerator, denominator } }
    end,
    config = {
        extra = {
            xmult = 2,
            odds = 2
        }
    },
    calculate = function(self, card, context)
        -- TBD
    end
}
