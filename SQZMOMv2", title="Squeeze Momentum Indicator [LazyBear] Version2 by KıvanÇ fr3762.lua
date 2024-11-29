-- Squeeze Momentum Indicator (SQZMOMv3)
instrument { name = "SQZMOMv3", title = "Squeeze Momentum Indicator" }

-- Input Parameters
length = input(20, "Bollinger Band Period", input.integer, 1)
mult = input(2, "Bollinger Band Multiplier", input.integer, 1)
lengthKC = input(20, "Keltner Channel Period", input.integer, 1)
multKC = input(1.5, "Keltner Channel Multiplier", input.double, 1)
SignalPeriod = input(5, "Signal Line Period", input.integer, 1)
source = input(1, "Source Type", input.string_selection, inputs.titles)

-- Line and Color Settings
input_group {
    "Line Colors and Width",
    color1 = input { default = "red", type = input.color },   -- Signal line
    color2 = input { default = "blue", type = input.color },  -- Momentum line
    color3 = input { default = "black", type = input.color }, -- Squeeze on
    color4 = input { default = "gray", type = input.color },  -- Squeeze off
    color5 = input { default = "blue", type = input.color },  -- No squeeze
    width = input { default = 1, type = input.line_width }
}

-- Background Color Settings
input_group {
    "Background",
    color6 = input { default = "lime", type = input.color },   -- Increasing momentum (positive)
    color7 = input { default = "green", type = input.color },  -- Decreasing momentum (positive)
    color8 = input { default = "red", type = input.color },    -- Increasing momentum (negative)
    color9 = input { default = "maroon", type = input.color }, -- Decreasing momentum (negative)
    bcolor_visible = input { default = true, type = input.plot_visibility }
}

-- Use True Range for Range Calculation
useTrueRange = true

-- Bollinger Band Calculation
basis = sma(close, length)
dev = mult * stdev(close, length)
upperBB = basis + dev
lowerBB = basis - dev

-- Keltner Channel Calculation
ma = sma(close, lengthKC)
range = iff(useTrueRange, tr, high - low)
rangema = sma(range, lengthKC)
upperKC = ma + rangema * multKC
lowerKC = ma - rangema * multKC

-- Squeeze Logic
sqzOn = (lowerBB > lowerKC) and (upperBB < upperKC)  -- Squeeze on
sqzOff = (lowerBB < lowerKC) and (upperBB > upperKC) -- Squeeze off
noSqz = not sqzOn and not sqzOff                     -- No squeeze condition

-- Momentum Calculation
val1 = (highest(high, lengthKC) + lowest(low, lengthKC)) / 2
val2 = (val1 + sma(close, lengthKC)) / 2
momentum = linreg(close - val2, lengthKC, 0)

-- Background Color Logic
bcolor = iff(momentum > 0, 
             iff(momentum > nz(momentum[1]), color6, color7), 
             iff(momentum < nz(momentum[1]), color8, color9))

-- Signal Line Calculation
signal = sma(momentum, SignalPeriod)

-- Squeeze Color Logic
scolor = iff(noSqz, color5, 
             iff(sqzOn, color3, color4))

-- Plot Background Fill
if bcolor_visible then
    fill(0.001, -0.001, "", bcolor)
end

-- Plot Lines
plot(momentum, "Momentum", color2, 2)
plot(signal, "Signal Line", color1, 2)

-- Plot Crosses for Squeeze Status
plot(0, "Squeeze Status", scolor, 4, 0, style.crosses, 0)

-- Uncomment if additional fill is desired between signal and momentum
-- fill(signal, momentum, "", bcolor)
