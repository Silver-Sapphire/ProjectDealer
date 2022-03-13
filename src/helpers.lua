function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts["large"])
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), VIRTUAL_WIDTH*2/3, 50)
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
function RenderCard(card, x, y)
	-- set color based on attribute ("art")
	local bTxFlag = false
	if card.trigger == 'crit' then
		bTxFlag = true
		love.graphics.setColor(8/8, 7/8, 1/3, 1)--darker yellow
	elseif card.trigger == 'heal' then
		bTxFlag = true
		love.graphics.setColor(1/4, 3/4, 3/8, 1)--green
	elseif card.sentinel then
		bTxFlag = true
		love.graphics.setColor(8/8, 7/8, 1/2, 1)--brighter yellow
	else
		love.graphics.setColor(0, 0, 0, 1)--black
	end

	-- card ""art"""
	love.graphics.rectangle('fill', x,y, CARD_WIDTH,CARD_HEIGHT)
	-- card text color setting
	if bTxFlag then
		love.graphics.setColor(0,0,0,1)
	else
		love.graphics.setColor(1,1,1,1)--white
	end

	-- draw card info
	love.graphics.setFont(gFonts['small'])
	love.graphics.print(card.grade, x+1, y+1)
	if card.shield then
		love.graphics.printf(card.shield, x+15, y+1, CARD_HEIGHT -2, 'center', math.pi/2) -- rotate 90*
	end
	love.graphics.printf(card.power or 0, x+1, y+CARD_HEIGHT-15, CARD_WIDTH-2, 'right')
end

function CraftMenu(template, items, onSubmitFunction)
	local craftMenu = Menu{}
end
