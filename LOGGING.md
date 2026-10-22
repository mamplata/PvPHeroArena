# Runtime Logging

The game captures runtime messages in memory while the server is running.

## What is captured

- Server `print()` and `warn()` output through `LogService.MessageOut`.
- Server script failures through `ScriptContext.Error`.
- Client warnings, errors, and info messages relayed to the server.
- Source, level, timestamp, and message text.

## Where logs are stored

During Play, inspect:

```text
ServerStorage.RuntimeLogs
```

Each entry is a `StringValue` with `Level`, `Source`, and `Timestamp` attributes. The buffer keeps the newest 250 entries.

## Dump logs in Studio

Run this in the server Command Bar:

```lua
for _, entry in ipairs(game:GetService("ServerStorage").RuntimeLogs:GetChildren()) do
    print(entry.Value)
end
```

## Important limitation

Roblox runtime scripts cannot write directly to the local Rojo workspace. These logs are memory-only and disappear when the server stops. Copy the dump into a local file if you need a permanent test record.

Client entries are diagnostic only and must never be trusted for gameplay, security, damage, or match decisions.
