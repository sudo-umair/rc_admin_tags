Config = {}

-- Command players type to toggle their own tag on/off.
Config.Command = 'admintag'

-- If true, staff automatically get their tag shown when they load in (no need to type the command).
Config.AutoEnableOnJoin = false

-- Whether you can see your OWN tag floating above your head.
Config.SeeOwnTag = true

-- Max distance (in meters) at which a tag becomes visible.
Config.DrawDistance = 20.0

-- Text size of the floating tag.
Config.TextScale = 0.35

-- Height above the player's feet to draw the tag (~1.0 is roughly above the head).
Config.HeightOffset = 1.05

-- How often (ms) the server re-checks who is near. Lower = snappier, higher = cheaper.
Config.NearCheckWait = 500

-----------------------------------------------------------------------------------
-- GROUP LABELS
-- Maps an ESX group (from xPlayer.getGroup()) to the label shown above the player.
-- Color codes: ~r~ red  ~g~ green  ~b~ blue  ~y~ yellow  ~o~ orange  ~p~ purple  ~w~ white
-----------------------------------------------------------------------------------
Config.GroupLabels = {
    ['support']   = '~g~SUPPORT',
    ['mod']       = '~o~MODERATOR',
    ['admin2']    = '~r~ADMINISTRATOR',
    ['developer'] = '~b~DEVELOPER',
    ['manager']   = '~o~MANAGER',
    ['admin']     = '~y~OWNER',
}

-----------------------------------------------------------------------------------
-- IDENTIFIER OVERRIDES
-- Force a specific tag for a player by identifier, IGNORING their ESX group.
--
-- This is REQUIRED for txAdmin superadmins: ESX forcibly sets their group to
-- "admin" (logged as "Superadmin detected, setting group to admin"), so the only
-- way to give such a player a different tag (e.g. DEVELOPER) is to list them here.
--
-- Key   = the player's full identifier. Run /admintag once and read the console:
--         it prints the exact identifier string to copy.
-- Value = the label to show (same color-code format as above).
-----------------------------------------------------------------------------------
Config.IdentifierOverrides = {
    ['license:df7e524e25b7b8bdacc5eb1b1af99e5ef2553762'] = '~b~DEVELOPER',
    -- ['license:4570157cd0e27f8e169cf972d66bba733c785981'] = '~o~MANAGER',
}
