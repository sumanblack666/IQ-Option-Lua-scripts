instrument {
    name = 'Support and resistance',
    icon = 'indicators:MA',
    overlay = True
}

boxp=input (21, "front.newind.darvasbox.length", input.integer, 5)

input_group {
    "Support and resistance",
    top_color = input { default = "red", type = input.color },
    bottom_color = input { default = "green", type = input.color },
}

RST = boxp

RSTT = value_when(high >= highest(high, RST), high, 0)
RSTB = value_when(low <= lowest(low, RST), low, 0)
plot (RSTT, "Resistance", iff(RSTT ~= RSTT[1], na ,top_color), 4, 0, style.levels, na_mode.restart)
plot (RSTB, "support", iff(RSTB ~= RSTB[1], na ,bottom_color), 4, 0, style.levels, na_mode.restart)
