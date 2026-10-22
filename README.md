# PvP Hero Arena

A Roblox PvP combat game where players choose heroes and fight in short arena matches using unique skills.

Current status: Knight combat prototype and Citadel Courtyard graybox.

Controls in the prototype:

- Left click: basic sword attack
- `Q`: hold shield block
- `E`: charge

See:

- [Game Plan](GAME_PLAN.md)
- [Character Designs](CHARACTER_DESIGNS.md)
- [Character Components](CHARACTER_COMPONENTS.md)
- [Weapons and Technical Plan](WEAPONS_AND_TECHNICAL_PLAN.md)
- [Arena Design](ARENA_DESIGN.md)
- [MVP Checklist](MVP.md)
- [Test Plan](TEST_PLAN.md)
- [Runtime Logging](LOGGING.md)
- [Studio Setup](STUDIO_SETUP.md)

## Run the automated smoke test

While the game is running in Studio, open the Command Bar and run:

```lua
workspace:SetAttribute("RunMVPTests", true)
```

Read the `[MVP PASS]`, `[MVP FAIL]`, and `[MVP RESULT]` messages in the Output window.
