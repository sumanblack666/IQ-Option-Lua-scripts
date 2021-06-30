instrument {
    name = 'BinaryMT2',
    icon = 'indicators:MA',
    overlay = true
}

input_group {
    "ADX",
    adx_color = input { default = rgba(255,255,255,0.7), type = input.color },
    adx_width = input { default = 1, type = input.line_width },
    adx_visible = input { default = true, type = input.plot_visibility }
}

Rlength = 14
change1 = change(close)
gain = iff(change1 >= 0 , change1 , 0.0)
loss = iff(change1 < 0 ,(-1) * change1 , 0.0)
avgGain = rma(gain, Rlength)
avgLoss = rma(loss, Rlength)
rs = avgGain / avgLoss
rsi = 100 - (100 / (1 + rs))
len = 14
lensig = 14

up = change(high)
down = -change(low)
plusDM = iff(na(up), na , iff(up > down and up > 0 , up , 0))
minusDM = iff(na(down), na , iff(down > up and down > 0 , down , 0))
trur = rma(tr, len)
plus = fixnan(100 * rma(plusDM, len) / trur)
minus = fixnan(100 * rma(minusDM, len) / trur)
sum = plus + minus

adx = 100 * rma(abs(plus - minus) / (plus + minus), lensig)

top = (plus<plus[1] and plus[1]>plus[2] and minus>minus[1]) or (plus<plus[1] and minus>minus[1] and minus[1]<minus[2])
bottom = (minus<minus[1] and minus[1]>minus[2] and plus>plus[1]) or (minus<minus[1] and plus>plus[1] and plus[1]<plus[2])

hiddenbeardiv = top and high < high[1] and rsi > rsi[1]  and adx < 25
hiddenbulldiv = bottom and low > low[1] and rsi < rsi[1] and adx < 25


plot_shape(hiddenbeardiv, "short", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')
plot_shape(hiddenbulldiv, "long", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY', 'green')