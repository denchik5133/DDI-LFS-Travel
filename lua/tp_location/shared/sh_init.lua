/***
 *   @addon         LFS Travel System
 *   @version       2.0.0
 *   @release_date  11/10/2022
 *   @authors       denchik, Kotyarishka
 *
 *   @contacts      denchik:
 *                  - Discord: denchik_gm
 *                  - Steam: [Profile](https://steamcommunity.com/profiles/76561198405398290/)
 *                  - GitHub: [Profile](https://github.com/denchik5133)
 *
 *                  Kotyarishka:
 *                  - Discord: kotyarishka
 *                  - Steam: [Profile](https://steamcommunity.com/id/kotyarishka/)
 *                  - GitHub: [Profile](https://github.com/Kotyarishka)
 *                
 *   @description   What can be better for comfortable wagering rp on the server? This system gives you the opportunity
 *                  to qualitatively play your role and will give you the opportunity to move between locations on the map without much effort.
 *                  
 *   @usage         !tl_admin (chat) | tl_admin (console)
 *   @license       MIT License
 *   @notes         For feature requests or contributions, please open an issue on GitHub.
 */



DDI.Teleports = DDI.Teleports or {}
DDI.Teleports.Brushe = DDI.Teleports.Brushe or {}


local Table = DanLib.Table
local Network = DanLib.Network


-- Save all locations
function DDI.Teleports:Save()
    local map = game.GetMap():lower()
    file.Write('ddi/tp_location/' .. map .. '.txt', util.TableToJSON(self.Brushe or {}, true))
end


--- Initializes a location entry.
-- @param id (string): Unique identifier for the location.
-- @param name (string): The name of the location.
-- @param model (string): The model associated with the location.
-- @param posA (Vector): The first point of the location boundaries.
-- @param posB (Vector): The second point of the location boundaries.
-- @return table: The initialized location entry.
local function InitializeLocation(id, name, model, posA, posB)
    return { id = id, name = name, model = model, boundA = posA, boundB = posB }
end


--- Creates a new location
-- @param id (string): Unique identifier for the location.
-- @param name (string): The name of the location.
-- @param model (string): The model associated with the location.
-- @param posA (Vector): The first point of the location boundaries.
-- @param posB (Vector): The second point of the location boundaries.
function DDI.Teleports:Add(id, name, model, posA, posB)
    -- Initialize if it doesn't exist
    self.Brushe[id] = self.Brushe[id] or {}
    self.Brushe[id] = InitializeLocation(id, name, model, posA, posB)

    local newEnt = ents.Create('teleport_brush')
    newEnt.PointA, newEnt.PointB, newEnt.id = posA, posB, id
    newEnt:Spawn()
    newEnt:Activate()

    self:Save()
end


--- Edits an existing location
-- @param id (string): Unique identifier of the location to edit.
-- @param name (string): The new name of the location.
-- @param model (string): New model associated with the location.
-- @param posA (Vector): New first point of the location boundaries.
-- @param posB (Vector): New second point of the location boundaries.
function DDI.Teleports:Edit(id, name, model, posA, posB)
    -- Initialize if it doesn't exist
    self.Brushe[id] = self.Brushe[id] or {}
    self.Brushe[id] = InitializeLocation(id, name, model, posA, posB)
    self:Save()
end


--- Deletes the location
-- @param id (string): Unique identifier of the location to delete.
function DDI.Teleports:Delete(id)
    local tbl = self.Brushe[id]
    if (not tbl) then return end

    self.Brushe[id] = nil
    self:Save()
end


-- Function to get planet name from entity
local function GetPlanetName(ent)
    if (not IsValid(ent)) then return nil end

    -- First try to get Planet directly from the entity's table
    local entTable = ent:GetTable()
    if (entTable and entTable.m_Planet) then
        return entTable.m_Planet
    end

    -- Then try through GetPlanet method
    if ent.GetPlanet then
        local planetName = ent:GetPlanet()
        if (planetName and planetName ~= '') then
            return planetName
        end
    end

    return nil
end

-- Function to collect location information
function DDI.Teleports:GetList()
    local LocationData = {}

    -- Find all brush entities
    local locationEntities = {}
    for _, ent in pairs(ents.GetAll()) do
        if IsValid(ent) and (ent.Base == 'base_brush' or ent:GetClass() == 'brush') then
            Table:Add(locationEntities, ent)
        end
    end

    -- Process each entity
    for _, ent in pairs(locationEntities) do
        if IsValid(ent) then
            local planetName = GetPlanetName(ent)

            if planetName then
                -- Create location info
                local locInfo = {
                    name = planetName,
                    type = ent:GetClass(),
                    entName = ent:GetName() ~= '' and ent:GetName() or nil,
                    owner = ent.CPPIGetOwner and ent:CPPIGetOwner() or nil,
                }

                -- Add to location data
                Table:Add(LocationData, locInfo)
            end
        end
    end

    -- Sort locations by name
    Table:Sort(LocationData, function(a, b)
        return a.name < b.name
    end)

    return LocationData
end


DanLib.BaseConfig.Permissions = DanLib.BaseConfig.Permissions or {}
DanLib.BaseConfig.Permissions['TLAccessTool'] = 'Who has access to use the tool?'
DanLib.BaseConfig.Permissions['TLEditConfig'] = 'Who has permission to create/edit deletions, and to the admin menu?'
