return {
	Knight = {
		MaxHealth = 100,
		WalkSpeed = 16,
		BasicAttack = {
			Damage = 20,
			Cooldown = 0.6,
			BoxSize = Vector3.new(6, 5, 7),
			BoxOffset = CFrame.new(0, 0, -3.5),
		},
		Block = {
			FrontAngle = 0.35,
		},
		Charge = {
			Cooldown = 4,
			Speed = 65,
		},
	},
	Mage = {
		MaxHealth = 80,
		WalkSpeed = 16,
		BasicAttack = {
			Damage = 12,
			Cooldown = 0.8,
			BoxSize = Vector3.new(5, 5, 6),
			BoxOffset = CFrame.new(0, 0, -3),
		},
		Fireball = {
			Damage = 28,
			Cooldown = 2.5,
			Range = 45,
		},
		Teleport = {
			Cooldown = 5,
			Distance = 16,
		},
	},
	Rogue = {
		MaxHealth = 90,
		WalkSpeed = 18,
		BasicAttack = {
			Damage = 16,
			Cooldown = 0.45,
			BoxSize = Vector3.new(5, 5, 6),
			BoxOffset = CFrame.new(0, 0, -3),
		},
		Dash = {
			Cooldown = 3,
			Speed = 90,
		},
		SmokeVeil = {
			Cooldown = 6,
			Duration = 2,
		},
	},
}
