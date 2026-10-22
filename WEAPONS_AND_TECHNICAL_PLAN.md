# Weapons and Technical Plan

This connects the visual designs and character components to the [Game Plan](GAME_PLAN.md), [Arena Design](ARENA_DESIGN.md), and [MVP Checklist](MVP.md).

## Design rule

Weapons are visual equipment. The server owns the actual damage, hit detection, cooldowns, and status effects.

The client requests an attack; it never decides whether an enemy was hit.

## Weapon categories

### Knight sword and shield

Objects needed:

- `Model` named `Sword`.
- `Handle` part for attachment.
- Blade and guard meshes or Parts.
- `Attachment` named `GripAttachment`.
- `Model` named `Shield`.
- Shield `Handle` and `BlockAttachment`.
- Optional `Hitbox` folder containing invisible hitbox parts.

Combat behavior:

- Sword uses a short forward box hitbox during the attack active frames.
- Shield Block creates a server-owned block state for a short duration.
- Block reduces or cancels damage from the front only.
- Charge moves the Knight forward after a visible windup.

### Mage staff

Objects needed:

- `Model` named `Staff`.
- Staff `Handle`.
- `Attachment` named `CastAttachment` at the crystal.
- Optional `MuzzleAttachment` for projectile origin.
- `Model` or `Part` for the crystal.

Combat behavior:

- Fireball creates a server-approved projectile or raycast result.
- The projectile has a lifetime, speed, radius, and damage value.
- Teleport validates the destination and prevents moving through walls.
- Area attacks use a server-side radius query.

### Rogue twin daggers

Objects needed:

- Left and right dagger `Model`s.
- Each dagger has a `Handle` and `GripAttachment`.
- `SmokeBomb` model with an effect attachment.
- Optional invisible dash trail attachment on the torso.

Combat behavior:

- Basic attacks use a short capsule or box hitbox.
- Dash validates distance and collision before moving the player.
- Smoke Veil creates a timed area status effect and limited visibility effect.

## Recommended Roblox hierarchy

```text
ReplicatedStorage
├── Remotes
│   ├── CombatRequest       (RemoteEvent)
│   └── CombatResult        (RemoteEvent)
├── Shared
│   ├── HeroDefinitions     (ModuleScript)
│   ├── AttackDefinitions   (ModuleScript)
│   └── CombatConstants     (ModuleScript)
├── Heroes
│   ├── Knight
│   │   ├── CharacterModel
│   │   ├── Weapons
│   │   ├── Animations
│   │   └── Effects
│   ├── Mage
│   └── Rogue
└── Assets
    ├── Sounds
    └── UI

ServerScriptService
├── CombatServer.server.lua
├── MatchServer.server.lua
├── HeroService.server.lua
└── Services
    ├── DamageService.lua
    ├── HitboxService.lua
    ├── CooldownService.lua
    └── StatusEffectService.lua

StarterPlayer
└── StarterPlayerScripts
    ├── CombatClient.client.lua
    ├── CombatEffects.client.lua
    └── InputController.client.lua
```

## Attack data

Attack values should live in ModuleScripts rather than being duplicated between client and server.

Example shape:

```lua
return {
    Knight = {
        BasicAttack = {
            damage = 25,
            cooldown = 0.6,
            range = 7,
            activeTime = 0.12,
            hitType = "Box",
        },
        ShieldBlock = {
            cooldown = 6,
            duration = 1.2,
            blockAngle = 120,
        },
    },
}
```

The client may read timing and display values for animation and UI, but the server must use its own trusted copy for damage and validation.

## Attack execution flow

```text
Player input
    ↓
InputController validates local state
    ↓
CombatRequest:FireServer(hero, attack)
    ↓
CombatServer validates player, hero, cooldown, and state
    ↓
HitboxService checks targets on the server
    ↓
DamageService applies damage or status effect
    ↓
CombatResult broadcasts the approved result
    ↓
Clients play animation, VFX, and SFX
```

## Server validation requirements

For every request, validate:

- Player has a live character.
- Player owns the selected hero.
- Attack exists for that hero.
- Player is not stunned, defeated, or already attacking illegally.
- Cooldown has expired.
- Position and facing are valid.
- Target is within the attack’s actual range.
- The request is not arriving too quickly.

Never trust client-supplied damage, target, hit result, position, or cooldown values.

## Hit detection options

### Box hitbox

Use `workspace:GetPartBoundsInBox()` with `OverlapParams` for swords and close attacks.

### Radius hitbox

Use `workspace:GetPartBoundsInRadius()` for explosions, shields, and area skills.

### Raycast

Use `workspace:Raycast()` for line attacks and teleport destination checks.

### Target filtering

Exclude the attacker, effects, weapons, and non-combat map objects through `OverlapParams.FilterDescendantsInstances` and collision groups.

## Weapon animation timing

Each attack should have four phases:

1. `Windup`: animation warns the opponent.
2. `Active`: server hitbox exists briefly.
3. `Recovery`: attacker cannot immediately repeat the attack.
4. `Cooldown`: skill becomes available again.

Use animation markers such as `HitStart`, `HitEnd`, and `Cast` to line up visuals. The server should still enforce a safe timing window instead of trusting a client marker.

## Required object attributes

Useful attributes on hero and weapon models:

- `HeroId` — string.
- `WeaponType` — string.
- `Damageable` — boolean.
- `HitboxOwner` — player user ID when needed.
- `EffectId` — string for approved client effects.

Avoid using attributes supplied by the client as security checks.

## VFX and sound objects

Each skill should have:

- Start effect.
- Active effect.
- Impact effect.
- Cleanup duration.
- Cast sound.
- Hit sound.
- Cooldown icon.

Use `ParticleEmitter`, `Beam`, `Trail`, `PointLight`, `Sound`, and temporary Parts or Attachments. Clean temporary effects with `Debris`.

## Weapon implementation choice

Use Models attached to the character, not Roblox `Tool` objects, for the first version.

This keeps weapon appearance and combat input separate and avoids Tool activation edge cases. Add `Tool` support only if players later need to equip, drop, or trade weapons.

## Testing requirements

- Test two players attacking each other.
- Test attacks through walls.
- Test spoofed damage and cooldown values.
- Test rapid remote-event spam.
- Test defeat during an active attack.
- Test respawn cleanup.
- Test multiple VFX effects at once.
- Test mobile and keyboard input separately.
