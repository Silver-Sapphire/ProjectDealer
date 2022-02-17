ConnectState = Class{__includes = BaseState}

function ConnectState:init()
    -- Setup and connet to server

	-- establish host for receiving msg
    host = enet.host_create()
    server = host:connect("73.25.64.47:45154")

	self.mx, self.my = push:toGame(love.mouse.getPosition())
    self.connectFlag = false
    self.debugCounter = 0
    self.debugCounter2 = 0
    self.peerNewX, self.peerNewY = 1
    self.peerX, self.peerY = 1
    self.buildPacket = ""
    self.currentEvent = ""
    self.reconnectTimer = 0
    self.throttleTimer = 0
    self.table = {}
end

function ConnectState:update(dt)
    self.throttleTimer = self.throttleTimer + dt
    self.mx, self.my = push:toGame(love.mouse.getPosition())

    if self.throttleTimer > .06 then
        event = host:service(0)
        if event then
            if event.type == "receive" then
                self.peerNewX, self.peerNewY = ParsePacketXY(event.data)
                server:send(self.mx .. "&" .. self.my .. "|", 0, "unreliable")
    
                Timer.tween(0.06, {
                    [self] = {peerX = self.peerNewX}
                })
                Timer.tween(0.06, {
                    [self] = {peerY = self.peerNewY}
                })
    
                self.debugCounter = self.debugCounter + 1
                self.throttleTimer = 0
    
            elseif event.type == "connect" then
                self.connectFlag = true
                self.peerNewX, self.peerNewY = self.mx, self.my
                self.peerX, self.peerY = self.mx, self.my
                server:send(self.mx .. "&" .. self.my .. "|")
    
            elseif event.type == "disconnect" then
                self.connectFlag = false
                host:flush()
            end
    
            event = host:service(0)
        end
    end

    if not self.connectFlag and self.throttleTimer > 0.5 then
        host:flush()
        host:connect("73.25.64.47:45154")
        self.throttleTimer = 0
    end

    -- if self.peerNewX and self.peerNewY then
    -- end
end

function ConnectState:render()
    -- display connection status
    if self.connectFlag then
        love.graphics.print('Connected!', 10, 10)   
        love.graphics.print(''.. self.currentEvent, VIRTUAL_WIDTH - 100, VIRTUAL_HEIGHT - 100)
        love.graphics.print(''.. self.debugCounter, VIRTUAL_WIDTH - 100, VIRTUAL_HEIGHT - 200)
    else
        love.graphics.print('Searching...', 10, 10)
    end

    -- display broadcast test results
    if self.connectFlag and self.peerX and self.peerY then
        love.graphics.setColor(1, 1, 0, 3/4)
        love.graphics.rectangle('fill', self.peerX,self.peerY, 5,5)
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print(host:get_socket_address(), 10, 60)
    -- if self.connectFlag and self.peerNewX and self.peerNewY then
    --     love.graphics.setColor(1, 0, 1, 3/4)
    --     love.graphics.rectangle('fill', self.peerNewX,self.peerNewY, 5,5)
    --     love.graphics.setColor(1, 1, 1, 1)
    -- end
end
