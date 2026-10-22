# Elaborate Character Component Plan

This separates what every character needs from what makes each hero specialized.

Use this with the [Character Design Plan](CHARACTER_DESIGNS.md), [Weapons and Technical Plan](WEAPONS_AND_TECHNICAL_PLAN.md), and [MVP Checklist](MVP.md).

## Required versus optional

The MVP only needs the objects marked **Required**. Everything marked **Optional** is visual polish and can wait until combat works.

## 1. Shared base character

Every hero should use the same gameplay foundation so combat stays fair.

### Body and rig

- **Required:** R15 character `Model`.
- **Required:** `Humanoid`.
- **Required:** `HumanoidRootPart`.
- **Required:** R15 body parts and joints.
- **Required:** `Animator` inside the Humanoid.
- **Required:** shared hitbox rules.
- **Required:** shared movement speed and jump settings.
- **Optional:** custom body meshes and layered clothing.
- Hero-specific animations layered on top of the same rig.

### Base visual parts

- **Required:** `Head`, face, torso, arms, legs, hands, and feet from the R15 rig.
- **Required:** one hero identifier attribute such as `HeroId = "Knight"`.
- **Required:** `Attachment`s for weapon and accessory mounting.
- **Required:** one weapon `Model` with a `Handle` or primary part.
- **Required:** one visible hero color and one team-color marker.
- **Optional:** hair or helmet slot.
- **Optional:** custom torso, arm, and leg clothing.
- **Optional:** back or waist accessory slot.
- **Optional:** secondary accessory slot.

### Shared presentation

- Idle animation.
- Walk, run, jump, fall, and landing animations.
- Basic attack animation.
- Hurt, block, defeat, and victory animations.
- Character nameplate and health bar.
- Selection portrait and hero card.
- Footstep, attack, hit, defeat, and victory sounds.

Required Roblox objects:

- `Animation` objects or animation asset IDs for the shared animations.
- `BillboardGui` with `TextLabel` and health-bar `Frame`.
- `Sound` objects or sound asset IDs stored in an effects folder.
- `Folder` for temporary effects attached to the character.

## Required character hierarchy

```text
ReplicatedStorage
└── Heroes
    └── Knight
        ├── CharacterModel       (Model)
        │   ├── Humanoid
        │   │   └── Animator
        │   ├── HumanoidRootPart
        │   ├── Head
        │   ├── UpperTorso
        │   ├── LowerTorso
        │   ├── Attachments       (Folder)
        │   └── Weapons            (Folder)
        ├── Animations             (Folder)
        ├── Effects                (Folder)
        ├── Sounds                 (Folder)
        └── HeroConfig              (ModuleScript)
```

The character model must have a valid `PrimaryPart` or a reliable `HumanoidRootPart` before it is cloned into a match.

## 2. Gameplay components

Each hero needs a data definition containing:

- Display name and description.
- Health and movement values.
- Basic attack damage, range, and timing.
- Skill names, cooldowns, damage, range, and duration.
- Hitbox shape and active frames.
- Crowd-control rules.
- Animation references.
- VFX and SFX references.

Damage, cooldowns, hit detection, and status effects must be controlled by the server.

## 3. Knight specialized design

### Silhouette

- Broad shoulders.
- Heavy chest plate.
- Large shield visible from the front.
- Short sword held low and close to the body.

### Equipment pieces

- **Required:** helmet or head accessory.
- **Required:** sword `Model` with `Handle` and `GripAttachment`.
- **Required:** shield `Model` with `Handle` and `BlockAttachment`.
- **Required:** sword and shield attachment points on the hands.
- **Optional:** layered shoulder plates.
- **Optional:** chest armor with a central crest.
- **Optional:** arm guards, knee plates, and armored boots.
- **Optional:** glowing shield emblem.

### Material language

- Brushed dark steel.
- Blue cloth and enamel details.
- Scratches and small dents for history.
- Cyan energy only appears during defensive skills.

### Specialized animations and effects

- Heavy, deliberate idle breathing.
- Shield Block: raise shield, hold a visible barrier, then release a pulse.
- Charge: lower shoulder, leave a blue streak, finish with a ground impact.
- Defeat: shield drops before the character falls.

Required assets:

- `KnightIdle` animation.
- `KnightBasicAttack` animation with `HitStart` and `HitEnd` markers.
- `KnightBlockStart`, `KnightBlockLoop`, and `KnightBlockEnd` animations.
- `KnightCharge` animation with a `Charge` marker.
- Shield barrier `Part` or `Beam` effect.

## 4. Mage specialized design

### Silhouette

- Tall hood or pointed hat.
- Long coat or robe with layered panels.
- Staff extending above the head.
- Floating spellbook or rune orbiting the body.

### Equipment pieces

- **Required:** hood or head accessory.
- **Required:** staff `Model` with `Handle` and `CastAttachment`.
- **Required:** staff crystal `Part` or `MeshPart`.
- **Required:** hand attachment point for the staff.
- **Optional:** high-collar robe.
- **Optional:** potion belt.
- **Optional:** floating rune or spellbook accessory.
- **Optional:** cloth strips.

### Material language

- Deep violet cloth.
- Warm orange trim.
- Brass or gold metal fittings.
- Ember particles around the staff crystal.

### Specialized animations and effects

- Robe and cloth movement during idle.
- Fireball: cast windup, hand flare, projectile, impact burst.
- Teleport: rune appears under the feet, body dissolves into embers, then reforms.
- Defeat: staff crystal dims and the orbiting rune breaks apart.

Required assets:

- `MageIdle` animation.
- `MageBasicAttack` animation with a `Cast` marker.
- `MageFireball` animation with a `Cast` marker.
- `MageTeleport` animation with `TeleportOut` and `TeleportIn` markers.
- Fireball projectile `Part` or `Model`.
- Teleport rune `Part` with `ParticleEmitter` or `Beam`.

## 5. Rogue specialized design

### Silhouette

- Slim profile.
- Hood or half-mask.
- Short scarf that creates readable motion.
- Two blades held at different angles.

### Equipment pieces

- **Required:** hood, mask, or hair accessory.
- **Required:** left dagger `Model` with `Handle` and `GripAttachment`.
- **Required:** right dagger `Model` with `Handle` and `GripAttachment`.
- **Required:** left and right hand attachment points.
- **Required:** smoke bomb `Model` for the Smoke Veil skill.
- **Optional:** light chest harness.
- **Optional:** smoke-bomb belt.
- **Optional:** forearm guards.
- **Optional:** short cape or scarf.

### Material language

- Matte black leather.
- Crimson fabric accents.
- Small silver blade edges.
- Magenta smoke during abilities only.

### Specialized animations and effects

- Constantly shifting idle stance.
- Dash: crouch, sharp launch, red motion streak, quick recovery.
- Smoke Veil: throw a smoke bomb, expand a readable cloud, fade the character silhouette.
- Defeat: one dagger falls before the character collapses.

Required assets:

- `RogueIdle` animation.
- `RogueBasicAttack` animation with `HitStart` and `HitEnd` markers.
- `RogueDash` animation with a `Dash` marker.
- `RogueSmokeVeil` animation with a `Throw` marker.
- Dash `Trail` or short-lived `Beam` effect.
- Smoke cloud `Part` with `ParticleEmitter`.

## 6. Customization components

Customization should change appearance without changing combat statistics.

- Helmet or hair variant.
- Face or mask variant.
- Chest armor or robe variant.
- Weapon skin.
- Back accessory.
- Victory pose.
- Emote.
- Spawn effect.
- Elimination effect.

Keep the hero silhouette and ability readability unchanged across cosmetics.

## 7. Roblox asset structure

Recommended structure for each hero:

```text
ReplicatedStorage
└── Heroes
    └── Knight
        ├── CharacterModel
        ├── Animations
        ├── VFX
        ├── SFX
        └── HeroConfig
```

The server owns combat configuration and hit detection. The client can display animation and effects after receiving a validated combat result.

## 8. Required code objects

- `HeroDefinitions` `ModuleScript` for names, stats, and asset references.
- `HeroService` server `Script` or `ModuleScript` to clone and equip heroes.
- `AnimationController` `ModuleScript` for playing shared and hero animations.
- `CosmeticService` only when customization is added.
- `RemoteEvent` for approved combat results.
- `RemoteEvent` for hero selection requests, validated by the server.

The client should request `HeroId`; the server should decide whether that hero is available and create the character.

## 9. Production checklist

- [ ] Blockout model with readable silhouette.
- [ ] Final body colors and materials.
- [ ] Weapon and accessory attachments.
- [ ] Idle, movement, attack, skill, hurt, defeat, and victory animations.
- [ ] Skill windups and hit frames.
- [ ] Skill VFX with start, active, impact, and cleanup phases.
- [ ] Matching sound effects.
- [ ] Portrait and selection-card art.
- [ ] Health bar and cooldown presentation.
- [ ] Performance check with multiple heroes and effects on screen.
- [ ] Colorblind/readability check.
- [ ] Multiplayer test for animation, hitbox, and latency behavior.
