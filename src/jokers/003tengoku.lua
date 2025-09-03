--- 天天天国地獄国 (Tententengokujigokugoku)
SMODS.Atlas {
    key = "003tengoku",
    path = "003tengoku.png",
    px = 71,
    py = 95
}

local pos = {
    alive = { x = 3, y = 0 },
    dead = { x = 3, y = 1 },
    birth = { x = 2, y = 0 },
    death = { x = 2, y = 1 },
    heaven = { x = 1, y = 0 },
    hell = { x = 1, y = 1 },
    empty = { x = 0, y = 0 }
}

local change_sprite = function(card, effect)
    G.E_MANAGER:add_event(Event({
        func = function()
            card.children.floating_sprite:set_sprite_pos(pos[effect])
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.children.floating_sprite:set_sprite_pos(pos.empty)
                    return true
                end
            }))
            return true
        end
    }))
end

SMODS.Joker {
    key = "tengoku",
    atlas = "003tengoku",
    soul_pos = pos.empty,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local kino_loaded = not not (Blockbuster or {}).Counters
        return {
            vars = {
                card.ability.extra.chance_1 * 100,
                card.ability.extra.chance_2 * 100,
                card.ability.extra.chance_3 * 100,
                not kino_loaded and card.ability.extra.chips or card.ability.extra.counters,
                not kino_loaded and
                card.ability.extra.mult or card.ability.extra.counters,
                card.ability.extra.xmult,
                card.ability.extra.perma_xmult,
                card.ability.extra.angelic and localize("k_repertorium_angelic") or
                localize("k_repertorium_devilish"),
                colours = { card.ability.extra.angelic and G.C.BLUE or G.C.RED }
            },
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
            counters = 2,
            angelic = true
        }
    },
    calculate = function(self, card, context)
        if context.press_play then
            local kino_loaded = not not (Blockbuster or {}).Counters
            local copied_cards = {}
            for _, pcard in ipairs(G.hand.highlighted) do
                local poll = pseudorandom(card.config.center.key)
                if poll <= card.ability.extra.chance_3 then
                    pcard.repertorium_tengoku_effect = card.ability.extra.angelic and "heaven" or "hell"
                elseif poll <= card.ability.extra.chance_2 then
                    pcard.repertorium_tengoku_effect = card.ability.extra.angelic and "birth" or "death"
                else
                    pcard.repertorium_tengoku_effect = card.ability.extra.angelic and "alive" or "dead"
                    if kino_loaded then
                        pcard:bb_counter_apply(pcard.repertorium_tengoku_effect == "alive" and
                            "counter_repertorium_angelic" or "counter_repertorium_devilish", card.ability.extra.counters)
                    end
                end
                card.ability.extra.angelic = not card.ability.extra.angelic

                if pcard.repertorium_tengoku_effect == "heaven" then
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local copy_card = copy_card(pcard, nil, nil, G.playing_card)
                    copy_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, copy_card)
                    G.hand:emplace(copy_card)
                    copy_card.states.visible = nil
                    table.insert(copied_cards, copy_card)

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            copy_card:start_materialize()
                            return true
                        end
                    }))
                end
            end

            if #copied_cards > 0 then
                for i, pcard in ipairs(copied_cards) do
                    if pcard:is_face() then inc_career_stat('c_face_cards_played', 1) end
                    pcard.base.times_played = pcard.base.times_played + 1
                    pcard.ability.played_this_ante = true
                    G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
                    draw_card(G.hand, G.play, i * 100 / #copied_cards, 'up', nil, pcard)
                end
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.calculate_context({ playing_card_added = true, cards = copied_cards })
                        return true
                    end
                }))
            end
        end

        if context.before and context.main_eval and not context.blueprint then
            for _, pcard in ipairs(context.full_hand) do
                if pcard.repertorium_tengoku_effect == "birth" then
                    pcard:set_ability(SMODS.poll_enhancement { guaranteed = true }, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            pcard:juice_up()
                            return true
                        end
                    }))
                end
                if pcard.repertorium_tengoku_effect == "hell" and pcard.ability.set == "Enhanced" then
                    pcard:set_ability("c_base", nil, true)
                    pcard.ability.perma_xmult = (pcard.ability.perma_xmult or 1) + card.ability.extra.perma_xmult
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            pcard:juice_up()
                            return true
                        end
                    }))
                end
            end
        end

        if context.modify_scoring_hand and context.other_card.repertorium_tengoku_effect and not (Blockbuster or {}).Counters then
            return {
                add_to_hand = context.other_card.repertorium_tengoku_effect == "alive" or nil,
                remove_from_hand = context.other_card.repertorium_tengoku_effect == "dead" or nil,
            }
        end

        if context.individual and (context.cardarea == G.play or context.cardarea == "unscored") and
            context.other_card.repertorium_tengoku_effect then
            local kino_loaded = not not (Blockbuster or {}).Counters
            change_sprite(card, context.other_card.repertorium_tengoku_effect)
            return {
                message = localize('k_repertorium_' .. context.other_card.repertorium_tengoku_effect),
                colour = pos[context.other_card.repertorium_tengoku_effect].y == 0 and G.C.BLUE or G.C.RED,
                message_card = card,
                extra = {
                    chips = not kino_loaded and context.other_card.repertorium_tengoku_effect == "alive" and
                        card.ability.extra.chips or nil,
                    mult = not kino_loaded and context.other_card.repertorium_tengoku_effect == "dead" and
                        card.ability.extra.mult or nil,
                    xmult = context.other_card.repertorium_tengoku_effect == "death" and card.ability.extra.xmult or nil,
                },
            }
        end

        if context.destroy_card and (context.cardarea == G.play or context.cardarea == "unscored") and
            context.destroy_card.repertorium_tengoku_effect == "death" then
            return {
                remove = true
            }
        end

        if context.after then
            for _, pcard in ipairs(context.full_hand) do
                pcard.repertorium_tengoku_effect = nil
            end
        end
    end
}
