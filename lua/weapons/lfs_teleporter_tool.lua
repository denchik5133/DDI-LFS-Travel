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



AddCSLuaFile()

SWEP.Author = 'denchik'
SWEP.Instructions = 'Left Click - Set first point then second point.\nAfter setting two points, click again to open the save window.\nALT - Increase range'
SWEP.Contact = 'https://discord.gg/CND6B5sH3j'
SWEP.Purpose = 'Create teleport locations for LFS Travel System'
SWEP.Category = '[DDI] Tool'

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = 'models/weapons/v_pistol.mdl'
SWEP.WorldModel = 'models/weapons/w_pistol.mdl'

SWEP.Primary.Automatic = false

local base = DanLib.Func
local utils = DanLib.Utils

-- Initialize teleport location tables if they don't exist
DDI = DDI or {}
DDI.Teleports = DDI.Teleports or {}
DDI.Teleports.Location = DDI.Teleports.Location or {}

-- Assign a random color for boundary visualization
local function GetRandomColor()
    return Color(math.random(100, 255), math.random(100, 255), math.random(100, 255))
end

-- Called when primary attack button (+attack) is pressed
function SWEP:PrimaryAttack()
    if (not IsFirstTimePredicted()) then 
        return
    end

    self:SetNextPrimaryFire(CurTime() + 1)

    DDI.Teleports.Location = DDI.Teleports.Location or {}

    if (not base.HasPermission(self.Owner, 'TLAccessTool')) then
        base:CreatePopupNotifi(self.Owner, base:L('AccessDenied'), base:L('AccessVer'), 'ERROR', 6)
        return 
    end

    if SERVER then
        return
    end
    
    if (#DDI.Teleports.Location ~= 2) then
        local Pos = self.Owner:GetShootPos()
        local Aim = self.Owner:GetAimVector()

        local dist = 200
        if input.IsKeyDown(KEY_LALT) then dist = 100000000 end

        local trace = util.TraceLine({ start = Pos, endpos = Pos + Aim * dist, filter = self.Owner })

        if not trace.HitPos or (IsValid(trace.Entity) and trace.Entity:IsPlayer()) then  
            return false 
        end

        local vecHitPos = trace.HitPos
        DDI.Teleports.Location[#DDI.Teleports.Location + 1] = vecHitPos
        
        -- Play sound and show notification for point placement
        surface.PlaySound('buttons/button14.wav')
        local pointNum = #DDI.Teleports.Location
        base:SidePopupNotification('Point ' .. pointNum .. ' set at ' .. tostring(vecHitPos), 'CONFIRM', 3)
        
        -- If we have two points, calculate volume to ensure it's valid
        if (#DDI.Teleports.Location == 2) then
            local pos1, pos2 = DDI.Teleports.Location[1], DDI.Teleports.Location[2]
            local volume = math.abs((pos2.x - pos1.x) * (pos2.y - pos1.y) * (pos2.z - pos1.z))
            
            if (volume < 1) then
                base:SidePopupNotification('The location volume cannot be zero', 'ERROR', 5)
                DDI.Teleports.Location = {}
                return
            end
            
            if (volume > DanLib.CONFIG.TP_LOCATION.MaxVolumeSize) then
                base:SidePopupNotification('Location volume is too large', 'ERROR', 5)
                DDI.Teleports.Location = {}
                return
            end
            
            -- Assign a random color for visualization
            DDI.Teleports.Location.Color = GetRandomColor()
        end
    else
        -- If we have both points, open the admin menu
        DDI.Teleports:AddMenu(DDI.Teleports.Location)
    end
end

-- Called when secondary attack button (+attack2) is pressed
function SWEP:SecondaryAttack()
    if (not IsFirstTimePredicted()) then 
        return
    end

    if (not base.HasPermission(self.Owner, 'TLAccessTool')) then
        base:CreatePopupNotifi(self.Owner, base:L('AccessDenied'), base:L('AccessVer'), 'ERROR', 6)
        return 
    end

    self:SetNextPrimaryFire(CurTime() + 1)

    DDI.Teleports.Location = DDI.Teleports.Location or {}
    if (not DDI.Teleports.Location[#DDI.Teleports.Location]) then return end
    
    DDI.Teleports.Location[#DDI.Teleports.Location] = nil
    
    if CLIENT then
        surface.PlaySound('buttons/button16.wav')
        base:SidePopupNotification('Last point cleared', 'CONFIRM', 2)
    end
end

if CLIENT then
    SWEP.PrintName = 'TL Tool'
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true

    -- Called when weapon tries to holster
    function SWEP:Holster()
        DDI.Teleports.Location = {}
        return true
    end

    -- Called when player has just switched to this weapon
    function SWEP:Deploy()
        DDI.Teleports.Location = {}
        return true
    end

    -- Called when player dropped the weapon
    function SWEP:OnDrop()
        DDI.Teleports.Location = {}
    end

    -- Local variables for rendering
    local vector = Vector(0, 0, 0)
    local angle = Angle(0, 0, 0)
    local mat = Material('models/wireframe')
    local white = Color(255, 255, 255)
    local green = Color(0, 255, 0)
    local red = Color(255, 0, 0)
    local blue = Color(0, 0, 255, 255)

    -- Draw HUD with visualization of selected points
    function SWEP:DrawHUD()
        local pPlayer = LocalPlayer()
        local Pos = pPlayer:GetShootPos()
        local Aim = pPlayer:GetAimVector()

        local dist = 200
        if input.IsKeyDown(KEY_LALT) then dist = 100000000 end

        local trace = util.TraceLine({ start = Pos, endpos = Pos + Aim * dist, filter = pPlayer })

        if (not trace.HitPos) or (IsValid(trace.Entity) and trace.Entity:IsPlayer()) then return false end

        local orig_pos1 = DDI.Teleports.Location[1]
        local orig_pos2 = DDI.Teleports.Location[2]

        local pos1, pos2
        pos1 = (orig_pos1 or trace.HitPos)
        if (not isvector(pos1)) then return end

        pos2 = (orig_pos2 or trace.HitPos)
        if (not isvector(pos2)) then return end
        if (not pos1 or not pos2) then return end

        -- Get visualization color
        local visualColor = DDI.Teleports.Location.Color or base:Theme('decor2')

        if DDI.Teleports.Location then
            cam.Start3D()
                -- Draw wireframe box and boundaries
                render.DrawWireframeBox(vector, angle, pos1, pos2, visualColor, false)
                render.DrawWireframeSphere(pos1, 8, 10, 10, red)
                render.DrawWireframeSphere(pos2, 8, 10, 10, blue)
                
                -- Draw translucent box
                render.SetColorMaterial()
                render.DrawBox(vector, angle, pos1, pos2, Color(visualColor.r, visualColor.g, visualColor.b, 50))
            cam.End3D()
        end
    end

    -- Function to draw the text box for instructions
    local function drawTextBox(text, title, y, alpha)
        local x = 34
        local w1, h1 = utils:GetTextSize(title, 'danlib_font_30')
        local w2, h2 = utils:GetTextSize(text, 'danlib_font_30')
        w2 = w2 + 34 + w1
        h2 = h2 + 16

        alpha = alpha or 255

        -- Set transparency
        surface.SetAlphaMultiplier(alpha / 255)

        utils:DrawRoundedBox(x, y, w2, h2, base:Theme('secondary_dark'))
        utils:DrawRoundedBox(x, y, 2, h2, base:Theme('decor'))
        utils:DrawSomeText(text, 'danlib_font_30', base:Theme('decor'), title, 'danlib_font_30', base:Theme('title'), x + 14, y + h2 / 2 - 16, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        -- Reset alpha multiplier
        surface.SetAlphaMultiplier(1)
    end

    -- Draw tool instructions on the view model
    function SWEP:PostDrawViewModel(viewModel, wWeapon)
        if wWeapon:GetClass() == 'lfs_teleporter_tool' and IsValid(self) then 
            local indx = viewModel:LookupBone('ValveBiped.Bip01_R_Hand')
            if (not indx) then return end
            
            local pPos, aAngle = viewModel:GetBonePosition(indx)
            pos = pPos + aAngle:Forward() * 4.9 + aAngle:Right() * 2 + aAngle:Up() * -9.5

            _angle = aAngle
            _angle:RotateAroundAxis(_angle:Right(), 190)
            _angle:RotateAroundAxis(_angle:Up(), 90)
            _angle:RotateAroundAxis(_angle:Forward(), 90)

            cam.Start3D2D(pos, _angle, 0.0122)
                drawTextBox('LeftClick', base:L('#first.point'), 140)
                drawTextBox('RightClick', base:L('#clear.selection'), 195)
                drawTextBox('ALT', base:L('#increase.range'), 250)
                
                -- Add point count if we've placed any points
                if (#DDI.Teleports.Location > 0) then
                    local pointsText = string.format('Points: %d/2', #DDI.Teleports.Location)
                    drawTextBox(pointsText, 'Status', 305)
                end
            cam.End3D2D()
        end
    end
end
