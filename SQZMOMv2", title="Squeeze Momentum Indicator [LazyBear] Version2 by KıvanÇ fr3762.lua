
instrument { name = "SQZMOMv3", title="Squeeze Momentum Indicator" }


length = input (20, "front.period", input.integer,  1)
mult   = input (2, "front.newind.stddev", input.integer, 1)
lengthKC = input (20, "Keltner Channel period", input.integer,  1)
multKC   = input (1.5, "Keltner Channel multiplier", input.double, 1)
source = input (1, "front.ind.source", input.string_selection, inputs.titles)
SignalPeriod = input (5, "Signal line period", input.integer,  1)

input_group {
    "front.newind.lines",
    color1  = input { default = "red", type = input.color },
    color2  = input { default = "blue", type = input.color },
    color3  = input { default = "black", type = input.color },
    color4  = input { default = "gray", type = input.color },
    color5  = input { default = "blue", type = input.color },
    width   = input { default = 1, type = input.line_width }
}


input_group {
    "Background",
    color6  = input { default = "lime", type = input.color },
    color7  = input { default = "green", type = input.color },
    color8  = input { default = "red", type = input.color },
    color9  = input { default = "maroon", type = input.color },
    bcolor_visible = input { default = true, type = input.plot_visibility }
}

useTrueRange = true

--Calculate BB
source = close
basis = sma(source, length)
dev = multKC * stdev(source, length)
upperBB = basis + dev
lowerBB = basis - dev

--Calculate KC
ma = sma(source, lengthKC)
range = iff ( useTrueRange , tr , (high - low) )
rangema = sma(range, lengthKC)
upperKC = ma + rangema * multKC
lowerKC = ma - rangema * multKC

sqzOn  = (lowerBB > lowerKC) and (upperBB < upperKC)
sqzOff = (lowerBB < lowerKC) and (upperBB > upperKC)
noSqz  = (sqzOn == false) and (sqzOff == false)

val1 = (highest(high, lengthKC) + lowest(low, lengthKC)) / 2 
val2 = ( val1 + sma(close,lengthKC) ) / 2 

val = linreg(source  -  val2, lengthKC,0)

bcolor = iff( val > 0, iff( val > nz(val[1]), color6, color7),iff( val < nz(val[1]), color8, color9))
scolor = iff ( noSqz , color5 ,iff (sqzOn , color3 , color4 ))
signal = sma(val,SignalPeriod)

if bcolor_visible then
    fill (0.001, -0.001, "", bcolor)
end


plot(val, "Dinapoli MACD", color2, 2)
plot(signal , "signal1", color1, 2)
plot (0,"squeeze", scolor,4,0,style.crosses,0 )

--fill(signal,val,"",bcolor)

