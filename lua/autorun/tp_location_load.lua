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
 *   @usage         !danlibmenu (chat) | danlibmenu (console)
 *   @license       MIT License
 *   @notes         For feature requests or contributions, please open an issue on GitHub.
 */


if (not DanLib) then
    ErrorNoHalt('[DanLib] You need to install DanLib to use this addon.')
    return
end

-- Initialize global tables
DDI = DDI or {}
DDI.Teleports = DDI.Teleports or {}
DDI.Teleports.Brushe = DDI.Teleports.Brushe or {}
DDI.Teleports.API = DDI.Teleports.API or {}
DDI.Teleports.Effects = DDI.Teleports.Effects or {}
DDI.Teleports.GamemodeConfig = DDI.Teleports.GamemodeConfig or {}
DDI.Teleports.Tutorial = DDI.Teleports.Tutorial or {}


-- Load all components
local function load()
    local TL = DanLib.Func.CreateLoader()
    TL:SetName('Teleport Location')
    TL:SetStartsLoading()
    TL:SetLoadDirectory('tp_location')

    -- Load core components
    TL:IncludeDir('shared')
    TL:IncludeDir('core/client')
    TL:IncludeDir('patches')
    TL:IncludeDir('core/server')
    
    -- Load UI components last
    TL:IncludeDir('vgui')
    
    TL:Register()
    
    -- Initialize API after loading
    if SERVER then
        hook.Run("DDI.TL.API.Initialize")
    end
    
    -- Log successful loading
    DanLib.Func:PrintType('TL', 'Enhanced Teleport System v3.0.0 loaded successfully!')
end

-- Initial load
load()

-- Reload command for developers
local function Reload()
    if CLIENT then
        DanLib.Func:ScreenNotification("RELOADING", "Reloading Teleport System...", "INFO")
    else
        DanLib.Func:PrintType('TL', 'Reloading Teleport System...')
    end
    load()
    
    if SERVER then
        hook.Run("DDI.TL.Reloaded")
    end
end
concommand.Add('tp_location_reload', Reload)

-- Add version info command
local function VersionInfo(ply)
    local info = {
        version = "3.0.0",
        release_date = "27/07/2023",
        effects = table.Count(DDI.Teleports.Effects),
        locations = table.Count(DDI.Teleports.Brushe or {}),
        gamemodes = table.Count(DDI.Teleports.GamemodeConfig)
    }
    
    if SERVER then
        if IsValid(ply) then
            DanLib.Func:CreatePopupNotifi(ply, "Teleport System", 
                string.format("Version: %s\nReleased: %s\nEffects: %d\nLocations: %d\nGamemodes: %d", 
                info.version, info.release_date, info.effects, info.locations, info.gamemodes),
                "INFO", 10)
        else
            print("Teleport System Version Info:")
            PrintTable(info)
        end
    else
        DanLib.Func:ScreenNotification("VERSION INFO", 
            string.format("Version: %s\nReleased: %s\nEffects: %d\nLocations: %d\nGamemodes: %d", 
            info.version, info.release_date, info.effects, info.locations, info.gamemodes),
            "INFO", 10)
    end
end
concommand.Add('tl_version', VersionInfo)
