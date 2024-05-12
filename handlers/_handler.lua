H = {}

H.Mode = DB.Enum.Mode
H.Trackable = DB.Enum.Trackable
H.Metric = DB.Enum.Metric

H.Enum = {}

H.Enum.Flags = {
    IGNORE = "ignore",
}

H.Enum.Offsets = {
    ABILITY = 512,
    PET  = 512,
}

H.Enum.Text = {
    BLANK = "",
}

require("handlers.melee")
require("handlers.melee_def")
require("handlers.ranged")
require("handlers.tp_action")
require("handlers.tp_action_def")
require("handlers.abilities")
require("handlers.spells")
require("handlers.spells_def")
require("handlers.deaths")