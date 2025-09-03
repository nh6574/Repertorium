if (Blockbuster or {}).Counters then
    SMODS.Atlas {
        key = "counters",
        path = "counters.png",
        px = 73,
        py = 97
    }

    Blockbuster.Counters.Counter {
        key = "angelic",
        atlas = 'counters',
        pos = { x = 0, y = 0 },
        config = { cap = 5 },
        discovered = true,
        pcard_only = true,
        calculate = function(self, card, context)
            if context.modify_scoring_hand and context.other_card == card then
                return {
                    add_to_hand = true
                }
            end
            if context.main_scoring and context.cardarea == G.play then
                card:bb_increment_counter(-1)
                return {
                    chips = 50
                }
            end
        end
    }
    Blockbuster.Counters.Counter {
        key = "devilish",
        atlas = 'counters',
        pos = { x = 1, y = 0 },
        config = { cap = 5 },
        discovered = true,
        pcard_only = true,
        calculate = function(self, card, context)
            if context.modify_scoring_hand and context.other_card == card then
                return {
                    remove_from_hand = true
                }
            end
            if context.main_scoring and (context.cardarea == G.play or context.cardarea == "unscored") then
                card:bb_increment_counter(-1)
                return {
                    mult = 5
                }
            end
        end
    }
end
