--https://www.tradeviewforex.com/demarks-pivots.php
instrument { name = "Pivot Points", icon="indicators:ADX", overlay = true }

method_id = input (1, "Type", input.string_selection, { "Classic", "Fibonacci", "Camarilla", "Woodie", "DeMark" })

input_group {
    "Pivot Point",

    level_0_color = input { default = "red", type = input.color },
    level_0_width = input { default = 1, type = input.line_width }
}

input_group {
    "Level 1",

    level_1_color = input { default = "green", type = input.color },
    level_1_width = input { default = 1, type = input.line_width }
}

input_group {
    "Level 2",

    level_2_color = input { default = "blue", type = input.color },
    level_2_width = input { default = 1, type = input.line_width }
}

input_group {
    "Level 3",

    level_3_color = input { default = "yellow", type = input.color },
    level_3_width = input { default = 1, type = input.line_width }
}

local function classic(candle)
    p = (candle.high + candle.low + candle.close) / 3

    r1 = 2 * p - candle.low
    r2 = p + candle.high - candle.low
    r3 = candle.high + 2 * (p - candle.low)

    s1 = 2 * p - candle.high
    s2 = p - candle.high + candle.low
    s3 = candle.low - 2 * (candle.high - p)
end

local function fibonacci(candle)
    p = (candle.high + candle.low + candle.close) / 3

    r1 = p + (candle.high - candle.low) * 0.382
    r2 = p + (candle.high - candle.low) * 0.618
    r3 = p + (candle.high - candle.low)

    s1 = p - (candle.high - candle.low) * 0.382
    s2 = p - (candle.high - candle.low) * 0.618
    s3 = p - (candle.high - candle.low)
end

local function camarilla(candle)
    p = (candle.high + candle.low + candle.close) / 3

    r1 = p + (candle.high - candle.low) * 1.1 / 12
    r2 = p + (candle.high - candle.low) * 1.1 / 6
    r3 = p + (candle.high - candle.low) * 1.1 / 4

    s1 = p - (candle.high - candle.low) * 1.1 / 12
    s2 = p - (candle.high - candle.low) * 1.1 / 6
    s3 = p - (candle.high - candle.low) * 1.1 / 4
end

local function woodie(candle)
    p = (candle.high + candle.low + 2 * candle.close) / 4

    r1 = 2 * p - candle.low
    r2 = p + (candle.high - candle.low)

    s1 = 2 * p - candle.high
    s2 = p - (candle.high - candle.low)
end

local function demark(candle)
    x = candle.high + 2 * candle.low + candle.close
    
    r1 = x/2 - candle.low
    p = x / 4
    s1 = x/2 - candle.high
end

local methods = { classic, fibonacci, camarilla, woodie, demark }

local resolution = "1W"

if is_daily then
    resolution = "1M"
elseif is_weekly or is_monthly then
    resolution = "1Y"
end

sec = security (current_ticker_id, resolution)

if sec then
   local method = methods [method_id]

   method (sec)

   plot (p, "Pivot", level_0_color, level_0_width, 0, style.levels, na_mode.restart)

   plot (r1, "R1",   level_1_color, level_1_width, 0, style.levels, na_mode.restart)
   plot (r2, "R2",   level_2_color, level_2_width, 0, style.levels, na_mode.restart)
   plot (r3, "R3",   level_3_color, level_3_width, 0, style.levels, na_mode.restart)
   
   plot (s1, "S1",   level_1_color, level_1_width, 0, style.levels, na_mode.restart)
   plot (s2, "S2",   level_2_color, level_2_width, 0, style.levels, na_mode.restart)
   plot (s3, "S3",   level_3_color, level_3_width, 0, style.levels, na_mode.restart)
end