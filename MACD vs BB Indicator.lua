instrument { name = "MACD vs BB Indicator", overlay = false, icon="indicators:ATR" }

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

fill_area {
    first = 0.01,
    second = -0.01,
    color = rgba(255,255,255,0.05)
}