instrument { name = "Strategy MACD vs BB signal", overlay = true, icon="indicators:ATR" }

fast_length = 8
slow_length = 21
src = close




fast_ma = sma(src, fast_length)
slow_ma = sma(src, slow_length)

macd = fast_ma - slow_ma
p1 = plot (macd, "MACD", 'blue', 1)
length = 40
mult = 2

basis = sma(macd, length)
dev = mult * stdev(macd, length)

plot (basis, "BB basis", 'orange', 1)
upper = basis + dev
lower = basis - dev

p2 = plot (upper, "BB upper", 'red', 1)
p3 = plot (lower, "BB basis", 'green', 1)

buy = macd[1] < lower[1] and macd > lower
sell = macd[1] > upper[1] and macd < upper

fill (macd, lower, "", iff( macd<lower,'green',na))
fill (macd, upper, "", iff( macd>upper,'red',na))

plot_shape(buy, "long", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY', 'green')
plot_shape(sell, "short", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')
