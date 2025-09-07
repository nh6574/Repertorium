--- Amanojaku, Enemy of All
SMODS.Atlas {
    key = "006amanojaku",
    path = "006amanojaku.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "006amanojaku_cheats",
    path = "006cheats.png",
    px = 34,
    py = 34
}

SMODS.current_mod.optional_features.post_trigger = true

local calc_keys = NsRepertorium.calc_keys

local items = {
    "orb",
    "camera",
    "umbrella",
    "mallet",
    "jizo",
    "doll",
    "bomb",
    "lantern",
    "fabric"
}

local amanojaku_setup = function(card, context)
    local valid_items = {}
    for _, item in ipairs(items) do
        if not card.ability.extra.items[item] and
            ((item ~= "jizo" and item ~= "bomb") or #card.ability.extra.items > 0) then
            table.insert(valid_items, item)
        end
    end

    local chosen = pseudorandom_element(valid_items,
        card.config.center.key .. G.GAME.round_resets.ante)
    if chosen then
        card.ability.extra.items[#card.ability.extra.items + 1] = chosen
        card.ability.extra.items[chosen] = true
    end

    local _poker_hands = {}
    for handname, _ in pairs(G.GAME.hands) do
        if SMODS.is_poker_hand_visible(handname) then
            _poker_hands[#_poker_hands + 1] = handname
        end
    end

    G.GAME.repertorium_amanojaku_conditions = {}
    local copy_hands = copy_table(_poker_hands)
    pseudoshuffle(copy_hands, card.config.center.key)
    for i, hand in ipairs(_poker_hands) do
        G.GAME.repertorium_amanojaku_conditions[hand] = copy_hands[i]
    end

    G.GAME.repertorium_amanojaku_poker_hands = { "High Card", "High Card", "High Card", played = { 0, 0, 0 } }

    for i = 1, 3 do
        local chosen_hand, index = pseudorandom_element(_poker_hands, card.config.center.key)
        G.GAME.repertorium_amanojaku_poker_hands[i] = chosen_hand or "High Card"
        G.GAME.repertorium_amanojaku_poker_hands.played[i] = 0
        if index then
            table.remove(_poker_hands, index)
        end
    end

    local valid_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
            valid_cards[#valid_cards + 1] = playing_card
        end
    end
    G.GAME.repertorium_amanojaku_cards = {
        { rank = "any", suit = "any", rank_amount = 5, suit_amount = 5 },
        { rank = "any", suit = "any" },
        { rank = "any", suit = "any" },
        { rank = "any", suit = "any" },
        { rank = "any", suit = "any" },
    }
    for i = 1, 5 do
        local amano_card, index = pseudorandom_element(valid_cards, card.config.center.key)
        if amano_card then
            G.GAME.repertorium_amanojaku_cards[i].rank = amano_card.base.value
            G.GAME.repertorium_amanojaku_cards[i].suit = amano_card.base.suit
            table.remove(valid_cards, index)

            if i == 1 then
                G.GAME.repertorium_amanojaku_cards[i].rank_amount = 0
                G.GAME.repertorium_amanojaku_cards[i].suit_amount = 0
                for _, pcard in ipairs(G.playing_cards) do
                    if pcard.base.value == amano_card.base.value then
                        G.GAME.repertorium_amanojaku_cards[i].rank_amount = G.GAME.repertorium_amanojaku_cards[i]
                            .rank_amount + 1
                    end
                    if pcard:is_suit(amano_card.base.suit) then
                        G.GAME.repertorium_amanojaku_cards[i].suit_amount = G.GAME.repertorium_amanojaku_cards[i]
                            .suit_amount + 1
                    end
                end
                G.GAME.repertorium_amanojaku_cards[i].rank_amount = pseudorandom(card.config.center.key,
                    math.ceil(G.GAME.repertorium_amanojaku_cards[i].rank_amount * 0.5),
                    G.GAME.repertorium_amanojaku_cards[i].rank_amount)
                G.GAME.repertorium_amanojaku_cards[i].suit_amount = pseudorandom(card.config.center.key,
                    math.ceil(G.GAME.repertorium_amanojaku_cards[i].suit_amount * 0.5),
                    G.GAME.repertorium_amanojaku_cards[i].suit_amount)
            end
        else
            G.GAME.repertorium_amanojaku_cards[i].rank = "any"
            G.GAME.repertorium_amanojaku_cards[i].suit = "any"
            if i == 1 then
                G.GAME.repertorium_amanojaku_cards[i].rank_amount = math.min(#G.playing_cards, 5)
                G.GAME.repertorium_amanojaku_cards[i].suit_amount = math.min(#G.playing_cards, 5)
            end
        end
    end
    G.GAME.repertorium_amanojaku_ranks = {}
    for _, pcard in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(pcard) then
            G.GAME.repertorium_amanojaku_ranks[pcard.base.value] = false
        end
    end

    card.ability.extra.played_only = true
    card.ability.extra.score = G.GAME.blind.chips
    card.ability.extra.win = nil
    card.ability.extra.count.rank = 0
    card.ability.extra.count.suit = 0

    if card.ability.extra.items["camera"] then
        ease_discard(1)
    end
    if card.ability.extra.items["fabric"] then
        ease_hands_played(1)
    end
    if card.ability.extra.items["doll"] then
        SMODS.change_play_limit(1)
        SMODS.change_discard_limit(1)
    end
    if card.ability.extra.items["lantern"] then
        G.hand:change_size(1)
    end

    if chosen then
        return {
            message = localize("k_repertorium_get")
        }
    end
end

SMODS.Joker {
    key = "amanojaku",
    atlas = "006amanojaku",
    discovered = true,
    rarity = 4,
    cost = 10,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { set = "Other", key = "repertorium_cheat_item" }
        local orb_numerator, orb_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.orb_odds, self.key)
        local cards_loc = {}
        local chosen_cards = G.GAME.repertorium_amanojaku_cards or
            {
                { rank = "any", suit = "any", rank_amount = 5, suit_amount = 5 },
                { rank = "any", suit = "any" },
                { rank = "any", suit = "any" },
                { rank = "any", suit = "any" },
                { rank = "any", suit = "any" },
            }
        for i, card_info in ipairs(chosen_cards) do
            cards_loc[i] = {}
            cards_loc[i].rank = localize(
                card_info.rank ~= "any" and card_info.rank or "k_repertorium_any",
                card_info.rank ~= "any" and "ranks" or nil)
            cards_loc[i].suit = localize(
                card_info.suit ~= "any" and card_info.suit or "k_repertorium_any",
                card_info.suit ~= "any" and "suits_plural" or nil)
            cards_loc[i].card = localize { type = 'raw_descriptions', key = 'playing_card', set = 'Other', vars = { cards_loc[i].rank, cards_loc[i].suit } }
                [1]
        end
        local poker_hands = G.GAME.repertorium_amanojaku_poker_hands or
            { "High Card", "High Card", "High Card", played = { 0, 0, 0 } }

        local vars = {
            orb = { card.ability.extra.score, localize(poker_hands[1], "poker_hands"), orb_numerator, orb_denominator },
            camera = { card.ability.extra.camera_discards, cards_loc[1].card, cards_loc[2].card, cards_loc[3].card, cards_loc[4].card, cards_loc[5].card, },
            umbrella = {},
            mallet = { card.ability.extra.mallet_score * 100, card.ability.extra.score, card.ability.extra.mallet_money },
            jizo = { card.ability.extra.jizo_used and 0 or 1 },
            doll = { chosen_cards[1].suit_amount, cards_loc[1].suit, chosen_cards[1].rank_amount, cards_loc[1].rank, card.ability.extra.count.suit, card.ability.extra.count.rank, card.ability.extra.doll_selection },
            bomb = { card.ability.extra.score * 3, localize(poker_hands[1], "poker_hands") },
            lantern = { localize(poker_hands[1], "poker_hands"), localize(poker_hands[2], "poker_hands"), localize(poker_hands[3], "poker_hands"), card.ability.extra.lantern_h_size, colours = { poker_hands.played[1] > 0 and G.C.UI.TEXT_INACTIVE or G.C.FILTER, poker_hands.played[2] > 0 and G.C.UI.TEXT_INACTIVE or G.C.FILTER, poker_hands.played[3] > 0 and G.C.UI.TEXT_INACTIVE or G.C.FILTER, } },
            fabric = { localize(poker_hands[2], "poker_hands"), card.ability.extra.fabric_hands, 3 - poker_hands.played[2] }
        }
        for _, item in ipairs(card.ability.extra.items) do
            info_queue[#info_queue + 1] = {
                set = "Other",
                key = "repertorium_cheat_" .. item,
                vars = vars[item],
                main_end =
                    item == "camera" and camera_main_end or nil
            }
        end
    end,
    update = function(self, card, dt)
        if G.jokers and card.area == G.jokers and not card.debuff then
            G.GAME.blind.chip_text = localize("k_repertorium_impossible")
        end
    end,
    config = {
        extra = {
            items = {},
            orb_odds = 2,
            camera_discards = 1,
            mallet_score = 0.1,
            mallet_money = 5,
            jizo_used = false,
            doll_selection = 1,
            lantern_h_size = 1,
            fabric_hands = 1,
            count = { rank = 0, suit = 0 },
            score = 300,
        }
    },
    calculate = function(self, card, context)
        if context.setting_blind then
            return amanojaku_setup(card, context)
        end

        if context.final_scoring_step and card.ability.extra.items["bomb"] then
            return {
                balance = true
            }
        end

        if context.evaluate_poker_hand and card.ability.extra.items["fabric"] and (G.GAME.repertorium_amanojaku_conditions or {})[context.scoring_name] then
            return {
                replace_scoring_name = G.GAME.repertorium_amanojaku_conditions[context.scoring_name]
            }
        end

        if context.post_trigger and context.other_card ~= card and context.other_card.ability.set == "Joker" and context.other_ret.jokers and card.ability.extra.items["mallet"] then
            for _, key in ipairs(calc_keys) do
                local is_hyper = key:sub(1, 1):lower() == "e" or key:sub(1, 2):lower() == "hy"
                local is_x = key:sub(1, 1):lower() == "x"
                if context.other_ret.jokers[key] and (is_hyper or
                        to_big(context.other_ret.jokers[key]) > to_big(is_x and 1 or 0)) then
                    return {
                        dollars = card.ability.extra.mallet_money,
                        message_card = card
                    }
                end
            end
        end

        if context.skip_blind and not card.ability.extra.items["orb"] and SMODS.pseudorandom_probability(card, card.config.center.key, 1, card.ability.extra.orb_odds) then
            card.ability.extra.items[#card.ability.extra.items + 1] = "orb"
            card.ability.extra.items["orb"] = true
            return {
                message = localize("k_repertorium_get")
            }
        end

        if context.end_of_round and context.game_over and card.ability.extra.items["jizo"] and not card.ability.extra.jizo_used then
            card.ability.extra.jizo_used = true
            return {
                saved = "k_repertorium_jizo_saved"
            }
        end

        local win = false
        local win_item

        if context.before then
            if context.scoring_name ~= G.GAME.repertorium_amanojaku_poker_hands[1] then
                card.ability.extra.played_only = false
            end
            if card.ability.extra.items["camera"] and #context.full_hand >= 5 then
                local check_hand = { false, false, false, false, false }

                for i, req in ipairs(G.GAME.repertorium_amanojaku_cards) do
                    if req.rank == "any" or req.suit == "any" then
                        check_hand[i] = true
                    end
                end
                for _, pcard in ipairs(context.full_hand) do
                    if not SMODS.has_no_suit(pcard) and not SMODS.has_no_rank(pcard) then
                        for i, req in ipairs(G.GAME.repertorium_amanojaku_cards) do
                            if not check_hand[i] and req.rank == pcard.base.value and pcard:is_suit(req.suit) then
                                check_hand[i] = true
                                break
                            end
                        end
                    else
                        break
                    end
                end
                win = true
                win_item = "camera"
                for _, bool in ipairs(check_hand) do
                    if not bool then
                        win = false
                        win_item = nil
                        break
                    end
                end
            end

            if not win and card.ability.extra.items["umbrella"] and next(context.poker_hands["Straight Flush"]) then
                if not next(G.GAME.repertorium_amanojaku_ranks) then
                    win = true
                    win_item = "umbrella"
                else
                    for _, pcard in ipairs(context.scoring_hand) do
                        G.GAME.repertorium_amanojaku_ranks[pcard.base.value] = true
                    end
                    win = true
                    win_item = "umbrella"
                    for _, req in pairs(G.GAME.repertorium_amanojaku_ranks) do
                        if not req then
                            win = false
                            win_item = nil
                            break
                        end
                    end
                end
            end

            if not win and card.ability.extra.items["doll"] then
                if G.GAME.repertorium_amanojaku_cards[1].rank == "any" or
                    G.GAME.repertorium_amanojaku_cards[1].suit == "any" then
                    card.ability.extra.count.rank = card.ability.extra.count.rank + #context.full_hand
                    card.ability.extra.count.suit = card.ability.extra.count.suit + #context.full_hand
                else
                    for _, pcard in ipairs(context.full_hand) do
                        if not SMODS.has_no_rank(pcard) and pcard.base.value == G.GAME.repertorium_amanojaku_cards[1].rank then
                            card.ability.extra.count.rank = card.ability.extra.count.rank + 1
                        end
                        if pcard:is_suit(G.GAME.repertorium_amanojaku_cards[1].suit) then
                            card.ability.extra.count.suit = card.ability.extra.count.suit + 1
                        end
                    end
                end
                if card.ability.extra.count.suit >= G.GAME.repertorium_amanojaku_cards[1].suit_amount and card.ability.extra.count.rank >= G.GAME.repertorium_amanojaku_cards[1].rank_amount then
                    win = true
                    win_item = "doll"
                end
            end
            if not win and (card.ability.extra.items["lantern"] or card.ability.extra.items["fabric"]) then
                for i, hand in ipairs(G.GAME.repertorium_amanojaku_poker_hands) do
                    if hand == context.scoring_name then
                        G.GAME.repertorium_amanojaku_poker_hands.played[i] = G.GAME.repertorium_amanojaku_poker_hands
                            .played[i] + 1
                    end
                end
                if card.ability.extra.items["lantern"] then
                    win = true
                    win_item = "lantern"
                    for _, req in ipairs(G.GAME.repertorium_amanojaku_poker_hands.played) do
                        if req == 0 then
                            win = false
                            win_item = nil
                            break
                        end
                    end
                end
                if not win and card.ability.extra.items["fabric"] and G.GAME.repertorium_amanojaku_poker_hands.played[2] >= 3 then
                    win = true
                    win_item = "fabric"
                end
            end
        end

        if context.after then
            if card.ability.extra.items["mallet"] and G.GAME.chips >= to_big(card.ability.extra.score - card.ability.extra.score * card.ability.extra.mallet_score) and G.GAME.chips <= to_big(card.ability.extra.score + card.ability.extra.score * card.ability.extra.mallet_score) then
                win = true
                win_item = "mallet"
            end

            if not win and card.ability.extra.items["bomb"] and card.ability.extra.played_only then
                G.E_MANAGER:add_event(Event({
                    blocking = false,
                    func = function()
                        if G.STATE == G.STATES.SELECTING_HAND and G.GAME.chips >= to_big(card.ability.extra.score * 3) then
                            card.ability.extra.win = "k_repertorium_bomb_win"
                            G.STATE = G.STATES.HAND_PLAYED
                            G.STATE_COMPLETE = true
                            end_round()
                            return true
                        end
                        if G.STATE == G.STATES.ROUND_EVAL then
                            return true
                        end
                    end
                }))
            end
        end

        if win then
            card.ability.extra.win = "k_repertorium_" .. (win_item or "none") .. "_win"
            G.E_MANAGER:add_event(Event({
                blocking = false,
                func = function()
                    if G.STATE == G.STATES.SELECTING_HAND then
                        G.STATE = G.STATES.HAND_PLAYED
                        G.STATE_COMPLETE = true
                        end_round()
                        return true
                    end
                    if G.STATE == G.STATES.ROUND_EVAL then
                        return true
                    end
                end
            }))
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.items["doll"] then
            SMODS.change_play_limit(1)
            SMODS.change_discard_limit(1)
        end
        if card.ability.extra.items["lantern"] then
            G.hand:change_size(1)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.chips - G.GAME.blind.chips >= to_big(0) then
            G.STATE = G.STATES.NEW_ROUND
            G.STATE_COMPLETE = false
        end
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        card.ability.extra.win = nil
        if card.ability.extra.items["doll"] then
            SMODS.change_play_limit(-1)
            SMODS.change_discard_limit(-1)
        end
        if card.ability.extra.items["lantern"] then
            G.hand:change_size(-1)
        end
    end
}

local mod_calculate_ref = SMODS.current_mod.calculate or function(...) end
SMODS.current_mod.calculate = function(self, context)
    if context.end_of_round and context.game_over == false and context.beat_boss and context.main_eval then
        for _, joker in ipairs(SMODS.find_card("j_repertorium_amanojaku", true)) do
            joker.ability.extra.items = {}
            joker.ability.extra.jizo_used = false
            if not joker.debuff then
                if joker.ability.extra.items["doll"] then
                    SMODS.change_play_limit(-1)
                    SMODS.change_discard_limit(-1)
                end
                if joker.ability.extra.items["lantern"] then
                    G.hand:change_size(-1)
                end
            end
        end
    end
    mod_calculate_ref(self, context)
end

NsRepertorium.get_amanojaku_win_condition = function()
    for _, joker in ipairs(SMODS.find_card("j_repertorium_amanojaku")) do
        if joker.ability.extra.win then
            G.GAME.repertorium_win_by_amanojaku = joker.ability.extra.win
            return joker.ability.extra.win
        end
        if joker.ability.extra.items["orb"] and
            joker.ability.extra.played_only and
            G.GAME.current_round.hands_left < 1 and
            to_big(joker.ability.extra.score) > G.GAME.chips then
            G.GAME.repertorium_win_by_amanojaku = "k_repertorium_orb_win"
            return "k_repertorium_orb_win"
        end
    end
end

local smods_four_fingers_ref = SMODS.four_fingers
function SMODS.four_fingers(hand_type)
    for _, joker in ipairs(SMODS.find_card("j_repertorium_amanojaku")) do
        if joker.ability.extra.items["umbrella"] then
            return 4
        end
    end
    return smods_four_fingers_ref(hand_type)
end

local smods_shortcut_ref = SMODS.shortcut
function SMODS.shortcut()
    for _, joker in ipairs(SMODS.find_card("j_repertorium_amanojaku")) do
        if joker.ability.extra.items["umbrella"] then
            return true
        end
    end
    return smods_shortcut_ref()
end

local smods_wrap_around_straight_ref = SMODS.wrap_around_straight
function SMODS.wrap_around_straight()
    for _, joker in ipairs(SMODS.find_card("j_repertorium_amanojaku")) do
        if joker.ability.extra.items["umbrella"] then
            return true
        end
    end
    return smods_wrap_around_straight_ref()
end

SMODS.DrawStep {
    key = 'repertorium_amanojaku',
    order = 50,
    func = function(card)
        if card.config.center.key == "j_repertorium_amanojaku" then
            if not G.repertorium_shared_cheats then
                local init_sprite = function(pos)
                    return Sprite(0, 0, G.CARD_W, G.CARD_H,
                        G.ASSET_ATLAS["repertorium_006amanojaku_cheats"], pos)
                end
                G.repertorium_shared_cheats = {
                    orb = init_sprite({ x = 0, y = 0 }),
                    camera = init_sprite({ x = 2, y = 2 }),
                    umbrella = init_sprite({ x = 0, y = 1 }),
                    mallet = init_sprite({ x = 2, y = 1 }),
                    jizo = init_sprite({ x = 1, y = 2 }),
                    doll = init_sprite({ x = 1, y = 0 }),
                    bomb = init_sprite({ x = 2, y = 0 }),
                    lantern = init_sprite({ x = 1, y = 1 }),
                    fabric = init_sprite({ x = 0, y = 2 })
                }
            end
            local i = 0
            for _, item in ipairs(card.ability.extra.items) do
                G.repertorium_shared_cheats[item].role.draw_major = card
                G.repertorium_shared_cheats[item]:draw_shader('dissolve', nil, nil, nil, card.children.center,
                    0, 0, -0.3 + 0.9 * (i % 3), -0.3 + 0.9 * math.floor(i / 3))
                i = i + 1
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.DrawStep {
    key = 'repertorium_amanojaku_cards',
    order = 50,
    func = function(card)
        if G.GAME.blind and G.GAME.blind.in_blind and (card.ability.set == "Default" or card.ability.set == "Enhanced") and not SMODS.has_no_rank(card) and G.GAME.repertorium_amanojaku_ranks and next(G.GAME.repertorium_amanojaku_ranks) and G.GAME.repertorium_amanojaku_cards then
            if not G.repertorium_shared_cheats then
                local init_sprite = function(pos)
                    return Sprite(0, 0, G.CARD_W, G.CARD_H,
                        G.ASSET_ATLAS["repertorium_006amanojaku_cheats"], pos)
                end
                G.repertorium_shared_cheats = {
                    orb = init_sprite({ x = 0, y = 0 }),
                    camera = init_sprite({ x = 2, y = 2 }),
                    umbrella = init_sprite({ x = 0, y = 1 }),
                    mallet = init_sprite({ x = 2, y = 1 }),
                    jizo = init_sprite({ x = 1, y = 2 }),
                    doll = init_sprite({ x = 1, y = 0 }),
                    bomb = init_sprite({ x = 2, y = 0 }),
                    lantern = init_sprite({ x = 1, y = 1 }),
                    fabric = init_sprite({ x = 0, y = 2 })
                }
            end
            local has_umbrella = false
            local has_camera = false
            for _, joker in ipairs(SMODS.find_card("j_repertorium_amanojaku")) do
                if joker.ability.extra.items["umbrella"] then
                    has_umbrella = true
                end
                if joker.ability.extra.items["camera"] then
                    has_camera = true
                end
            end
            if has_umbrella and not G.GAME.repertorium_amanojaku_ranks[card.base.value] then
                G.repertorium_shared_cheats["umbrella"].role.draw_major = card
                G.repertorium_shared_cheats["umbrella"]:draw_shader('dissolve', nil, nil, nil, card.children.center,
                    0, 0, -card.T.w * 0.2, card.T.h * 0.6)
            end
            if has_camera and not SMODS.has_no_suit(card) then
                local is_target = false
                for _, req in ipairs(G.GAME.repertorium_amanojaku_cards) do
                    if req.rank == "any" or req.suit == "any" or
                        (req.rank == card.base.value and card:is_suit(req.suit)) then
                        is_target = true
                        break
                    end
                end
                if is_target then
                    G.repertorium_shared_cheats["camera"].role.draw_major = card
                    G.repertorium_shared_cheats["camera"]:draw_shader('dissolve', nil, nil, nil, card.children.center,
                        0, 0, card.T.w * 0.2, card.T.h * 0.6)
                end
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.JimboQuip {
    key = "amanojaku_loss",
    type = 'loss',
    filter = function(self, type)
        if next(SMODS.find_card('j_repertorium_amanojaku')) then
            return true, { weight = 999999999 }
        end
    end,
    extra = {
        center = "j_repertorium_amanojaku"
    }
}

SMODS.JimboQuip {
    key = "amanojaku_win",
    type = 'win',
    filter = function(self, type)
        if next(SMODS.find_card('j_repertorium_amanojaku')) then
            return true, { weight = 999999999 }
        end
    end,
    extra = {
        center = "j_repertorium_amanojaku"
    }
}
