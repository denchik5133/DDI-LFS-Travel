/***
 *   @addon         LFS Travel System
 *   @version       3.0.0
 *   @release_date  (Current Date)
 *   @authors       denchik, Kotyarishka, (Your Name)
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

do
    -- Create the module configuration interface
    local TL = DanLib.Func.CreateModule('TP_LOCATION')
    TL:SetTitle('LFS Travel System')
    TL:SetIcon('Gv2bPhD')
    TL:SetAuthor('76561198405398290')
    TL:SetVersion('3.0.0')
    TL:SetDescription('Advanced teleportation system with multi-location support, effects, and integration capabilities')
    TL:SetColor(Color(0, 80, 200))
    TL:SetSortOrder(3)

    -- Basic settings
    TL:AddOption('ChatCommand', 'Chat command', 'Chat command to open admin menu (no need for prefix)', DanLib.Type.String, 'tl_admin')
    TL:AddOption('Debugg', 'Debug mode', 'Enable debug mode (admin/superadmin only)', DanLib.Type.Bool, false)
    
    -- Teleport settings
    TL:AddOption('DefaultCooldown', 'Default cooldown', 'Default cooldown for new teleport locations (in seconds)', DanLib.Type.Int, 0)
    TL:AddOption('MaxCooldown', 'Maximum cooldown', 'Maximum cooldown allowed for teleport locations (in seconds)', DanLib.Type.Int, 3600)
    TL:AddOption('DefaultEffect', 'Default effect', 'Default effect for new teleports', DanLib.Type.String, 'hyperspace', 
        {'none', 'fade', 'hyperspace', 'portal', 'hologram'})
    
    -- Economy settings
    TL:AddOption('EnableCost', 'Enable cost', 'Allow teleport locations to have monetary costs (DarkRP)', DanLib.Type.Bool, true)
    TL:AddOption('DefaultCost', 'Default cost', 'Default cost for new teleport locations', DanLib.Type.Int, 0)
    TL:AddOption('MaxCost', 'Maximum cost', 'Maximum cost allowed for teleport locations', DanLib.Type.Int, 10000)
    
    -- Admin settings
    TL:AddOption('AdminOnly', 'Admin only', 'Restrict teleport creation to admins only', DanLib.Type.Bool, true)
    TL:AddOption('LogTeleports', 'Log teleports', 'Log teleport usage in console and data files', DanLib.Type.Bool, true)
    TL:AddOption('AllowRestricted', 'Allow restricted locations', 'Allow creation of restricted locations that only specific jobs/ranks can use', DanLib.Type.Bool, true)
    
    -- Integration settings
    TL:AddOption('EnableDarkRP', 'Enable DarkRP', 'Enable DarkRP integration for costs and job restrictions', DanLib.Type.Bool, true)
    TL:AddOption('EnableWiremod', 'Enable Wiremod', 'Enable Wiremod integration', DanLib.Type.Bool, true)
    TL:AddOption('EnableTTT', 'Enable TTT', 'Enable Trouble in Terrorist Town integration', DanLib.Type.Bool, true)
    TL:AddOption('EnableStarwarsRP', 'Enable StarwarsRP', 'Enable StarwarsRP gamemode integration', DanLib.Type.Bool, true)
    
    -- Effects settings
    TL:AddOption('AllowEffectSelection', 'Allow effect selection', 'Allow players to select teleport effects', DanLib.Type.Bool, true)
    TL:AddOption('DisableEffectsInPvP', 'Disable effects in PvP', 'Automatically disable visual effects in PvP gamemodes', DanLib.Type.Bool, true)
    TL:AddOption('SavePlayerPreferences', 'Save preferences', 'Save player effect preferences between sessions', DanLib.Type.Bool, true)
    
    -- Sound settings
    TL:AddOption('EnableSounds', 'Enable sounds', 'Enable teleport sounds', DanLib.Type.Bool, true)
    TL:AddOption('SoundVolume', 'Sound volume', 'Volume for teleport sounds (0-1)', DanLib.Type.Int, 0.8)
    
    -- Vehicle settings
    TL:AddOption('RequireVehicle', 'Require vehicle', 'Require players to be in a vehicle to use teleports', DanLib.Type.Bool, true)
    TL:AddOption('AllowedVehicleClasses', 'Allowed vehicle classes', 'List of allowed vehicle classes (comma separated, empty = all)', DanLib.Type.String, '')
    TL:AddOption('TeleportPassengers', 'Teleport passengers', 'Teleport passengers along with the vehicle', DanLib.Type.Bool, true)
    
    -- Advanced settings
    TL:AddOption('AutocleanInterval', 'Autoclean interval', 'Interval in seconds to clean up invalid teleport states (0 = disable)', DanLib.Type.Int, 300)
    TL:AddOption('MaxDistance', 'Maximum distance', 'Maximum distance for teleport location boundaries (0 = unlimited)', DanLib.Type.Int, 0)
    TL:AddOption('MaxVolumeSize', 'Maximum volume size', 'Maximum volume size for teleport locations (0 = unlimited)', DanLib.Type.Int, 1000000)
    
    -- Register module
    TL:Register()
end
