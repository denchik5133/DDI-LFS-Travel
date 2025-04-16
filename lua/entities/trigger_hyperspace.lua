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



ENT.Base = 'base_brush'
ENT.Type = 'brush'

AccessorFunc(ENT, 'm_Planet', 'Planet')

DanLib = DanLib or {}
local Network = DanLib.Network

if (SERVER) then
    --- Initializes the entity.
    function ENT:Initialize()
        
    end

    --- Called when another entity starts touching this entity.
    -- @param entity Entity: The entity that has touched this entity.
    function ENT:StartTouch(entity)
        -- Check if the entity is valid
        if (not IsValid(entity)) then return end

        -- Check if the entity is a player or a vehicle
        if entity:IsPlayer() then
            -- Admin check and debug mode
            if (not entity:IsAdmin() and not DanLib.CONFIG.TP_LOCATION.Debugg) then
                return
            end
            
            -- Sending a debug message
            DanLib.Func:SendDebugMessage(entity, 'The ID of the location (', DanLib.Config.Theme['DarkOrange'], self:GetPlanet(), color_white, ')')
        elseif entity.LFS then
            -- If it's a vehicle, we get the driver
            local driver = entity:GetDriver()
            if (IsValid(driver) and driver:IsPlayer()) then
                -- Calling up the menu for the player
                Network:Start('DDI.NetOpenLocationsList')
                Network:WriteTable(DDI.Teleports.Brushe or {})
                Network:WriteString(self:GetPlanet())
                Network:SendToPlayer(driver)
                driver.CurPlanet = self:GetPlanet()
            end
        end
    end

    --- Called when an entity stops touching this entity.
    -- @param entity Entity: The entity that has stopped touching this entity.
    function ENT:EndTouch(entity)
        if (entity.LFS) then
            Network:Start('DDI.NetCloseLocationsList')
            Network:SendToPlayer(entity:GetDriver())
            entity:GetDriver().CurPlanet = nil
        end
    end

    --- Called when this entity is touched.
    -- @param entity Entity: The entity that is touching this entity.
    function ENT:Touch(entity)
        
    end

    --- Sets a key value for the entity.
    -- @param key string: The key to set.
    -- @param value string: The value to set for the key.
    function ENT:KeyValue(key, value)
        if (key == 'Planet') then
            self:SetPlanet(value)
        end
    end
end
