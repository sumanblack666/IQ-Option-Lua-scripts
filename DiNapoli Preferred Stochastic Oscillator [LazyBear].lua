
instrument { name = "DiNapoli Preferred Stochastic Oscillator [LazyBear]" }

fk = 8
sk = 3
sd = 3
min_ = lowest(low, fk) 
max_ = highest(high, fk) 
fast = (close - min_)/(max_ - min_)*100
r = nz(r[1]) + (fast - nz(r[1]))/sk
s = nz(s[1]) + (r - nz(s[1]))/sd

obb = hline(70)
oss = hline(30)

fill_area (90, 10, "", rgba(255,255,255,0.05))



plot (r, "Dinapoli Stoch", '#56CEFF', 2)
plot (s, "Signal", 'red', 2)
