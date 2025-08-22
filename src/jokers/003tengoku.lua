--- 天天天国地獄国 (Tententengokujigokugoku)
SMODS.Atlas {
    key = "003tengoku",
    path = "003tengoku.png",
    px = 71,
    py = 95
}


SMODS.Joker {
    key = "tengoku",
    atlas = "003tengoku",
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local kino_loaded = not not next(SMODS.find_mod("kino"))
        return {
            vars = { card.ability.extra.chance_1 * 100, card.ability.extra.chance_2 * 100, card.ability.extra.chance_3 * 100, not kino_loaded and card.ability.extra.chips or card.ability.extra.counters, not kino_loaded and card.ability.extra.mult or card.ability.extra.counters, card.ability.extra.xmult, card.ability.extra.perma_xmult },
            key = kino_loaded and "j_repertorium_tengoku_alt" or nil
        }
    end,
    config = {
        extra = {
            chance_1 = 0.8,
            chance_2 = 0.15,
            chance_3 = 0.05,
            chips = 50,
            mult = 5,
            xmult = 1.25,
            perma_xmult = 0.1,
            counters = 2
        }
    },
    calculate = function(self, card, context)
        -- TBD
    end
}
