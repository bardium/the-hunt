local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

local localPlayer = Players.localPlayer

local mainPlaceId = 12640491155
local theHuntPlaceId = 16722544136

local keyMappings = {
	["1"] = Enum.KeyCode.D,
	["2"] = Enum.KeyCode.F,
	["3"] = Enum.KeyCode.J,
	["4"] = Enum.KeyCode.K
}

local minimumDistance = 1

local function pressKey(keyCode, state)
	VirtualInputManager:SendKeyEvent(state, keyCode, false, nil)
end

if game.PlaceId == mainPlaceId then
	while localPlayer and game.PlaceId == mainPlaceId do
		TeleportService:Teleport(theHuntPlaceId, localPlayer)
		wait(60)
	end
elseif game.PlaceId == theHuntPlaceId then
	local noteCosmetics = Workspace:WaitForChild("_RhythmEssentials"):WaitForChild("noteCosmetics")
	local notePositions = Workspace:WaitForChild("_RhythmEssentials"):WaitForChild("notePosition")

	while task.wait() do
		for _, notePosition in notePositions:GetChildren() do
			task.spawn(function()
				local keyToPress = keyMappings[notePosition.Name]
				if keyToPress then
					for _, note in noteCosmetics:GetChildren() do
						local primary = note:FindFirstChild("Primary")
						if primary and not note:GetAttribute("NoPress") and (primary.Position - notePosition.Position).Magnitude < minimumDistance then
							pressKey(keyToPress, true)
							local beam = primary:FindFirstChild("Beam")
							local beamAttachment0 = beam and beam.Attachment0
							local beamAttachment1 = beam and beam.Attachment1
							if beam and beamAttachment0 and beamAttachment1 then
								beamAttachment0.Parent.Parent:SetAttribute("NoPress", true)
								beamAttachment1.Parent.Parent:SetAttribute("NoPress", true)
								repeat
									task.wait()
								until (beamAttachment1.WorldPosition - primary.Position).Magnitude < 1
								pressKey(keyToPress, false)
							else
								task.wait()
								pressKey(keyToPress, false)
							end
						end
						task.wait()
					end
				end
			end)
		end
	end
end
