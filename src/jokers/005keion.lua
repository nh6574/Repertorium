--- 映画けいおん! (K-On! The Movie)
SMODS.Atlas {
    key = "005keion",
    path = "005keion.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "keion",
    atlas = "005keion",
    discovered = true,
    rarity = 2,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        local kino_loaded = not not next(SMODS.find_mod("kino"))
        return {
            vars = { card.ability.extra.counters, card.ability.extra.xchips, card.ability.extra.current_xchips },
            key = (not kino_loaded and "j_repertorium_keion_locked") or
                (#SMODS.Suit.obj_buffer >= 5 and "j_repertorium_keion_alt") or nil
        }
    end,
    generate_ui = (Kino or {}).generate_info_ui,
    kino_joker = {
        id = 120811,
        budget = 0,
        box_office = 21434003,
        release_date = "2011-03-12",
        runtime = 110,
        country_of_origin = "JP",
        original_language = "jp",
        critic_score = 0,
        audience_score = 7.9,
        cast = {},
    },
    pools, k_genre = { "Animation", "Comedy", "Musical" },
    config = {
        extra = {
            counters = 5,
            xchips = 0.5,
            current_xchips_non = 1,
            suits = {}
        }
    },
    calculate = function(self, card, context)
        if context.before then
            for _, pcard in ipairs(context.scoring_hand) do
                if not card.ability.extra.suits[pcard.base.suit] then
                    pcard:bb_counter_apply("counter_repertorium_angelic", card.ability.extra.counters)
                    card.ability.extra.suits[pcard.base.suit] = true
                    card.ability.extra.suits[1] = (card.ability.extra.suits[1] or 0) + 1
                end
            end

            if (card.ability.extra.suits[1] or 0) >= 5 then
                card.ability.extra.current_xchips_non = card.ability.extra.current_xchips_non +
                    card.ability.extra.xchips
            end
        end
        if context.joker_main and card.ability.extra.current_xchips_non > 1 then
            return {
                xchips = card.ability.extra.current_xchips_non
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval then
            card.ability.extra.suits = {}
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        card.ability.extra.suits = {}
    end,
    in_pool = function(self, args)
        return not not next(SMODS.find_mod("kino"))
    end
}
