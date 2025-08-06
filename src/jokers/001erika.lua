--- Erika Saionji

SMODS.current_mod.optional_features.post_trigger = true

local calc_keys = {
    'chips', 'h_chips', 'chip_mod',
    'mult', 'h_mult', 'mult_mod',
    'x_chips', 'xchips', 'Xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
}

SMODS.Joker {
    key = "erika",
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { localize(card.ability.extra.suit, "suits_plural"), card.ability.extra.mult, card.ability.extra.mult_mod, localize(card.ability.extra.suit, "suits_singular") } }
    end,
    config = {
        extra = {
            mult = 0,
            mult_mod = 1,
            suit = 'Diamonds'
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.suit) then
            return {
                mult = card.ability.extra.mult
            }
        end
        if not context.blueprint then
            if context.post_trigger and context.other_card ~= card and context.other_card.ability.set == "Joker" and
                context.other_context.individual and context.other_ret.jokers then
                for _, key in ipairs(calc_keys) do
                    if context.other_ret.jokers[key] and
                        context.other_ret.jokers[key] > (key:sub(1, 1):lower() == "x" and 1 or 0) then
                        if context.other_context.other_card:is_suit(card.ability.extra.suit) then
                            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                            return {
                                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod } },
                                colour = G.C.MULT,
                                message_card = card
                            }
                        else
                            local prev_mult = card.ability.extra.mult
                            card.ability.extra.mult = math.max(0, card.ability.extra.mult - card.ability.extra.mult_mod)
                            if prev_mult > card.ability.extra.mult then
                                return {
                                    message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod } },
                                    colour = G.C.MULT,
                                    message_card = card
                                }
                            end
                        end
                    end
                end
            end
            if context.end_of_round and context.game_over == false and context.main_eval then
                card.ability.extra.suit = 'Diamonds'
                local valid_cards = {}
                for _, playing_card in ipairs(G.playing_cards) do
                    if not SMODS.has_no_suit(playing_card) then
                        valid_cards[#valid_cards + 1] = playing_card
                    end
                end
                local pcard = pseudorandom_element(valid_cards,
                    'j_repertorium_erika' .. G.GAME.round_resets.ante)
                if pcard then
                    card.ability.extra.suit = pcard.base.suit
                end
            end
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.suit = 'Diamonds'
        if G.playing_cards then
            local valid_cards = {}
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(playing_card) then
                    valid_cards[#valid_cards + 1] = playing_card
                end
            end
            local pcard = pseudorandom_element(valid_cards,
                'j_repertorium_erika' .. G.GAME.round_resets.ante)
            if pcard then
                card.ability.extra.suit = pcard.base.suit
            end
        end
    end
}
