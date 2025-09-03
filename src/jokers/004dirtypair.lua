--- Lovely Angels
SMODS.Atlas {
    key = "004dirtypair",
    path = "004dirtypair.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "dirtypair",
    discovered = true,
    atlas = "004dirtypair",
    rarity = 3,
    cost = 7,
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
        if context.joker_main and next(context.poker_hands["Pair"]) then
            for _, pair in ipairs(context.poker_hands["Pair"]) do
                if SMODS.pseudorandom_probability(card, card.config.center.key, 1, card.ability.extra.odds) then
                    for _, pcard in ipairs(pair) do
                        pcard.repertorium_dirtypair = true
                    end
                end
            end

            return {
                xmult = card.ability.extra.xmult * #context.poker_hands["Pair"]
            }
        end

        if context.destroy_card and context.cardarea == G.play and context.destroy_card.repertorium_dirtypair then
            context.destroy_card.repertorium_dirtypair = nil
            return {
                remove = true,
                message = localize("k_repertorium_oops"),
                message_card = card
            }
        end
    end
}
