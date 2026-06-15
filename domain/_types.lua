---@meta
--- doprog.domain — types for the quest/mission/zone object model. Annotation-only.

--- Prerequisite description for a quest. All listed tasks must be complete AND
--- the optional predicate must pass before the quest is eligible to start.
---@class doprog.Prereq
---@field tasks? string[]                              # task names that must be complete
---@field fn? fun(ctx: doprog.StepContext): boolean    # arbitrary gate

---@class doprog.Quest.Opts
---@field name string
---@field type doprog.QuestType
---@field zone string                                  # short zone name
---@field steps doprog.Step[]
---@field prereq? doprog.Prereq
---@field doneWhen? fun(ctx: doprog.StepContext): boolean  # external "already done" probe
---@field completionTask? string                       # if this task is complete, quest is done

---@class doprog.Mission.Opts : doprog.Quest.Opts
---@field requestNpc? doprog.SpawnQuery                 # NPC the mission is requested from
---@field requestSay? string                           # phrase that requests the mission
---@field lockoutMinutes? integer                      # request lockout (informational)

---@class doprog.Zone.Opts
---@field shortName string                             # EQ zone short name (e.g. "stratos")
---@field displayName string
---@field quests doprog.Quest[]                        # in intended completion order

return {}
