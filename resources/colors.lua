Res.Colors = T{}

Res.Colors.Basic = {
    -- Base Colors
    WHITE    = {1.0, 1.0, 1.0, 1.0},
    RED      = {1.0, 0.0, 0.0, 1.0},
    GREEN    = {0.0, 1.0, 0.0, 1.0},
    BLUE     = {0.0, 0.0, 1.0, 1.0},
    ORANGE   = {0.9, 0.6, 0.0, 1.0},
    YELLOW   = {0.9, 1.0, 0.0, 1.0},
    BR_GREEN = {0.2, 1.0, 0.0, 1.0},
    PURPLE   = {0.7, 0.2, 1.0, 1.0},
    DIM      = {0.4, 0.4, 0.4, 1.0},
    -- Elements
    LIGHT    = {1.0, 1.0, 1.0, 1.0},
    DARK     = {0.9, 0.0, 1.0, 1.0},
    FIRE     = {1.0, 0.0, 0.0, 1.0},
    ICE      = {0.0, 0.7, 1.0, 1.0},
    WIND     = {0.0, 1.0, 0.0, 1.0},
    EARTH    = {0.7, 0.5, 0.0, 1.0},
    THUNDER  = {0.7, 0.2, 1.0, 1.0},
    WATER    = {0.3, 0.5, 0.8, 1.0},
}

Res.Colors.Elements = {
    [0] = Res.Colors.Basic.FIRE,
    [1] = Res.Colors.Basic.ICE,
    [2] = Res.Colors.Basic.WIND,
    [3] = Res.Colors.Basic.EARTH,
    [4] = Res.Colors.Basic.THUNDER,
    [5] = Res.Colors.Basic.WATER,
    [6] = Res.Colors.Basic.LIGHT,
    [7] = Res.Colors.Basic.DARK,
}

Res.Colors.Avatars = {
    Carbuncle = Res.Colors.Basic.LIGHT,
    Fenrir    = Res.Colors.Basic.DARK,
    Diabolos  = Res.Colors.Basic.DARK,
    Ifrit     = Res.Colors.Basic.FIRE,
    Shiva     = Res.Colors.Basic.ICE,
    Garuda    = Res.Colors.Basic.WIND,
    Titan     = Res.Colors.Basic.EARTH,
    Ramuh     = Res.Colors.Basic.THUNDER,
    Leviathan = Res.Colors.Basic.WATER,
}