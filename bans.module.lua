--[[
  LeMonde Open-Source Bans
  @author Sxribe
]]

-- NOTICE: COPY AND PASTING THIS SCRIPT WILL **NOT** WORK! GO TO THE FILE "README.md" AND USE THE MODEL LINK PRESENT!

local PlayerService = game:GetService("Players");
local HttpService = game:GetService("HttpService");

function out(text) warn ("[LMD BAN SYS] " .. text) end;
function err(text) error("[LMD BAN SYS] " .. text) end;

function isHttpEnabled()
	local _, err = pcall(HttpService.GetAsync, game.HttpService, "a");
	return (err:lower():find("trust check failed") ~= nil);
end

local BAN_URL = "[restricted]"
local FAILED_STARTUP = false;
local banlist = {}

if BAN_URL == "[restricted"] then
  FAILED_STARTUP = true;
  err("Whoops! You copy-pasted the script from GitHub, instead of using the model. Visit https://github.com/LeMonde-Development/opensource-bans to grab the right module!")
end

if not script:IsA("Script") then
	err("Script has been tampered with! Please use the original module!");
	script.Disabled = true;
	script:Destroy();
	FAILED_STARTUP = true;
	return
end

if not script.Parent:IsA("ServerScriptService") then
	err("Script has been placed in the wrong spot! Please place the script in ServerScriptService!");
	script.Disabled = true;
	script:Destroy();
	FAILED_STARTUP = true;
	return
end

if not isHttpEnabled() then
	err("HttpEnabled is not set. Please fix in game settings!")
	FAILED_STARTUP = true;
end


function checkban(player)
	for i, v in ipairs(banlist) do
		if v == tostring(player.UserId) then
			out("Kicking banned user " .. player.Name)
			player:Kick("This game is protected by the open-source LeMonde ban database. As you are banned from LeMonde, you are banned from all games protected by this system. You can appeal this ban by openning a support ticket in the LeMonde communications server.")
		end
	end
end

if FAILED_STARTUP then
	err("Preflight failed. Exiting...");
	return;
else
	local success, bans = pcall(function()
		return HttpService:GetAsync(BAN_URL);
	end)
	if success then
		out("Successfully initialized!")
		banlist = HttpService:JSONDecode(bans);
		for _, v in pairs(PlayerService:GetChildren()) do
			checkban(v)
		end
		game.Players.PlayerAdded:Connect(checkban)
	else
		err("Failed to retrieve bans");
	end
end