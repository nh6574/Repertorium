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

SMODS.Joker {
    key = "amanojaku",
    atlas = "006amanojaku",
    discovered = true,
    rarity = 4,
    cost = 10,
    config = {
        extra = {
            items = { "jizo", "doll", "camera" }
        }
    },
    calculate = function(self, card, context)

    end
}
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
