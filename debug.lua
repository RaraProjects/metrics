local d = {}

d.Show_Act = function(result)
    A.Chat.Debug("Action.Finish_Spell Reaction    " .. tostring(result.reaction))
    A.Chat.Debug("Action.Finish_Spell Animation   " .. tostring(result.animation))
    A.Chat.Debug("Action.Finish_Spell Effect      " .. tostring(result.effect))
    A.Chat.Debug("Action.Finish_Spell Stagger     " .. tostring(result.stagger))
    A.Chat.Debug("Action.Finish_Spell Param       " .. tostring(result.param))
    A.Chat.Debug("Action.Finish_Spell Message     " .. tostring(result.message))
    A.Chat.Debug("Action.Finish_Spell Unknown     " .. tostring(result.unknown))
    A.Chat.Debug("Action.Finish_Spell Add Effect  " .. tostring(result.has_add_effect))
    A.Chat.Debug("Action.Finish_Spell Eff Anim    " .. tostring(result.add_effect_animation))
    A.Chat.Debug("Action.Finish_Spell Eff Effect  " .. tostring(result.add_effect_effect))
    A.Chat.Debug("Action.Finish_Spell Eff Param   " .. tostring(result.add_effect_param))
    A.Chat.Debug("Action.Finish_Spell Eff Message " .. tostring(result.add_effect_message))
    A.Chat.Debug("Action.Finish_Spell Has Spike   " .. tostring(result.has_spike_effect))
    A.Chat.Debug("Action.Finish_Spell Spike Anim  " .. tostring(result.spike_effect_animation))
    A.Chat.Debug("Action.Finish_Spell Spike Eff   " .. tostring(result.spike_effect_effect))
    A.Chat.Debug("Action.Finish_Spell Spike Param " .. tostring(result.spike_effect_param))
    A.Chat.Debug("Action.Finish_Spell Spike Mess  " .. tostring(result.spike_effect_message))
end

return d