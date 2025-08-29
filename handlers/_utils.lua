H.Offense = { }
H.Defense = { }

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits    table Contains necessary entity audit data; helps save on parameter slots.
---@param damage    number
---@param ownerMob? table
------------------------------------------------------------------------------------------------------
H.Offense.GrandTotals = function(audits, damage, ownerMob)
    DB.Data.Update(DB.UpdateMode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE, DB.Metric.TOTAL)
    DB.Data.Update(DB.UpdateMode.INC, damage, audits, DB.Trackable.TOTAL_DAMAGE_NO_SKILLCHAIN, DB.Metric.TOTAL)
    DB.TotalDamage = DB.TotalDamage + damage
    DB.TotalDamageNoSkillchain = DB.TotalDamageNoSkillchain + damage

    if ownerMob then
        DB.Data.Update(DB.UpdateMode.INC, damage, audits, DB.Trackable.PET_OVERALL, DB.Metric.TOTAL)
    end
end

------------------------------------------------------------------------------------------------------
-- Tracks over time recent accuracy.
------------------------------------------------------------------------------------------------------
---@param audits    table Contains necessary entity audit data; helps save on parameter slots.
---@param hit       boolean
---@param ownerMob? table
------------------------------------------------------------------------------------------------------
H.Offense.UpdateRecentAccuracy = function(audits, hit, ownerMob)
    if not ownerMob then
        DB.Accuracy.Update(audits.player_name, hit)
    end
end

------------------------------------------------------------------------------------------------------
-- Hit.
-- Can't just used DB.Data.Update_Damage for this because I can call this multiple times per packet.
-- The total damage will be incremented too much if that happens.
------------------------------------------------------------------------------------------------------
---@param audits       table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable    DB.Trackable
---@param damage       integer
---@param criticalHit? boolean
------------------------------------------------------------------------------------------------------
H.Offense.Hit = function(audits, trackable, damage, criticalHit)
    DB.Data.UpdateDamageBasic(audits, trackable, damage, criticalHit)
    DB.Data.UpdateAccuracy(audits, trackable, true)
end

------------------------------------------------------------------------------------------------------
-- Miss.
------------------------------------------------------------------------------------------------------
---@param audits    table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable DB.Trackable
------------------------------------------------------------------------------------------------------
H.Offense.Miss = function(audits, trackable)
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_TARGET)
end

------------------------------------------------------------------------------------------------------
-- Player attacks absorbed by shadows or mob heal. These are counted as hits in terms of accuracy.
-- No effect on recent accuracy tracking.
------------------------------------------------------------------------------------------------------
---@param audits    table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable DB.Trackable
---@param metric    DB.Metric
------------------------------------------------------------------------------------------------------
H.Offense.NoDamageHit = function(audits, trackable, metric)
    H.Offense.Hit(audits, trackable, 0)
end

------------------------------------------------------------------------------------------------------
-- Attempt being absorbed by shadows.
-- Accuracy doesn't suffer because this isn't a miss. It just heals the mob.
------------------------------------------------------------------------------------------------------
---@param audits    table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable DB.Trackable player melee or pet melee.
---@param ownerMob? table
------------------------------------------------------------------------------------------------------
H.Offense.PhysicalShadowAbsorption = function(audits, trackable, ownerMob)
    H.Offense.Hit(audits, trackable, 0)
    H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.SHADOW_ABSORPTION)
end

------------------------------------------------------------------------------------------------------
-- Healing the mob with a physical hit.
-- Accuracy doesn't suffer because this isn't a miss. It just heals the mob.
------------------------------------------------------------------------------------------------------
---@param audits    table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable DB.Trackable player melee or pet melee.
---@param damage    integer
---@param ownerMob? table
------------------------------------------------------------------------------------------------------
H.Offense.MobHeal = function(audits, trackable, damage, ownerMob)
    H.Offense.Hit(audits, trackable, 0)
    H.Offense.UpdateRecentAccuracy(audits, true, ownerMob)
    DB.Data.Update(DB.UpdateMode.INC, damage, audits, trackable, DB.Metric.MOB_HEALING)
end

------------------------------------------------------------------------------------------------------
-- Cataloged action hit.
------------------------------------------------------------------------------------------------------
---@param audits       table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable    DB.Trackable
---@param damage       integer
---@param actionName   string
---@param criticalHit? boolean
------------------------------------------------------------------------------------------------------
H.Offense.CatalogHit = function(audits, trackable, damage, actionName, criticalHit)
    DB.Catalog.UpdateDamage(audits.player_name, audits.target_name, trackable, damage, actionName, audits.pet_name, criticalHit)
    DB.Catalog.UpdateAccuracy(audits, trackable, actionName, true)
end

------------------------------------------------------------------------------------------------------
-- Cataloged action miss.
------------------------------------------------------------------------------------------------------
---@param audits       table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable    DB.Trackable
---@param actionName   string
---@param criticalHit? boolean
------------------------------------------------------------------------------------------------------
H.Offense.CatalogMiss = function(audits, trackable, actionName, criticalHit)
    DB.Catalog.UpdateDamage(audits.player_name, audits.target_name, trackable, 0, actionName, audits.pet_name, criticalHit)
    DB.Catalog.UpdateAccuracy(audits, trackable, actionName, false)
end

------------------------------------------------------------------------------------------------------
-- Cataloged action no damage hit.
------------------------------------------------------------------------------------------------------
---@param audits     table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable  DB.Trackable
---@param actionName string
------------------------------------------------------------------------------------------------------
H.Offense.CatalogNoDamageHit = function(audits, trackable, actionName)
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_TARGET)
    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_TARGET)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, actionName, DB.Metric.HITS_ON_TARGET)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, actionName, DB.Metric.ATTEMPTS_ON_TARGET)
end

------------------------------------------------------------------------------------------------------
-- Action used outside of the target loop.
------------------------------------------------------------------------------------------------------
---@param audits    table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable DB.Trackable
---@param hit       boolean
---@param mpSpent?  integer      If the action is spell
------------------------------------------------------------------------------------------------------
H.Offense.ActionUsed = function(audits, trackable, action_name, hit, mpSpent)
    if hit then
        DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.HITS_ON_USE)
        DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, action_name, DB.Metric.HITS_ON_USE)
    end

    DB.Data.Update(DB.UpdateMode.INC, 1, audits, trackable, DB.Metric.ATTEMPTS_ON_USE)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, 1, audits, trackable, action_name, DB.Metric.ATTEMPTS_ON_USE)

    if mpSpent then
        DB.Data.Update(DB.UpdateMode.INC, mpSpent, audits, trackable, DB.Metric.MP_SPENT)
        DB.Catalog.UpdateMetric(DB.UpdateMode.INC, mpSpent, audits, trackable, action_name, DB.Metric.MP_SPENT)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Increments weaponskill hits.
-- ------------------------------------------------------------------------------------------------------
---@param audits    table
---@param tp?       integer
---@param wsName    string
---@param trackable DB.Trackable
---@return integer
-- ------------------------------------------------------------------------------------------------------
H.Offense.WeaponskillTP = function(audits, tp, wsName, trackable)
    tp = math.max(0, math.min(3000, tp or 0))

    DB.Data.Update(DB.UpdateMode.INC, tp, audits, trackable, DB.Metric.TP_SPENT)
    DB.Catalog.UpdateMetric(DB.UpdateMode.INC, tp, audits, trackable, wsName, DB.Metric.TP_SPENT)

    return tp
end

------------------------------------------------------------------------------------------------------
-- Minimum and maximum melee values.
------------------------------------------------------------------------------------------------------
---@param audits          table        Contains necessary entity audit data; helps save on parameter slots.
---@param trackable       DB.Trackable
---@param damage          integer      whether or not the animation is a NIN auto throwing attack.
---@param wasCriticalHit? boolean
------------------------------------------------------------------------------------------------------
H.Offense.MinMax = function(audits, trackable, damage, wasCriticalHit)
    local metricMin = wasCriticalHit and DB.Metric.CRITICAL_MIN or DB.Metric.MIN
    local metricMax = wasCriticalHit and DB.Metric.CRITICAL_MAX or DB.Metric.MAX

    if damage > 0 and (damage < DB.Data.Get(audits.player_name, trackable, metricMin, audits.target_name)) then
        DB.Data.Update(DB.UpdateMode.SET, damage, audits, trackable, metricMin)
    end

    if damage > DB.Data.Get(audits.player_name, trackable, metricMax, audits.target_name) then
        DB.Data.Update(DB.UpdateMode.SET, damage, audits, trackable, metricMax)
    end
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits    table  Contains necessary entity audit data; helps save on parameter slots.
---@param damage    number
---@param ownerMob? table
------------------------------------------------------------------------------------------------------
H.Defense.GrandTotals = function(audits, damage, ownerMob)
    if ownerMob then
        DB.Data.UpdateDamageBasic(audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL_PET, damage)
    else
        DB.Data.UpdateDamageBasic(audits, DB.Trackable.DEF_DAMAGE_TAKEN_TOTAL, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Check for a full mitigation attempt.
------------------------------------------------------------------------------------------------------
---@param audits       table          Contains necessary entity audit data; helps save on parameter slots.
---@param trackable    DB.Trackable
---@param damage       integer
---@param messageId    integer        the ID of the entity animation when taking a hit.
---@param messageCheck integer
---@return boolean
------------------------------------------------------------------------------------------------------
H.Defense.Mitigation = function(audits, trackable, damage, messageId, messageCheck)
    local mitigationOccurred = false

    if messageId == messageCheck then
        mitigationOccurred = true
        H.Offense.Hit(audits, trackable, damage)

    else
        H.Offense.Miss(audits, trackable)
    end

    return mitigationOccurred
end


------------------------------------------------------------------------------------------------------
-- Check for critical damage taken.
------------------------------------------------------------------------------------------------------
---@param audits    table          Contains necessary entity audit data; helps save on parameter slots.
---@param damage    number
---@param messageId Ashita.Message the ID of the entity animation when taking a hit.
------------------------------------------------------------------------------------------------------
H.Defense.Crit = function(audits, damage, messageId)
    if messageId == Ashita.Message.CRITICAL_HIT then
        H.Offense.Hit(audits, DB.Trackable.DEF_CRITICAL, damage, true)
    else
        H.Offense.Miss(audits, DB.Trackable.DEF_CRITICAL)
    end
end