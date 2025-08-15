--- Erika Saionji
SMODS.Atlas {
    key = "001erika",
    path = "erika.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "001erika_soul",
    path = "erika_soul.png",
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

SMODS.current_mod.optional_features.post_trigger = true

local calc_keys = {
    'chips', 'h_chips', 'chip_mod',
    'mult', 'h_mult', 'mult_mod',
    'x_chips', 'xchips', 'Xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
}

SMODS.Joker {
    key = "erika",
    atlas = "001erika",
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
    { key = "side",           frames = 2 },
    { key = "empty",          frames = 2 }
}

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
    { key = "side",           frames = 8 },
    { key = "empty",          frames = 8 },
    { key = "side",           frames = 8 },
    { key = "empty",          frames = 8 },
    { key = "front",          frames = 2 },
    { key = "side",           frames = 2 },
    { key = "back",           frames = 2 },
    { key = "side_mirrored",  frames = 2 },
    { key = "front",          frames = 2 },
    { key = "side",           frames = 2 },
    { key = "back",           frames = 2 },
    { key = "empty",          frames = 2 },
    { key = "front",          frames = 2 },
    { key = "side",           frames = 2 },
    { key = "back",           frames = 2 },
    { key = "side_mirrored",  frames = 2 },
    { key = "front",          frames = 2 },
    { key = "side",           frames = 2 },
    { key = "back",           frames = 2 },
    { key = "empty",          frames = 2 },
    { key = "side_mirrored",  frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side_mirrored",  frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 12 },
    { key = "front",          frames = 4 },
    { key = "side",           frames = 8 },
    { key = "empty",          frames = 8 },
    { key = "side",           frames = 8 },
    { key = "empty",          frames = 10 },
    { key = "side_mirrored",  frames = 2 },
    { key = "back_mirrored",  frames = 2 },
    { key = "side",           frames = 2 },
    { key = "front_mirrored", frames = 2 },
    { key = "side_mirrored",  frames = 2 },
    { key = "back_mirrored",  frames = 2 },
    { key = "side",           frames = 2 },
    { key = "empty",          frames = 2 },
    { key = "side_mirrored",  frames = 2 },
    { key = "back_mirrored",  frames = 2 },
    { key = "side",           frames = 2 },
    { key = "front_mirrored", frames = 2 },
    { key = "side_mirrored",  frames = 2 },
    { key = "back_mirrored",  frames = 2 },
    { key = "side",           frames = 2 },
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
    { key = "side",           frames = 2 },
    { key = "empty",          frames = 2 }
}

local erika_anim = {
    pattern1,
    pattern2,
    { { key = "empty", frames = 156 } },
    pattern2,
    { { key = "empty", frames = 380 } },
    pattern1,
    pattern2,
}

local erika_anim_bg = {
    [0] = "empty",
    [288] = "lava",
    [352] = "space",
    [416] = "lava",
    [480] = "space",
    [544] = "empty",
    [576] = "poster",
    [608] = "empty",
    [640] = "poster",
    [672] = "empty",
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

local function play_animation(sprite)
    local pattern = erika_anim[sprite.current_pattern]
    if sprite.current_frame <= #pattern and G.TIMERS.REAL >= sprite.next_time then
        local anim = pattern[sprite.current_frame]
        --print(G.repertorium_erika_soul.total_frames)
        if erika_anim_bg[G.repertorium_erika_soul.total_frames] then
            for _, joker in ipairs(SMODS.find_card("j_repertorium_erika")) do
                joker.children.center:set_sprite_pos(erika_bg[erika_anim_bg[G.repertorium_erika_soul.total_frames]])
            end
        end

        sprite:set_sprite_pos(erika_pos[anim.key])
        G.repertorium_erika_soul.total_frames = G.repertorium_erika_soul.total_frames + anim.frames
        sprite.next_time = G.TIMERS.REAL + anim.frames * 0.1

        sprite.current_frame = sprite.current_frame + 1

        if sprite.current_frame > #pattern then
            sprite.current_pattern = sprite.current_pattern + 1
            sprite.current_frame = 1
            if sprite.current_pattern > #erika_anim then
                sprite.current_frame = 3
                sprite.current_pattern = 6
            end
        end
    end
end

SMODS.DrawStep {
    key = 'repertorium_erika',
    order = 50,
    func = function(card)
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
                G.repertorium_erika_soul.current_frame = 1
                G.repertorium_erika_soul.current_pattern = 1
                G.repertorium_erika_soul.next_time = 0
                G.repertorium_erika_soul.total_frames = 0
                G.repertorium_erika_soul:set_sprite_pos({ x = math.floor(G.TIMERS.REAL * 7) % 2, y = 0 })
            else
                if not G.repertorium_erika_soul.current_frame or not G.repertorium_erika_soul.next_time then
                    G.repertorium_erika_soul.current_frame = 1
                    G.repertorium_erika_soul.current_pattern = 1
                    G.repertorium_erika_soul.next_time = 0
                    G.repertorium_erika_soul.total_frames = 0
                end
                play_animation(G.repertorium_erika_soul)
            end

            --G.repertorium_erika_light.role.draw_major = card
            --G.repertorium_erika_light:draw_shader('dissolve', nil, nil, nil, card.children.center, 0, 0, -0.6, -0.3)
            G.repertorium_erika_soul.role.draw_major = card
            G.repertorium_erika_soul:draw_shader('dissolve', nil, nil, nil, card.children.center, 0, 0, -0.6, -0.3)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}
