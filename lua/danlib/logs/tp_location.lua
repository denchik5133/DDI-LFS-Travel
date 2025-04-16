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



do
	-- CREATED
	local MODULE = DanLib.Func.CreateLogs('CreateLocation')
	MODULE:SetDescription('Location creation.')
	MODULE:SetColor(Color(0, 165, 0))
	MODULE:SetSort(99)
	MODULE:SetSetup(function()
		if (SERVER) then
			hook.Add('DDI.TL.CreateLocation', 'Logs.TL.CreateLocation', function(pPlayer, tbl)
				local color = Color(0, 165, 0)
				local fields = {
					{name = 'ID', value = tbl.id, inline = true},
					{name = 'Name', value = tbl.name, inline = true},
					{name = 'Model', value = tbl.model, inline = false},
					{name = 'Vector A', value = tbl.boundA, inline = true},
					{name = 'Vector B', value = tbl.boundB, inline = true}
				}

				DanLib.Func:GetDiscordLogs('CreateLocation', DanLib.Func.L('#log.create.location', pPlayer:Nick(), pPlayer:SteamID(), pPlayer:SteamID64()), fields, color)
			end)
		end
	end)
	MODULE:Register()

	-- DELETED
	local MODULE = DanLib.Func.CreateLogs('DeleteLocation')
	MODULE:SetDescription('Delete location.')
	MODULE:SetColor(Color(255, 69, 0))
	MODULE:SetSort(99)
	MODULE:SetSetup(function()
		if (SERVER) then
			hook.Add('DDI.TL.DeleteLocation', 'Logs.DeleteLocation', function(pPlayer, id)
				local color = Color(255, 69, 0)

			    DanLib.Func:GetDiscordLogs('DeleteLocation', DanLib.Func.L('#log.delete.location', pPlayer:Nick(), pPlayer:SteamID(), pPlayer:SteamID64(), id), nil, color)
			end)
		end
	end)
	MODULE:Register()

	-- EDITED
	local MODULE = DanLib.Func.CreateLogs('EditLocation')
	MODULE:SetDescription('Edit location.')
	MODULE:SetColor(Color(0, 151, 230))
	MODULE:SetSort(99)
	MODULE:SetSetup(function()
		if (SERVER) then
			hook.Add('DDI.TL.EditLocation', 'Logs.TLHookConfigUpdated', function(pPlayer, tbl)
		    	local function TableTo()
				    return util.TableToJSON(tbl, true)
				end

				local color = Color(0, 151, 230)

				DanLib.Func:GetDiscordLogs('EditLocation', DanLib.Func.L('#log.edit.location', pPlayer:Nick(), pPlayer:SteamID(), pPlayer:SteamID64()) .. ' ```lua\n' .. TableTo() .. '```', nil, color)
			end)
		end
	end)
	MODULE:Register()
end