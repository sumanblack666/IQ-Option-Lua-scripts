instrument { name = "BO indicator", overlay = true, icon = "indicators:BB" }

period = input (20, "front.period", input.integer,  1)
devs   = input (1, "front.newind.stddev", input.integer, 1)

overbought = input (1, "front.overbought", input.double, -2, 2, 0.1, false)
oversold = input (0, "front.oversold", input.double, -2, 2, 0.1, false)

source = input (1, "front.ind.source", input.string_selection, inputs.titles)
fn     = input (1, "front.newind.average", input.string_selection, averages.titles)

input_group {
    "RSI",
    period1 = input (7, "front.period", input.integer, 1),
    source1 = input (1, "front.ind.source", input.string_selection, inputs.titles),
    fn1     = input (averages.ssma, "front.newind.average", input.string_selection, averages.titles),

    color  = input { default = "#B42EFF", type = input.color },
    width  = input { default = 1, type = input.line_width}
}


local sourceSeries = inputs [source]
local averageFunction = averages [fn]
local sourceSeries1 = inputs [source1]
local averageFunction1 = averages [fn1]

CCIupLevel= 100
CCIdnLevel=-100

BBupLevel=1
BBdnLevel=0

RSIupLevel=70
RSIdnLevel=30

middle = averageFunction (sourceSeries, period)
scaled_dev = devs * stdev (sourceSeries, period)

top = middle + scaled_dev
bottom = middle - scaled_dev

bbr = (sourceSeries - bottom) / (top - bottom)


delta = sourceSeries1 - sourceSeries1 [1]

up1 = averageFunction (max (delta, 0), period)
down1 = averageFunction (max (-delta, 0), period)

rs = up1 / down1
rsi = 100 - 100 / (1 + rs)

src = close
len = 7
RSIupLevel=70
RSIdnLevel=30
up = rma(max(change(src), 0), len)
down = rma(-min(change(src), 0), len)

rsi1 = iff(down == 0 , 100 , iff( up == 0 , 0 , 100 - (100 / (1 + up / down))))
--rsi = (down == 0 , 100 ,iff( up == 0 , 0 ,iff( 100 - (100 / (1 + up / down)))))


MAfast=9
MAslow=21
short = ema(close, MAfast)
long =  ema(close, MAslow)

period_cci = 20
nom = hlc3 - sma (hlc3, period_cci)
denom = mad (hlc3, period_cci) * 0.015

cci = nom / denom

pu= (cci>CCIupLevel) and (rsi>RSIupLevel ) and (bbr>BBupLevel) and (open[1] > short[1] and close[1]>short[1])
pd= (cci<CCIdnLevel) and (rsi < RSIdnLevel) and (bbr < BBdnLevel) and (open[1]< short[1] and close[1]<short[1]) 

plot_shape(pd, "short", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')
plot_shape(pu, "long", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY', 'green')

print(pu)