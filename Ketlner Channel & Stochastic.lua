instrument { name = "Ketlner Channel & Stochastic", overlay = true }
period = input (20, "front.period", input.integer, 1)
shift =  input (3,  "front.newind.offset", input.double, 0.01, 300, 0.01)
fn     = input (averages.ema, "front.newind.average", input.string_selection, averages.titles)
source = input (1, "front.ind.source", input.string_selection,  inputs.titles)
input_group {
    "front.top line",
    upper_line_visible = input { default = true, type = input.plot_visibility },
    upper_line_color   = input { default = "#21B190", type = input.color },
    upper_line_width   = input { default = 1, type = input.line_width }
}
input_group {
    "front.middle line",
    middle_line_visible = input { default = true, type = input.plot_visibility },
    middle_line_color   = input { default = rgba(33,177,144,0.6), type = input.color },
    middle_line_width   = input { default = 1, type = input.line_width }
}
input_group {
    "front.bottom line",
    lower_line_visible = input { default = true, type = input.plot_visibility },
    lower_line_color   = input { default = "#21B190", type = input.color },
    lower_line_width   = input { default = 1, type = input.line_width }
}
input_group {
    "front.newind.adx.fill",
    fill_visible = input { default = true, type = input.plot_visibility },
    fill_color   = input { default = rgba(33,177,144,0.08), type = input.color },
}

input_group {
    "%K",
    k_period = input (5, "front.period", input.integer, 1),
    smooth = input (3, "front.platform.smothing", input.integer, 1),

}

input_group {
    "%D",
    d_period = input (3, "front.period", input.integer, 1),

}


local averageFunction = averages [fn]
local sourceSeries = inputs [source]

k = sma (stochastic (sourceSeries, k_period), smooth) * 100
d = sma (k, d_period)



middle = averageFunction (hlc3, period)
offset = rma(tr, period) * shift
h = middle + offset
l = middle - offset


short = h <= close
long = l >= close

stochUpperValue = 80
stochLowerValue = 20
shortk = k >= stochUpperValue and d >= stochUpperValue
longk = k <= stochLowerValue and d <= stochLowerValue


shortSignal = iff(((k >= stochUpperValue and d >= stochUpperValue and d >= k) and (h <= close)), true, false)
longSignal = iff(((k <= stochLowerValue and d <= stochLowerValue and k >= d) and (l >= close)), true, false)

plot_shape(shortSignal, "short", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar)
plot_shape(longSignal, "long", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar)


if fill_visible then
    fill { first = h, second = l, color = fill_color }
end
if upper_line_visible then
    plot (h, "h", upper_line_color, upper_line_width)
end
if lower_line_visible then
    plot (l, "l", lower_line_color, lower_line_width)
end
if middle_line_visible then
    plot (middle, "Middle", middle_line_color, middle_line_width)
end

