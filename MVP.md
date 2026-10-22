# MVP Checklist

The MVP is one complete playable loop, not the final amount of content. Detailed requirements are linked from the [Game Plan](GAME_PLAN.md).

## Project foundation

- [x] Rojo project folder created.
- [x] `ReplicatedStorage.Remotes` created.
- [x] Shared hero and attack definition ModuleScripts created.
- [x] Server and client script locations created.

## Arena

- [x] Build the Citadel Courtyard graybox.
- [x] Add floor, walls, center, side lanes, and four cover pieces.
- [x] Add two equal-distance spawn points.
- [x] Add invisible arena boundaries and a recovery zone.
- [x] Add a lobby spawn and return players after matches.
- [x] Add simple lighting and one ambient sound.

See [Arena Design](ARENA_DESIGN.md).

## Combat

- [x] Create one complete Knight mirror-match prototype first.
- [x] Add R15 character model and required attachments.
- [x] Add sword and shield Models.
- [x] Add basic attack, Shield Block, and Charge.
- [x] Add server-side damage, hitbox, cooldown, and block validation.
- [x] Add a local health bar and combat status HUD.
- [x] Add defeat handling and respawn/reset.
- [x] Add Mage and Rogue after the Knight loop is fun.
- [x] Add two skills for each final MVP hero.
- [x] Add hero selection with server validation.

See [Character Components](CHARACTER_COMPONENTS.md) and [Weapons and Technical Plan](WEAPONS_AND_TECHNICAL_PLAN.md).

## Match flow

- [x] Add a lobby and queue two players.
- [x] Start a countdown.
- [x] Best-of-three rounds.
- [x] Prevent waiting players from using combat actions.
- [x] Lock players into the selected arena during a round.
- [x] Reset health, positions, states, and cooldowns between rounds.
- [x] Return players to the lobby.
- [x] Display the winner.

## Later, not MVP

- Ranked matchmaking.
- More heroes.
- More arenas.
- Environmental hazards and moving platforms.
- Cosmetics and emotes.
- Teams and tournaments.
