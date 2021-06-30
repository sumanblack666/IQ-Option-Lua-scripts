instrument { name = "Vdubs Mr Mani", overlay = true, icon="indicators:ATR" }

input_group {
    "front.ind.dpo.generalline",
    up_color = input { default = "#58FF44", type = input.color },
    down_color = input { default = "#57A1D0", type = input.color },
    width = input { default = 1, type = input.line_width }
}

fn     = input (averages.ema, "front.newind.average", input.string_selection, averages.titles)

local avg = averages [fn]
--ema signal 1
src0 = close
len0 = 13
ema0 = ema(src0, len0)
rising1 = ema0[0] > ema0[1] and ema0[1] > ema0[2]
falling1 = ema0[2] > ema0[1] and ema0[1] > ema0[0]
--
direction = iff(rising1, 1,iff(falling1, -1, 0 ))
plot_color = iff(direction > 0 , up_color,iff( direction < 0, down_color , na))
plot(ema0, 'EMA', plot_color , width, -1, style.solid_line, na_mode.continue)
--ema signal 2
src02 = close
len02 = 21
ema02 = ema(src02, len02)
rising2 = ema02[0] > ema02[1] and ema02[1] > ema02[2]
falling2 = ema02[2] > ema02[1] and ema02[1] > ema02[0]
direction2 = iff(rising2, 1,iff(falling2, -1, 0 ))
plot_color2 = iff(direction2 > 0 , up_color,iff( direction2 < 0, down_color , na))
plot(ema02, 'EMA Signal 2', plot_color2 , width, -1, style.solid_line, na_mode.continue)

--ema signal out

fast = 5
slow = 8
avg0 = (low + close)/2
avg1 = (high + close)/2
vh1 = ema(highest(avg0, fast), 5)
vl1 = ema(lowest(avg1, slow), 8)
--print(vl1)

e_ema1 = ema(close, 1)
e_ema2 = ema(e_ema1, 1)
e_ema3 = ema(e_ema2, 1)
tema = 1 * (e_ema1 - e_ema2) + e_ema3
--print(tema)


e_e1 = ema(close, 8)
e_e2 = ema(e_e1, 5)
dema = 2 * e_e1 - e_e2
--print(dema)
signal = iff(tema > dema , max (vh1, vl1) , min (vh1, vl1))
--print(signal)


is_call = tema > dema and signal > low and (signal-signal[1] > signal[1]-signal[2])
is_put = tema < dema and signal < high and (signal[1]-signal > signal[2]-signal[1])


period = 30
plot_shape(iff(is_call and direction > 0 , 1, na), "long", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY', 'green')
plot_shape(iff(is_put and direction < 0, 1, na) , "short", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')
plot (hma (src0, period), "HMA", '#FF00FF', 2)

Factor=3
Pd=1
atr1= rma(tr, Pd)
Up=hl2-(Factor*atr1)
Dn=hl2+(Factor*atr1)
TrendUp = iff( close[1] > TrendUp[1], max(Up,TrendUp[1]) , Up)
TrendDown=iff( close[1] < TrendDown[1], min(Dn,TrendDown[1]) , Dn)
Trend = iff(close>TrendDown[1] , 1 , iff(close< TrendUp[1],-1,nz(Trend[1],0)))
long1 = (Trend == 1 and Trend[1] == -1)
//plot_shape(long1, "long", shape_style.triangleup, shape_size.large, 'yellow', shape_location.belowbar,0,'BUY', 'yellow')
//
--plot_shape(iff(Trend == -1 and Trend[1] == 1 , Trend , na), "short", shape_style.triangledown, shape_size.large, 'blue', shape_location.abovebar,0,'SELL', 'red')



--Up= hl2 - (Factor * atr(Pd))