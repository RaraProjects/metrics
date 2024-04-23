local themes = {}

themes.Elements = {
    ImGuiCol_Text                  = 0;
    ImGuiCol_TextDisabled          = 1;
    ImGuiCol_WindowBg              = 2; -- Background of normal windows
    ImGuiCol_ChildBg               = 3; -- Background of child windows
    ImGuiCol_PopupBg               = 4; -- Background of popups, menus, tooltips windows
    ImGuiCol_Border                = 5;
    ImGuiCol_BorderShadow          = 6;
    ImGuiCol_FrameBg               = 7; -- Background of checkbox, radio button, plot, slider, text input
    ImGuiCol_FrameBgHovered        = 8;
    ImGuiCol_FrameBgActive         = 9;
    ImGuiCol_TitleBg               = 10;
    ImGuiCol_TitleBgActive         = 11;
    ImGuiCol_TitleBgCollapsed      = 12;
    ImGuiCol_MenuBarBg             = 13;
    ImGuiCol_ScrollbarBg           = 14;
    ImGuiCol_ScrollbarGrab         = 15;
    ImGuiCol_ScrollbarGrabHovered  = 16;
    ImGuiCol_ScrollbarGrabActive   = 17;
    ImGuiCol_CheckMark             = 18;
    ImGuiCol_SliderGrab            = 19;
    ImGuiCol_SliderGrabActive      = 20;
    ImGuiCol_Button                = 21;
    ImGuiCol_ButtonHovered         = 22;
    ImGuiCol_ButtonActive          = 23;
    ImGuiCol_Header                = 24; -- Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
    ImGuiCol_HeaderHovered         = 25;
    ImGuiCol_HeaderActive          = 26;
    ImGuiCol_Separator             = 27;
    ImGuiCol_SeparatorHovered      = 28;
    ImGuiCol_SeparatorActive       = 29;
    ImGuiCol_ResizeGrip            = 30;
    ImGuiCol_ResizeGripHovered     = 31;
    ImGuiCol_ResizeGripActive      = 32;
    ImGuiCol_Tab                   = 33;
    ImGuiCol_TabHovered            = 34;
    ImGuiCol_TabActive             = 35;
    ImGuiCol_TabUnfocused          = 36;
    ImGuiCol_TabUnfocusedActive    = 37;
    ImGuiCol_PlotLines             = 38;
    ImGuiCol_PlotLinesHovered      = 39;
    ImGuiCol_PlotHistogram         = 40;
    ImGuiCol_PlotHistogramHovered  = 41;
    ImGuiCol_TableHeaderBg         = 42; -- Table header background
    ImGuiCol_TableBorderStrong     = 43; -- Table outer and header borders (prefer using Alpha=1.0 here)
    ImGuiCol_TableBorderLight      = 44; -- Table inner borders (prefer using Alpha=1.0 here)
    ImGuiCol_TableRowBg            = 45; -- Table row background (even rows)
    ImGuiCol_TableRowBgAlt         = 46; -- Table row background (odd rows)
    ImGuiCol_TextSelectedBg        = 47;
    ImGuiCol_DragDropTarget        = 48;
    ImGuiCol_NavHighlight          = 49; -- Gamepad/keyboard: current highlighted item
    ImGuiCol_NavWindowingHighlight = 50; -- Highlight window when using CTRL+TAB
    ImGuiCol_NavWindowingDimBg     = 51; -- Darken/colorize entire screen behind the CTRL+TAB window list, when active
    ImGuiCol_ModalWindowDimBg      = 52; -- Darken/colorize entire screen behind a modal window, when one is active
}

themes.Default = {
    ImGuiCol_Text                   = {0.94, 0.94, 0.94, 1.00},
    ImGuiCol_TextDisabled           = {0.94, 0.94, 0.94, 0.29},
    ImGuiCol_WindowBg               = {0.18, 0.20, 0.23, 0.96},
    ImGuiCol_ChildBg                = {0.22, 0.24, 0.27, 0.96},
    ImGuiCol_PopupBg                = {0.05, 0.05, 0.10, 0.90},
    ImGuiCol_Border                 = {0.05, 0.05, 0.10, 0.80},
    ImGuiCol_BorderShadow           = {0.00, 0.00, 0.00, 0.00},
    ImGuiCol_FrameBg                = {0.16, 0.17, 0.20, 1.00},
    ImGuiCol_FrameBgHovered         = {0.14, 0.14, 0.14, 0.78},
    ImGuiCol_FrameBgActive          = {0.12, 0.12, 0.12, 1.00},
    ImGuiCol_TitleBg                = {0.83, 0.33, 0.28, 0.69},
    ImGuiCol_TitleBgActive          = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_TitleBgCollapsed       = {0.83, 0.33, 0.28, 0.50},
    ImGuiCol_MenuBarBg              = {0.12, 0.13, 0.17, 1.00},
    ImGuiCol_ScrollbarBg            = {0.12, 0.13, 0.17, 1.00},
    ImGuiCol_ScrollbarGrab          = {0.83, 0.33, 0.28, 0.69},
    ImGuiCol_ScrollbarGrabHovered   = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_ScrollbarGrabActive    = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_CheckMark              = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_SliderGrab             = {0.83, 0.33, 0.28, 0.69},
    ImGuiCol_SliderGrabActive       = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_Button                 = {0.83, 0.33, 0.28, 0.78},
    ImGuiCol_ButtonHovered          = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_ButtonActive           = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_Header                 = {0.83, 0.33, 0.28, 0.78},
    ImGuiCol_HeaderHovered          = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_HeaderActive           = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_Separator              = {0.43, 0.43, 0.50, 0.50},
    ImGuiCol_SeparatorHovered       = {0.10, 0.40, 0.75, 0.78},
    ImGuiCol_SeparatorActive        = {0.10, 0.40, 0.75, 1.00},
    ImGuiCol_ResizeGrip             = {0.05, 0.05, 0.05, 0.69},
    ImGuiCol_ResizeGripHovered      = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_ResizeGripActive       = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_Tab                    = {0.05, 0.05, 0.05, 0.69},
    ImGuiCol_TabHovered             = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_TabActive              = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_TabUnfocused           = {0.07, 0.10, 0.15, 0.97},
    ImGuiCol_TabUnfocusedActive     = {0.14, 0.26, 0.42, 1.00},
    ImGuiCol_PlotLines              = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_PlotLinesHovered       = {0.81, 0.81, 0.81, 1.00},
    ImGuiCol_PlotHistogram          = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_PlotHistogramHovered   = {0.81, 0.81, 0.81, 1.00},
    ImGuiCol_TableHeaderBg          = {0.05, 0.05, 0.05, 0.69},
    ImGuiCol_TableBorderStrong      = {0.10, 0.10, 0.10, 1.00},
    ImGuiCol_TableBorderLight       = {0.15, 0.15, 0.15, 1.00},
    ImGuiCol_TableRowBg             = {0.00, 0.00, 0.00, 0.00},
    ImGuiCol_TableRowBgAlt          = {1.00, 1.00, 1.00, 0.06},
    ImGuiCol_TextSelectedBg         = {0.83, 0.33, 0.28, 0.50},
    ImGuiCol_DragDropTarget         = {1.00, 1.00, 0.00, 0.90},
    ImGuiCol_NavHighlight           = {1.00, 1.00, 0.00, 1.00},
    ImGuiCol_NavWindowingHighlight  = {0.83, 0.33, 0.28, 1.00},
    ImGuiCol_NavWindowingDimBg      = {0.00, 0.00, 0.00, 0.60},
    ImGuiCol_ModalWindowDimBg       = {0.05, 0.05, 0.05, 0.78},
}

return themes