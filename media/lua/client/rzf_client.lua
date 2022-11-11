local timeManager = require('../shared/rzf_timeManager')
local zombiesManager = require('../shared/rzf_zombiesManager')
local utilities = require('../shared/rzf_utilities')

-- Mod "global" configuration
local configuration = {}
local currentPreset = ''

-- Check the time and decide which preset to load for the zombies
local function UpdatePreset()
    print("[RZF] In UpdatePreset (Client)")
    local detectedPreset = timeManager.DetectPreset(timeManager.GetStartTime(configuration.schedule), timeManager.GetEndTime(configuration.schedule))
    print("[RZF] Client Preset detected -> ", detectedPreset)
    if currentPreset ~= detectedPreset then
        local zombieDistribution = zombiesManager.activatePreset(configuration[detectedPreset])
        zombiesManager.disable()
        zombiesManager.enable(zombieDistribution, configuration.updateFrequency)
        currentPreset = detectedPreset
    end
end

-- Load configuration from options
local function LoadConfiguration()
    print("[RZF] In LoadConfiguration (Client)")
    utilities.ValidateConfiguration()
    configuration = utilities.LoadConfiguration()

    if type(configuration) ~= 'table' then
        error("[RZF] Configuration is not a table of values")
    else
        UpdatePreset()
        Events.EveryHours.Add(UpdatePreset)
    end
end

print("[RZF] Starting (Client)")
Events.OnGameStart.Add(LoadConfiguration)