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
            }
        }
    }
}
