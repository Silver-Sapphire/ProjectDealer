function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts["large"])
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, VIRTUAL_HEIGHT - 10)
    love.graphics.setColor(1, 1, 1, 1)
end

function ServerListen()
    hostevent = enethost:service()
	
	-- if hostevent then
	-- 	print("Server detected message type: " .. hostevent.type)
	-- 	if hostevent.type == "connect" then 
	-- 		print(hostevent.peer, "connected.")
	-- 	end
	-- 	if hostevent.type == "receive" then
	-- 		print("Received message: ", hostevent.data, hostevent.peer)
	-- 	end
	-- end
end

function ClientSend(message)
	enetclient:service(0)
	clientpeer:send(message)
end

function ParsePacketXY(packet)
	-- take a packet (x&y) and seperate in into two values, x, and y
	-- pos == ition
	local pos, ition = string.find(packet, '&')
	local termin, ation = string.find(packet, "|")

	-- if pos then
		local x = string.sub(packet, 0, pos - 1)
		local y = string.sub(packet, ition + 1, termin - 1)
	-- end

	return x, y
end

function ParsePacketEvent(packet)
	local pos, ition = string.find(packet, "|")
	local gameEvent = string.sub(packet, pos + 1, string.len(packet))
	return gameEvent
end

function ParseAddress(address)
	local foo, bar = string.find(address, ':')
	foo = string.sub(address, 0, bar)
	return foo
end
