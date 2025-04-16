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



local base = DanLib.Func
local dHook = DanLib.Hook
local Table = DanLib.Table
local Network = DanLib.Network
local NetworkUtil = DanLib.NetworkUtil


NetworkUtil:AddString('DDI.NetCreateLocation')
NetworkUtil:AddString('DDI.NetEditLocation')
NetworkUtil:AddString('DDI.NetRemoveLocation')
NetworkUtil:AddString('DDI.NetAdminMenuLocation')
NetworkUtil:AddString('DDI.NetRefreshLocations')
NetworkUtil:AddString('DDI.NetOpenLocationsList')
NetworkUtil:AddString('DDI.NetCloseLocationsList')
NetworkUtil:AddString('DDI.NetRequestTransport')


DDI.Teleports = DDI.Teleports or {}


--- Send an updated location list to all players
-- @return void
local function Refresh()
    Network:Start('DDI.NetRefreshLocations')
    Network:WriteTable(DDI.Teleports.Brushe or {})
    Network:SendToPlayer(player.GetAll())
end


--- Create a new location
-- @param _ (any): Unused parameter
-- @param pPlayer (Player): The player who requested the location creation
-- @return void
local function CreateLocation(_, pPlayer)
    if (not base.HasPermission(pPlayer, 'TLEditConfig')) then
        base:CreatePopupNotifi(pPlayer, base:L('AccessDenied'), base:L('AccessVer'), 'ERROR', 6)
        return 
    end

    local tbl = Network:ReadTable()
    if (not istable(tbl)) then
        base:SidePopupNotifi(pPlayer, false, base:L('#no.table'), 'WARNING', 5)
        return
    end

    DDI.Teleports:Add(tbl.id, tbl.name, tbl.model, tbl.boundA, tbl.boundB)
    base:SidePopupNotifi(pPlayer, false, base:L('#added.location'), 'CONFIRM', 5)
    dHook:ProtectedRun('DDI.TL.CreateLocation', pPlayer, tbl)
    Refresh()
end
Network:Receive('DDI.NetCreateLocation', CreateLocation)


--- Edit an existing location
-- @param _ (any): Unused parameter
-- @param pPlayer (Player): The player who requested the location editing
-- @return void
local function EditLocation(_, pPlayer)
    if (not base.HasPermission(pPlayer, 'TLEditConfig')) then
        base:CreatePopupNotifi(pPlayer, base:L('AccessDenied'), base:L('AccessVer'), 'ERROR', 6)
        return 
    end

    local tbl = Network:ReadTable()
    if (not istable(tbl)) then
        base:SidePopupNotifi(pPlayer, false, base:L('#no.table'), 'WARNING', 5)
        return
    end

    DDI.Teleports:Edit(tbl.id, tbl.name, tbl.model, tbl.boundA, tbl.boundB)
    dHook:ProtectedRun('DDI.TL.EditLocation', pPlayer, tbl)
    Refresh()
end
Network:Receive('DDI.NetEditLocation', EditLocation)


--- Delete a location
-- @param _ (any): Unused parameter
-- @param pPlayer (Player): The player who requested the location deletion
-- @return void
local function DeleteLocation(_, pPlayer)
    if (not base.HasPermission(pPlayer, 'TLEditConfig')) then
        base:CreatePopupNotifi(pPlayer, base:L('AccessDenied'), base:L('AccessVer'), 'ERROR', 6)
        return 
    end

    local tbl = Network:ReadTable()
    if (not istable(tbl)) then
        base:SidePopupNotifi(pPlayer, false, base:L('#no.table'), 'WARNING', 5)
        return
    end

    DDI.Teleports:Delete(tbl.id)
    dHook:ProtectedRun('DDI.TL.DeleteLocation', pPlayer, tbl.id)
    Refresh()
end
Network:Receive('DDI.NetRemoveLocation', DeleteLocation)


--- Initialize the teleport locations from file
-- @function Initialize
-- @return void
local function Initialize()
    if (not file.IsDir('ddi', 'DATA')) then file.CreateDir('ddi') end
    if (not file.IsDir('ddi/tp_location', 'DATA')) then file.CreateDir('ddi/tp_location') end

    local map = game.GetMap():lower()
    if file.Exists('ddi/tp_location/' .. map .. '.txt', 'DATA') then
        local status, result = pcall(util.JSONToTable, file.Read('ddi/tp_location/' .. map .. '.txt', 'DATA'))

        if status then
            DDI.Teleports.Brushe = result
            base:PrintType('TL', base:L('#teleports.file.loaded'))
        else
            DDI.Teleports.Brushe = {}
            base:PrintType('TL', base:L('#error.file.loaded'))
        end
    else
        DDI.Teleports.Brushe = {}
        file.Write('ddi/tp_location/' .. map .. '.txt', '{}')
        base:PrintType('TL', base:L('#created.file'))
    end

    for k, v in pairs(DDI.Teleports.Brushe or {}) do
        local newEnt = ents.Create('teleport_brush')
        newEnt.PointA, newEnt.PointB = v.boundA, v.boundB
        newEnt:Spawn()
        newEnt:Activate()
    end

    if (#DDI.Teleports.Brushe > 0) then
        base:PrintType('TL', 'Uploaded by ', Color(100, 200, 100), (#DDI.Teleports.Brushe or {}), color_white, ' teleporters for map ', Color(100, 200, 100), game.GetMap(), color_white, '!\n')
    end
end
dHook:Add('Initialize', 'DDI.Initialize', Initialize)


--- Send the list of locations to the player when they log on to the server
-- @param pPlayer (Player): The player who just connected
-- @return void
local function PlayerInitial(pPlayer)
    Network:Start('DDI.NetRefreshLocations')
    Network:WriteTable(DDI.Teleports.Brushe or {})
    Network:SendToPlayer(pPlayer)
end
dHook:Add('PlayerInitialSpawn', 'DDI.SendLocationsOnSpawn', PlayerInitial)


--- Cleanup teleport locations after a map cleanup
-- @return void
local function CleanupMap()
    for k, v in pairs(DDI.Teleports.Brushe or {}) do
        local newEnt = ents.Create('teleport_brush')
        newEnt.PointA, newEnt.PointB = v.boundA, v.boundB
        newEnt:Spawn()
        newEnt:Activate()
    end

    if (#DDI.Teleports.Brushe > 0) then
    	base:PrintType('TL', 'Restored ', Color(100, 200, 100), (#DDI.Teleports.Brushe or {}), color_white, ' teleporters!')
    end
end
dHook:Add('PostCleanupMap', 'DDI.PostCleanupMap', CleanupMap)


--- Handle player chat commands for opening admin menu
-- @param pPlayer (Player): The player who sent the message
-- @param text (string): The message text sent by the player
-- @return string: Returns an empty string to prevent the message from being sent to others
local function PlayerSay(pPlayer, text)
    if (text:lower():sub(1, 1) ~= '!' or text:lower():sub(2, #DanLib.CONFIG.TP_LOCATION.ChatCommand + 1) ~= DanLib.CONFIG.TP_LOCATION.ChatCommand) then
        return
    end

    if (not base.HasPermission(pPlayer, 'TLEditConfig')) then
        base:CreatePopupNotifi(pPlayer, base:L('AccessDenied'), base:L('AccessVer'), 'ERROR', 6)
        return 
    end
    
    Network:Start('DDI.NetAdminMenuLocation')
    Network:WriteTable(DDI.Teleports.Brushe or {})
    Network:SendToPlayer(pPlayer)

    return ''
end
dHook:Add('PlayerSay', 'DDI.OpenAdminConfig', PlayerSay)


--- Command to show the admin location list to the player
-- @param pPlayer (Player): The player who requested the admin list
-- @return void
local function TLAdminList(pPlayer)
    if (not IsValid(pPlayer)) then return end

    Network:Start('DDI.NetAdminMenuLocation')
    Network:WriteTable(DDI.Teleports.Brushe or {})
    Network:SendToPlayer(pPlayer)
end
concommand.Add('tl_admin_list', TLAdminList)


--- Print a simple list of location names to the player
-- @param pPlayer (Player): The player to whom the list will be printed
-- @return void
local function PrintLocationsList(pPlayer)
    if (not IsValid(pPlayer)) then return end

    -- Print header
    pPlayer:PrintMessage(HUD_PRINTCONSOLE, '\n=== Available Locations ID ===')

    -- Sort and print location names
    local locationNames = {}
    for _, loc in pairs(DDI.Teleports:GetList()) do
        Table:Add(locationNames, loc.name)
    end
    Table:Sort(locationNames)

    for i, name in ipairs(locationNames) do
        pPlayer:PrintMessage(HUD_PRINTCONSOLE, string.format('%d. %s', i, name))
    end

    pPlayer:PrintMessage(HUD_PRINTCONSOLE, string.format('\nTotal locations: %d', #locationNames))
    pPlayer:PrintMessage(HUD_PRINTCONSOLE, '========================')
end
concommand.Add('tl_list_locations', PrintLocationsList)
