# Arena and Battlefield Plan

This arena is the combat space for the [Game Plan](GAME_PLAN.md) and must support the weapons and hit detection described in the [Weapons and Technical Plan](WEAPONS_AND_TECHNICAL_PLAN.md).

## Arena design goals

Every battlefield should:

- Support readable one-versus-one combat.
- Give melee and ranged heroes useful positions.
- Avoid long hiding periods.
- Keep both spawn points fair and symmetrical.
- Make hazards visible before they become dangerous.
- Fit a short three-to-five-minute match.

## Recommended MVP arena: The Citadel Courtyard

The first battlefield should be a ruined stone courtyard. It is visually strong, easy to build from basic Parts, and does not require advanced systems.

### Layout

```text
                North Gate
        [cover]      [cover]

     Spawn A     Center     Spawn B
        [cover]      [cover]

                South Gate
```

### Required combat spaces

- Two equal-distance spawn platforms.
- Open center area for direct fights.
- Two side lanes for flanking.
- Four waist-high cover blocks.
- One raised center platform with no permanent ownership.
- Solid outer walls that prevent leaving the arena.
- Clear sightlines between the center and both spawns.

### Tactical purpose

- Knight benefits from side cover and close approaches.
- Mage benefits from the raised center platform but remains exposed.
- Rogue benefits from side lanes and flank routes.
- No hero should be able to attack the enemy spawn safely from their own spawn.

## Battlefield type 2: Arcane Foundry

A magical factory with rotating platforms, glowing channels, and timed energy vents.

### Features

- Two main bridges and one risky shortcut.
- Central platform that periodically activates.
- Visible energy vents that damage players after a warning pulse.
- Breakable crates for temporary cover.
- Strong orange and violet lighting.

### Design risk

Moving platforms and hazards add complexity. Build this only after the basic combat arena works.

## Battlefield type 3: Skybridge Monastery

A floating temple connected by narrow bridges.

### Features

- Large central temple.
- Two side bridges.
- Low walls instead of full cover.
- Wind zones that push players slightly.
- Fall boundaries that teleport defeated or displaced players back safely.

### Design risk

Knockback and falling can feel unfair. Add clear warning edges and a recovery rule before using this map in ranked play.

## Battlefield type 4: Frozen Throne

An icy arena with sliding movement and breakable ice walls.

### Features

- Large open center.
- Ice pillars that crack after repeated damage.
- Slippery side lanes.
- A throne platform used as a visual landmark, not a permanent advantage.

### Design risk

Slippery movement can make precise combat frustrating. Keep it limited to side lanes.

## Shared arena object structure

```text
Workspace
└── ActiveArena
    ├── Geometry
    │   ├── Floor
    │   ├── Walls
    │   ├── Cover
    │   └── Platforms
    ├── Spawns
    │   ├── SpawnA              (SpawnLocation or Part)
    │   └── SpawnB              (SpawnLocation or Part)
    ├── Boundaries
    │   ├── ArenaBounds         (invisible Parts)
    │   └── RecoveryZone        (invisible Part)
    ├── Objectives              (optional)
    ├── Hazards                 (optional)
    ├── Decorations
    └── ArenaConfig              (ModuleScript or attributes)
```

## Required Roblox objects

### Geometry

- Anchored `Part`s for early blockouts.
- `Model`s for grouped structures.
- `MeshPart`s only after the layout is approved.
- `Attachment`s for effects, lights, and hazard origins.
- `CollisionGroup`s for players, weapons, effects, and boundaries.

### Spawns

- Two `Part`s or `SpawnLocation`s with `SpawnId` attributes.
- `SpawnDirection` attributes for starting facing.
- An invisible safe-zone `Part` around each spawn.

### Boundaries

- Invisible anchored `Part`s around the playable space.
- `CanCollide = true` for outer walls.
- `CanQuery = true` for server validation.
- Optional recovery trigger using `Touched` or spatial checks.

### Presentation

- `Lighting` atmosphere and color correction.
- `Folder` of lights and decorative effects.
- `SoundService` ambience.
- `BillboardGui` signs only where they improve navigation.

## How to create the arena

### Phase 1: Paper layout

1. Choose the arena dimensions.
2. Mark both spawn points.
3. Draw the center route and side routes.
4. Mark cover and sightlines.
5. Check that both players have equal travel distance.

### Phase 2: Graybox

1. Create an `ArenaBuilder` server script or build the blockout manually.
2. Use plain anchored Parts with bright temporary colors.
3. Add floor, walls, spawns, cover, and boundaries.
4. Test walking, jumping, dash distance, and attack range.
5. Remove any spot where a player can become trapped.

### Phase 3: Combat test

1. Test with two players.
2. Check melee access to both spawns.
3. Check ranged sightlines and cover.
4. Check whether Rogue can flank without becoming invisible to everyone.
5. Measure whether a round ends within the target time.

### Phase 4: Art pass

1. Replace approved blockout pieces with themed models.
2. Add materials, trims, banners, lighting, and landmarks.
3. Keep collision simple even if the visual model is detailed.
4. Add ambient sound and non-gameplay particles.

### Phase 5: Optimization and polish

1. Anchor static geometry.
2. Use simple collision meshes.
3. Limit particles and dynamic lights.
4. Group map assets into clear folders.
5. Test on lower-end devices.

## Arena code plan

### `ArenaService`

Responsible for loading, resetting, and removing the active arena.

### `SpawnService`

Responsible for choosing safe spawn points, facing players correctly, and preventing spawn attacks.

### `BoundaryService`

Responsible for detecting players outside the playable area and returning them safely.

### `HazardService`

Responsible for warning, activating, damaging, and resetting hazards. Hazards must be server-authoritative.

### `MatchService`

Responsible for selecting the arena, starting rounds, locking the arena, and returning players to the lobby.

## Arena configuration

Each arena should provide:

- Arena ID.
- Display name.
- Map model reference.
- Spawn locations.
- Boundary dimensions.
- Match lighting preset.
- Hazard list.
- Recommended player count.
- Whether the arena is approved for ranked play.

## What belongs in the MVP

- Citadel Courtyard only.
- Static geometry.
- Two spawn points.
- Center and side routes.
- Four cover pieces.
- Outer boundary.
- No moving platforms.
- No environmental damage.
- No breakable objects.

Add hazards and advanced geometry only after the basic arena produces fair, enjoyable matches.
