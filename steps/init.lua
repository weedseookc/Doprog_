--- doprog.steps
---
--- Aggregator + authoring DSL for steps. Quest files require this and build
--- their step list declaratively, e.g.:
---
---     local S = require('doprog.steps')
---     ...
---     steps = {
---       S.travel{ zone = 'stratos', loc = {y=1,x=2,z=3}, desc = 'to giver' },
---       S.pickup{ zone = 'stratos', npc = {name='Foo'}, taskName = 'Soldier of Air' },
---       S.combat{ target = {name='a fire mephit', npc=true}, taskName='Soldier of Air', objective=1 },
---       S.handin{ npc = {name='Foo'}, taskName = 'Soldier of Air' },
---     }

local TravelStep = require('doprog.steps.travel_step')
local PickupStep = require('doprog.steps.pickup_step')
local HandinStep = require('doprog.steps.handin_step')
local CombatStep = require('doprog.steps.combat_step')
local LootStep = require('doprog.steps.loot_step')
local ClickStep = require('doprog.steps.click_step')
local WaitStep = require('doprog.steps.wait_step')

---@class doprog.StepsModule
---@field Step doprog.Step
---@field travel fun(opts: doprog.Step.Opts): doprog.TravelStep
---@field pickup fun(opts: doprog.Step.Opts): doprog.PickupStep
---@field handin fun(opts: doprog.Step.Opts): doprog.HandinStep
---@field combat fun(opts: doprog.Step.Opts): doprog.CombatStep
---@field loot fun(opts: doprog.Step.Opts): doprog.LootStep
---@field click fun(opts: doprog.Step.Opts): doprog.ClickStep
---@field wait fun(opts: doprog.Step.Opts): doprog.WaitStep
local M = {
    Step = require('doprog.steps.step'),
    travel = TravelStep.new,
    pickup = PickupStep.new,
    handin = HandinStep.new,
    combat = CombatStep.new,
    loot = LootStep.new,
    click = ClickStep.new,
    wait = WaitStep.new,
}

return M
