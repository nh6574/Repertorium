--- UTILS

-- Scoring calculation keys for scoring effects
NsRepertorium.calc_keys = {
    'chips', 'h_chips', 'chip_mod',
    'mult', 'h_mult', 'mult_mod',
    'x_chips', 'xchips', 'Xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
    'e_mult', 'e_chips', 'ee_mult', 'ee_chips', 'eee_mult', 'eee_chips', 'hyper_mult', 'hyper_chips',
    'emult', 'echips', 'eemult', 'eechips', 'eeemult', 'eeechips', 'hypermult', 'hyperchips',
    'Emult_mod', 'Echip_mod', 'EEmult_mod', 'EEchip_mod', 'EEEmult_mod', 'EEEchip_mod', 'hypermult_mod', 'hyperchip_mod'
}

-- Talisman compat
to_big = to_big or function(x)
    return x
end
