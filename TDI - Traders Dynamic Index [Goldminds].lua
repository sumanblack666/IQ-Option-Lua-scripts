instrument {
    name = 'TDI - Traders Dynamic Index [Goldminds] use ashi candle',
    icon = 'indicators:MA',
    overlay = false
}


rsiPeriod = 13
bandLength = 34
lengthrsipl = 2
lengthtradesl = 7

src = close                                                            
r = rsi(src, rsiPeriod)                                                
ma = sma(r, bandLength)                                                
offs = (1.6185 * stdev(r, bandLength))                                  
up = ma + offs                                                         
dn = ma - offs                                                         
mid = (up + dn) / 2                                                     
fastMA = sma(r, lengthrsipl)                                         
slowMA = sma(r, lengthtradesl)                                         

hline(32)                                                    
hline(50)                                                            
hline(68)  

uplot(up, "Upper Band", 'blue', 2)                              
plot(dn, "Lower Band", 'blue', 2)                             
plot(mid, "Middle of Bands", 'orange', 2) 

plot(slowMA, "Slow MA", 'green', 2)
plot(fastMA, "Fast MA", 'fuchsia', 2) 

fill(up,mid,"",rgba(255,108,88,0.15))

fill(mid, dn, "", rgba(37,225,84,0.15)) 
