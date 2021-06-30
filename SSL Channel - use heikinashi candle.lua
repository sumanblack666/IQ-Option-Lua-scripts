instrument {
    name = 'SSL Channel - use heikinashi candle',
    icon = 'indicators:MA',
    overlay = true
}

--local Hlv = 0.0


len = 13
smaHigh = sma(high, len)
smaLow = sma(low, len)

Hlv = iff(close > smaHigh , 1 ,iff( close < smaLow , -1 , Hlv[1]))
sslDown = iff(Hlv < 0 , smaHigh , smaLow)
sslUp   = iff(Hlv < 0 , smaLow , smaHigh)

plot(sslDown, 'down', '#FF0000' , width, -1, style.solid_line, na_mode.continue)
plot(sslUp, 'up', '#00FF00' , width, -1, style.solid_line, na_mode.continue)


