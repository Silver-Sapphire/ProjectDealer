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


-- display a card
function renderCard(card, x, y)
	-- set color based on attribute ("art")
	if card.trigger == 'crit' then
		love.graphics.setColor(7/8, 7/8, 1/4,1)--darker yellow
	elseif card.trigger == 'heal' then
		love.graphics.setColor(1/4, 1, 1/4, 1)--green
	elseif card.sentinel then
		love.graphics.setColor(7/8, 7/8, 1/2, 1)--brighter yellow
	else
		love.graphics.setColor(0, 0, 0, 1)--black
	end

	-- card ""art"""
	love.graphics.rectangle('fill', x,y, CARD_WIDTH,CARD_HEIGHT)
	-- card grade
	love.graphics.setColor(1,1,1,1)--white
	love.graphics.print(card.grade, x+1, y+1)
end

-- a powerful multipurpose function that moves a card
-- from a given location at a given index, to another specified location, at at an option index
function moveCard(request)
	-- get	
	local _field = request._field 
	local _inputTable = request._inputTable
	local _inputIndex = request._inputIndex
	local _outputTable = request._outputTable
	local _outputIndex = request._outputIndex or false

	local _ = fetchCard(_field, _inputTable, _inputIndex)
	if _outputIndex then
		pushCard(_field, _outputTable, _outputIndex, _)
	else
		pushCard(_field, _outputTable, _)
	end
end

function convertToIndex(string)
	-- todo add ride deck and gzone
	if string == "hand" then

	elseif string == "deck" then

	elseif string == "drop" then

	elseif string == "bind" then

	elseif string == "trigger" then

	elseif string == "order" then

	elseif string == "damage" then

	elseif string == "guard" then

	elseif string == "soul" then

	elseif string == "vanguard" then

	elseif string == "rearguard" then

	-- insert front/back row, ect here
	end
end
