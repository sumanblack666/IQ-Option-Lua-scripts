instrument {
    name = "Consecutive Candle Count",
    short_name = "CCC",
    icon = "indicators:MACD"
}


barup = close > close[1]
bardown = close < close[1]

rundown = bars_since(bardown)
runup = bars_since(barup)


rect {
    first = 0,
    second = rundown,
    color = 'green',
    width = 0.8
}

rect {
    first = 0,
    second = -runup,
    color = 'red',
    width = 0.8
}

