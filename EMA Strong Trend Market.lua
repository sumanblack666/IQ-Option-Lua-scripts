instrument { name = "EMA Strong Trend Market", overlay = true }

len = 3
src = high
out = ema(src, len)
HIGH = out

len1 = 3
src1 = low
out1 = ema(src1, len1)
LOW = out1

HL2 = (HIGH+LOW)/2

y = HIGH[1]<HL2 and LOW[1]<HL2 and close
x =HIGH[1]>HL2 and LOW[1]>HL2

plot_shape(x, "short", shape_style.xcross, shape_size.large, 'red', shape_location.abovebar)
plot_shape(y, "long", shape_style.xcross, shape_size.large, 'green', shape_location.bottom)

