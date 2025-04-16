/***
 *   @addon         LFS Travel System
 *   @version       3.0.0
 *   @file          sh_utils.lua
 *   @description   Shared utility functions for the teleport system
 */

local Utils = {}
DDI.Teleports.Utils = Utils


-- Calculate distance between two vectors
function Utils:CalculateDistance(vec1, vec2)
    return vec1:Distance(vec2)
end


-- Calculate center point between two vectors
function Utils:CalculateCenter(vec1, vec2)
    return (vec1 + vec2) / 2
end


-- Calculate the volume of a box defined by two corners
function Utils:CalculateVolume(vec1, vec2)
    local width = math.abs(vec1.x - vec2.x)
    local length = math.abs(vec1.y - vec2.y)
    local height = math.abs(vec1.z - vec2.z)
    
    return width * length * height
end


-- Check if a point is inside a box defined by two corners
function Utils:IsPointInBox(point, vec1, vec2)
    local minX = math.min(vec1.x, vec2.x)
    local maxX = math.max(vec1.x, vec2.x)
    local minY = math.min(vec1.y, vec2.y)
    local maxY = math.max(vec1.y, vec2.y)
    local minZ = math.min(vec1.z, vec2.z)
    local maxZ = math.max(vec1.z, vec2.z)
    
    return point.x >= minX and point.x <= maxX and
           point.y >= minY and point.y <= maxY and
           point.z >= minZ and point.z <= maxZ
end


-- Generate a random point inside a box defined by two corners
function Utils:RandomPointInBox(vec1, vec2)
    local minX = math.min(vec1.x, vec2.x)
    local maxX = math.max(vec1.x, vec2.x)
    local minY = math.min(vec1.y, vec2.y)
    local maxY = math.max(vec1.y, vec2.y)
    local minZ = math.min(vec1.z, vec2.z)
    local maxZ = math.max(vec1.z, vec2.z)
    
    return Vector(
        math.Rand(minX, maxX),
        math.Rand(minY, maxY),
        math.Rand(minZ, maxZ)
    )
end


-- Round a vector to integer coordinates
function Utils:RoundVector(vec)
    return Vector(
        math.Round(vec.x),
        math.Round(vec.y),
        math.Round(vec.z)
    )
end


-- Format a vector to a readable string
function Utils:FormatVector(vec, precision)
    precision = precision or 0
    local format = '%.' .. tostring(precision) .. 'f'
    return string.format('(%s, %s, %s)', 
        string.format(format, vec.x),
        string.format(format, vec.y),
        string.format(format, vec.z)
    )
end


-- Check if a point is near a vector
function Utils:IsNearPoint(point, target, radius)
    return point:Distance(target) <= radius
end


-- Validate teleport parameters
function Utils:ValidateTeleportParams(pPlayer, fromLocationId, toLocationId)
    if (not IsValid(pPlayer)) then
        return false, 'Invalid pPlayer'
    end
    
    if (not fromLocationId or not toLocationId) then
        return false, 'Missing location IDs'
    end
    
    if (fromLocationId == toLocationId) then
        return false, DanLib.Func:L('#same.planet')
    end
    
    if (not DDI.Teleports.Brushe[fromLocationId]) then
        return false, 'Source location not found: ' .. fromLocationId
    end
    
    if (not DDI.Teleports.Brushe[toLocationId]) then
        return false, 'Destination location not found: ' .. toLocationId
    end
    
    local config = DDI.Teleports.API:GetCurrentGamemode()
    
    if config.requiresVehicle then
        local ship = pPlayer:lfsGetPlane()
        if (not IsValid(ship) or ship:GetDriver() != pPlayer) then
            return false, DanLib.Func:L('#not.in.vehicle')
        end
    end
    
    if pPlayer.LastTransportRequest and (CurTime() - pPlayer.LastTransportRequest < config.cooldownTime) then
        local remainingTime = math.ceil(config.cooldownTime - (CurTime() - pPlayer.LastTransportRequest))
        return false, DanLib.Func:L('#cooldown.active', {time = remainingTime})
    end
    
    return true, ''
end


-- Create a unique ID for a new location
function Utils:GenerateLocationId(name)
    local base = string.lower(string.gsub(name, '[^%w]', ''))
    
    -- If base is empty (e.g., all non-alphanumeric), use a generic base
    if (base == '') then
        base = 'location'
    end
    
    -- Check if the base ID already exists
    if (not DDI.Teleports.Brushe[base]) then
        return base
    end
    
    -- If it exists, add a number to make it unique
    local counter = 1
    while DDI.Teleports.Brushe[base .. counter] do
        counter = counter + 1
    end
    
    return base .. counter
end


-- Validate location data before creating/editing
function Utils:ValidateLocationData(data)
    -- Check required fields
    if (not data.id or data.id == '') then
        return false, DanLib.Func:L('#no.id')
    end
    
    if (not data.name or data.name == '') then
        return false, DanLib.Func:L('#no.name')
    end
    
    if (not data.model or data.model == '') then
        return false, DanLib.Func:L('#no.model')
    end
    
    if (not data.boundA or not isvector(data.boundA)) then
        return false, DanLib.Func:L('#no.boundA')
    end
    
    if (not data.boundB or not isvector(data.boundB)) then
        return false, DanLib.Func:L('#no.boundB')
    end
    
    -- Validate model format
    if (not string.StartWith(data.model, 'models/') or not string.EndsWith(data.model, '.mdl')) then
        return false, DanLib.Func:L('#invalid.model.format')
    end
    
    -- Check if volume is reasonable
    local volume = Utils:CalculateVolume(data.boundA, data.boundB)
    if (volume <= 0) then
        return false, DanLib.Func:L('#zero.volume')
    elseif (volume > 1000000) then
        return false, DanLib.Func:L('#volume.too.large')
    end
    
    return true, ''
end


-- Save an array of locations to a data file
function Utils:SaveToFile(fileName, data)
    if (not file.IsDir('ddi', 'DATA')) then 
        file.CreateDir('ddi') 
    end
    
    if (not file.IsDir('ddi/tp_location', 'DATA')) then 
        file.CreateDir('ddi/tp_location') 
    end
    
    local jsonData = util.TableToJSON(data, true)
    file.Write(fileName, jsonData)
    
    return file.Exists(fileName, 'DATA')
end


-- Load an array of locations from a data file
function Utils:LoadFromFile(fileName)
    if (not file.Exists(fileName, 'DATA')) then
        return nil, 'File does not exist'
    end
    
    local jsonData = file.Read(fileName, 'DATA')
    local success, result = pcall(util.JSONToTable, jsonData)
    
    if (not success) then
        return nil, 'Failed to parse JSON: ' .. tostring(result)
    end
    
    return result, nil
end


-- Create a debug indicator entity at a position
if SERVER then
    function Utils:CreateDebugPoint(pos, color, duration)
        if (not DanLib.CONFIG.TP_LOCATION.Debugg) then return end
        
        duration = duration or 10
        color = color or Color(255, 0, 0)
        
        local point = ents.Create('env_sprite')
        point:SetPos(pos)
        point:SetColor(color)
        point:SetKeyValue('model', 'sprites/glow04_noz.vmt')
        point:SetKeyValue('scale', '0.5')
        point:SetKeyValue('rendermode', '5')
        point:Spawn()
        
        timer.Simple(duration, function()
            if IsValid(point) then
                point:Remove()
            end
        end)
        
        return point
    end
end


-- Log an event to the console with optional DanLib notification
function Utils:LogEvent(type, message, notifyPlayer)
    DanLib.Func:PrintType('TL', message)
    
    if (SERVER and notifyPlayer and IsValid(notifyPlayer)) then
        DanLib.Func:CreatePopupNotifi(notifyPlayer, DanLib.Func:L('#' .. type), message, string.upper(type))
    elseif (CLIENT and notifyPlayer) then
        DanLib.Func:ScreenNotification(DanLib.Func:L('#' .. type), message, string.upper(type))
    end
end


-- Get the estimated travel time between two locations
function Utils:GetTravelTime(fromLocationId, toLocationId)
    if (not DDI.Teleports.Brushe[fromLocationId] or not DDI.Teleports.Brushe[toLocationId]) then
        return 0
    end
    
    local fromPos = Utils:CalculateCenter(
        DDI.Teleports.Brushe[fromLocationId].boundA,
        DDI.Teleports.Brushe[fromLocationId].boundB
    )
    
    local toPos = Utils:CalculateCenter(
        DDI.Teleports.Brushe[toLocationId].boundA,
        DDI.Teleports.Brushe[toLocationId].boundB
    )
    
    local distance = fromPos:Distance(toPos)
    
    -- Calculate estimated travel time based on distance
    -- This formula can be adjusted based on your preference
    local baseTime = 2 -- Base time in seconds
    local distanceFactor = distance / 5000 -- Adjust time based on distance
    
    return math.Clamp(baseTime + distanceFactor, 2, 10)
end
