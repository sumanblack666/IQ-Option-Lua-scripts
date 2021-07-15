study("Engulfing Bars", shorttitle= "Bars", overlay = true)

bearish=(close[1] > open[1] and open > close and open >= close[1] and open[1] >= close and open - close > close[1] - open[1] )


bullish=(open[1] > close[1] and close > open and close >= open[1] and close[1] >= open and close - open > open[1] - close[1] )

plot_shape(bearish, "Bearish Engulfing", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')
plot_shape(bullish, "Bullish Engulfing", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY', 'green')


