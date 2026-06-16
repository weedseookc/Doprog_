# doprog quest authoring guide

How to write a quest/mission file under `zones/<zone>/`. Read the matching
`references/eqresource/<slug>.md` for the real data, then encode it precisely.

## Step DSL (`local S = require('doprog.steps')`)

Every step takes one options table. Common fields: `zone`, `desc`.

- `S.pickup{ zone, npc, taskName, request?, desc }`
  Navigate to `npc`, hail, say `request` (the offer keyword), accept the task
  window. Completes when the task is in the journal. Use for accepting tasks and
  for requesting missions.
- `S.combat{ zone?, taskName?, objective?, target?, untilItem?, untilCount?, loc?, mechanics?, desc }`
  doprog SELECTS + navigates to + `/target`s the mob, then advertises NEED_COMBAT
  (the host kills it). Completion: `taskName`+`objective` -> that objective Done;
  `taskName` only -> whole task done; `untilItem` -> hold N of an item; `target`
  only -> nothing matching remains. `target` may be a `SpawnQuery` OR a function
  `fun(ctx) -> SpawnQuery|false|nil` (false = wait, nil = done) for solved orders.
- `S.handin{ zone, npc, taskName?, objective?, items?, desc }`
  Navigate to `npc`, give `items` (or just hail), complete. Used for turn-ins and
  "speak with X" objectives.
- `S.loot{ zone?, item, count?, desc }` — gate on holding `count` of `item`.
- `S.click{ zone?, npc?, loc?, action, condition?, completeAfter?, desc }`
  Navigate to `npc`/`loc`, then run `action`. doprog AUTO-TARGETS `npc` before the
  action. Completion: `condition(ctx)` if given; else `completeAfter` ms; else a
  zone change. Use for say-phrase puzzle steps, door/portal zone-ins, clickies.
- `S.wait{ condition, desc }` — block until `condition(ctx)` is true.

SpawnQuery: `{ name=?, id=?, npc=true?, radius=?, exclude={...}? }`.
Vec3: `{ y=, x=, z=? }` (z optional; 2D uses `/nav loc Y X`).
Mechanic: `{ react='flee'|'hide'|'drag'|'aura'|'moveTo', emote=?, loc=?, spawn=?, distance=? }`.

`objDone` helper pattern for puzzle/say steps:
```lua
local TASK = 'Quest Name'
local function objDone(n) return function(ctx) return ctx.task:objectiveDone(TASK, n) end end
```

## Proper MQ commands (use THESE in `action` strings)

doprog auto-targets the step's `npc` first, so actions usually need no targeting.

- Say to the step's NPC: `'/say <phrase>'` (npc already targeted).
- Hail: `'/say Hail'`.
- Door / portal zone-in: `'/multiline ; /doortarget ; /click left door'`
  (must `/doortarget` before `/click left door`).
- Ground-spawn / clicky item pickup: `'/multiline ; /itemtarget "<Name>" ; /click left item'`.
- Right-click an inventory item (rings, siphons): `'/itemnotify "<Name>" rightmouseup'`.
- Accept an offered task window: `'/notify TaskSelectWnd TSEL_AcceptButton leftmouseup'`.
- Multiple commands in one action: `'/multiline ; /cmd1 ; /cmd2'`.

Do NOT use `/click left door` without `/doortarget`, or `/click left item`
without `/itemtarget` — those are the "improper commands" being fixed.

## Rules

- One objective per step where the task has discrete objectives; set `objective`.
- Givers in another zone: set the pickup/handin step `zone` to the giver's zone.
- Combat is objective/target-driven — never invent attack commands; the host
  fights. doprog only positions (mechanics) and targets.
- Cite the source page in the file header. No "TODO"/stub text — encode the real
  data from the reference. If a value is genuinely unpublished, use the best real
  mechanism and a one-line note (not a TODO).
- Only edit your assigned `zones/**/*.lua` files. Do not touch `steps/`,
  `services/`, `core/`, or `data/` — flag any framework gap back instead.
- Keep lines <= 120 chars. Verify with `luac5.4 -p <file>`.
