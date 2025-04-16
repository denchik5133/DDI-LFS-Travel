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


LOCALTIONS_MENU = nil

local SW, SH = ScrW(), ScrH()
local function LocationsMenu()
	if IsValid(LOCALTIONS_MENU) then LOCALTIONS_MENU:Remove() end

	local MainFrame = base.CreateUIFrame()
	LOCALTIONS_MENU = MainFrame
	MainFrame:SetPos(SW, SH / 2 - 250)
	MainFrame:SetSize(350, 360)
	MainFrame:SetTitle(base:L('#planets.list'))
	MainFrame:MoveTo(SW - 400, SH / 2 - 250, 0.4, 0, 0.2)

	local Hint = CustomUtils(MainFrame)
	Hint:Pin(TOP, 2)
    Hint:ApplyText(base:L('#F3.select'), nil, nil, nil, base:Theme('text'))

    local Scroll = CustomUtils(MainFrame, 'DanLib.UI.Scroll')
    Scroll:Pin(FILL, 2)
    
    local TargetPlanet = Network:ReadTable()
    local CurPlanet = Network:ReadString()

    for k, v in pairs(TargetPlanet) do
    	local PlanetPanel = CustomUtils(Scroll)
        PlanetPanel:Pin(TOP, 4)
        PlanetPanel:SetTall(74)
        PlanetPanel:ApplyBackground(base:Theme('secondary_dark'), 6)
        PlanetPanel:ApplyText(v.name or base:L('#no.name'), 'danlib_font_20', 80, 12, base:Theme('text'), TEXT_ALIGN_LEFT)

        local mol = 'models/starwars/syphadias/props/sw_tor/bioware_ea/planets/nar_shadda/nar_shadda.mdl'
        local PlanetIcon = base:CreateModelPanel(PlanetPanel)
        PlanetIcon:Pin(LEFT, 4)
        PlanetIcon.ModelPanel:CoagulationModel(v.model or mol)

        base.CreateUIButton(PlanetPanel, {
            dock = { BOTTOM, 6 },
            text = { CurPlanet == v.id and base:L('#you.here') or base:L('#on.way') },
            tall = 34,
            click = function()
                Network:Start('DDI.NetRequestTransport')
                Network:WriteString(v.id)
                Network:WriteString(CurPlanet)
                Network:SendToServer()
            end
        })
    end
end
Network:Receive('DDI.NetOpenLocationsList', LocationsMenu)

local function closeMenu()
    if (not IsValid(LOCALTIONS_MENU)) then
        LOCALTIONS_MENU:Remove()
        return
    end

    LOCALTIONS_MENU:SetPos(SW - 400, SH / 2 - 250)
    LOCALTIONS_MENU:MoveTo(SW - 0, SH / 2 - 250, 0.8, 0, 0.2)

    LOCALTIONS_MENU:SetAlpha(255)
    LOCALTIONS_MENU:AlphaTo(0, 0.9, 0, function()
        if IsValid(LOCALTIONS_MENU) then
        	LOCALTIONS_MENU:Remove()
        end
    end)
end
Network:Receive('DDI.NetCloseLocationsList', closeMenu)