EndPhaseState = Class{__includes = BaseState}

function EndPhaseState:init()
    -- Setup and connet to server

    enethost = nil
    hostevent = nil
    clientpeer = nil

	-- establish host for receiving msg
	enethost = enet.host_create("*:4545")
	
	-- establish a connection to host on same PC
	enetclient = enet.host_create()
        clientpeer = enetclient:connect("10.0.0.144:4545")

	self.mx, self.my = push:toGame(love.mouse.getPosition())
	self.timer = 0
	self.timerflag = true
end

function EndPhaseState:update(dt)
	self.mx, self.my = push:toGame(love.mouse.getPosition())
	ServerListen()	
	ClientSend(self.mx .. "&" .. self.my)
	if self.timerflag then
		self.timer = dt + self.timer
	else
		self.timer = 0
	end
end

function EndPhaseState:render()
    love.graphics.setFont(gFonts["medium"])
	local tmp = self.mx .. "&" .. self.my
	local tmp2 = 0
	love.graphics.print(tmp, 0,0)
	
    if hostevent then 
		love.graphics.print(hostevent.data, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2) 
		if tmp == hostevent.data then 
			love.graphics.rectangle("fill", 20,50, 60, 120) 
			if self.timer ~= tmp2 then tmp2 = self.timer end
			self.timerflag = false
			love.graphics.print(tmp2, 10, 10)
		else
			self.timerflag = true
		end
	end
end
