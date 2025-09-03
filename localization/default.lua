return {
    descriptions = {
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
                        "{C:mult}-#3#{} otherwise"
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
                        "switching between {C:blue}Angelic{} and {C:red}Devilish{} effects intermittently"
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
                        "switching between {C:blue}Angelic{} and {C:red}Devilish{} effects intermittently",
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
                        "on the first card of each suit",
                        "played this round when scored"
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
        }
    },
    misc = {
        dictionary = {
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
        }
    }
}
