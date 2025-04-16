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
local Network = DanLib.Network


--- Handle transport requests from players
-- @param _ (any): Unused parameter
-- @param pPlayer (Player): The player who requested the transport
-- @return void
local function RequestTranspot(_, pPlayer)
	local TargetPlanet = Network:ReadString()
	local CurPlanet = Network:ReadString()

    if (TargetPlanet == CurPlanet) then
        base:CreatePopupNotifi(pPlayer, base:L('#not.relocation'), base:L('#same.planet'), 'ERROR', 5)
        return 
    end

    -- if (not pPlayer:IsAdmin() and not pPlayer:HasPermission('use_transport')) then
    --     base:CreatePopupNotifi(pPlayer, base:L('#not.authorized'), 'You are not authorized to use this transport!', 'ERROR')
    --     return
    -- end

    if (pPlayer.CurPlanet != CurPlanet) then
        pPlayer:Kick('[EXPLOITER] Transport System Alert')
        return 
    end

    if pPlayer.LastTransportRequest and (CurTime() - pPlayer.LastTransportRequest < 5) then
        base:CreatePopupNotifi(pPlayer, base:L('#not.relocation'), 'You must wait before using transport again!', 'ERROR', 5)
        return
    end
    pPlayer.LastTransportRequest = CurTime()

    local ExitPoints = DDI.Teleports.Brushe or {}
    local exitPoint = ExitPoints[TargetPlanet]

    if exitPoint then
        local pos_center = (exitPoint.boundA + exitPoint.boundB) / 2
        local ship = pPlayer:lfsGetPlane()

        if (not ship or ship:GetDriver() != pPlayer) then
            base:CreatePopupNotifi(pPlayer, base:L('#not.relocation'), 'You need to be in a vehicle to use transport!', 'ERROR', 5)
            return
        end

        local blocked = false
        local playersInSphere = 0
        local entitiesInSphere = ents.FindInSphere(pos_center, 128)

        for _, entity in ipairs(entitiesInSphere) do
            if entity.LFS then
                blocked = true
                break
            end

            if entity:IsPlayer() then
                playersInSphere = playersInSphere + 1
            end
        end

        if blocked then
            base:CreatePopupNotifi(pPlayer, base:L('#not.relocation'), 'Exit point blocked, try again!', 'ERROR', 5)
            return
        end

        if (playersInSphere > 0) then
            base:CreatePopupNotifi(pPlayer, base:L('#not.relocation'), 'There are too many players at the final exit point, please wait.', 'WARNING', 5)
            return
        end

        -- Moving a physical object
        local phys = ship:GetPhysicsObject()
        if IsValid(phys) then
            phys:SetPos(pos_center + Vector(math.random(-50, 50), math.random(-50, 50), 0), true)
        else
            base:CreatePopupNotifi(pPlayer, base:L('#not.relocation'), 'Unable to move the vehicle, please try again.', 'ERROR', 5)
            return
        end

        -- Action Logging
        print(string.format('Player %s transported from %s to %s', pPlayer:Nick(), CurPlanet, TargetPlanet))
    else
    	base:CreatePopupNotifi(pPlayer, base:L('#not.relocation'), base:L('#not.found'), 'ADMIN')
    end
end
Network:Receive('DDI.NetRequestTransport', RequestTranspot)