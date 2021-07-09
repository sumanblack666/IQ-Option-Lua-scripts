instrument { name = "imple Reversal Point", overlay = true, icon="indicators:ATR" }

c1 = close[1] < open[1] and close > open
c2 = close > open[1]
c3 = lowest(low,3) < lowest (low,50)[1] or lowest(low,3) < lowest(low,50)[2] or lowest(low,3) < lowest(low,50)[3]
buy = c1 and c2 and c3

c4 = close[1] > open[1] and close < open
c5 = close < open[1]
c6 = highest(high,3) > highest (high,50)[1] or highest(high,3) > highest(high,50)[2] or highest(high,3) > highest(high,50)[3]
sell = c4 and c5 and c6

plot_shape(buy, "long", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY', 'green')
plot_shape(sell , "short", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')