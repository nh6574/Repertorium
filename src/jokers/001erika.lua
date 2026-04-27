--- Erika Saionji
SMODS.Atlas {
    key = "001erika",
    path = "001erika.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "001erika_soul",
    path = "001erika_soul.png",
    px = 111,
    py = 135
}

SMODS.Sound {
    key = "music_hoehoe",
    path = "hoehoe.ogg",
    sync = false,
    pitch = 1,
    select_music_track = function()
        return G.STAGE == G.STAGES.RUN and G.GAME.repertorium_hoehoe and math.huge or false
    end,
}

local pos_channel = love.thread.getChannel("repertorium_pos_channel")
local req_channel = love.thread.getChannel("sound_request")

NsRepertorium.get_sound_source = function()
    req_channel:push { type = "repertorium_get_source" }
    return pos_channel:demand()
end

local get_song_pos = function()
    local source = NsRepertorium.get_sound_source()
    if not source or not source.sound or source.sound_code ~= "repertorium_music_hoehoe" then return end
    source = source.sound
    return source:tell()
end

local get_song_duration = function()
    local source = NsRepertorium.get_sound_source()
    if not source or not source.sound or source.sound_code ~= "repertorium_music_hoehoe" then return end
    source = source.sound
    return source:getDuration()
end

SMODS.current_mod.optional_features.post_trigger = true

local calc_keys = NsRepertorium.calc_keys

SMODS.Joker {
    key = "erika",
    atlas = "001erika",
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { localize(card.ability.extra.suit, "suits_plural"), card.ability.extra.mult, card.ability.extra.mult_mod, localize(card.ability.extra.suit, "suits_singular"), colours = { G.C.SUITS[card.ability.extra.suit] } } }
    end,
    config = {
        extra = {
            mult = 1,
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
        if context.after then
            local count = 0
            for _, joker in ipairs(G.jokers.cards) do
                if joker.repertorium_hoehoe then
                    count = count + 1
                end
                joker.repertorium_hoehoe = nil
            end
            if count >= 4 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.repertorium_hoehoe = true
                        return true
                    end
                }))
            end
        end
        if not context.blueprint then
            if context.post_trigger and context.other_card ~= card and context.other_card.ability.set == "Joker" and
                context.other_context.individual and context.other_ret.jokers then
                for _, key in ipairs(calc_keys) do
                    local is_hyper = key:sub(1, 1):lower() == "e" or key:sub(1, 2):lower() == "hy"
                    local is_x = key:sub(1, 1):lower() == "x"
                    if context.other_ret.jokers[key] and (is_hyper or
                            to_big(context.other_ret.jokers[key]) > to_big(is_x and 1 or 0)) then
                        if context.other_context.other_card:is_suit(card.ability.extra.suit) then
                            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                            context.other_card.repertorium_hoehoe = true
                            return {
                                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod } },
                                colour = G.C.FILTER,
                                message_card = card
                            }
                        else
                            local prev_mult = card.ability.extra.mult
                            card.ability.extra.mult = math.max(1, card.ability.extra.mult - card.ability.extra.mult_mod)
                            if prev_mult > card.ability.extra.mult then
                                return {
                                    message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod } },
                                    colour = G.C.FILTER,
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
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and not next(SMODS.find_card("j_repertorium_erika", true)) then
            G.GAME.repertorium_hoehoe = nil
        end
    end,
    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                { text = "+", },
                { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
            },
            text_config = { colour = G.C.MULT },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "suit", colour = G.C.FILTER },
                { text = ")" },
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:is_suit(card.ability.extra.suit) then
                            count = count +
                                JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.mult = card.ability.extra.mult * count
                card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
            end,
            style_function = function(card, text, reminder_text, extra)
                if reminder_text and reminder_text.children[2] then
                    reminder_text.children[2].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
                end
                return false
            end
        }
    end
}

--#region Animation

local erika_pos = {
    front = { x = 0, y = 1 },
    jump = { x = 1, y = 1 },
    side = { x = 2, y = 1 },
    back = { x = 3, y = 1 },
    empty = { x = 3, y = 0 },
    front_mirrored = { x = 0, y = 2 },
    jump_mirrored = { x = 1, y = 2 },
    side_mirrored = { x = 2, y = 2 },
    back_mirrored = { x = 3, y = 2 }
}

local erika_bg = {
    regular = { x = 0, y = 0 },
    poster = { x = 1, y = 0 },
    empty = { x = 2, y = 0 },
    lava = { x = 3, y = 0 },
    space = { x = 4, y = 0 },
}

local pattern1 = {
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "empty",          frames = 2 },
    { key = "side",           frames = 1 },
    { key = "empty",          frames = 3 },
    { key = "front",          frames = 1 },
    { key = "empty",          frames = 3 },
    { key = "side",           frames = 1 },
    { key = "empty",          frames = 3 },
    { key = "front",          frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 2 },
    { key = "front",          frames = 2 },
    { key = "side",           frames = 1 },
    { key = "back",           frames = 1 },
    { key = "side_mirrored",  frames = 1 },
    { key = "front_mirrored", frames = 1 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "empty",          frames = 2 },
    { key = "side",           frames = 1 },
    { key = "empty",          frames = 3 },
    { key = "front",          frames = 1 },
    { key = "empty",          frames = 3 },
    { key = "side",           frames = 1 },
    { key = "empty",          frames = 3 },
    { key = "front",          frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "side",           frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "back",           frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "side_mirrored",  frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "front_mirrored", frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "side_mirrored",  frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "back_mirrored",  frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "side",           frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "front",          frames = 1 },
    { key = "empty",          frames = 1 },
    { key = "jump",           frames = 2 },
    { key = "front",          frames = 2 },
    { key = "jump",           frames = 2 },
    { key = "front",          frames = 2 },
    { key = "empty",          frames = 4 },
    { key = "side",           frames = 2, ease_y = -0.4, y_frames = 1 },
    { key = "empty",          frames = 2 }
}

local offset_unit = 0.2

local pattern2 = {
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 2 },
    { key = "front",          frames = 2 },
    { key = "jump",           frames = 2 },
    { key = "front",          frames = 2 },
    { key = "jump_mirrored",  frames = 4 },
    { key = "front_mirrored", frames = 4 },
    { key = "jump_mirrored",  frames = 4 },
    { key = "front_mirrored", frames = 4 },
    { key = "jump_mirrored",  frames = 4 },
    { key = "front_mirrored", frames = 4 },
    { key = "jump_mirrored",  frames = 4 },
    { key = "front_mirrored", frames = 4 },
    { key = "jump_mirrored",  frames = 4 },
    { key = "front_mirrored", frames = 4 },
    { key = "jump_mirrored",  frames = 4 },
    { key = "front_mirrored", frames = 4 },
    { key = "jump_mirrored",  frames = 4 },
    { key = "front_mirrored", frames = 4 },
    { key = "jump_mirrored",  frames = 2 },
    { key = "front_mirrored", frames = 2 },
    { key = "jump_mirrored",  frames = 2 },
    { key = "front_mirrored", frames = 2 },
    { key = "side",           frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side_mirrored",  frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side_mirrored",  frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 8,  offset_x = offset_unit * 3,  offset_y = -0.4 },
    { key = "empty",          frames = 8 },
    { key = "side",           frames = 8,  offset_x = -offset_unit * 2, offset_y = 0 },
    { key = "empty",          frames = 8 },
    { key = "front",          frames = 2,  offset_x = -offset_unit * 3, offset_y = -0.05 },
    { key = "side",           frames = 2,  offset_x = -offset_unit * 2 },
    { key = "back",           frames = 2,  offset_x = -offset_unit },
    { key = "side_mirrored",  frames = 2,  offset_x = 0 },
    { key = "front",          frames = 2,  offset_x = offset_unit },
    { key = "side",           frames = 2,  offset_x = offset_unit * 2 },
    { key = "back",           frames = 2,  offset_x = offset_unit * 3 },
    { key = "empty",          frames = 2 },
    { key = "front",          frames = 2,  offset_x = -offset_unit * 3 },
    { key = "side",           frames = 2,  offset_x = -offset_unit * 2 },
    { key = "back",           frames = 2,  offset_x = -offset_unit },
    { key = "side_mirrored",  frames = 2,  offset_x = 0 },
    { key = "front",          frames = 2,  offset_x = offset_unit },
    { key = "side",           frames = 2,  offset_x = offset_unit * 2 },
    { key = "back",           frames = 2,  offset_x = offset_unit * 3 },
    { key = "empty",          frames = 2 },
    { key = "side_mirrored",  frames = 12, offset_x = 0 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side_mirrored",  frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 8,  offset_x = offset_unit * 2 },
    { key = "empty",          frames = 8 },
    { key = "side",           frames = 8,  offset_x = -offset_unit * 3, offset_y = -0.4 },
    { key = "empty",          frames = 10 },
    { key = "side_mirrored",  frames = 2,  offset_x = offset_unit * 3,  offset_y = 0 },
    { key = "back_mirrored",  frames = 2,  offset_x = offset_unit * 2 },
    { key = "side",           frames = 2,  offset_x = offset_unit },
    { key = "front_mirrored", frames = 2,  offset_x = 0 },
    { key = "side_mirrored",  frames = 2,  offset_x = -offset_unit },
    { key = "back_mirrored",  frames = 2,  offset_x = -offset_unit * 2 },
    { key = "side",           frames = 2,  offset_x = -offset_unit * 3 },
    { key = "empty",          frames = 2 },
    { key = "side_mirrored",  frames = 2,  offset_x = offset_unit * 3 },
    { key = "back_mirrored",  frames = 2,  offset_x = offset_unit * 2 },
    { key = "side",           frames = 2,  offset_x = offset_unit },
    { key = "front_mirrored", frames = 2,  offset_x = 0 },
    { key = "side_mirrored",  frames = 2,  offset_x = -offset_unit },
    { key = "back_mirrored",  frames = 2,  offset_x = -offset_unit * 2 },
    { key = "side",           frames = 2,  offset_x = -offset_unit * 3 },
    { key = "jump",           frames = 4,  offset_x = 0 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "jump",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 4 },
    { key = "front",          frames = 4 },
    { key = "front",          frames = 8 },
    { key = "side",           frames = 8 },
    { key = "front",          frames = 1 },
    { key = "side_mirrored",  frames = 1 },
    { key = "back_mirrored",  frames = 1 },
    { key = "side",           frames = 1 },
    { key = "front",          frames = 2 },
    { key = "empty",          frames = 6 },
    { key = "side",           frames = 2,  ease_y = -0.4,               y_frames = 1 },
    { key = "empty",          frames = 2 }
}

local erika_anim = {
    pattern1,
    pattern2,
    { { key = "empty", frames = 156 } },
    pattern2,
    { { key = "empty", frames = 386 } },
    pattern1,
    pattern2,
}

local erika_anim_bg = {
    [-1] = "empty",
    [288] = "lava",
    [352] = "space",
    [416] = "lava",
    [480] = "space",
    [544] = "empty",
    [576] = "poster",
    [608] = "empty",
    [640] = "poster",
    [672] = "empty",
    [723] = "regular",
    [858] = "empty",
    [988] = "lava",
    [1052] = "space",
    [1116] = "lava",
    [1180] = "space",
    [1244] = "empty",
    [1276] = "poster",
    [1308] = "empty",
    [1340] = "poster",
    [1372] = "empty",
}

local erika_lyrics = {
    [0] = { "", "" },
    [158] = { "Oh please, I'm begging you", "おねだりしちゃう" },
    [174] = { "Oh please, I'm begging you", "おねだりしちゃう" },
    [190] = { "Oh please, I'm begging you", "おねだりしちゃう" },
    [206] = { "Take me with you", "つれてって" },
    [220] = { "Oh please, I'm begging you", "おねだりしちゃう" },
    [238] = { "Oh please, I'm begging you", "おねだりしちゃう" },
    [254] = { "Oh please, I'm begging you", "おねだりしちゃう" },
    [270] = { "Don't drive me crazy", "ホエホエって" },
    [284] = { "Why are you so mischievous?", "ほしの イリュージョン" },
    [338] = { "Every time I'm with you", "オチャメな ムスメ" },
    [376] = { "I can see the stars", "ベルマーク" },
    [400] = { "I know, I know", "でもでも" },
    [414] = { "There are times you get cute with me", "つぶらな こころが" },
    [466] = { "When I see you like that", "ポイント ミリョク" },
    [504] = { "I can't help but blush", "わたしとて" },
    [528] = { "Lovey Dovey", "ヒューヒュー" },
    [542] = { "Take my hand", "たに に" },
    [556] = { "and I'll take yours", "むかって" },
    [574] = { "You are such a ditzy girl", "ホエホエむすめなの" },
    [603] = { "Watch your step", "1の" },
    [619] = { "or you'll fall down", "つぎは2" },
    [637] = { "Shucks, too late for that", "3は パス" },
    [667] = { "Please don't get mad at me!", "ダメなのよさー" },
    [703] = { "", "" },
    [861] = { "Don't look at me like that", "おねがいよねえ" },
    [877] = { "Don't look at me like that", "おねがいよねえ" },
    [893] = { "Don't look at me like that", "おねがいよねえ" },
    [909] = { "I'll buy you a cream puff", "シュークリーム" },
    [923] = { "Don't look at me like that", "おねがいよねえ" },
    [941] = { "Don't look at me like that", "おねがいよねえ" },
    [957] = { "Don't look at me like that", "おねがいよねえ" },
    [973] = { "Here, have some more sweets", "シュガーベイブ" },
    [987] = { "There are times you act like a cat", "ねこのインビテーション" },
    [1041] = { "When you brush against me", "ぎゃふんと わたし" },
    [1079] = { "My heart skips a beat", "うちょうてん" },
    [1103] = { "Lovey Dovey", "ロリロリ" },
    [1117] = { "I wonder what makes her so sweet", "かわに みをまかせ" },
    [1169] = { "Must be those cakes she eats", "ドーナツ アンパン" },
    [1207] = { "She's eating one now", "ダイエット" },
    [1231] = { "(nom nom)", "モグモグ" },
    [1245] = { "You act first", "さきに" },
    [1259] = { "and think later", "てをうつ" },
    [1277] = { "You are such a ditzy girl", "ホエホエむすめです" },
    [1307] = { "May your dreams", "みのる" },
    [1322] = { "always come true", "ゆめかつ" },
    [1340] = { "I will cheer you on", "うちゅう1" },
    [1370] = { "You're the best in the world", "しげき てきよー" },
    [1406] = { "", "" },
    [1947] = { "You are so bright, so radiant", "まぶしいわ きみ" },
    [1963] = { "that I can't even breathe", "いきが できない" },
    [1979] = { "You are so bright, so radiant", "まぶしいわ きみ" },
    [1995] = { "Could it be your eyes?", "きみの めが" },
    [2009] = { "You are so bright, so radiant", "まぶしいわ きみ" },
    [2027] = { "I can barely bear it", "たってられない" },
    [2043] = { "You are so bright, so radiant", "まぶしいわ きみ" },
    [2059] = { "Could it be your dreams?", "きみのゆめ" },
    [2073] = { "It's like looking straight at the Sun", "とくしゅ ソラリゼーション" },
    [2127] = { "Even though I closed my eyes", "ズゲッと きたワ" },
    [2165] = { "I can still see you", "ためらうの" },
    [2189] = { "Lovey Dovey", "キュンキュン" },
    [2203] = { "Your smile always brightens my day", "なりは キラリなの" },
    [2255] = { "And that is why I cannot", "いてざで Bがた" },
    [2293] = { "live without you", "ホロリだわ" },
    [2317] = { "So please listen", "まあまあ" },
    [2331] = { "When you want", "たまに" },
    [2345] = { "give me a call", "TELして" },
    [2363] = { "You are my sweet ditzy girl", "ホエホエむすめGO!" },
    [2393] = { "Before you", "とおる" },
    [2409] = { "even hang up", "みちあけ" },
    [2427] = { "I'll be there for you", "そこ のけよー" },
    [2457] = { "'Cause I'm madly in love", "とんちがきくー" },
    [2492] = { "", "" },
}

local function add_speech_bubble(self, text_key, align, loc_vars)
    if self.children.speech_bubble then self.children.speech_bubble:remove() end
    self.config.speech_bubble_align = { align = align or 'bm', offset = { x = 0, y = 0 }, parent = self }
    self.children.speech_bubble =
        UIBox {
            definition = G.UIDEF.speech_bubble(text_key, loc_vars),
            config = self.config.speech_bubble_align
        }
    self.children.speech_bubble:set_role {
        role_type = 'Minor',
        xy_bond = 'Weak',
        r_bond = 'Strong',
        major = self,
    }
    self.children.speech_bubble.states.visible = false
end

local function remove_speech_bubble(self)
    if self.children.speech_bubble then
        self.children.speech_bubble:remove(); self.children.speech_bubble = nil
    end
end

local function say_stuff(self, n, not_first)
    self.talking = true
    if not not_first then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end
                say_stuff(self, n, true)
                return true
            end
        }))
    else
        if n <= 0 then
            self.talking = false; return
        end
        local new_said = math.random(1, 11)
        while new_said == self.last_said do
            new_said = math.random(1, 11)
        end
        self.last_said = new_said
        self:juice_up(0.1, 0.05)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false,
            blocking = false,
            delay = 0.13,
            func = function()
                say_stuff(self, n - 1, true)
                return true
            end
        }), 'tutorial')
    end
end

local make_erika_say_stuff = function(sprite)
    local _, card = next(SMODS.find_card("j_repertorium_erika", true))
    if not card then return end
    if sprite.frame_tick == 723 and sprite.say_stuff ~= 723 then
        add_speech_bubble(card, "repertorium_erika_hoehoe_1", nil, { quip = true })
        say_stuff(card, 3, false)

        sprite.say_stuff = 723
    end
    if sprite.frame_tick == 766 and sprite.say_stuff ~= 766 then
        add_speech_bubble(card, "repertorium_erika_hoehoe_2", nil, { quip = true })
        say_stuff(card, 3, false)

        sprite.say_stuff = 766
    end
    if sprite.frame_tick == 806 and sprite.say_stuff ~= 806 then
        add_speech_bubble(card, "repertorium_erika_hoehoe_3", nil, { quip = true })
        say_stuff(card, 3, false)

        sprite.say_stuff = 806
    end
    if sprite.say_stuff and sprite.frame_tick >= 858 then
        remove_speech_bubble(card)
        sprite.say_stuff = nil
    end
end

local joker_quips = {
    "repertorium_erika_hoehoe_other_1",
    "repertorium_erika_hoehoe_other_2",
    "repertorium_erika_hoehoe_other_3",
    "repertorium_erika_hoehoe_other_4",
    "repertorium_erika_hoehoe_other_5",
    "repertorium_erika_hoehoe_other_6",
    "repertorium_erika_hoehoe_other_7",
}

local other_joker_quip = function(sprite)
    local elegible = {}
    for _, joker in ipairs(G.jokers.cards) do
        if not joker.repertorium_hoehoe_quip and joker.config.center_key ~= "j_repertorium_erika" then
            table.insert(elegible, joker)
        end
    end
    local choice, _ = pseudorandom_element(elegible, "repertorium_hoehoe_quip_joker")
    if choice then
        local quips = {}
        for _, quip in ipairs(joker_quips) do
            if not sprite.said_quips[quip] then
                table.insert(quips, quip)
            end
        end
        if #quips <= 0 then
            sprite.no_quips = true
            return
        end
        local quip_choice = pseudorandom_element(quips, "repertorium_hoehoe_quip")
        if quip_choice then
            sprite.said_quips[quip_choice] = true
            add_speech_bubble(choice, quip_choice, nil, { quip = true })
            say_stuff(choice, 0, false)
            choice.repertorium_hoehoe_quip = true
        end
    end
end

local remove_all_quips = function(on_end)
    for _, joker in ipairs(G.jokers.cards) do
        if joker.repertorium_hoehoe_quip or joker.config.center_key == "j_repertorium_erika" then
            remove_speech_bubble(joker)
            if on_end then joker.repertorium_hoehoe_quip = nil end
        end
    end
end

local quip_frames = {
    [1422] = true,
    [1478] = true,
    [1531] = true,
    [1584] = true,
    [1640] = true,
    [1672] = true,
    [1728] = true
}

local make_other_jokers_say_stuff = function(sprite)
    if sprite.frame_tick == 1404 and not sprite.dance then
        for _, joker in ipairs(G.jokers.cards) do
            local func = function()
                return G.GAME.repertorium_hoehoe and not NsRepertorium.hoehoe_stop_dance
            end
            juice_card_until(joker, func, true)
        end

        sprite.dance = true
        sprite.said_quips = {}
    end
    if quip_frames[sprite.frame_tick] and sprite.other_quip ~= sprite.frame_tick then
        remove_all_quips()
        if not sprite.no_quips then
            other_joker_quip(sprite)
        end
        sprite.other_quip = sprite.frame_tick
    end
    if sprite.frame_tick >= 1790 and sprite.dance then
        NsRepertorium.hoehoe_stop_dance = true
        remove_all_quips(on_end)
    end
end

local hide_light_frame = 1403

local function play_animation(sprite)
    local sound_pos = get_song_pos()
    if not sound_pos then return end
    if sprite.sound_pos and sound_pos < sprite.sound_pos and sound_pos < 5 then
        local duration = get_song_duration()
        sprite.next_frame = sprite.next_frame - duration
        sprite.next_time = sprite.next_time - duration
    end
    sprite.sound_pos = sound_pos
    local pattern = erika_anim[sprite.current_pattern]

    if erika_lyrics[sprite.frame_tick] then
        G.repertorium_erika_lyrics_next_eng = erika_lyrics[sprite.frame_tick][1]
        if G.repertorium_erika_lyrics_next_eng == "" then
            G.repertorium_erika_lyrics_eng = ""
        end
        G.repertorium_erika_lyrics_next_jp = erika_lyrics[sprite.frame_tick][2]
        if G.repertorium_erika_lyrics_next_jp == "" then
            G.repertorium_erika_lyrics_jp = ""
        end
    end

    make_erika_say_stuff(sprite)
    make_other_jokers_say_stuff(sprite)

    if erika_anim_bg[(sprite.frame_tick or 0) - 1] then
        for _, joker in ipairs(SMODS.find_card("j_repertorium_erika")) do
            joker.children.center:set_sprite_pos(erika_bg[erika_anim_bg[sprite.frame_tick - 1]])
        end
        sprite.current_bg = erika_anim_bg[sprite.frame_tick - 1]
    end

    if sound_pos >= sprite.next_frame then
        sprite.next_frame = sprite.next_frame + 0.1
        sprite.frame_tick = sprite.frame_tick + 1
    end
    if sprite.current_frame <= #pattern and sound_pos >= sprite.next_time then
        local anim = pattern[sprite.current_frame]

        if sprite.frame_tick >= hide_light_frame then
            sprite.hide_light = true
            sprite.offset_y = 0
            sprite.offset_x = 0
        else
            if anim.offset_y then sprite.offset_y = anim.offset_y end
            if anim.offset_x then sprite.offset_x = anim.offset_x end
        end

        sprite:set_sprite_pos(erika_pos[anim.key])

        sprite.total_frames = sprite.total_frames + anim.frames
        sprite.next_time = sprite.next_time + anim.frames * 0.1

        if anim.ease_y and sprite.frame_tick < hide_light_frame then
            sprite.offset_y = anim.ease_y
            G.E_MANAGER:add_event(Event({
                trigger = "ease",
                ease = "outquad",
                delay = (anim.y_frames or anim.frames) * 0.1,
                ref_table = sprite,
                ref_value = "offset_y",
                ease_to = 0,
                timer = "REAL"
            }))
        end

        sprite.current_frame = sprite.current_frame + 1

        if sprite.current_frame > #pattern then
            sprite.current_pattern = sprite.current_pattern + 1
            sprite.current_frame = 1
            if sprite.current_pattern > #erika_anim then
                sprite.current_frame = 2
                sprite.current_pattern = 6
            end
        end
    end
end

local create_lyrics_box = function()
    local make_text_row = function(ref, align, font)
        return {
            n = G.UIT.R,
            config = { align = align },
            nodes = {
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = { { ref_table = G, ref_value = ref } },
                            colours = { HEX("FFFFFF") },
                            scale = 0.4,
                            font = font
                        }),
                    }
                },
            }
        }
    end
    local eng_row = make_text_row("repertorium_erika_lyrics_eng", "cl")
    local jp_row = make_text_row("repertorium_erika_lyrics_jp", "cr", G.FONTS[5])
    local next_eng_row = make_text_row("repertorium_erika_lyrics_next_eng", "cl")
    local next_jp_row = make_text_row("repertorium_erika_lyrics_next_jp", "cr", G.FONTS[5])

    local make_box = function(_eng_row, _jp_row)
        return {
            n = G.UIT.C,
            config = { align = 'cm', colour = HEX("000000"), minw = G.jokers.T.w, minh = 1.2, padding = 0.1 },
            nodes = {
                {
                    n = G.UIT.R,
                    config = { align = 'cl' },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = 'cl', minw = G.jokers.T.w - 2, minh = 0.6, padding = 0.1 },
                            nodes = {
                                _eng_row
                            }
                        }
                    }
                },
                {
                    n = G.UIT.R,
                    config = { align = 'cr' },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = 'cr', minw = G.jokers.T.w - 2, minh = 0.6, padding = 0.1 },
                            nodes = {
                                _jp_row
                            }
                        }
                    }
                }
            }
        }
    end
    local definition = {
        make_box(eng_row, jp_row),
        make_box(next_eng_row, next_jp_row),
    }

    local config = {
        align = 'cmi',
        offset = { x = 0, y = 2 },
        major = G.jokers,
        bond = 'Weak',
        instance_type = "MOVEABLE"
    }

    local text_object = SMODS.UIScrollBox({
        content = {
            definition = {
                n = G.UIT.ROOT,
                config = { colour = G.C.CLEAR },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cm" },
                        nodes = definition,
                    },
                },
            },
            config = { align = "cm" },
        },
        container = {
            config = {
                can_collide = false,
            }
        },
        overflow = {
            node_config = {
                no_overflow = "h",
                w = G.jokers.T.w,
            },
            config = {
                can_collide = false,
            }
        },
        sync_mode = "offset",
        scroll_move = function(self, dt)
            if G.repertorium_erika_lyrics_next_eng and G.repertorium_erika_lyrics_next_eng ~= "" then
                self.stored_dt = (self.stored_dt or 0) + G.real_dt
                if self.stored_dt > 0.002 then
                    self.scroll_offset.x = math.min((self.scroll_offset.x or 0) + 0.1, G.jokers.T.w)
                    if self.scroll_offset.x >= G.jokers.T.w then
                        self.scroll_offset.x = 0
                        G.repertorium_erika_lyrics_eng = G.repertorium_erika_lyrics_next_eng
                        G.repertorium_erika_lyrics_jp = G.repertorium_erika_lyrics_next_jp
                        G.repertorium_erika_lyrics_next_eng = ""
                        G.repertorium_erika_lyrics_next_jp = ""
                    end
                    self.stored_dt = 0
                end
            else
                self.stored_dt = 0
            end
        end,
    })

    local uibox = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = { colour = G.C.CLEAR },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { align = "cm", padding = 0.05 },
                    nodes = { {
                        n = G.UIT.O,
                        config = { object = text_object },
                    } },
                },
            },
        },
        config = config
    }
    uibox.states.collide.can = false
    return uibox
end

NsRepertorium.reset_hoehoe = function()
    if not G.repertorium_erika_light then
        G.repertorium_erika_light = Sprite(0, 0, G.CARD_W, G.CARD_H,
            G.ASSET_ATLAS["repertorium_001erika_soul"], { x = 2, y = 0 })
    end
    if not G.repertorium_erika_soul then
        G.repertorium_erika_soul = Sprite(0, 0, G.CARD_W, G.CARD_H,
            G.ASSET_ATLAS["repertorium_001erika_soul"], { x = 0, y = 0 })
    end
    G.repertorium_erika_soul.current_frame = 1
    G.repertorium_erika_soul.current_pattern = 1
    G.repertorium_erika_soul.next_time = 0
    G.repertorium_erika_soul.total_frames = 0
    G.repertorium_erika_soul.frame_tick = 0
    G.repertorium_erika_soul.next_frame = 0
    G.repertorium_erika_soul.sound_pos = 0
    G.repertorium_erika_soul:set_sprite_pos({ x = math.floor(G.TIMERS.REAL * 7) % 2, y = 0 })
    G.repertorium_erika_soul:set_sprite_pos({ x = math.floor(G.TIMERS.REAL * 7) % 2, y = 0 })
    G.repertorium_erika_lyrics_eng = ""
    G.repertorium_erika_lyrics_jp = ""
end

local game_start_run_ref = Game.start_run
function Game:start_run(args)
    game_start_run_ref(self, args)
    NsRepertorium.reset_hoehoe()
end

SMODS.DrawStep {
    key = 'repertorium_erika',
    order = 50,
    func = function(card)
        if not G.GAME.repertorium_hoehoe and G.jokers and G.jokers.children.repertorium_lyrics_box then
            G.jokers.children.repertorium_lyrics_box:remove()
        end
        if card.config.center.key == "j_repertorium_erika" then
            if not G.repertorium_erika_light then
                G.repertorium_erika_light = Sprite(0, 0, G.CARD_W, G.CARD_H,
                    G.ASSET_ATLAS["repertorium_001erika_soul"], { x = 2, y = 0 })
            end
            if not G.repertorium_erika_soul then
                G.repertorium_erika_soul = Sprite(0, 0, G.CARD_W, G.CARD_H,
                    G.ASSET_ATLAS["repertorium_001erika_soul"], { x = 0, y = 0 })
            end


            if not G.GAME.repertorium_hoehoe then
                NsRepertorium.reset_hoehoe()
                card.children.center:set_sprite_pos(erika_bg.regular)
            else
                if not G.repertorium_erika_soul.current_frame or not G.repertorium_erika_soul.next_time then
                    G.repertorium_erika_soul.current_frame = 1
                    G.repertorium_erika_soul.current_pattern = 1
                    G.repertorium_erika_soul.next_time = 0
                    G.repertorium_erika_soul.total_frames = 0
                    G.repertorium_erika_soul.current_bg = "empty"
                    G.repertorium_erika_soul.frame_tick = 0
                    G.repertorium_erika_soul.next_frame = 0
                    G.repertorium_erika_soul.sound_pos = 0
                    G.repertorium_erika_lyrics_eng = ""
                    G.repertorium_erika_lyrics_jp = ""
                end
                if G.jokers and not G.jokers.children.repertorium_lyrics_box then
                    G.jokers.children.repertorium_lyrics_box = create_lyrics_box()
                end
                play_animation(G.repertorium_erika_soul)
                if not G.repertorium_erika_soul.hide_light and G.repertorium_erika_soul.current_bg == "empty" then
                    G.repertorium_erika_light.role.draw_major = card
                    G.repertorium_erika_light:draw_shader('dissolve', nil, nil, nil,
                        card.children.center, 0, 0, -0.6, -0.3)
                end
            end

            G.repertorium_erika_soul.role.draw_major = card
            local offset_y = G.repertorium_erika_soul.offset_y or 0
            local offset_x = G.repertorium_erika_soul.offset_x or 0
            G.repertorium_erika_soul:draw_shader('dissolve', nil, nil, nil, card.children.center, 0, 0, -0.6 + offset_x,
                -0.3 + offset_y)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

--#endregion

SMODS.JimboQuip {
    key = "erika_win",
    type = 'win',
    filter = function(self, type)
        if next(SMODS.find_card('j_repertorium_erika')) then
            return true, { weight = 10 }
        end
    end,
    extra = {
        center = "j_repertorium_erika"
    }
}
