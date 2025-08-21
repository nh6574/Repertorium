return {
    descriptions = {
        Joker = {
            j_repertorium_erika = {
                name = "Erika Saionji",
                text = {
                    {
                        "Scored {C:diamonds}#1#{} in played hand",
                        "give {C:mult}+#2#{} Mult",
                        "{C:inactive}(Suit changes every round){}"
                    },
                    {
                        "If another Joker makes",
                        "a played card give score,",
                        "change this Joker's Mult by",
                        "{C:mult}+#3#{} if it's a {C:diamonds}#4#{}",
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
                        "Copies the card and adds it to played hand {C:inactive,s:0.85}(#3#% chance)"
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
                        "switching between {C:blue}Angelic{} and {C:red}Devilish{} effects intermittently"
                    },
                    {
                        "{C:blue}Angelic",
                        "Puts {C:attention}#4#{} {C:blue}Angelic{} Counters on the card {C:inactive,s:0.85}(#1#% chance)",
                        "{C:attention}Enhances{} the card into a random enhancement {C:inactive,s:0.85}(#2#% chance)",
                        "Copies the card and adds it to played hand {C:inactive,s:0.85}(#3#% chance)"
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
                        "contained in played hand"
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
                        "Put {C:attention}#1#{} {C:blue}Angelic{} Counter",
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
                        "Put {C:attention}#1#{} {C:blue}Angelic{} Counter",
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
        }
    }
}
