# PvP Hero Arena Test Plan

This document is the manual QA checklist for testing the current MVP in Roblox Studio.

## Test environment

### Required setup

1. Open Roblox Studio.
2. Start Rojo from the project folder:

```bash
cd /home/nana7/Roblox/PvPHeroArena
rojo serve default.project.json
```

3. Connect the Rojo plugin.
4. Use **Test > Start** with two players.
5. Keep the Output window open for server warnings and errors.

### Test roles

- **Player A:** first test client.
- **Player B:** second test client.
- **Observer:** Studio Output and Explorer.

### Result labels

- `PASS` — behavior matches the expected result.
- `FAIL` — behavior is incorrect or causes an error.
- `BLOCKED` — test cannot run because of an earlier failure.
- `N/A` — not applicable to the current build.

Record failures with the test ID, exact steps, expected result, actual result, and an Output-window screenshot.

## 1. Project and startup tests

### P-001 — Rojo build

Steps:

1. Run `rojo build default.project.json -o /tmp/PvPHeroArena.rbxlx`.

Expected:

- Build completes without errors.
- The output place file is created.
- All mapped scripts appear in the generated place.

### P-002 — Rojo live sync

Steps:

1. Start `rojo serve`.
2. Connect Studio.
3. Change a harmless print statement in a source file.
4. Save the file.

Expected:

- Studio receives the source change.
- No duplicate scripts or folders appear.

### P-003 — Server startup

Expected in Output:

- `Citadel Courtyard loaded`.
- `Hero combat server ready`.
- `Match server ready`.
- `Arena boundary service ready`.
- No red errors.

### P-004 — Generated hierarchy

Check Explorer during Play:

- `Workspace.ActiveArena` exists.
- `Workspace.ActiveArena.LobbySpawn` exists.
- `Workspace.ActiveArena.SpawnA` and `SpawnB` exist.
- `ReplicatedStorage.Remotes` exists.
- `ReplicatedStorage.MatchState` exists.
- No duplicate `ActiveArena` or remote folders exist after stopping and starting again.

## 2. Lobby and match workflow

### W-001 — Single-player lobby

Steps:

1. Start with one player.
2. Wait ten seconds.

Expected:

- Player remains at the lobby spawn.
- HUD says `WAITING FOR 2 PLAYERS`.
- Player cannot damage themselves or use combat actions against anything.

### W-002 — Two-player match start

Steps:

1. Start with two players.
2. Observe the HUD.

Expected:

- Both players receive the same countdown.
- Countdown reaches `FIGHT`.
- Players are placed at opposite arena spawns.
- Score begins at `0 - 0`.

### W-003 — Round win

Steps:

1. Have Player A defeat Player B.

Expected:

- Player B is defeated.
- Player A receives one round win.
- HUD announces the round winner.
- Next round starts after the delay.
- Both players receive fresh health and cooldowns.

### W-004 — Match win

Steps:

1. Have the same player win two rounds.

Expected:

- Match winner is displayed.
- Players are returned to the lobby.
- Combat is disabled until another match starts.
- A new pair can start a later match.

### W-005 — Player leaves during countdown

Steps:

1. Start a two-player match.
2. Remove Player B during the countdown.

Expected:

- The server does not error.
- Player A returns to waiting state.
- A later second player can start a new match.

### W-006 — Player leaves during combat

Steps:

1. Start a match.
2. Remove one player during `FIGHT`.

Expected:

- The match ends cleanly.
- The remaining player returns to the lobby.
- No stuck `InMatch` state remains.

### W-007 — Three or more players

Steps:

1. Start with three players.

Expected:

- Only the first two players enter the active match.
- The extra player remains in the lobby.
- The extra player cannot damage active fighters.

## 3. Hero selection tests

### H-001 — Default hero

Steps:

1. Join with a fresh player.

Expected:

- Player starts as Knight.
- Sword and shield appear.
- HUD identifies Knight.

### H-002 — Select Mage

Steps:

1. While in the lobby, press `2`.

Expected:

- Player respawns safely in the lobby.
- Player receives the Mage staff and crystal.
- HUD identifies Mage.
- Health and movement values change to Mage values.

### H-003 — Select Rogue

Steps:

1. While in the lobby, press `3`.

Expected:

- Player respawns safely in the lobby.
- Player receives two daggers.
- HUD identifies Rogue.
- Health and movement values change to Rogue values.

### H-004 — Select Knight again

Steps:

1. While in the lobby, press `1`.

Expected:

- Mage or Rogue equipment is removed.
- Sword and shield are restored.
- HUD returns to Knight controls.

### H-005 — Selection during match

Steps:

1. Enter `FIGHT`.
2. Press `1`, `2`, and `3`.

Expected:

- Hero does not change.
- Player is not force-respawned.

## 4. Common combat tests

### C-001 — Basic attack input

Steps:

1. Face the opponent.
2. Press left click.

Expected:

- Attack request is accepted during `FIGHT`.
- Target in range loses the configured health amount.
- Target outside the hitbox is not damaged.

### C-002 — Basic attack cooldown

Steps:

1. Spam left click rapidly.

Expected:

- Only one hit occurs per configured cooldown.
- Server Output has no errors.

### C-003 — Attack direction

Steps:

1. Stand beside or behind the opponent.
2. Press left click without facing them.

Expected:

- The opponent is not hit unless inside the forward hitbox.

### C-004 — Attack through cover

Steps:

1. Put a cover block between the players.
2. Attack.

Expected:

- The attack cannot hit through the cover when line-of-sight is required.
- If the current box attack intentionally allows it, record this as a design decision.

### C-005 — Attack after defeat

Steps:

1. Die.
2. Try attacking before respawn.

Expected:

- No attack is processed.

### C-006 — Remote spam

Steps:

1. Use the client input rapidly.
2. If possible, invoke the remote repeatedly from the client console.

Expected:

- Server cooldowns remain authoritative.
- Client cannot increase damage or bypass range checks.

## 5. Knight tests

### K-001 — Shield block

Steps:

1. Player B faces Player A.
2. Player B holds `Q`.
3. Player A attacks from the front.

Expected:

- Player B takes no or reduced damage according to the configured rule.
- HUD shows `SHIELD BLOCKING`.

### K-002 — Shield angle

Steps:

1. Player B holds `Q`.
2. Player A attacks from behind or the side.

Expected:

- The block does not protect the rear outside the configured angle.

### K-003 — Charge

Steps:

1. Select Knight.
2. Press `E` during `FIGHT`.

Expected:

- Knight moves forward.
- Charge cooldown prevents immediate reuse.
- Charge does not work while blocking.

## 6. Mage tests

### M-001 — Fireball hit

Steps:

1. Select Mage.
2. Face the opponent.
3. Press `E`.

Expected:

- A forward Fireball request is processed.
- An opponent in range takes Fireball damage.
- The skill cooldown is enforced.

### M-002 — Fireball miss

Steps:

1. Face away from the opponent.
2. Press `E`.

Expected:

- The opponent is not damaged.

### M-003 — Teleport

Steps:

1. Select Mage.
2. Press `R` near open space.

Expected:

- Mage moves forward by no more than the configured distance.
- Teleport cooldown is enforced.
- Mage cannot teleport through a wall.

### M-004 — Mage durability

Expected:

- Mage has lower health than Knight.
- Mage does not receive Knight shield behavior.

## 7. Rogue tests

### R-001 — Dash

Steps:

1. Select Rogue.
2. Press `E`.

Expected:

- Rogue moves forward quickly.
- Dash cooldown is enforced.
- Boundary recovery prevents leaving the arena.

### R-002 — Smoke Veil

Steps:

1. Select Rogue.
2. Press `R`.

Expected:

- Rogue becomes partially transparent for the configured duration.
- Rogue returns to normal visibility afterward.
- Smoke Veil cooldown is enforced.

### R-003 — Rogue movement

Expected:

- Rogue moves faster than Knight and Mage.
- Rogue does not receive Knight block behavior.

## 8. Arena and boundary tests

### A-001 — Spawn fairness

Expected:

- Spawn A and Spawn B are equally distant from the center.
- Players face each other.
- Neither spawn gives immediate cover or damage advantage.

### A-002 — Arena wall collision

Steps:

1. Walk and charge into every outer wall.

Expected:

- Players cannot leave through the walls.
- No player becomes permanently stuck.

### A-003 — Boundary recovery

Steps:

1. Use Charge or Dash toward an edge.
2. Attempt to move beyond the boundary.

Expected:

- Player is returned to their assigned spawn side.
- Velocity is cleared.
- Player remains alive unless the attack caused normal defeat.

### A-004 — Lobby separation

Expected:

- Waiting players remain outside the combat area.
- Waiting players do not receive combat actions.
- Active fighters are not returned to the lobby before the match ends.

### A-005 — Restart cleanup

Steps:

1. Stop Play.
2. Start Play again.

Expected:

- One arena exists.
- One lobby exists.
- No duplicate remotes, sounds, HUDs, or generated geometry exist.

## 9. Security and trust-boundary tests

### S-001 — Fake hero name

Attempt to request a hero name not in `CombatConfig`.

Expected:

- Selection is rejected.
- No error occurs.

### S-002 — Client damage value

Attempt to send a custom damage value with an attack request.

Expected:

- Server ignores the custom value.
- Damage comes only from server configuration.

### S-003 — Client target selection

Attempt to name a target outside the hitbox.

Expected:

- Server ignores the target name.
- Only server-detected targets can take damage.

### S-004 — Combat while waiting

Attempt every combat action before `FIGHT`.

Expected:

- No damage, movement skill, or status effect is applied.

### S-005 — Cooldown bypass

Spam every skill through remote requests.

Expected:

- Server cooldowns cannot be bypassed.

## 10. Regression pass

Run this short pass after every combat or match-system change:

- [ ] P-003 startup has no errors.
- [ ] W-002 two-player countdown works.
- [ ] W-003 round win works.
- [ ] W-004 match win and lobby return work.
- [ ] H-002 Mage selection works.
- [ ] H-003 Rogue selection works.
- [ ] C-002 basic cooldown works.
- [ ] K-001 Knight block works.
- [ ] M-001 Fireball works.
- [ ] R-001 Rogue dash works.
- [ ] A-003 boundary recovery works.
- [ ] S-004 waiting players cannot attack.

## 11. Test log

| Date | Build/commit | Tester | Passed | Failed | Blocked | Notes |
|---|---|---|---:|---:|---:|---|
| | | | | | | |

## 12. Bug report template

```text
ID:
Date:
Build:
Test case:
Players:
Steps to reproduce:
Expected:
Actual:
Output errors:
Screenshots/video:
Severity: Blocker / High / Medium / Low
```
