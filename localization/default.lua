return {
    descriptions = {
        Mod = {
            Repertorium = {
                name = "N's Repertorium",
                text = {
                    "mod where I put what I can't in {C:joy_mod}JoyousSpring"
                }
            }
        },
        Joker = {
            j_repertorium_erika = {
                name = "Erika Saionji",
                text = {
                    {
                        "Scored {V:1}#1#{} in played hand",
                        "give {C:mult}+#2#{} Mult",
                        "{C:inactive}(Suit changes each round){}"
                    },
                    {
                        "If another Joker makes",
                        "a played card give score,",
                        "change this Joker's Mult by",
                        "{C:mult}+#3#{} if it's a {V:1}#4#{}",
                        "{C:mult}-#3#{} otherwise {C:inactive}(min. +1)"
                    }
                }
            },
            j_repertorium_joe = {
                name = "For the Sake of Tomorrow #4#",
                text = {
                    {
                        "{C:mult}+#1#{} Mult",
                        "{C:mult}-#2#{} per hand played"
                    },
                    {
                        "If Mult is {C:mult}0{},",
                        "gives {X:mult,C:white}X#3#{} Mult and resets"
                    }
                }
            },
            j_repertorium_tengoku = {
                name = {
                    "{f:5}天天天国地獄国",
                    "{C:gold,s:0.8}(Tententengokujigokugoku)"
                },
                text = {
                    {
                        "Applies one of these effects randomly for each played card,",
                        "alternating between {C:blue}Angelic{} and {C:red}Devilish{}",
                        "{C:inactive}(Currently {V:1}#8#{C:inactive})"
                    },
                    {
                        "{C:blue}Angelic",
                        "Counts for scoring and gives {C:chips}+#4#{} Chips {C:inactive,s:0.85}(#1#% chance)",
                        "{C:attention}Enhances{} the card into a random enhancement {C:inactive,s:0.85}(#2#% chance)",
                        "Copies the card and adds it to played hand",
                        "but doesn't apply an effect to it {C:inactive,s:0.85}(#3#% chance)"
                    },
                    {
                        "{C:red}Devilish",
                        "Doesn't count for scoring but gives {C:mult}+#5#{} Mult {C:inactive,s:0.85}(#1#% chance)",
                        "Destroys card and gives {X:mult,C:white}X#6#{} Mult {C:inactive,s:0.85}(#2#% chance)",
                        "Removes any {C:attention}modifications{} on the card and, if it did,",
                        "the played card permanently gains {X:mult,C:white}X#7#{} Mult {C:inactive,s:0.85}(#3#% chance)"
                    },
                }
            },
            j_repertorium_tengoku_alt = {
                name = {
                    "{f:5}天天天国地獄国",
                    "{C:gold,s:0.8}(Tententengokujigokugoku)"
                },
                text = {
                    {
                        "Applies one of these effects randomly for each played card,",
                        "alternating between {C:blue}Angelic{} and {C:red}Devilish{}",
                        "{C:inactive}(Currently {V:1}#8#{C:inactive})"
                    },
                    {
                        "{C:blue}Angelic",
                        "Puts {C:attention}#4#{} {C:blue}Angelic{} Counters on the card {C:inactive,s:0.85}(#1#% chance)",
                        "{C:attention}Enhances{} the card into a random enhancement {C:inactive,s:0.85}(#2#% chance)",
                        "Copies the card and adds it to played hand",
                        "but doesn't apply an effect to it {C:inactive,s:0.85}(#3#% chance)"
                    },
                    {
                        "{C:red}Devilish",
                        "Puts {C:attention}#5#{} {C:red}Devilish{} Counters on the card {C:inactive,s:0.85}(#1#% chance)",
                        "Destroys card and gives {X:mult,C:white}X#6#{} Mult {C:inactive,s:0.85}(#2#% chance)",
                        "Removes any {C:attention}modifications{} on the card and, if it did,",
                        "the played card permanently gains {X:mult,C:white}X#7#{} Mult {C:inactive,s:0.85}(#3#% chance)"
                    },
                }
            },
            j_repertorium_dirtypair = {
                name = "Lovely Angels",
                text = {
                    {
                        "{X:mult,C:white}X#1#{} Mult for each {C:attention}Pair{}",
                        "contained in scoring hand"
                    },
                    {
                        "{C:green}#2# in #3#{} chance to destroy",
                        "each contained {C:attention}Pair{}"
                    }
                }
            },
            j_repertorium_keion = {
                name = {
                    "{f:5}映画けいおん!",
                    "{C:gold,s:0.8}(K-On! The Movie)"
                },
                text = {
                    {
                        "Puts {C:attention}#1#{} {C:blue}Angelic{} Counters",
                        "on the first played card of each suit",
                        "scored this round"
                    }
                }
            },
            j_repertorium_keion_alt = {
                name = {
                    "{f:5}映画けいおん!",
                    "{C:gold,s:0.8}(K-On! The Movie)"
                },
                text = {
                    {
                        "Puts {C:attention}#1#{} {C:blue}Angelic{} Counters",
                        "on the first card of each suit",
                        "played this round when scored"
                    },
                    {
                        "Gains {X:chips,C:white}X#2#{} Chips",
                        "when the effect is applied to the",
                        "{C:attention}5{}th suit of the round",
                        "{C:inactive}(Currently {X:chips,C:white}X#3#{}{C:inactive} Chips)"
                    }
                }
            },
            j_repertorium_keion_locked = {
                name = {
                    "{f:5}映画けいおん!",
                    "{C:gold,s:0.8}(K-On! The Movie)"
                },
                text = {
                    {
                        "Available after installing",
                        "{C:attention}Balatro Goes Kino{}"
                    },
                }
            },
            j_repertorium_amanojaku = {
                name = {
                    "Amanojaku, Enemy of All",
                },
                text = {
                    {
                        "{C:attention}Blinds{} become {C:red}impossible{} to beat",
                    },
                    {
                        "When {C:attention}Blind{} is selected,",
                        "gains a random {C:attention}cheat item{}",
                        "{C:inactive,s:0.9}(Resets when {C:attention,s:0.9}Boss Blind{C:inactive,s:0.9} is defeated){}"
                    },
                }
            },
        },
        Counter = {
            counter_repertorium_angelic = {
                name = "Angelic Counter",
                text = {
                    "Gives {C:chips}+50{} Chips",
                    "and counts for scoring",
                    "{C:inactive}(Caps at 5){}"
                }
            },
            counter_repertorium_devilish = {
                name = "Devilish Counter",
                text = {
                    "Gives {C:mult}+5{} Mult",
                    "but doesn't count for scoring",
                    "{C:inactive}(Caps at 5){}"
                }
            },
        },
        Other = {
            repertorium_cheat_item = {
                name = "Cheat Items",
                text = {
                    "Fulfill any of the conditions listed",
                    "in any item to win the Blind",
                    "Each Joker can only hold one of each kind"
                }
            },
            repertorium_cheat_orb = {
                name = "Bloodthirsty Yin-Yang Orb",
                text = {
                    "Get below {C:attention}#1#{} score to win",
                    "after using all hands and",
                    "playing only {C:attention}#2#",
                    "{s:0.5} ",
                    "{C:green}#3# in #4#{} chance to obtain",
                    "this item when skipping a {C:attention}Blind{}"
                }
            },
            repertorium_cheat_camera = {
                name = "Tengu's Toy Camera",
                text = {
                    "Play a hand containing specific cards to win",
                    "{s:0.85,C:attention}#2#",
                    "{s:0.85,C:attention}#3#",
                    "{s:0.85,C:attention}#4#",
                    "{s:0.85,C:attention}#5#",
                    "{s:0.85,C:attention}#6#",
                    "{s:0.5} ",
                    "{C:red}+#1#{} Discard"
                }
            },
            repertorium_cheat_umbrella = {
                name = "Gap Folding Umbrella",
                text = {
                    "Play hands containing {C:attention}Straight Flushes{}",
                    "with every rank in your deck to win",
                    "{s:0.5} ",
                    "All {C:attention}Flushes{} and {C:attention}Straights{}",
                    "can be made with 4 cards",
                    "and allows {C:attention}Straights{} to be made",
                    "with gaps of 1 rank and wrap around"
                }
            },
            repertorium_cheat_mallet = {
                name = "A Miracle Mallet Replica",
                text = {
                    "Get within {C:attention}#1#%{} of {C:attention}#2#{} to win",
                    "{s:0.5} ",
                    "{C:money}+$#3#{} when a Joker scores Chips or Mult"
                }
            },
            repertorium_cheat_jizo = {
                name = "Substitute Jizo",
                text = {
                    "Prevents Death.",
                    "{C:inactive}(One time use) (#1#/1)",
                    " ",
                    "Can't be obtained unless",
                    "the Joker holds an item"
                }
            },
            repertorium_cheat_doll = {
                name = "Cursed Decoy Doll",
                text = {
                    "Play {C:attention}#3#{} cards of rank {C:attention}#4#{}",
                    "and {C:attention}#1#{} {C:attention}#2#{} to win",
                    "{C:inactive}(#6#/#3# rank, #5#/#1# suit){}",
                    "{s:0.5} ",
                    "{C:attention}+#7#{} hand selection limit"
                }
            },
            repertorium_cheat_bomb = {
                name = "Four-Foot Magic Bomb",
                text = {
                    "Balances Chips and Mult",
                    "Beat {C:attention}#1#{} score to win",
                    "by playing only {C:attention}#2#",
                    "{s:0.5} ",
                    "Can't be obtained unless",
                    "the Joker holds an item"
                }
            },
            repertorium_cheat_lantern = {
                name = "Ghastly Send-Off Lantern",
                text = {
                    "Play a {V:1}#1#{}, a {V:2}#2#{}",
                    "and a {V:3}#3#{} to win",
                    "{s:0.5} ",
                    "{C:attention}+#4#{} hand size"
                }
            },
            repertorium_cheat_fabric = {
                name = "Nimble Fabric",
                text = {
                    "Poker Hand conditions are swapped randomly",
                    "{C:inactive}(Contained hands behave normally)",
                    "Play 3 {C:attention}#1#{} to win {C:inactive}(#3# left){}",
                    "{s:0.5} ",
                    "{C:blue}+#2#{} Hand"
                }
            },
        }
    },
    misc = {
        dictionary = {
            k_repertorium_discord = "(JoyousSpring's) Discord",
            k_repertorium_github = "Github",
            k_repertorium_cross = "Cross Counter!",
            k_repertorium_angelic = "Angelic",
            k_repertorium_devilish = "Devilish",
            k_repertorium_dead = "Dead!",
            k_repertorium_alive = "Alive!",
            k_repertorium_death = "Death!",
            k_repertorium_birth = "Birth!",
            k_repertorium_hell = "Hell!",
            k_repertorium_heaven = "Heaven!",
            k_repertorium_oops = "Oops!",
            k_repertorium_impossible = "Impossible",
            k_repertorium_any = "Any",
            k_repertorium_get = "Get!",
            k_repertorium_jizo_saved = "Substituted by the Jizo",
            k_repertorium_orb_win = "Evaded Blind with Bloodthirsty Yin-Yang Orb",
            k_repertorium_camera_win = "Captured Blind with Tengu's Toy Camera",
            k_repertorium_umbrella_win = "Breached the gap with the Gap Folding Umbrella",
            k_repertorium_mallet_win = "Reduced the Blind with the Miracle Mallet replica",
            k_repertorium_doll_win = "Confused the Blind using the Cursed Decoy Doll",
            k_repertorium_bomb_win = "Demolished the Blind using the Four-Foot Magic Bomb",
            k_repertorium_lantern_win = "Passed through the Blind with the Ghastly Send-Off Lantern",
            k_repertorium_fabric_win = "Hid from the Blind using the Nimble Fabric",
            k_repertorium_none_win = "Refused to lose to the Blind",
        },
        quips = {
            repertorium_erika_win = {
                "I couldn't have done it",
                "without my song",
                "and my friends!"
            },
            repertorium_amanojaku_loss = {
                "Ugh, they're getting stronger",
                "Maybe I should try",
                "leveling up my new items, too... "
            },
            repertorium_amanojaku_win = {
                "Outta the way!",
                "The (soon to be) great Amanojaku",
                "is passing through!"
            },
        }
    }
}
