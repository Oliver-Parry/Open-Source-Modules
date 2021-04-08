local CHUNKS = {}

--// Cache
local floor = math.floor
local round = math.round

--// Methods
CHUNKS.init = function(self, CHUNK_SIZE, CHUNK_ROOT)
	self.CHUNK_SIZE = CHUNK_SIZE
	self.CHUNK_ROOT = CHUNK_ROOT
	
	self.CHUNK_ROOT_SQUARED = CHUNK_ROOT^2
	self.CHUNK_SIZE_DIV_2 = CHUNK_SIZE / 2
	self.CHUNK_ROOT_MINUS_1 = CHUNK_ROOT - 1
	self.CHUNK_ROOT_MOD_2 = CHUNK_ROOT % 2
end

CHUNKS.findNearestChunk = function(self, Pos)
	local Chunk = {}
	if self.CHUNK_ROOT_MOD_2 == 0 then
		Chunk.X = floor(Pos.X / self.CHUNK_SIZE)
		Chunk.Y = floor(Pos.Z / self.CHUNK_SIZE)
	else
		Chunk.X = floor((Pos.X - self.CHUNK_SIZE_DIV_2) / self.CHUNK_SIZE)
		Chunk.Y = floor((Pos.Z - self.CHUNK_SIZE_DIV_2) / self.CHUNK_SIZE)
	end
	return Chunk
end

CHUNKS.findNearestChunks = function(self, Chunk)
	local Chunks = {}
	for Row = 0, self.CHUNK_ROOT_MINUS_1 do
		Chunks[Row] = {}
	end
	for i = 1, self.CHUNK_ROOT_SQUARED do
		local Row = floor(i / self.CHUNK_ROOT - 0.1)
		local Column = (i - self.CHUNK_ROOT) % self.CHUNK_ROOT
		local X = (Column + Chunk.X - 1) * self.CHUNK_SIZE
		local Y = (Row + Chunk.Y - 1) * self.CHUNK_SIZE
		Chunks[Row][X .. " " .. Y] = {
			["X"] = X;
			["Y"] = Y;
		}
	end
	return Chunks
end

CHUNKS.findNearestChunksWithDirection = function(self, Chunk, DirectionX, DirectionZ)
	local RoundedX, RoundedZ = round(DirectionX), round(DirectionZ)
	RoundedX, RoundedZ = RoundedX - 1, RoundedZ - 1
	local Chunks = {}
	for Row = 0, self.CHUNK_ROOT_MINUS_1 do
		Chunks[Row] = {}
	end
	for i = 1, self.CHUNK_ROOT_SQUARED do
		local Row = floor(i / self.CHUNK_ROOT - 0.1)
		local Column = (i - self.CHUNK_ROOT) % self.CHUNK_ROOT
		local X = (Column + Chunk.X + RoundedX) * self.CHUNK_SIZE
		local Y = (Row + Chunk.Y + RoundedZ) * self.CHUNK_SIZE
		Chunks[Row][X .. " " .. Y] = {
			["X"] = X;
			["Y"] = Y;
		}
	end
	return Chunks
end

CHUNKS.findNearestChunksFromPoint = function(self, Pos)
	return self:findNearestChunks(self:findNearestChunk(Pos))
end

CHUNKS.chunksToPoints = function(self, Chunks)
	local Points = {}
	for _, Row in next, Chunks do
		for WaveName, Point in next, Row do
			Points[WaveName] = Point
		end
	end
	return Points
end

return CHUNKS
