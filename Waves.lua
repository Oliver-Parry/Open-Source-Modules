local WAVES = {}

--// Private constructor
function newWaveOptions(Options)
	Options.waveLength = (2*math.pi)/Options.waveLength
	Options.steepnessAmplitude = Options.steepness * Options.amplitude
	Options.lengthSpeed = Options.waveLength * Options.waveSpeed
	Options.steepnessAmplitudeY = Options.steepnessAmplitude * Options.direction.Y
	return Options
end

--// Settings
WAVES.HEIGHT = 25
WAVES.Waves = {
	newWaveOptions({
		waveLength = 35;
		amplitude  = 1.5;
		steepness  = 0.5;
		waveSpeed  = 8;
		direction  = Vector2.new(.25, .25)
	});
	newWaveOptions({
		waveLength = 35;
		amplitude  = 1.5;
		steepness  = 0.5;
		waveSpeed  = 6.5;
		direction  = Vector2.new(.25, -.3)
	});
}

--// Cache
WAVES.CAMERA = workspace.CurrentCamera
local cos = math.cos

--// Methods
WAVES.trochoidal = function(X, Y, Time, Options)
	-- Formula: steepness * amplitude * direction.Y * cos(waveNumber * direction:Dot(Vector2.new(x, y)) + (2pi / waveLength) * waveSpeed * time)
	return Options.steepnessAmplitudeY * cos((Options.direction.X * X + Options.direction.Y * Y) + Options.lengthSpeed * Time)
end

WAVES.calculateYOffset = function(X, Y, Time)
	local Offset = 0
	for _, WaveOptions in next, WAVES.Waves do
		Offset += WAVES.trochoidal(X, Y, Time, WaveOptions)
	end
	return Offset
end

WAVES.surfaceNormalFromTri = function(Pos1, Pos2, Pos3)
	--[[ Formula:
	Edge1 = Pos2 - Pos1
	Edge2 = Pos3 - Pos1
	SurfaceNormal = Edge1 x Edge2
	]]
	return (Pos2 - Pos1):Cross(Pos3 - Pos1)
end

WAVES.projectXZOnTri = function(Pos0, Pos1, Pos2, Pos3)
	local Det = (Pos2.Z - Pos3.Z) * (Pos1.X - Pos3.X) + (Pos3.X - Pos2.X) * (Pos1.Z - Pos3.Z)
	
	local L1 = ((Pos2.Z - Pos3.Z) * (Pos0.X - Pos3.X) + (Pos3.X - Pos2.X) * (Pos0.Z - Pos3.Z)) / Det
	local L2 = ((Pos3.Z - Pos1.Z) * (Pos0.X - Pos3.X) + (Pos1.X - Pos3.X) * (Pos0.Z - Pos3.Z)) / Det
	
	return L1 * Pos1.Y + L2 * Pos2.Y + (1 - L1 - L2) * Pos3.Y
end

WAVES.isPointVisible = function(Pos, Lenience)
	local ScreenVector, OnScreen = WAVES.CAMERA:WorldToScreenPoint(Pos)
	local ScreenSize = WAVES.CAMERA.ViewportSize
	
	if OnScreen then return true end
	
	local RelativeX = ScreenVector.X / ScreenSize.X
	local RelativeY = ScreenVector.Y / ScreenSize.Y
	
	local LenienceX = Lenience * ScreenSize.X
	local LenienceY = Lenience * ScreenSize.Y
		
	return (RelativeX >= -LenienceX or RelativeX <= ScreenSize.X + LenienceX) and (RelativeY >= -LenienceY or RelativeY <= ScreenSize.Y + LenienceY)
end

return WAVES
