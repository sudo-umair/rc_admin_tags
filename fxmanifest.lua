fx_version 'cerulean'
game 'gta5'

name 'rc_admin_tags'
description 'Overhead staff tags for ESX, with identifier overrides for txAdmin superadmins'
author 'codejunkie'
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

dependencies {
    'es_extended',
}
