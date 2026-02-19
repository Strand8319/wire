--[[
	Find gates
]]

GateActions("Find")

local function safeClassMatch(class, filter)
    if filter == "" then return true end
    local ok, result = pcall(string.match, string.lower(class), string.lower(filter))
    return ok and result ~= nil
end

GateActions["find_incone"] = {
    name = "Find In Cone",
    description = "Finds all entities within a spherical cone. Returns an array of entities. Filter accepts a Lua pattern for class name. Ignore is an array of entities to exclude.",
    inputs = { "Clk", "Position", "Direction", "Length", "Degrees", "Filter", "Ignore" },
    inputtypes = { "NORMAL", "VECTOR", "VECTOR", "NORMAL", "NORMAL", "STRING", "ARRAY" },
    outputs = { "Entities", "Count" },
    outputtypes = { "ARRAY", "NORMAL" },
    timed = true,
    output = function(gate, Clk, Position, Direction, Length, Degrees, Filter, Ignore)
        if Clk == 0 then
            return gate.Outputs.Entities.Value, gate.Outputs.Count.Value
        end

        if not isvector(Position)       then Position = Vector(0, 0, 0) end
        if not isvector(Direction)      then Direction = Vector(0, 0, 1) end
        if not Length  or Length  <= 0  then Length    = 1024 end
        if not Degrees or Degrees <= 0  then Degrees   = 45 end
        if not isstring(Filter)         then Filter    = "" end

        Direction = Direction:GetNormalized()

        local ignoreLookup = {}
        if istable(Ignore) then
            for _, v in ipairs(Ignore) do
                if IsValid(v) then ignoreLookup[v] = true end
            end
        end

        local cosDegrees = math.cos(math.rad(Degrees))
        local findlist   = ents.FindInSphere(Position, Length)
        local result     = {}

        for _, ent in ipairs(findlist) do
            if IsValid(ent) and not ignoreLookup[ent] then
                local dot = Direction:Dot((ent:GetPos() - Position):GetNormalized())
                if dot > cosDegrees then
                    if safeClassMatch(ent:GetClass(), Filter) then
                        result[#result + 1] = ent
                    end
                end
            end
        end

        return result, #result
    end,
    label = function(Out, Clk, Position, Direction, Length, Degrees, Filter)
        return string.format("findInCone(%s, len=%s, deg=%s, filter=%q) = %d",
            tostring(Position), tostring(Length), tostring(Degrees), tostring(Filter), Out.Count)
    end
}

GateActions["find_inbox"] = {
    name = "Find In Box",
    description = "Finds all entities within an axis-aligned box. Returns an array of entities. Filter accepts a Lua pattern for class name. Ignore is an array of entities to exclude.",
    inputs = { "Clk", "Min", "Max", "Filter", "Ignore" },
    inputtypes = { "NORMAL", "VECTOR", "VECTOR", "STRING", "ARRAY" },
    outputs = { "Entities", "Count" },
    outputtypes = { "ARRAY", "NORMAL" },
    timed = true,
    output = function(gate, Clk, Min, Max, Filter, Ignore)
        if Clk == 0 then
            return gate.Outputs.Entities.Value, gate.Outputs.Count.Value
        end

        if not isvector(Min)    then Min    = Vector(0, 0, 0) end
        if not isvector(Max)    then Max    = Vector(0, 0, 0) end
        if not isstring(Filter) then Filter = "" end

        local rMin = Vector(math.min(Min.x, Max.x), math.min(Min.y, Max.y), math.min(Min.z, Max.z))
        local rMax = Vector(math.max(Min.x, Max.x), math.max(Min.y, Max.y), math.max(Min.z, Max.z))

        local ignoreLookup = {}
        if istable(Ignore) then
            for _, v in ipairs(Ignore) do
                if IsValid(v) then ignoreLookup[v] = true end
            end
        end

        local findlist = ents.FindInBox(rMin, rMax)
        local result   = {}

        for _, ent in ipairs(findlist) do
            if IsValid(ent) and not ignoreLookup[ent] then
                if safeClassMatch(ent:GetClass(), Filter) then
                    result[#result + 1] = ent
                end
            end
        end

        return result, #result
    end,
    label = function(Out, Clk, Min, Max, Filter)
        return string.format("findInBox(%s → %s, filter=%q) = %d",
            tostring(Min), tostring(Max), tostring(Filter), Out.Count)
    end
}

GateActions()