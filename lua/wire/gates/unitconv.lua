--[[
		Unit Conversion
]]

GateActions("Unit Conversion")

local speed = {
    ["u/s"]   = 1 / 0.75,
    ["u/m"]   = 60 * (1 / 0.75),
    ["u/h"]   = 3600 * (1 / 0.75),
    ["mm/s"]  = 25.4,
    ["cm/s"]  = 2.54,
    ["dm/s"]  = 0.254,
    ["m/s"]   = 0.0254,
    ["km/s"]  = 0.0000254,
    ["in/s"]  = 1,
    ["ft/s"]  = 1 / 12,
    ["yd/s"]  = 1 / 36,
    ["mi/s"]  = 1 / 63360,
    ["nmi/s"] = 127 / 9260000,
    ["mm/m"]  = 60 * 25.4,
    ["cm/m"]  = 60 * 2.54,
    ["dm/m"]  = 60 * 0.254,
    ["m/m"]   = 60 * 0.0254,
    ["km/m"]  = 60 * 0.0000254,
    ["in/m"]  = 60,
    ["ft/m"]  = 60 / 12,
    ["yd/m"]  = 60 / 36,
    ["mi/m"]  = 60 / 63360,
    ["nmi/m"] = 60 * 127 / 9260000,
    ["mm/h"]  = 3600 * 25.4,
    ["cm/h"]  = 3600 * 2.54,
    ["dm/h"]  = 3600 * 0.254,
    ["m/h"]   = 3600 * 0.0254,
    ["km/h"]  = 3600 * 0.0000254,
    ["in/h"]  = 3600,
    ["ft/h"]  = 3600 / 12,
    ["yd/h"]  = 3600 / 36,
    ["mi/h"]  = 3600 / 63360,
    ["nmi/h"] = 3600 * 127 / 9260000,
    ["mph"]   = 3600 / 63360,
    ["knots"] = 3600 * 127 / 9260000,
    ["mach"]  = 0.0254 / 295,
}
local length = {
    ["u"]   = 1 / 0.75,
    ["mm"]  = 25.4,
    ["cm"]  = 2.54,
    ["dm"]  = 0.254,
    ["m"]   = 0.0254,
    ["km"]  = 0.0000254,
    ["in"]  = 1,
    ["ft"]  = 1 / 12,
    ["yd"]  = 1 / 36,
    ["mi"]  = 1 / 63360,
    ["nmi"] = 127 / 9260000,
}
local weight = {
    ["g"]  = 1000,
    ["kg"] = 1,
    ["t"]  = 0.001,
    ["oz"] = 1 / 0.028349523125,
    ["lb"] = 1 / 0.45359237,
}

GateActions["unit_tounit"] = {
    name = "To Unit",
    description = "Converts a value from Source units (inches) to the specified unit. Supports speed (m/s, km/h, mph...), length (m, cm, ft...) and weight (kg, lb, oz...).",
    inputs = { "Value", "Unit" },
    inputtypes = { "NORMAL", "STRING" },
    outputtypes = { "NORMAL" },
    output = function(gate, Value, Unit)
        if speed[Unit] then
            return (Value * 0.75) * speed[Unit]
        elseif length[Unit] then
            return (Value * 0.75) * length[Unit]
        elseif weight[Unit] then
            return Value * weight[Unit]
        end
        return 0
    end,
    label = function(Out, Value, Unit)
        return string.format("toUnit(%s, %q) = %f", tostring(Value), tostring(Unit), Out)
    end
}

GateActions["unit_fromunit"] = {
    name = "From Unit",
    description = "Converts a value from the specified unit back to Source units (inches). Supports speed, length and weight.",
    inputs = { "Value", "Unit" },
    inputtypes = { "NORMAL", "STRING" },
    outputtypes = { "NORMAL" },
    output = function(gate, Value, Unit)
        if speed[Unit] then
            return (Value / 0.75) / speed[Unit]
        elseif length[Unit] then
            return (Value / 0.75) / length[Unit]
        elseif weight[Unit] then
            return Value / weight[Unit]
        end
        return 0
    end,
    label = function(Out, Value, Unit)
        return string.format("fromUnit(%s, %q) = %f", tostring(Value), tostring(Unit), Out)
    end
}

GateActions["unit_convertunit"] = {
    name = "Convert Unit",
    description = "Converts a value from one unit to another. Both units must be of the same type (speed, length or weight).",
    inputs = { "Value", "From", "To" },
    inputtypes = { "NORMAL", "STRING", "STRING" },
    outputtypes = { "NORMAL" },
    output = function(gate, Value, From, To)
        if speed[From] and speed[To] then
            return Value * (speed[To] / speed[From])
        elseif length[From] and length[To] then
            return Value * (length[To] / length[From])
        elseif weight[From] and weight[To] then
            return Value * (weight[To] / weight[From])
        end
        return 0
    end,
    label = function(Out, Value, From, To)
        return string.format("convertUnit(%s, %q → %q) = %f", tostring(Value), tostring(From), tostring(To), Out)
    end
}