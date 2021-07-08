
instrument { name = "SQZMOMv2", title="Squeeze Momentum Indicator [LazyBear] Version2 by Kvan fr3762" }


length = 20
mult = 2
lengthKC=20
multKC = 1.5
SignalPeriod=5

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

bcolor = iff( val > 0, iff( val > nz(val[1]), 'lime', 'green'),iff( val < nz(val[1]), 'red', 'maroon'))
scolor = iff ( noSqz , 'blue' ,iff (sqzOn , 'black' , 'gray' ))
signal = sma(val,SignalPeriod)


plot(val, "Dinapoli MACD", "blue", 2)
plot(signal , "signal1", "red", 2)
plot (0,"squeeze", scolor,2,0,style.crosses,0 )



