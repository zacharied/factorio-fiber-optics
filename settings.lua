require('lib.init')

data:extend {
    {
        -- Debug mode (framework dependency)
        setting_type = 'startup',
        name = Framework.PREFIX .. 'debug-mode',
        type = 'bool-setting',
        default_value = false,
        order = 'z'
    },
}

--------------------------------------------------------------------------------
require('framework.other-mods').settings()
