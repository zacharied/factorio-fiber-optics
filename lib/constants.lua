------------------------------------------------------------------------
-- mod constant definitions.
--
-- can be loaded into scripts and data
------------------------------------------------------------------------

local Constants = {}

--------------------------------------------------------------------------------
-- main constants
--------------------------------------------------------------------------------

-- the current version that is the result of the latest migration
Constants.current_version = 1

Constants.prefix = 'hps:fo-'
Constants.name = 'optical-connector'
Constants.root = '__fiber-optics__'
Constants.gfx_location = Constants.root .. '/gfx/'

--------------------------------------------------------------------------------
-- Framework intializer
--------------------------------------------------------------------------------

---@return FrameworkConfig config
function Constants.framework_init()
    return {
        -- prefix is the internal mod prefix
        prefix = Constants.prefix,
        -- name is a human readable name
        name = Constants.name,
        -- The filesystem root.
        root = Constants.root,
    }
end

--------------------------------------------------------------------------------
-- Path and name helpers
--------------------------------------------------------------------------------

---@param value string
---@return string result
function Constants:with_prefix(value)
    return self.prefix .. value
end

---@param path string
---@return string result
function Constants:png(path)
    return self.gfx_location .. path .. '.png'
end

---@param id string
---@return string result
function Constants:locale(id)
    return Constants:with_prefix('gui.') .. id
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

Constants.creation_events = {
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive
}

Constants.deletion_events = {
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity,
    defines.events.on_entity_died,
    defines.events.script_raised_destroy
}


Constants.debug_mode = 0 -- bit 0 (0/1): network debug, bit 1 (0/2): entity debug


-------- todo -------

Constants.optical_connector = Constants:with_prefix(Constants.name)

Constants.optical_connector_technology = Constants:with_prefix('optical-connector-technology')

Constants.oc_power_interface = Constants:with_prefix('oc-power-interface')
Constants.oc_power_pole = Constants:with_prefix('oc-power-pole')
Constants.oc_led_lamp = Constants:with_prefix('oc-led-lamp')
Constants.oc_cc = Constants:with_prefix('oc-constant-combinator')

Constants.oc_iopin_count = 16
Constants.oc_iopin_prefix = Constants:with_prefix('oc-iopin_')

Constants.iopin_name = function(idx) return Constants.oc_iopin_prefix .. idx end

-- network specific stuff
Constants.network_connector = Constants:with_prefix('network-connector')

Constants.attached_entities = {
    Constants.oc_power_interface,
    Constants.oc_power_pole,
    Constants.oc_led_lamp,
    Constants.oc_cc,
}

Constants.empty_sprite = {
    filename = '__core__/graphics/empty.png',
    width = 1,
    height = 1,
}

Constants.circuit_wire_connectors = {
    wire = { red = { 0, 0 }, green = { 0, 0 } },
    shadow = { red = { 0, 0 }, green = { 0, 0 } },
}

Constants.directions = { defines.direction.north, defines.direction.west, defines.direction.south, defines.direction.east }

Constants.msg_wires_too_long = Constants.prefix .. 'messages.wires_too_long'

local function rotate_pins(from)
    local result = {}
    for _, offset in pairs(from) do
        local pin = { offset[2], -offset[1] }
        table.insert(result, pin)
    end
    return result
end

Constants.check_circuit_wires = 1
Constants.check_power_wires = 2

Constants.all_iopins = {}

-- map for all entities that need to do connection check
Constants.wire_check = {
    [Constants.oc_power_pole] = Constants.check_power_wires
}

for idx = 1, Constants.oc_iopin_count, 1 do
    local name = Constants.iopin_name(idx)
    table.insert(Constants.attached_entities, name)
    table.insert(Constants.all_iopins, name)

    Constants.wire_check[name] = Constants.check_circuit_wires
end

--
-- connection points for wires
--
Constants.iopin_connection_points = {
    [defines.direction.north] = {
        [1] = { -2, -2 }, [16] = { -2, -1 }, [15] = { -2, 0 }, [14] = { -2, 1 }, [13] = { -2, 2 },
        [2] = { -1, -2 }, [12] = { -1, 2 },
        [3] = { 0, -2 }, [11] = { 0, 2 },
        [4] = { 1, -2 }, [10] = { 1, 2 },
        [5] = { 2, -2 }, [6] = { 2, -1 }, [7] = { 2, 0 }, [8] = { 2, 1 }, [9] = { 2, 2 },
    },
}

local previous = {}
for _, dir in pairs(Constants.directions) do
    if not Constants.iopin_connection_points[dir] then
        Constants.iopin_connection_points[dir] = rotate_pins(previous)
    end
    previous = Constants.iopin_connection_points[dir]
end

return Constants
