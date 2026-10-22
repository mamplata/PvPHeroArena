# Game Plan

This plan is implemented through the [character design](CHARACTER_DESIGNS.md), [character components](CHARACTER_COMPONENTS.md), [weapon technical plan](WEAPONS_AND_TECHNICAL_PLAN.md), and [arena plan](ARENA_DESIGN.md).

## Core loop

1. Join the lobby.
2. Choose a hero.
3. Enter a small arena.
4. Fight another player using basic attacks and skills.
5. Win the round and return to the lobby.

## Match rules

- One-versus-one combat.
- Best of three rounds.
- Each round starts with full health and refreshed cooldowns.
- A round ends when one player is defeated.

## Starter heroes

### Knight

- Strength: high defense and close-range damage.
- Skills: Shield Block, Charge.

### Mage

- Strength: ranged damage and area control.
- Skills: Fireball, Teleport.

### Rogue

- Strength: speed and burst damage.
- Skills: Dash, Smoke Veil.

## Design goals

- Easy to understand in the first match.
- Short matches with meaningful decisions.
- Heroes should have strengths and weaknesses.
- Progression should focus on cosmetics, not paid power.

## Build order

### Phase 1: Foundation

- Create the Rojo project structure.
- Create shared remotes and ModuleScripts.
- Build the Citadel Courtyard graybox.
- Add two spawn points, boundaries, and simple lighting.

See [Arena Design](ARENA_DESIGN.md).

### Phase 2: One complete hero

- Build the Knight blockout model.
- Add the sword and shield Models.
- Add idle, basic attack, Shield Block, and Charge animations.
- Implement server-side hitboxes, damage, cooldowns, and block validation.
- Test a Knight mirror match before adding more heroes.

See [Character Components](CHARACTER_COMPONENTS.md) and [Weapons and Technical Plan](WEAPONS_AND_TECHNICAL_PLAN.md).

### Phase 3: Hero roster

- Add Mage with Fireball and Teleport.
- Add Rogue with Dash and Smoke Veil.
- Add selection UI and server-validated hero selection.
- Test matchups on the same arena.

See [Character Designs](CHARACTER_DESIGNS.md).

### Phase 4: Match loop

- Add lobby queue for two players.
- Add countdown and round state.
- Reset characters and cooldowns between rounds.
- Track best-of-three wins.
- Return players to the lobby and show the winner.

See [MVP Checklist](MVP.md).

## Technical ownership

- Server: match state, hero selection, movement validation, hit detection, damage, cooldowns, status effects, and arena boundaries.
- Client: input, local animation playback, UI, and approved VFX/SFX.
- Shared ModuleScripts: hero definitions, attack definitions, constants, and safe presentation data.

## Dependency order

```text
Arena graybox
    ↓
One hero model and weapon
    ↓
Server combat validation
    ↓
Attack animations and effects
    ↓
Three-hero selection
    ↓
Round and match flow
```
