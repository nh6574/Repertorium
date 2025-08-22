--- 映画けいおん! (K-On! The Movie)

SMODS.Joker {
    key = "keion",
    discovered = true,
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
    },
    pools, k_genre = { "Animation", "Comedy", "Musical" },
    config = {
        extra = {
            counters = 1,
            xchips = 0.5,
            current_xchips = 1
        }
    },
    calculate = function(self, card, context)

    end
}
