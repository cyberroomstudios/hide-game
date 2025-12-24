local QueueOfKillerPaidService = {}

local queue = {}

function QueueOfKillerPaidService:Init()
	table.clear(queue)
end

function QueueOfKillerPaidService:Add(player)
	if not player then
		return
	end

	table.insert(queue, player)
end

function QueueOfKillerPaidService:Remove(player)
	if not player then
		return
	end

	for index, queuedPlayer in ipairs(queue) do
		if queuedPlayer == player then
			table.remove(queue, index)
			return
		end
	end
end

function QueueOfKillerPaidService:GetAndRemoveNext()
	if #queue == 0 then
		return nil
	end

	return table.remove(queue, 1) -- FIFO
end

return QueueOfKillerPaidService
