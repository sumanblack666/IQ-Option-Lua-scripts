instrument { name = "ema  20/50/200 by Suman", overlay = true }
local length = input (20, "EMA 1", input.integer, 1 , 250  )
local length1 = input (50, "EMA 2", input.integer, 1 , 250  )
local length2 = input (200, "EMA 3", input.integer, 1 , 250  )
local source = input (1,  "front.ind.source", input.string_selection, inputs.titles_overlay)
local follow = input(false, "Follow ema 200", input.boolean)
local cross = input(false, "Ema 50 cross 200", input.boolean)



input_group {
    "front.newind.lines",
    color = input { default = "green", type = input.color },
    color1 = input { default = "yellow", type = input.color },
    color2 = input { default = "red", type = input.color },
    width = input { default = 1, type = input.line_width}
}

ema20 = ema(close,length)
ema50 = ema(close,length1)
ema200 = ema(close,length2)

up = ema50[1] > ema20[1] and ema20 > ema50 
down = ema50[1] < ema20[1] and ema20 < ema50 
up1 = ema200[1] > ema50[1] and ema50 > ema200
down1 = ema200[1] < ema50[1] and ema50 < ema200


plot_shape(iff(follow,up and ema200[1] < ema200,up), "long", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY', 'green')
plot_shape(iff(follow, down  and ema200[1] > ema200 , down), "short", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')

if cross then 
    plot_shape(up1, "long1", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY EMA200', 'green')
    plot_shape(down1, "short1", shape_style.triangleup, shape_size.large, 'red', shape_location.abovebar,0,'SELL EMA200', 'red')

end




plot (ema20, "ema 20", color, width)
plot (ema50, "ema 50", color1, width)
plot (ema200, "ema 200", color2, width)