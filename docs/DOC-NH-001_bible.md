# DOC-NH-001 // DESIGN BIBLE // GOLD MASTER

**CODENAME:** CLAWED · UE 5.6 / 5.7 · DEC 2026
**THE ARCHITECT:** BARRY LEE GIER
**VERSION:** v1.0 · GOLD
**TAGLINE:** A PRISON THAT REMEMBERS YOU.

> In a prison that remembers you, every conversation is a move, every cigarette is a bullet, and freedom lives twenty stories down.

## § 00 — COVER

**THE NYGHTSHADE HOLLOW.** — CLASSIFIED

| Metric | Value | Detail |
|---|---|---|
| NPCs | 82 | With Big Five + Memory |
| Factions | 55 | Dynamic relationships |
| Housing | 10 | Units A–J |
| GRAVE | 20 | Stories down |

NYGHTSHADE STATE PENITENTIARY · EST. UNKNOWN · CLASS MAX · DOC-NH
Octagonal compound · 137m inradius · 8 guard towers

Section order: § 01 BRAND → § 02 PALETTE → § 03 TYPE → § 04 COMPOUND → § 05 GRAVE → § 06 FACTIONS → § 07 ROSTER → § 08 UI → § 09 KIT → § 10 TOKENS

---

## § 01 — BRAND IDENTITY

**THE WORDMARK & MARKS**

The Y is the brand — archaic, deliberate, ownable. The octagon is the world. Everything reads monochrome; color is discipline, not decoration.

### 01.A · PRIMARY WORDMARK — STACKED
THE / NYGHTSHADE / HOLLOW.
Big Shoulders Stencil Display · 700
Safe area = cap-height of Y

### 01.B · ICON MARK
32px ready · Y mark, four variants

### 01.C · MONOCHROME LOCKUP
NYGHTSHADE

### 01.D · THE Y
The Y replaces the I in NIGHT. Lexical mis-pronunciation is the point — the world has been misread, misfiled, and misremembered. The Y is always crimson when color is available.

### 01.E · CLEAR SPACE & MIN SIZE
- Clear space = height of Y
- Min. wordmark = 96px wide
- Min. icon mark = 16px (favicon)
- Never tilt, never italic, never stretch

### 01.F · DO / DON'T
- ✓ Crimson Y
- ✗ Never serif
- ✓ Stencil
- ✗ Off-palette

If a surface can't hold crimson, the mark goes fully bone. Never substitute gold, white, or mixed accents.

---

## § 02 — PALETTE

**MATTE BLACK. DRIED BLOOD.**

No saturated brights. No neons. Eight core neutrals for the compound; seven accents for drama. If a color isn't on this page, it isn't in the game.

| # | Name | Hex | Token | Use |
|---|---|---|---|---|
| 01 | VOID | #050507 | nh.void | Outer margin, letterbox |
| 02 | BLACK | #0A0A0B | nh.black | Matte black base |
| 03 | ASPHALT | #111114 | nh.asphalt | Surface, cards |
| 04 | CONCRETE | #1A1A1C | nh.concrete | Elevated surface |
| 05 | REBAR | #2A2A2D | nh.rebar | Borders, dividers |
| 06 | DUST | #44444A | nh.dust | Muted body |
| 07 | BONE | #C9C3B5 | nh.bone | Primary foreground |
| 08 | PAPER | #E8E2D4 | nh.paper | Parchment / journal |
| 09 | CRIMSON | #8B0A1A | nh.crimson | Dried blood · primary accent |
| 10 | CRIMSON HOT | #C41E2E | nh.crimson.hot | Fresh blood · alarm |
| 11 | CRIMSON DEEP | #4A0610 | nh.crimson.deep | Old blood · shadow |
| 12 | AMBER | #D4A03C | nh.amber | Sodium lamp · warning |
| 13 | AMBER DIM | #7A5C20 | nh.amber.dim | Low-priority caution |
| 14 | INST. GREEN | #4A5948 | nh.inst.green | Institutional signage |
| 15 | RUST | #7A3419 | nh.rust | Oxidation · corrosion |

**KEEP-OFF:** Neon greens, electric blues, saturated pinks — never. Any HUD element that needs to "pop" uses crimson-hot or amber, not a new hue.

### 02.B · STATE MAPPING — FACTION & NPC STATUS
- **ALLIED** — Faction at peace · NPC trusts player
- **NEUTRAL** — No memory events · no reputation
- **HOSTILE** — Rep below 0 · will refuse/attack
- **AT WAR** — Active violence this cycle
- **PLAYER** — Your thread · your marker

Texture motifs: Crimson wall stripes · Scan lines · Concrete grain · Stencil numerals

---

## § 03 — TYPOGRAPHY

**FIVE VOICES. ONE PRISON.**

Cold institutional type on the system side. Scrawled human type on the player side. The friction between them is the brand.

### 03.A · DISPLAY / WORDMARK — Big Shoulders Stencil Display · 700
Sizes: 140 / 96 / 64 / 40 / 24 / 14 px

### 03.B · UI / INSTITUTIONAL VOICE — JetBrains Mono
Always uppercase, always tracked wide (0.18em). PA announcements, HUD chrome, guard commands, signage.
Examples: `COUNT 04:00` · `BLOCK C LOCKED` · `CONTRABAND +17`

### 03.C · BODY / INFORMATIONAL — Inter
Regular 400 · Medium 500 · Bold 700

> Prison Credits are earned through work details, commissary labor, and good behavior. Cigarettes move through hand, pocket, mattress. One gets tracked. The other gets counted.

### 03.D · HAND / PLAYER-SIDE — Caveat
Diegetic player content only — journal entries, scrap-paper maps, wall scratches, tattoo captions. Never UI chrome.
- *Bridgette knows.*
- *Trust Valentino.*
- *Grave-level 17 is flooded.*

### 03.E · SERIF / LORE & QUOTES — EB Garamond
Found documents, chapter epigraphs, press-kit copy. Never HUD.

> "A prison is not a place. It is a relationship between a man and a memory. The Hollow remembers."
> — HARRINGTON MARLOWE, LIFER, 85

### 03.F · TYPE SCALE
Round to 8px multiples where possible.

| Token | px | Use | Stack | Tracking |
|---|---|---|---|---|
| --nh-size-marquee | 140 | Hero wordmark | DISPLAY | -0.02em |
| --nh-size-h1 | 72 | Section titles | DISPLAY | -0.01em |
| --nh-size-h2 | 40 | Sub-titles | DISPLAY | 0 |
| --nh-size-h3 | 24 | Card titles | UI / DISPLAY | 0.08em |
| --nh-size-lead | 19 | Lead paragraph | BODY | 0 |
| --nh-size-body | 16 | Body copy | BODY | 0 |
| --nh-size-mono-md | 14 | HUD label | UI | 0.18em |
| --nh-size-mono-sm | 12 | Meta / byline | UI | 0.18em |
| --nh-size-mono-xs | 10 | Footnote / classification | UI | 0.18em |

---

## § 04 — THE COMPOUND

**OCTAGONAL. 137m INRADIUS.**

Eight segments. Eight towers. Ten housing units, west and east of a 120m spine corridor. The Warden Tower rises 80m at the north. You cannot escape what you can see from everywhere.

### 04.A · PLAN VIEW — SURFACE (Scale 1:800)
- Housing A–J
- Warden Tower 80m (north)
- Yards SW / SE / NW / NE
- Guard towers T1–T8
- DWG NH-04.A · R0
- Perimeter 900ft · 8 towers · 10 housing units
- Phase 1 QA resolved — Option C

### 04.B · LEGEND
| Element | Spec |
|---|---|
| Housing A–J | 22×30×6m ea. |
| Guard Tower | 8 × 4×4m |
| Warden Tower | 80m · 20 floors |
| Sec. Fence | 4.4m tall · 250m |
| Yard (4 sec.) | NW / NE / SW / SE |

### 04.C · SPINE BUILDINGS
S01 ADMIN · S02 MEDICAL · S03 CHAPEL · S04 CAFETERIA · S05 LIBRARY · S06 WORKSHOP · S07 COMMISSARY · S08 GYM · S09 PSYCH · S10 VISITATION

### 04.D · NON-NEGOTIABLE FACTS
- Octagonal perimeter 137m inradius, 5.49m wall, 0.6m thick
- Warden Tower 12×12m footprint, dark glass, crimson band every 5 floors
- Spine corridor 6×120×4m, splits north housing from south
- Security fence at y=0, checkpoints at x=±40

---

## § 05 — G.R.A.V.E.

**TWENTY STORIES DOWN.**

GRAVE — Government Riot Assault & Violent Engagement. The sub-game beneath the sub-game. Twenty levels of faction-controlled tunnel, each with its own rules, water table, and way to die.

### 05.A · STRATA · CROSS-SECTION (0m → -80m)

**SURFACE** — Compound · Yards · Housing · 0m

| Level | Name | Hazard |
|---|---|---|
| -01 | GUARD PATROL | LOW |
| -02 | MAINTENANCE | LOW |
| -03 | BROS. CALLAHAN | LOW |
| -04 | IRON CHAPEL | LOW |
| -05 | COMMISSARY RUN | LOW |
| -06 | BRAXTON SHRINE | MED |
| -07 | BLACK MARKET | MED |
| -08 | BOXCAR CULT | MED |
| -09 | KILN KINGS | MED |
| -10 | TUNNEL RATS | MED |
| -11 | GHOST BIKE (BRANDON) | HIGH |
| -12 | QUARANTINE — SEALED | HIGH |
| -13 | WATER TABLE | HIGH |
| -14 | HOLLOWED | HIGH |
| -15 | DIG-13 | HIGH |
| -16 | MARROW CHURCH | LETHAL |
| -17 | THE PARLIAMENT | LETHAL |
| -18 | DEEP-17 · FLOODED | LETHAL |
| -19 | THE VEIN | LETHAL |
| -20 | BEDROCK — LOCKED | LETHAL |

BEDROCK · SEALED · ESCAPE ROUTE

### 05.B · HAZARD LADDER
LOW → MED → HIGH → LETHAL. Hazard rating blends faction hostility, water ingress, oxygen, LLM-driven patrol density, and structural stability. Descending without a Tier-3 ally is suicide past -10.

### 05.C · KEY NODES
- **-3 BROS. CALLAHAN** — Lee's half-brother works this line. Safe. For now.
- **-11 GHOST BIKE — BRANDON** — Memorial. The player places a candle to advance memory arc.
- **-15 DIG-13** — Tunnel crew. Quest-gated. Contraband flows here.
- **-17 DEEP-17 · FLOODED** — Rebreather required. Pre-Hollow maintenance levels.
- **-20 BEDROCK** — One of three escape endings terminates here.

### 05.D · BRAND RULE
GRAVE is never drawn in plan view. Always strata. The player experiences depth; marketing shows depth.

---

## § 06 — FACTIONS (55)

**GENERATIVE SIGIL SYSTEM**

Fifty-five faction sigils — not hand-drawn, but generated from a fixed grammar. 4 archetypes × 5 fills × 5 modifiers = 100 legible combinations. Every faction shares DNA; none look identical.

- **06.A · Archetype (×4):** GANG · RELIGIOUS · WORK · AUTHORITY
- **06.B · Fill (×5):** SOLID · STRIPES · STIPPLE · HATCH · NEGATIVE
- **06.C · Modifier (×5):** STAR · CROWN · CROSS · CHAIN · BLADE

### Sample roster
| Faction | Location | Status |
|---|---|---|
| KILN KINGS | Housing F · Workshop | HOSTILE |
| MARROW CHURCH | Chapel · GRAVE -16 | NEUTRAL |
| DIG-13 | GRAVE -15 | ALLIED |
| THE PARLIAMENT | Admin · Warden Tower | HOSTILE |
| BOXCAR CULT | GRAVE -08 | AT WAR |
| TUNNEL RATS | GRAVE -10 | NEUTRAL |
| BRAXTON'S FLOCK | Psych Ward · Chapel | ALLIED |
| G.R.A.V.E. SQUAD | All levels · raids | HOSTILE |

### 06.D · System Rule
All 55 factions are generated with archetype × fill × modifier and tinted from the locked accent palette. Any new faction added must fit the grammar — no one-offs.

---

## § 07 — NPC ROSTER (82)

**ONE CARD. EVERY BODY.**

The dossier component is fixed: portrait slot · register · tier · faction sigil · Big Five radar · last three memory events. Every one of the 82 NPCs fills this shape.

### Dossier — REG-0001 · CALLAHAN, Valentino — "The Warden"
- Faction: THE PARLIAMENT · AUTHORITY
- Tier: 4 · Multi-agent
- Big Five: OCEAN radar
- Memory (recent 3):
  - [D-41] PLAYER REFUSED AUDIENCE. NOTED.
  - [D-39] INTERCEPTED CIGARETTE LEDGER
  - [D-37] HALF-BROTHER DOSSIER SEALED

### Dossier — REG-0237 · RADCLIFFE, Damian — "Six-Nine"
- Faction: KILN KINGS · GANG LIEUTENANT
- Tier: 3 · Single LLM
- Big Five: OCEAN radar
- Memory (recent 3):
  - [D-40] PLAYER SHARED SMOKE. +2 RESPECT.
  - [D-38] WITNESSED YARD FIGHT, STAYED BACK
  - [D-36] OFFERED PROTECTION — 4 SMOKES/WK

### Dossier — REG-0001-B · MARLOWE, Harrington — "The Lifer"
- Faction: MARROW CHURCH · ELDER
- Tier: 3 · Single LLM
- Big Five: OCEAN radar
- Memory (recent 3):
  - [D-41] PLAYER ASKED ABOUT 1974
  - [D-38] GAVE GRAVE-03 ACCESS TOKEN
  - [D-34] RECITED BRAXTON'S RITE UNPROMPTED

### 07.B · INTELLIGENCE TIERS
| Tier | Name | Tech | Count |
|---|---|---|---|
| T1 | AMBIENT | Behavior Tree | ~48 NPCs |
| T2 | NAMED MINOR | BT + Rule Engine | ~22 NPCs |
| T3 | FEATURED | Single-agent LLM | ~9 NPCs |
| T4 | STORY-CRIT | Multi-agent graph | ~3 NPCs |

---

## § 08 — DIEGETIC UI

**EVERY PANEL IS AN OBJECT.**

Five mandatory surfaces. Each exists inside the fiction — a clipboard, a receipt, a scrap map, an intercom panel, a journal. When a system needs a new UI, it becomes an object first.

### 08.A · QUEST LOG (clipboard)
DOC-NH · WORK ASSIGNMENT · D-41 · REG-0237
DELIVER — 03 CARTONS · GRAVE LEVEL 03 · BROS. CALLAHAN · 22:00
- OBJ-01 Tunnel to -03 via boiler
- OBJ-02 Exchange for 12 credits
- OBJ-03 Return by Count 04:00
APPROVED · *Don't trust G.*

### 08.B · INVENTORY (commissary receipt)
BARRIO COMMISSARY · NH-STATE · CYCLE D-41 · 14:22 · REG-0237

| Item | Qty | Unit | Total |
|---|---|---|---|
| COFFEE, INSTANT | 02 | 0.80 | 1.60 |
| SOAP, BAR | 01 | 0.25 | 0.25 |
| TOP TOBACCO 1/2oz | 01 | 4.00 | 4.00 |
| ROLLING PAPER | 02 | 0.10 | 0.20 |
| NOODLE, RAMEN | 04 | 0.30 | 1.20 |
| TUNA POUCH | 02 | 1.40 | 2.80 |
| PENCIL, #2 | 01 | 0.15 | 0.15 |

- SUBTOTAL PC: 10.20
- PAID · PRISON CREDITS: 10.20
- TRADE · CIGARETTES: ── 04 ──
- BAL. PC: 147.80
- BAL. CIGS: 22
- *-- NO REFUNDS · NO FAVORS --*

### 08.C · MAP (scrap paper)
W yard · A–E · F–J · GRAVE -03 · boiler · *cameras dead 22:00–22:20*

### 08.D · DIALOGUE · INTERCOM
CH-07 · WARDEN TOWER · VALENTINO · TIER 4
> YOU TOOK A SMOKE FROM DAMIAN.
> I NOTICED.
> ▌
1. DENY IT.
2. AGREE. ASK WHAT HE WANTS.
3. [INTIMIDATE · -10 REP] TRY ME.

### 08.E · JOURNAL (tabs: FAC · GRV · NPC · MAP)
D-41 · after count
*Valentino asked about Larry Joe. He knows suspects. GRAVE -17 flooded. Rebreather w/ Damian.*
NPC: Bridgette

### 08.F · UI RULE
Dual currency must appear together on every economy surface. Prison Credits and Cigarettes are never shown in isolation — the tension is the mechanic.

---

## § 09 — MARKETING KIT

**PUBLISHER-READY.**

Every marketing surface assembled from the locked palette, type stack, and octagon/Y motif. No new colors, no new fonts. Built to scale from 32px favicon to 2K marquee.

- **09.A · Steam Capsule (460×215):** NYGHTSHADE HOLLOW. · "A PRISON THAT REMEMBERS YOU"
- **09.B · Social Tiles:** 1080×1080 and 1200×630 · Y mark · NYGHTSHADE · DEC · 2026
- **09.C · Steam Header (920×430):** strata strip -01 to -20 · "COMING DECEMBER 2026 · PC / CONSOLE" · "82 NPCs. 55 factions. 20 stories down."

### 09.D · Key Art Composition Guide
- Focal NPC at lower-left third, silhouette against cold amber light
- Wordmark upper-right, 8–12% frame height, always includes the dot
- Octagon motif overlays as faint compositional guide — never solid
- Negative space > 50% — the compound is more present than people

### 09.E · Press One-Sheet (A4)
**NYGHTSHADE HOLLOW.** — A prison that remembers you. 82 AI-driven NPCs, 55 factions, 20 underground levels. No two runs the same.

| Field | Value |
|---|---|
| Genre | Prison RPG · Single-player |
| Engine | Unreal Engine 5.7 (C++) |
| Platform | PC · Console |
| Ship | December 2026 |

**Key features**
- 82 NPCs with Big Five personalities and persistent memory
- 55 dynamic factions · territory · leadership · inter-faction war
- Dual economy — Prison Credits and Cigarettes
- GRAVE — 20-story underground faction tunnels
- Tiered NPC intelligence — BT → Rules → LLM → Multi-agent

Screenshots: SCR·1 through SCR·6
Contact: DADDY-GIER · THE ARCHITECT · press@nyghtshadehollow.game

---

## § 10 — TOKENS & HANDOFF

**INFRASTRUCTURE, NOT DECORATION.**

Every value above is exported as:
- `tokens.json` — Machine-readable design tokens (colors, type, space, radius, motif rules)
- `tokens.css` — CSS variables consumed by this bible
- `UE5_UMG_tokens.md` — Slate brush naming, FLinearColor hexes, font registration notes

### 10.B · BRAND RULES — 10 COMMANDMENTS
1. No color outside core + accent palette.
2. No font outside the 5-stack (Big Shoulders · JetBrains Mono · Inter · Caveat · EB Garamond).
3. Octagon motif appears in brand mark, seal, map, capsule, tile, and press sheet.
4. Y is archaic, crimson, and present in the wordmark and favicon at all times.
5. Hairline crimson stripes recur on any surface representing compound geometry.
6. All 55 faction sigils generated from archetype × fill × modifier grammar.
7. Every NPC uses the single dossier component — portrait · register · tier · Big Five · memory.
8. Diegetic UI exists as objects — clipboard, receipt, scrap paper, intercom, journal.
9. Prison Credits and Cigarettes appear together on every economy surface.
10. GRAVE is rendered as strata (cross-section), never plan view.

---

**DOC-NH-001 · VERSION 1.0-BIBLE · GOLD MASTER**
THE ARCHITECT · BARRY LEE GIER · DADDY-GIER
SHIP · DECEMBER 2026
