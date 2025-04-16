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
local utils = DanLib.Utils
local Network = DanLib.Network
local CustomUtils = DanLib.CustomUtils.Create

local defaultFont20 = 'danlib_font_20'
local defaultFont18 = 'danlib_font_18'

local width = base:GetSize(700)
local height = base:GetSize(550)

--// Refresh cache size/positions
local function ScreenSizeChanged()
    width = base:GetSize(700)
    height = base:GetSize(500)
end
dHook:Add('DDI.PostScreenSizeChanged', 'DDI.ScreenSizeChanged', ScreenSizeChanged)

local vector = Vector(0, 0, 0)
local angle = Angle(0, 0, 0)

local mat = Material('models/wireframe')
local white = color_white
local green = Color(0, 255, 0)
local red = Color(255, 0, 0)
local vol = 10

local input = input
local gui = gui
local math = math
local util = util

local SW = ScrW
local SH = ScrH

local IsKeyDown = input.IsKeyDown
local Clamp = math.Clamp

local Angle_ = Angle
local Vector_ = Vector

local text_w = 0
local function centerText(str, y)
    local _, tall = draw.SimpleText(str, defaultFont20, text_w / 2, y, base:Theme('text'), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    return y - tall
end

if IsValid(ADMIN_MENU_ZONE) then ADMIN_MENU_ZONE:Remove() end
local function AdminMenuZone()
    if IsValid(ADMIN_MENU_ZONE) then ADMIN_MENU_ZONE:Remove() end

    local locationShow = false
    local pPlayer = LocalPlayer()

    pPlayer:GetViewModel():SetNoDraw(true) -- Hiding the player's model
    for _, v in ipairs(ents.FindByClass('physgun_beam')) do
        if (v:GetParent() == LocalPlayer()) then
            v:SetNoDraw(true)
        end
    end

    local Mainframe = CustomUtils()
    ADMIN_MENU_ZONE = Mainframe
    Mainframe:SetPos(0, 0)
    Mainframe:SetSize(SW(), SH())
    Mainframe:ApplyFadeInPanel(0.2)

    local Position = pPlayer:GetPos() + Vector_(0, 0, 65)
    local Angles = pPlayer:EyeAngles()
    Mainframe:SetMouseInputEnabled(true)

    local speedMultiplier = 30
    local speedCam = 0.2

    Mainframe:ApplyEvent(nil, function(self, width, height)
        render.RenderView({ origin = Position, angles = Angles, x = 0, y = 0, w = width, h = height })
    end)

    Mainframe:ApplyEvent('Think', function(self)
        local ang = Angles
        local move = Vector_(0, 0, 0)

        self:SetCursor('sizeall')
        self.Cam:SetCursor('sizeall')

        -- Increase speed by pressing Shift
        if IsKeyDown(KEY_LSHIFT) then
            speedMultiplier = 150 -- Increase speed
            speedCam = 0.4 -- Increase speed
        else
            speedMultiplier = 30 -- Reduce speed
            speedCam = 0.2 -- Reduce speed
        end

        if IsKeyDown(KEY_F1) then
            if (self.NextControlsSwitch or 0) < CurTime() then
                self.NextControlsSwitch = CurTime() + 0.2
                self.ShowControls = not self.ShowControls
            end
        end

        if IsKeyDown(KEY_W) then move = move + ang:Forward() end
        if IsKeyDown(KEY_S) then move = move - ang:Forward() end
        if IsKeyDown(KEY_A) then move = move - ang:Right() end
        if IsKeyDown(KEY_D) then move = move + ang:Right() end
        if IsKeyDown(KEY_SPACE) then move = move + Vector_(0, 0, 1) end
        if IsKeyDown(KEY_LCONTROL) then move = move - Vector_(0, 0, 1) end

        Position = Position + move * 5 * speedMultiplier * FrameTime() -- Travel speed`

        if input.IsMouseDown(MOUSE_RIGHT) then
            local mx, my = input.GetCursorPos()
            local w, h = self:GetSize() -- Get width and height
            local posX, posY = self:GetPos() -- Get the position as two separate values
            local centerX = posX + w / 2 -- Calculate center by X
            local centerY = posY + h / 2 -- Calculate Y center
            local dx, dy = mx - centerX, my - centerY

            self:SetCursor('blank')
            self.Cam:SetCursor('blank')

            -- Create a new angle based on the current angle
            local newPitch = Angles.p + dy * 0.1 -- We're only changing pitch
            local newYaw = Angles.y - dx * 0.1 -- Change only yaw
            -- Limit the vertical angle
            newPitch = Clamp(newPitch, -90, 90)
            -- Create a new angle
            local targetAngles = Angle(newPitch, newYaw, 0) -- Set roll to 0 to avoid flipping
            -- Smooth interpolation of angles
            Angles = LerpAngle(speedCam, Angles, targetAngles)
            -- Reset cursor to center
            gui.SetMousePos(centerX, centerY)
        end
    end)

    Mainframe.Cam = CustomUtils(Mainframe)
    Mainframe.Cam:SetPos(0, 0)
    Mainframe.Cam:SetSize(SW(), SH())
    Mainframe.Cam:ApplyBlur()
    Mainframe.Cam:ApplyBackground(Color(14, 22, 33, 150))
    Mainframe.Cam:ApplyEvent(nil, function(self, width, height)
        text_w = width
        if self:GetParent().ShowControls then
            local pos = height - 10
            pos = centerText('Hold [RMB] + Rotate Mouse — Camera Rotate', pos)
            pos = centerText('Press [WASD] — Move Camera', pos)
            pos = centerText('Hold [L.Shift] — SpeedUp Camera Move&Rotate', pos)
            pos = centerText('Press [Space] — Move up', pos)
            pos = centerText('Press [L.Ctrl] — Move down', pos)
            pos = centerText('Press [Z] — Restore position', pos)
            pos = centerText('Press [F1] — Hide Controls', pos)
        else
            centerText('[F1] — Show Controls', height - 10)
        end
    end)

    local Container = base.CreateUIFrame(Mainframe)
    ADMIN_MENU_ZONE = Container
    Container:SetTitle('Location List')
    Container:SetPos(0, 0)
    Container:SetSize(width, height)
    Container:ApplyAppear(5)
    Container:MakePopup()
    Container:Transparency()

    Container.OnRemove = function(sl)
        pPlayer:GetViewModel():SetNoDraw(false) -- Turning the model display back on
        for _, v in ipairs(ents.FindByClass('physgun_beam')) do
            if v:GetParent() == LocalPlayer() then
                v:SetNoDraw(false)
            end
        end

        Mainframe:SetAlpha(255)
        Mainframe:AlphaTo(0, 0.2, 0, function()
            Mainframe:Remove()
        end)

        sl:ApplyFadeOutPanel(0.2)
    end

    local BackPanel = CustomUtils(Container)
    BackPanel:PinMargin(TOP, 6, 10, 6, 4)
    BackPanel:SetTall(30)
    BackPanel:ApplyEvent(nil, function(sl, w, h)
    	utils:DrawRect(0, 0, w, h, base:Theme('secondary_dark'))

    	draw.SimpleText('#ID', defaultFont18, 10, h / 2, base:Theme('text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    	draw.SimpleText(base:L('#d.model'), defaultFont18, w / 2, h / 2, base:Theme('text'), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    	draw.SimpleText(base:L('#d.name'), defaultFont18, w  - 10, h / 2, base:Theme('text'), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end)


    local scrollPanel = CustomUtils(Container, 'DanLib.UI.Scroll')
    scrollPanel:Pin(nil, 5)

    function Container:Refresh(tbl)
        scrollPanel:Clear()

        -- Function to move the camera to the center between two points
        local function MoveCameraTo(boundA, boundB)
            if IsValid(pPlayer) then
                -- Calculate the center position between boundA and boundB
                local targetPosition = (boundA + boundB) / 2 + Vector_(0, 0, 0)
                Position = targetPosition -- Update camera position
                Angles = pPlayer:EyeAngles() -- Maintain the player's angle of view
            end
        end

        for id, v in pairs(tbl or {}) do
            local DButton = base:CreateButton(scrollPanel)
            DButton:PinMargin(TOP, 6, nil, 4, 4)
            DButton:SetTall(40)
            DButton:ApplyFadeInPanel(0.2)
            DButton:ApplyEvent(nil, function(sl, w, h)
                utils:DrawRect(0, 0, w, h, base:Theme('secondary_dark'))

                draw.SimpleText('#' .. v.id, 'danlib_font_18', 10, h / 2, base:Theme('text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		    	draw.SimpleText(v.model, 'danlib_font_18', w / 2, h / 2, base:Theme('text'), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		    	draw.SimpleText(v.name, 'danlib_font_18', w  - 10, h / 2, base:Theme('text'), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end)
            DButton:ApplyEvent('DoClick', function(sl, w, h)
            	local menu = base:UIContextMenu()

                menu:Option(base:L('#d.name'), nil, DanLib.Config.Materials['Edit'], function()
                    base:RequestTextPopup('EDIT NAME', 'Enter the name that corresponds to this planet.', v.name or '', nil, function(value)
                        Network:Start('DDI.NetEditLocation')
                            Network:WriteTable({ name = value, model = v.model, id = id, boundA = v.boundA, boundB = v.boundB })
                        Network:SendToServer()
                    end)
                end)

                menu:Option('Move Camera Here', nil, '1poK1q6', function()
                    MoveCameraTo(v.boundA, v.boundB) -- Move the camera to the center position between boundA and boundB
                end)

                menu:Option(base:L('#d.model'), nil, DanLib.Config.Materials['Edit'], function()
                    base:RequestTextPopup('EDIT MODEL', 'Enter the path to the model that corresponds to this planet.', v.model or '', nil, function(value)
                        Network:Start('DDI.NetEditLocation')
                            Network:WriteTable({ name = v.name, model = value, id = id, boundA = v.boundA, boundB = v.boundB })
                        Network:SendToServer()
                    end)
                end)

            	menu:Option('Delete', DanLib.Config.Theme['Red'], DanLib.Config.Materials['Delete'], function()
                    base:QueriesPopup(base:L('#d.removal'), base:L('#d.delete.location', { id = id }), nil, function()
                		Network:Start('DDI.NetRemoveLocation')
    	                    Network:WriteTable({ id = id })
    	                Network:SendToServer()

	                   DButton:ApplyFadeOutPanel(0.2)
	                   DButton:Remove()

                        base:CreatePopupNotifi(Mainframe, base:L('#d.removal'), base:L('#d.confirm.delete', { id = id }), 'ADMIN')
                    end)
            	end)

            	menu:Open()
            end)


            Mainframe.Cam:ApplyEvent('PaintOver', function(sl, w, h)
                if (not IsValid(Container)) then return end

                local Pos = pPlayer:GetShootPos()
                local Aim = pPlayer:GetAimVector()
                local trace = util.TraceLine({ start = Pos, filter = pPlayer })

                if (not trace.HitPos or IsValid(trace.Entity) && trace.Entity:IsPlayer()) then return false end

                local orig_pos1 = v.boundA
                local orig_pos2 = v.boundB

                local pos1, pos2
                pos1 = (orig_pos1 or trace.HitPos)
                if (not isvector(pos1)) then return end

                pos2 = (orig_pos2 or trace.HitPos)
                if (not isvector(pos2)) then return end
                if (not pos1 or not pos2) then return end

                local pos_center = (orig_pos1 + orig_pos2) / 2
            
                cam.Start3D()
                    render.DrawWireframeBox(vector, angle, pos1, pos2, base:Theme('decor2'), false)
                    render.DrawWireframeSphere(pos1, 8, 10, 10, Color(255, 0, 0, 255)) -- Red sphere for boundA
                    render.DrawWireframeSphere(pos2, 8, 10, 10, Color(0, 0, 255, 255)) -- Blue sphere for boundB
                    render.DrawWireframeSphere(pos_center, 8, 10, 10, Color(0, 255, 0, 255)) -- Green sphere for the center
                    render.SetColorMaterial()
                    render.DrawBox(vector, angle, pos1, pos2, base:Theme('decor2', 50))
                cam.End3D()
            end)
        end
    end

    local tbl = Network:ReadTable()
    Container:Refresh(tbl)
end
Network:Receive('DDI.NetAdminMenuLocation', AdminMenuZone)


-- Processing of the updated list of locations
Network:Receive('DDI.NetRefreshLocations', function()
    local updatedLocations = Network:ReadTable()
    if IsValid(ADMIN_MENU_ZONE) then
        ADMIN_MENU_ZONE:Refresh(updatedLocations)
    end
end)
