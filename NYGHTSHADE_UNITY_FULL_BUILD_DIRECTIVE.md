# NYGHTSHADE HOLLOW / CLAWED — FULL UNITY 6 BUILD DIRECTIVE

You are the Unity 6 AI development agent working inside the active Nyghtshade Hollow / CLAWED Unity project.

## MISSION

Build the game systems, scene organization, optimization, MMA warehouse fight club, prison simulation systems, riot/security response systems, UI hooks, save/load hooks, and verification reports needed to turn this project into a playable prison RPG vertical slice.

This is not only an audit. This is a BUILD DIRECTIVE.

## CORE GOAL

The project must become a playable third-person prison RPG/simulation where the player can:

- Spawn as the playable character
- Move with a working third-person camera
- Interact with doors, NPCs, items, stash points, evidence, and zone triggers
- Enter major areas like prison block, morgue, basketball gym, warehouse/MMA fight club, chapel, cafeteria, infirmary, yard, and GRAVE tunnel entrance if present
- Use inventory
- Carry legal/illegal item categories
- Experience suspicion, contraband heat, faction reputation, stress, lockdown, schedule, dialogue, quests, and riot escalation
- Save and load core game state
- Test a complete vertical slice scenario

---

## PROJECT RULES

- Preserve source assets.
- Preserve the current scene before major changes.
- Use real imported/purchased visible assets.
- Do not use visible primitive placeholders.
- Invisible primitive colliders are allowed and encouraged for optimization and gameplay collision.
- Do not delete original asset files from the Project folder.
- If objects must be removed from the active scene, disable or move them under backup containers instead of deleting them.
- Before placing the MMA arena, search the active scene to make sure it is not already placed. If it is already placed, do not duplicate it.
- Build systems in clean scripts under an organized Nyghtshade folder.
- Every system must have a clear test method.
- Create markdown reports documenting what was built, what was found, what remains missing, and how to test.

---

## SAFETY / FICTIONALIZATION RULE

This game may include mature prison themes, violence, corruption, contraband, riots, lockdowns, abuse, neglect, investigation, and survival systems. Implement these as fictionalized game mechanics using stats, meters, item categories, scripted events, quests, and abstract risk systems.

Use game-safe abstract systems such as:
- Item Heat
- Contraband Category
- Stash Quality
- Search Risk
- Guard Suspicion
- Staff Pressure
- Faction Control
- Riot Threat
- Barricade Strength
- Area Control
- Tactical Response Level
- Gas Exposure
- Noise Level
- Evidence Flags
- Lockdown Severity
- Escape Window

Do not implement real-world procedural tutorials. Do not write real-world crafting recipes, smuggling instructions, tactical breaching instructions, or step-by-step illegal methods. Convert all such concepts into fictional RPG stats, quests, checks, scripted events, and non-instructional mechanics.

---

## BACKUP AND SCENE PREP

1. Save the currently active scene.
2. Duplicate it to: `Assets/NYGHTSHADE_BACKUP_BEFORE_FULL_SYSTEM_BUILD.unity`
3. Create or update a working scene: `Assets/NYGHTSHADE_OPTIMIZED_MAIN.unity`
4. Work in the optimized/main working scene.

Create hierarchy roots if missing:
```
_NYGHTSHADE_WORLD_ROOT
_PLAYER_AND_CAMERA
_GAMEPLAY_SYSTEMS
_UI
_AUDIO
_LIGHTING
_PRISON_CORE
_CELL_BLOCKS
_MORGUE
_BASKETBALL_GYM
_UNITY_WAREHOUSE_MMA_FIGHT_CLUB
_CAFETERIA
_CHAPEL
_INFIRMARY
_ADMIN_CONTROL
_YARD
_GRAVE_TUNNELS
_NPCS_ACTIVE
_NPCS_BACKGROUND
_OPTIMIZED_COLLIDERS
_DISABLED_BACKUP_OBJECTS
_DISABLED_DUPLICATE_LIGHTS
_DISABLED_ORIGINAL_REPEATED_MESHES
```

---

## PHASE 1 — HARD PROJECT AUDIT BEFORE BUILD

Run a full project and active scene scan. Count and report:

- Total GameObjects (active, inactive)
- MeshRenderers, SkinnedMeshRenderers
- MeshColliders, simple colliders
- Cameras (active, Main Cameras, AudioListeners)
- Lights by type (realtime, baked, mixed, shadow-casting)
- Animators, NavMeshAgents, Rigidbodies, Terrains, ReflectionProbes, LightProbes
- Unique materials, GPU instancing material count
- Missing scripts, missing materials, pink/error materials
- Duplicate EventSystems, duplicate Main Cameras, duplicate AudioListeners
- Top repeated GameObject names and meshes
- Static batching settings, batching static count, navigation static count, occlusion static count

**Create:** `Assets/NYGHTSHADE_FULL_BUILD_INITIAL_AUDIT.md`

---

## PHASE 2 — PERFORMANCE STABILIZATION

The scene previously showed extreme object counts including over 100k objects, over 77k MeshColliders, and thousands of realtime lights. Stabilize the scene before adding more systems.

### A. LIGHTS
- Keep one primary Directional Light as the main sun/moon light.
- Allow only one active AudioListener.
- Allow only one active gameplay Main Camera.
- Reduce realtime shadow-casting lights. Convert decorative lights to baked or no-shadow lights.
- Disable obvious duplicate point lights and duplicate directional lights under `_DISABLED_DUPLICATE_LIGHTS`.
- **Target:** active realtime lights under 100, realtime shadow lights as low as possible, one main directional shadow source.

### B. COLLIDERS
- Reduce MeshColliders aggressively on repeated static tiles, walls, decorations, shelves, props, and background pieces.
- Replace gameplay-important walking/floor/wall collision with simple invisible BoxColliders under `_OPTIMIZED_COLLIDERS`.
- Keep MeshColliders only where complex collision is actually necessary.
- **Target:** MeshColliders under 1000, ideally under 300 for the vertical slice.

### C. MATERIALS
- Enable GPU Instancing on safe repeated materials.
- Preserve materials. Do not break shader assignments.
- Report how many materials were updated.

### D. RENDERERS / STATIC
- Mark static scenery as batching static/occluder/occludee/navigation static where appropriate.
- Do not mark player, NPCs, doors, interactables, pickups, physics objects, or animated objects as fully static.
- Combine repeated static meshes by logical chunks where safe.
- Move disabled originals under `_DISABLED_ORIGINAL_REPEATED_MESHES`.

**Create:** `Assets/NYGHTSHADE_PERFORMANCE_STABILIZATION_REPORT.md`

---

## PHASE 3 — MMA ARENA / UNITY WAREHOUSE FIGHT CLUB

Find the Unity Warehouse area in the scene and project. Search scene and project names for:
`Unity Warehouse, Warehouse, Warehouse_BuildingOnly, Forklift, Shelf, Shelves, Rack, Pallet, Storage, Boxes`

Find the MMA arena asset. Search scene and project names for:
`MMA, Arena, Octagon, Ring, Cage, Fight, Combat, PolyRonin, UFC`

### MMA RULES
- First check whether an MMA arena/octagon/cage is already in the active scene.
- If already in scene: report its hierarchy path, position, rotation, scale, and whether it is inside the warehouse. If correctly inside the warehouse, keep it and optimize around it. If it exists but is not inside the warehouse, move it into the cleared warehouse if safe.
- If it does not exist in the scene, locate the best real prefab/scene asset and place it into the warehouse.
- Do not create a primitive placeholder arena.
- Center the arena naturally on the warehouse floor. Keep walking space around it. Make sure it is not floating, underground, intersecting walls, or blocking all paths.

### WAREHOUSE CONVERSION
- Remove/disable forklifts from the active warehouse scene.
- Remove/disable shelves, racks, pallets, and shelf contents from the central floor area.
- Move disabled clutter under: `_DISABLED_BACKUP_OBJECTS/_WAREHOUSE_REMOVED_FOR_MMA_ARENA`
- Preserve useful warehouse walls, floor, ceiling, doors, and structural assets.
- Use real seating/benches/chairs/crowd props if available.
- Arrange seats logically around the arena.
- Add simple invisible BoxColliders for floor/walls/arena boundaries.
- Add or optimize warehouse/fight club lighting.
- Keep the warehouse performance-safe.
- Set it up as a playable MMA/fight club gameplay zone.

**Create:** `Assets/NYGHTSHADE_MMA_WAREHOUSE_BUILD_REPORT.md`

---

## PHASE 4 — CORE PLAYABILITY FOUNDATION

### A. PLAYER
Create/verify: one Player root, working ThirdPerson controller, movement, sprint, jump, camera follow, one Main Camera, one AudioListener, input working, CharacterController or valid movement collision, spawn point.

If Starter Assets ThirdPerson exists, use the real Starter Assets player. If not, build a clean third-person controller script using the existing character model/prefab available in project assets.

Scripts under `Assets/_Nyghtshade/Scripts/Core/`:
- `NH_PlayerController.cs`
- `NH_PlayerStats.cs`
- `NH_PlayerSpawnPoint.cs`
- `NH_CameraBootstrap.cs`
- `NH_GameBootstrap.cs`

### B. PLAYER STATS
Implement: Health, Stamina, Stress, SuspicionExposure, CurrentZone, CurrentScheduleState, PlayerPathFlags

### C. CAMERA
- Only one gameplay camera active
- Follows player, does not clip badly, has reasonable sensitivity
- Can be found by bootstrap if missing

### D. PLAY MODE TEST
Test that player can spawn and walk in the scene.

**Create:** `Assets/NYGHTSHADE_PLAYER_CAMERA_PLAYABLE_REPORT.md`

---

## PHASE 5 — UNIVERSAL INTERACTION SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Interaction/`:
- `NH_IInteractable.cs`
- `NH_InteractionSystem.cs`
- `NH_InteractionPromptUI.cs`
- `NH_InteractableBase.cs`

System must support: look/raycast interaction, interaction prompt, press key to interact, object display name, interaction verb, disabled/locked interaction state, distance check, optional required item, optional quest/faction/schedule requirement, debug logging.

Interactable types: doors, pickups, NPC dialogue, stash points, evidence, readable notes, zone transitions, tunnel entrances, medical/morgue objects, fight club signup, basketball gym activities.

**Create:** `Assets/NYGHTSHADE_INTERACTION_SYSTEM_REPORT.md`

---

## PHASE 6 — INVENTORY / ITEM / CONTRABAND SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Inventory/`:
- `NH_ItemDefinition.cs`
- `NH_InventoryItem.cs`
- `NH_PlayerInventory.cs`
- `NH_ItemPickup.cs`
- `NH_ContrabandSystem.cs`
- `NH_ItemHeatCategory.cs`

Item categories: Normal, Food, Medicine, Commissary, Tool, Key, Keycard, QuestItem, Evidence, WeaponFictional, ContrabandLow, ContrabandMedium, ContrabandHigh, GRAVERelic

Core mechanics: add item, remove item, has item, item heat value, legal/illegal status, confiscation logic, quest item protection option, evidence flag option, UI/debug inventory list

Create starter item definitions under `Assets/_Nyghtshade/Data/Items/`:
- RamenPack
- CommissaryBattery
- BasicKeycard
- MorgueEvidenceFile
- ChapelNote
- GRAVEMapFragment
- LowHeatContrabandItem
- MediumHeatContrabandItem
- HighHeatContrabandItem

**Create:** `Assets/NYGHTSHADE_INVENTORY_CONTRABAND_REPORT.md`

---

## PHASE 7 — DOOR / LOCK / KEYCARD SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Doors/`:
- `NH_DoorController.cs`
- `NH_DoorLockData.cs`
- `NH_KeycardAccessLevel.cs`
- `NH_DoorState.cs`

Door states: Open, Closed, Locked, Jammed, Alarmed, LockdownSealed

Door requirements: no key, key item, keycard level, faction permission, quest flag, schedule flag, lockdown override

Features: interact to open/close, locked prompt, optional sound hook, optional animation hook, simple rotate/slide fallback, alarm trigger hook, save/load state support

Apply to obvious doors/cell doors/gates where safe.

**Create:** `Assets/NYGHTSHADE_DOOR_LOCK_SYSTEM_REPORT.md`

---

## PHASE 8 — ZONE / AREA CONTROL SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Zones/`:
- `NH_Zone.cs`
- `NH_ZoneType.cs`
- `NH_AreaControlState.cs`
- `NH_AreaControlManager.cs`

Zone types: CellBlock, Yard, Cafeteria, Kitchen, Chapel, Infirmary, Morgue, AdminControl, BasketballGym, MMAWarehouse, Warehouse, GRAVETunnel, Outside, Restricted

Area control states: Guards, Neutral, FactionControlled, RiotCrowd, TacticalResponse, LockdownSealed, GRAVEInfluence

Create/assign zones to: morgue, basketball gym, MMA warehouse, prison core/cell block, chapel, cafeteria, infirmary, yard, GRAVE tunnel entrance if found.

**Create:** `Assets/NYGHTSHADE_ZONE_AREA_CONTROL_REPORT.md`

---

## PHASE 9 — FACTION / REPUTATION SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Factions/`:
- `NH_FactionDefinition.cs`
- `NH_FactionManager.cs`
- `NH_FactionStanding.cs`
- `NH_FactionTerritory.cs`
- `NH_FactionRiotStance.cs`

Faction stats: Respect, Fear, Trust, Debt, Heat, Hostility, Protection, TerritoryControl, WarStatus

Faction types: InmateFaction, GuardFaction, Medical, Chapel, Admin, OldGuard, GRAVE

Starter factions: HollowKings, CrimsonVerdict, BlackLanternMob, SewerRats, Administration, CorrectionalOfficers, MedicalDepartment, ChapelFlock, OldGuard, GRAVEUnknown

System must support: get standing, modify standing, territory owner, faction hostility, faction protection, quest hooks, dialogue hooks, riot stance.

**Create:** `Assets/NYGHTSHADE_FACTION_SYSTEM_REPORT.md`

---

## PHASE 10 — NPC / AI FOUNDATION

Scripts under `Assets/_Nyghtshade/Scripts/NPC/`:
- `NH_NPCIdentity.cs`
- `NH_NPCBrain.cs`
- `NH_NPCState.cs`
- `NH_NPCRole.cs`
- `NH_NPCScheduleAgent.cs`
- `NH_NPCRiotState.cs`
- `NH_NPCRelationshipMemory.cs`

NPC roles: Inmate, Guard, Nurse, Doctor, Teacher, Preacher, Warden, KitchenWorker, Janitor, Visitor, TacticalResponse, BackgroundNPC, GRAVEEntity

NPC states: Idle, Patrol, Working, Eating, YardTime, Talking, Suspicious, Searching, Fleeing, Hiding, FightingAbstract, Injured, Surrendered, GuardingArea, LockdownPosition, RiotActive, Negotiating

Use NavMeshAgent where available. Keep background NPCs lightweight. Do not activate expensive AI for every background character.

**Create:** `Assets/NYGHTSHADE_NPC_AI_FOUNDATION_REPORT.md`

---

## PHASE 11 — GUARD SUSPICION / SEARCH / LOCKDOWN SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Security/`:
- `NH_GuardSuspicionSystem.cs`
- `NH_SearchSystem.cs`
- `NH_LockdownManager.cs`
- `NH_RestrictedZone.cs`
- `NH_AlarmSystem.cs`
- `NH_GuardResponseLevel.cs`

Suspicion increases from: entering restricted zone, carrying high heat item, ignoring schedule, being near violence event, entering GRAVE/tunnel area, opening alarmed door, failing search, being seen during lockdown.

Search system: search thoroughness, item heat check, confiscation, suspicion increase, faction consequences, evidence exceptions, debug test command.

Lockdown triggers: alarm door, missing tool event, faction violence event, riot flashpoint, suspicious death/morgue evidence, GRAVE breach, player-triggered security event.

Lockdown effects: doors lock, zones restricted, guards change state, NPCs move/freeze/flee, sirens/audio hook, lights hook, UI warning, save/load state.

**Create:** `Assets/NYGHTSHADE_SECURITY_LOCKDOWN_REPORT.md`

---

## PHASE 12 — SCHEDULE / DAILY ROUTINE SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Schedule/`:
- `NH_PrisonScheduleManager.cs`
- `NH_ScheduleBlock.cs`
- `NH_ScheduleState.cs`

Schedule blocks: WakeUp, Count, Breakfast, WorkPrograms, Yard, Lunch, MedicalPrograms, Recreation, Dinner, EveningMovement, LockIn, Night, DeepNight

System must: track current day/time, advance time, broadcast schedule changes, affect NPCs, affect zone access, affect quest availability, affect guard suspicion, save/load time.

**Create:** `Assets/NYGHTSHADE_SCHEDULE_SYSTEM_REPORT.md`

---

## PHASE 13 — STASH / ECONOMY / SURVIVAL SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Survival/`:
- `NH_StashPoint.cs`
- `NH_StashQuality.cs`
- `NH_PrisonEconomyManager.cs`
- `NH_BarterValue.cs`
- `NH_SurvivalStatus.cs`

Stash point types: PersonalCellStash, CommonAreaStash, YardStash, KitchenLaundryStash, ChapelStash, MedicalStash, TunnelStash, FactionCache

Stash mechanics: capacity, quality, discovery risk, degradation risk, faction owner, search result, informant risk as abstract stat, confiscation consequences.

Economy: commissary value, favor value, debt, protection payment, faction price multiplier, barter exchange, item heat affects value.

**Create:** `Assets/NYGHTSHADE_STASH_ECONOMY_SURVIVAL_REPORT.md`

---

## PHASE 14 — DIALOGUE / QUEST / STORY FLAG SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Dialogue/`:
- `NH_DialogueNode.cs`
- `NH_DialogueChoice.cs`
- `NH_DialogueRunner.cs`
- `NH_DialogueCondition.cs`

Scripts under `Assets/_Nyghtshade/Scripts/Quests/`:
- `NH_QuestDefinition.cs`
- `NH_QuestManager.cs`
- `NH_QuestState.cs`
- `NH_QuestObjective.cs`
- `NH_StoryFlagManager.cs`

Dialogue supports: NPC name, text, choices, faction checks, item checks, quest checks, schedule checks, story flags, consequences.

Quest states: NotStarted, Available, Accepted, InProgress, ReadyToComplete, Completed, Failed, Hidden.

Starter quests:
- **Morgue Evidence:** discover suspicious morgue evidence, update story flag, connect to medical/admin/GRAVE mystery
- **Fight Club Initiation:** locate MMA warehouse, sign up, gain faction reputation
- **Basketball Gym Tension:** enter gym during recreation, witness faction conflict, choose to avoid/mediate/escalate
- **First Lockdown:** trigger or witness security event, survive lockdown
- **GRAVE First Whisper:** find first tunnel clue, unlock tunnel story flag

**Create:** `Assets/NYGHTSHADE_DIALOGUE_QUEST_STORY_REPORT.md`

---

## PHASE 15 — MEDICAL / MORGUE SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Medical/`:
- `NH_MedicalRequestSystem.cs`
- `NH_MorgueEvidence.cs`
- `NH_CustodyDeathCase.cs`
- `NH_MedicalNeglectMeter.cs`

Features: medical request, triage suspicion as abstract stat, injury treatment, mental stress event, morgue evidence objects, autopsy note evidence item, hidden report quest hook, medical staff NPC hooks, lockdown/riot trigger from suspicious death, GRAVE mystery connection.

Find morgue in scene. Attach interactable evidence where appropriate. Use real morgue assets already in scene.

**Create:** `Assets/NYGHTSHADE_MEDICAL_MORGUE_SYSTEM_REPORT.md`

---

## PHASE 16 — CHAPEL / KITCHEN / EDUCATION / ADMIN SYSTEMS

Scripts under `Assets/_Nyghtshade/Scripts/Facility/`:
- `NH_ChapelSystem.cs`
- `NH_KitchenSystem.cs`
- `NH_EducationProgramSystem.cs`
- `NH_AdminPressureSystem.cs`
- `NH_WardenPolicySystem.cs`

Chapel: safe zone, spiritual quest hook, faction meeting risk abstracted, GRAVE/Marrow Church story hook.

Kitchen: meal schedule, food quality, hunger effect, kitchen access, missing tool lockdown event abstracted, faction control.

Education: program enrollment, skill/progress report, teacher trust, program shutdown risk.

Admin/Warden: budget pressure, scandal heat, lockdown authorization, inmate liaison committee as abstract event, reform/corruption path flags.

**Create:** `Assets/NYGHTSHADE_FACILITY_SYSTEMS_REPORT.md`

---

## PHASE 17 — MMA / BASKETBALL / RECREATION GAMEPLAY

Scripts under `Assets/_Nyghtshade/Scripts/Recreation/`:
- `NH_BasketballGymSystem.cs`
- `NH_MMAFightClubSystem.cs`
- `NH_FightRegistration.cs`
- `NH_FightOutcomeResolver.cs`
- `NH_CrowdNoiseSystem.cs`

Basketball gym: recreation zone, schedule access, faction tension, crowd noise, guard attention, conflict event hook.

MMA warehouse: fight registration, opponent selection placeholder data, abstract fight outcome resolver, stamina/health/faction reputation effects, fight club rank, crowd noise, guard raid/lockdown event hook, arena boss fight data hooks.

No need for advanced combat animations yet if not available. Use abstract fight resolution first, then leave hooks for real combat.

**Create:** `Assets/NYGHTSHADE_RECREATION_MMA_BASKETBALL_REPORT.md`

---

## PHASE 18 — RIOT / SECURITY RESPONSE SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Riot/`:
- `NH_RiotManager.cs`
- `NH_RiotPhase.cs`
- `NH_RiotTrigger.cs`
- `NH_RiotAreaObjective.cs`
- `NH_BarricadePoint.cs`
- `NH_TacticalResponseSystem.cs`
- `NH_GasExposureZone.cs`
- `NH_RiotPlayerPathResolver.cs`

Riot phases: Phase0_RisingTension, Phase1_Flashpoint, Phase2_InitialSurge, Phase3_AreaControlShift, Phase4_FactionPowerStruggle, Phase5_WardenNegotiation, Phase6_TacticalResponse, Phase7_Aftermath.

Riot triggers: bad food quality, medical neglect scandal, excessive lockdowns, faction assassination abstract event, guard brutality story event, canceled visitation story event, heat wave/power outage, morgue evidence discovered, GRAVE tunnel breach, player-caused escalation.

Area control: update zone ownership/control, affect NPC behavior, affect doors/lockdown, affect quests, affect player path.

Barricade system: barricade strength, breach time, noise generated, required response level, AI pathing blocker hook, player can reinforce/bypass/sabotage/avoid through abstract interactions.

Tactical response levels: Level0 normal, Level1 extra guards, Level2 lockdown, Level3 sweep, Level4 response staged, Level5 resolution event.

Gas/visibility/status: GasExposure as gameplay status, stamina drain, visibility blur hook, stress increase, safe zone checks, surrender/hide/negotiate/escape choices.

Player path impact:
- Float Through: survive/hide/avoid blame
- Escape Artist: use escape window
- Yard King: control areas/negotiate
- Investigator: access evidence
- Redeemer: rescue/de-escalate
- GRAVE Truth Seeker: hidden routes/events

**Create:** `Assets/NYGHTSHADE_RIOT_SECURITY_RESPONSE_REPORT.md`

---

## PHASE 19 — GRAVE / HORROR / TUNNEL SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/GRAVE/`:
- `NH_GRAVEManager.cs`
- `NH_TunnelEntrance.cs`
- `NH_DarknessZone.cs`
- `NH_FearStressEvent.cs`
- `NH_GRAVEClue.cs`
- `NH_TunnelDiscoveryMap.cs`

Features: tunnel entrance interactable, locked/unlocked by story flag, darkness/stress zone, clue collection, map fragment collection, strange event trigger, morgue/chapel/admin evidence connection, escape path hook, riot breach hook.

**Create:** `Assets/NYGHTSHADE_GRAVE_TUNNEL_SYSTEM_REPORT.md`

---

## PHASE 20 — UI SYSTEMS

Scripts under `Assets/_Nyghtshade/Scripts/UI/`:
- `NH_UIManager.cs`
- `NH_InteractionPromptWidget.cs`
- `NH_PlayerHUD.cs`
- `NH_InventoryUI.cs`
- `NH_QuestJournalUI.cs`
- `NH_FactionUI.cs`
- `NH_ScheduleUI.cs`
- `NH_LockdownWarningUI.cs`
- `NH_RiotDebugUI.cs`
- `NH_DebugOverlay.cs`

UI must show: interaction prompt, health, stamina, stress, suspicion, contraband heat, current zone, current schedule block, lockdown status, riot phase if active, quest updates, basic inventory list, faction reputation debug screen, FPS/performance debug overlay.

Create Canvas if missing. Use simple Unity UI elements. Name UI clearly. Do not create excessive UI duplicates.

**Create:** `Assets/NYGHTSHADE_UI_SYSTEM_REPORT.md`

---

## PHASE 21 — AUDIO HOOKS

Scripts under `Assets/_Nyghtshade/Scripts/Audio/`:
- `NH_AudioManager.cs`
- `NH_AmbienceZone.cs`
- `NH_EventAudioTrigger.cs`

Audio categories: cell block ambience, guard keys, PA announcements, doors, alarms, fluorescent buzz, cafeteria noise, basketball gym echo, MMA crowd, morgue ambience, chapel ambience, warehouse ambience, tunnel whispers, rain/wind outside, riot crowd, lockdown siren.

Use existing audio assets if found. If not found, create hooks and report missing audio assets.

**Create:** `Assets/NYGHTSHADE_AUDIO_HOOKS_REPORT.md`

---

## PHASE 22 — SAVE / LOAD SYSTEM

Scripts under `Assets/_Nyghtshade/Scripts/Save/`:
- `NH_SaveManager.cs`
- `NH_SaveData.cs`
- `NH_ISaveable.cs`
- `NH_SaveableObject.cs`

Save: player position, player stats, inventory, item heat, current day/time, zone/control states, faction standings, NPC relationship memory critical states, quest states, story flags, door states, stash states, lockdown state, riot phase/state, GRAVE discovered clues, evidence collected.

Add debug keys or menu buttons: Save Game, Load Game, New Game Reset.

**Create:** `Assets/NYGHTSHADE_SAVE_LOAD_SYSTEM_REPORT.md`

---

## PHASE 23 — DEV TOOLS / VALIDATION

Scripts under `Assets/_Nyghtshade/Scripts/DevTools/`:
- `NH_SceneAuditTool.cs`
- `NH_OptimizationValidator.cs`
- `NH_MissingReferenceScanner.cs`
- `NH_OneClickPlayableProof.cs`
- `NH_BuildReadinessReport.cs`

Tools must check: duplicate Main Cameras, duplicate AudioListeners, missing scripts, missing materials, pink/error materials, total GameObjects, active renderers, MeshColliders, realtime lights, shadow lights, player exists, camera exists, EventSystem exists, UI exists, save manager exists, interaction system exists, quest manager exists, faction manager exists, lockdown manager exists, riot manager exists, MMA warehouse placed, morgue exists, basketball gym exists, GRAVE tunnel entrance exists if assets found, scene playability readiness.

Create menu items:
- `Nyghtshade/Run Full Audit`
- `Nyghtshade/Validate Playable Scene`
- `Nyghtshade/Generate Build Readiness Report`
- `Nyghtshade/Run Performance Counts`

**Create:** `Assets/NYGHTSHADE_DEVTOOLS_VALIDATION_REPORT.md`

---

## PHASE 24 — VERTICAL SLICE SCENARIO

Create a playable test scenario named: `NYGHTSHADE_VERTICAL_SLICE_01`

Scenario requirements:
- Player spawns in or near prison block.
- Player can move and camera follows.
- Player can interact with at least one door.
- Player can pick up at least one item.
- Player can pick up one evidence item.
- Player can trigger a suspicion increase.
- Player can trigger or witness a lockdown test event.
- Player can enter or identify morgue zone.
- Player can enter or identify basketball gym zone.
- Player can enter or identify MMA warehouse fight club.
- Player can use fight club signup interactable.
- Player can receive one quest.
- Player can modify faction reputation.
- Player can find one GRAVE clue or tunnel entrance if present.
- Player can save and load.

Create test objects only where necessary and keep visible objects real imported assets. Use invisible trigger volumes/colliders freely.

**Create:** `Assets/NYGHTSHADE_VERTICAL_SLICE_01_REPORT.md`

---

## PHASE 25 — FINAL AUDIT AFTER BUILD

After building, run a final full audit.

**Create:** `Assets/NYGHTSHADE_FULL_BUILD_FINAL_AUDIT.md`

Include:
- Before/after GameObject counts
- Before/after renderer counts
- Before/after MeshCollider counts
- Before/after realtime light counts
- One Main Camera confirmed
- One AudioListener confirmed
- Systems built
- Systems found existing
- Systems still missing
- Scene paths, script paths, prefab/data paths
- UI created
- Test instructions
- Known issues
- Next recommended build tasks

---

## FINAL REQUIRED DELIVERABLES

| Deliverable | Type |
|---|---|
| `Assets/NYGHTSHADE_BACKUP_BEFORE_FULL_SYSTEM_BUILD.unity` | Scene backup |
| `Assets/NYGHTSHADE_OPTIMIZED_MAIN.unity` | Working scene |
| `Assets/_Nyghtshade/Scripts/` | All systems organized |
| `Assets/_Nyghtshade/Data/` | Item/faction/quest starter data |
| MMA warehouse fight club placed and playable | Scene |
| Morgue evidence gameplay hook | System |
| Basketball gym recreation hook | System |
| Player/camera playable | Core |
| Interaction system working | Core |
| Inventory/contraband working | Core |
| Door/lock system working | Core |
| Zone/area control working | Core |
| Faction/reputation working | Core |
| NPC foundation working | Core |
| Guard suspicion/search/lockdown working | Security |
| Schedule working | Core |
| Stash/economy/survival working | Prison |
| Dialogue/quest/story flags working | RPG |
| Medical/morgue system working | Prison |
| Chapel/kitchen/education/admin hooks working | Facility |
| MMA/basketball recreation systems working | Recreation |
| Riot/security response system working | Advanced |
| GRAVE/tunnel system working | Horror/Mystery |
| UI/HUD/debug overlay working | UI |
| Audio hooks working | Audio |
| Save/load working | Core |
| Dev validation tools working | Tools |
| Vertical slice scenario created | Test |
| Final audit report created | Report |
| Play Mode tested and reported | Test |

---

## FINAL COMMAND TO AGENT

Work continuously through the phases. If any asset, prefab, script, or scene object is missing, create the code/data hook and clearly report the missing art/audio/animation dependency instead of stopping. Prioritize a working playable vertical slice over perfect polish. Save often. Report every completed phase.

The reports that matter most when done:
- `NYGHTSHADE_FULL_BUILD_FINAL_AUDIT.md`
- `NYGHTSHADE_VERTICAL_SLICE_01_REPORT.md`
- `NYGHTSHADE_PERFORMANCE_STABILIZATION_REPORT.md`
- `NYGHTSHADE_MMA_WAREHOUSE_BUILD_REPORT.md`
