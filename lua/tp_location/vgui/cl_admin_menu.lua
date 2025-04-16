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
local NetworkUtil = DanLib.NetworkUtil
local CustomUtils = DanLib.CustomUtils.Create

DDI.Teleports = DDI.Teleports or {}

function DDI.Teleports:AddMenu(tbl)
    if (not base.HasPermission(LocalPlayer(), 'TLEditConfig')) then
        return 
    end

    if (not isvector(tbl[1]) or not isvector(tbl[2])) then
        chat.AddText(base:L('#not.vector'), Color(255, 142, 50), base:L('#not.vector2'))
        return 
    end

    local Container = CustomUtils(nil, 'DanLib.UI.PopupBasis')
    Container:BackgroundCloseButtonShow(true)
    Container:CloseButtonShow(false)
    Container:SetHeader('Location creation')
    Container:SetPopupWide(400)
    Container:SetExtraHeight(300)

    local helpText = CustomUtils(Container)
    helpText:PinMargin(TOP, nil, 4, nil, 5)
    helpText:ApplyText(base:L('#are.required'), 'danlib_font_18', nil, nil, base:Theme('text'))

    local margin = { 10, 5, 10 }
    local function Row(text, backText)
        local header = CustomUtils(Container)
        header:PinMargin(TOP, unpack(margin))
        header:ApplyText(text, 'danlib_font_16', 0, nil, base:Theme('text', 150), TEXT_ALIGN_LEFT)

        local String = base.CreateTextEntry(Container)
        String:PinMargin(TOP, unpack(margin))
        String:SetTall(30)
        String:SetBackText(backText)

        return String
    end

    -- ID
    local id = Row(base:L('#id.planet'), 'ID')
    -- Name
    local name = Row(base:L('#name.planet'), 'Name')
    -- Model
    local model = Row(base:L('#model.planet'), 'Model')

    -- Add model checking before sending data to the server
    local function isValidModel(model)
        if (not model or model == '') then return false end -- Check for empty string
        if (not string.StartWith(model, 'models/')) then return false end -- Checking path format
        if (not string.EndsWith(model, '.mdl')) then return false end
        
        -- Check if the file exists
        local exists = file.Exists(model, 'GAME')
        return exists
    end

    -- Bottom buttons
    local bottom = CustomUtils(Container)
    bottom:PinMargin(BOTTOM, 10, nil, 10, 10)
    bottom:SetTall(30)

    local buttons = {
        {
            name = base:L('cancel'),
            color = Color(236, 57, 62),
            click = function()
                Container:AlphaTo(0, 0.3, 0, function()
                    Container:Remove()
                end)
            end
        },
        {	-- submit
            name = base:L('confirm'),
            color = Color(106, 178, 242),
            click = function()
            	if (id:GetValue() == '' or not id:GetValue()) then
	                base:ScreenNotification(base:L('#no.id'), base:L('#enter.id'), 'WARNING')
	                return 
	            end

	            if (name:GetValue() == '' or not name:GetValue()) then
	                base:ScreenNotification(base:L('#no.name'), base:L('#enter.name'), 'WARNING')
	                return 
	            end

                local modelValue = model:GetValue()
                if (modelValue == '' or not modelValue) then
                    base:ScreenNotification(base:L('#no.model'), base:L('#enter.model'), 'WARNING')
                    return 
                end

                if (not isValidModel(modelValue)) then
                    base:ScreenNotification(base:L('#invalid.model'), base:L('#enter.valid.model'), 'WARNING')
                    return 
                end

	            local ID = id:GetValue()
	            local nameValue = name:GetValue()

                Network:Start('DDI.NetCreateLocation')
                Network:WriteTable({ name = nameValue, model = modelValue, id = ID, boundA = tbl[1], boundB = tbl[2] })
                Network:SendToServer()

                DDI.Teleports.Location = {}

                Container:AlphaTo(0, 0.3, 0, function()
                    Container:Remove()
                end)
            end
        }
    }

    local buttonW = base:Scale(170)
    for k, v in pairs(buttons) do
        base.CreateUIButton(bottom, { background = { nil }, dock_indent = { RIGHT, 6 }, wide = buttonW, hover = { ColorAlpha(v.color, 50), nil, 6 }, text = { v.name }, click = v.click })
    end
end