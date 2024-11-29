-- Indicator using Keltner Channel and Stochastic for Built-in IQ Option Script

instrument { name = "KC Suman", overlay = true }

-- Input Parameters
period = input(20, "Keltner Channel Period", input.integer, 1)
shift = input(2.5, "Keltner Channel Shift", input.double, 0.01, 300, 0.01)
fn = input(averages.ema, "Smoothing Function", input.string_selection, averages.titles)
source = input(1, "Source Type", input.string_selection, inputs.titles)

-- Line Visibility and Style Settings
input_group {
    "Keltner Channel - Lines",
    upper_line_visible = input { default = true, type = input.plot_visibility },
    upper_line_color = input { default = "#21B190", type = input.color },
    upper_line_width = input { default = 1, type = input.line_width },

    middle_line_visible = input { default = true, type = input.plot_visibility },
    middle_line_color = input { default = rgba(33, 177, 144, 0.6), type = input.color },
    middle_line_width = input { default = 1, type = input.line_width },

    lower_line_visible = input { default = true, type = input.plot_visibility },
    lower_line_color = input { default = "#21B190", type = input.color },
    lower_line_width = input { default = 1, type = input.line_width }
}

input_group {
    "Keltner Channel Fill",
    fill_visible = input { default = true, type = input.plot_visibility },
    fill_color = input { default = rgba(33, 177, 144, 0.08), type = input.color }
}

-- Stochastic Inputs
input_group {
    "Stochastic %K",
    k_period = input(5, "Period", input.integer, 1),
    smooth = input(3, "Smoothing", input.integer, 1)
}
input_group {
    "Stochastic %D",
    d_period = input(3, "Period", input.integer, 1)
}

-- Keltner Channel Calculation
local averageFunction = averages[fn]
local sourceSeries = inputs[source]
local hlc3_avg = hlc3

middle = averageFunction(hlc3_avg, period)
offset = rma(tr, period) * shift
upper_band = middle + offset
lower_band = middle - offset

-- Stochastic Calculation
k = sma(stochastic(sourceSeries, k_period), smooth) * 100
d = sma(k, d_period)

-- Signal Logic
stochUpperValue = 90
stochLowerValue = 10

shortSignal = k >= stochUpperValue and d >= stochUpperValue and upper_band <= close
longSignal = k <= stochLowerValue and d <= stochLowerValue and lower_band >= close

-- Plot Signals
plot_shape(shortSignal, "Short Signal", shape_style.triangledown, shape_size.large, "red", shape_location.abovebar)
plot_shape(longSignal, "Long Signal", shape_style.triangleup, shape_size.large, "green", shape_location.belowbar)

-- Plot Keltner Channel
if fill_visible then
    fill { first = upper_band, second = lower_band, color = fill_color }
end
if upper_line_visible then
    plot(upper_band, "Upper Band", upper_line_color, upper_line_width)
end
if middle_line_visible then
    plot(middle, "Middle Line", middle_line_color, middle_line_width)
end
if lower_line_visible then
    plot(lower_band, "Lower Band", lower_line_color, lower_line_width)
end
