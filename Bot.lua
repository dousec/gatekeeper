local discordia = require('discordia')
local fs = require('fs')
local path = require('path')
local handlers = require('./lib/loadhandlers')

local defaultOptions = {
    prefix = '!',
    filesDir = './discordia_files/'
}

---@class BotOptions : discordia.client_options
---@field prefix string
---@field filesDir string
---@field gatewayFile string

--- @param options BotOptions
local function parseOptions(options)
    local all = options or {}
    local prefix = all.prefix or defaultOptions.prefix
    local filesDir = all.filesDir or defaultOptions.filesDir

    all.logFile = all.logFile or filesDir .. os.date('%Y-%m-%d') .. '.log'
    all.gatewayFile = all.gatewayFile or filesDir .. 'gateway.json'

    local clean = table.copy(all)
    clean.prefix = nil
    clean.filesDir = nil

    return {
        clean = clean,
        prefix = prefix,
        filesDir = filesDir
    }
end

---@class Bot
---@field client Client
---@field prefix string
---@field commands table
---@field events table
local Bot, getters = discordia.class('Bot')

---@param options BotOptions
function Bot:__init(options)
    options = parseOptions(options)

    if fs.mkdirSync(options.filesDir) then
        print(('Created discordia files directory at "%s"'):format(path.resolve(options.filesDir)))
    end

    self._client = discordia.Client(options.clean)
    self._prefix = options.prefix
    self._commands = {}
    self._events = {}

    handlers.loadCommands(self)
    handlers.loadEvents(self)
end

function Bot:run()
    local token = os.getenv('DISCORD_BOT_TOKEN')
    assert(token, '"DISCORD_BOT_TOKEN" is not set in the environment variables')

    for eventName, eventHandler in pairs(self._events) do
        self._client:on(eventName, function(...)
            eventHandler(self, ...)
        end)
    end

    self._client:run('Bot ' .. token)
end

function getters:client()
    return self._client
end

function getters:prefix()
    return self._prefix
end

function getters:commands()
    return self._commands
end

function getters:events()
    return self._events
end

return Bot