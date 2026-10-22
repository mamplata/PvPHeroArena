# Character Design Plan

Related implementation details: [Character Components](CHARACTER_COMPONENTS.md), [Weapons and Technical Plan](WEAPONS_AND_TECHNICAL_PLAN.md), and [MVP Checklist](MVP.md).

## Shared art direction

- Stylized fantasy silhouettes that are readable from a distance.
- Strong primary color for each hero.
- Dark neutral armor or clothing to keep effects visible.
- Simple shapes first; detailed accessories can come later.
- Every skill gets a distinct color and shape so players can react quickly.

## Knight — The Iron Vanguard

### Visual identity

- Large shoulder silhouette and sturdy stance.
- Steel armor with deep blue cloth accents.
- Round shield and short sword.
- Small blue glow in the shield emblem.

### Palette

- Armor: charcoal steel.
- Accent: royal blue.
- Skill effect: bright cyan.

### Ability visuals

- Shield Block: blue shield-shaped barrier.
- Charge: blue trail and short impact burst.

## Mage — The Ember Scholar

### Visual identity

- Tall hooded robe with floating spellbook pages.
- Purple robe with warm orange trim.
- Staff topped with a glowing crystal.

### Palette

- Robe: deep violet.
- Accent: ember orange.
- Skill effect: orange and gold.

### Ability visuals

- Fireball: bright orange projectile with a short smoke trail.
- Teleport: circular rune that flashes before and after movement.

## Rogue — The Shadow Runner

### Visual identity

- Slim silhouette and forward-leaning stance.
- Dark leather armor with red scarf accents.
- Two short blades and a small belt of smoke bombs.

### Palette

- Clothing: near-black.
- Accent: crimson red.
- Skill effect: magenta smoke and red streaks.

### Ability visuals

- Dash: sharp red motion streak.
- Smoke Veil: dark purple smoke cloud with fading red particles.

## Readability rules

- Do not rely on tiny details to identify a hero.
- Keep each hero’s main color consistent across their model, UI, and effects.
- Avoid effects that hide the entire arena.
- Keep attack windups visible before damage happens.
- Use shape as well as color because players may not distinguish colors clearly.

## Design deliverables per hero

Each hero design is not complete until it has:

- Front, back, and side reference views.
- A simple silhouette view at thumbnail size.
- Color palette with material assignments.
- Weapon and accessory callouts.
- R15 attachment locations.
- Basic attack and skill pose sheets.
- Ability effect color and shape references.
- Selection portrait and in-game nameplate.
- A list separating required MVP assets from optional polish.

## Roblox design constraints

- Build around the standard R15 proportions first.
- Keep weapons attached to named hand attachments, not hard-coded body positions.
- Keep the head, torso, and weapon silhouette readable at normal camera distance.
- Use `MeshPart` or approved layered clothing for final custom assets.
- Use simple `Part`, `Attachment`, `ParticleEmitter`, `Beam`, `Trail`, and `PointLight` objects for early prototypes.
- Keep hero colors consistent between the character, ability effects, hero card, and cooldown UI.
- Avoid oversized accessories that hide hit reactions or other players.

## Production order

1. Build simple blocky silhouettes.
2. Add the primary color and weapon shapes.
3. Add idle and attack poses.
4. Add readable skill effects.
5. Polish armor, cloth, particles, and cosmetics after combat feels good.
