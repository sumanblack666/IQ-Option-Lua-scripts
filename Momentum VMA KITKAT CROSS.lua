instrument {
    name = 'Momentum VMA KITKAT CROSS v2.1',
    icon = 'indicators:MA',
    overlay = true
   
}

input_group {
    "Level 1",

    level_1_color = input { default = "green", type = input.color },
    level_1_width = input { default = 1, type = input.line_width }
}

input_group {
    "Level 2",

    level_2_color = input { default = "red", type = input.color },
    level_2_width = input { default = 1, type = input.line_width }
}

length = 25
src = close
mvma = wma(2*wma(src, length/2)-wma(src, length), round(sqrt(length)))
--plot(mvma, linewidth=2, offset=+1, color=blue, transp=0, title="MVMA 1")
plot(mvma, 'MVMA 1', 'blue' , 2, -1, style.solid_line, na_mode.continue)

length2 = 21
src2 = close
mvma2 = wma(2*wma(src2, length2/2)-wma(src2, length2), round(sqrt(length2)))
--plot(mvma2, linewidth=2, offset=+0, color=red, transp=0, title="MVMA 2")
plot(mvma2, 'MVMA 2', 'red' , 2, -1, style.solid_line, na_mode.continue)


source = close
length3 = 9
Lead = wma(2*wma(source, length3/2)-wma(source, length3), round(sqrt(length3)))
--plot(Lead, linewidth=3, offset=+0, color=black, transp=0, title=" Lead MVMA")
plot(Lead, 'Lead MVMA2', 'black' , 2, -1, style.solid_line, na_mode.continue)
cross1 = value_when(Lead == mvma2  ,mvma2 , 2 )
--plot(cross1, 'Lead MVMA2', 'black' , 2, -1, style.solid_line, na_mode.continue)
plot_shape(iff(Lead == mvma2,mvma2 ,na), "short", shape_style.cross, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')
--plot(cross(Lead,mvma2) ? mvma2 : na, style = cross, linewidth = 4, title="MVMA cross")

RST = 16     
RSTT = value_when(high >= highest(high, RST), high, 0)
RSTB = value_when(low <= lowest(low, RST), low, 0)
plot (RSTT, "Resistance", iff(RSTT ~= RSTT[1], na ,level_2_color), 4, 0, style.levels, na_mode.restart)
--plot (RSTB, "support", 'green', 4, 0, style.levels, na_mode.restart)
plot (RSTB, "support", iff(RSTB ~= RSTB[1], na ,level_1_color), 4, 0, style.levels, na_mode.restart)
--RT2 = plot(RSTT, color=RSTT != RSTT[1] ? na : red, linewidth=4, offset=+0, title="Resistance")
--RB2 = plot(RSTB, color=RSTB != RSTB[1] ? na : green, linewidth=4, offset=0, title="Support")



RST2 = 16     
RSTT2 = value_when(high >= highest(high, RST2), high, 1)
RSTB2 = value_when(low <= lowest(low, RST2), low, 1)
--RT22 = plot(RSTT2, color=RSTT2 != RSTT2[1] ? na : red, linewidth=9, offset=+0, title="Resistance")
plot (RSTT2, "Resistance", iff(RSTT2 ~= RSTT2[1], na ,level_2_color), 9, 0, style.levels, na_mode.restart)
--RB22 = plot(RSTB2, color=RSTB2 != RSTB2[1] ? na : green, linewidth=9, offset=0, title="Support")
plot (RSTB2, "support", iff(RSTB2 ~= RSTB2[1], na ,level_1_color), 9, 0, style.levels, na_mode.restart)

