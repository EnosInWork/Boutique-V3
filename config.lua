Config = {
	------------
	discord_webhook = "DISCORD",
	------------
	ColorMenuR = 252, -- Bannière couleur R
	ColorMenuG = 136, -- Bannière couleur G
	ColorMenuB = 3, -- Bannière couleur B
	ColorMenuA = 170, -- Bannière couleur A
	MenuPositionX = 0,
	MenuPositionY = 0,
	------------
	MenuName = "Boutique",
	SubMenuName = "~o~5-Dev",
	------------
	TimeMessage = "90000", -- in ms (90 secondes)
	AutoMessage = "N'hésitez pas à jeter un coup d'oeil à notre boutique (F11) !",
	------------
	CreditName = "Crédit(s)", 
	------------
	img_notif = "CHAR_SOCIAL_CLUB",
	------------
	LicenceSysteme = "steam", -- steam / licence options
	------------
	ActivePromo = true, 
	PromoCode = "cEnos",
	------------
	EchangePoint = true,
	------------------------------------------------------------------------------------------------
	ActiveVeh = true, 
	ExportName = "rConcess",
	CustomPrice = 200,
	ListVeh = {
		{category = "↓ ~r~Import~s~ ↓"}, -- exemple of categorie
		{img = "bolide", name = "Bugatti Bolide" , model = "rmodbugatti", point = 1000, place = 2, vitesse = 450},
		{img = "voiturenoire", name = "La Voiture Noire" , model = "rmodbolide", point = 1000, place = 2, vitesse = 449},
		{img = "charger", name = "Dodge Charger 69" , model = "rmodcharger69", point = 1000, place = 2, vitesse = 448},
		{img = "f12", name = "Ferrari F12 TDF" , model = "rmodf12tdf", point = 1000, place = 2, vitesse = 447},
		{img = "f40", name = "Ferrari F40" , model = "rmodf40", point = 1000, place = 2, vitesse = 446},
		{img = "b63s", name = "Brabus GT63S" , model = "rmodgt63", point = 1000, place = 2, vitesse = 445},
		{img = "gtr", name = "Nissan GTR" , model = "rmodgtr50", point = 1000, place = 2, vitesse = 444},
		{img = "jeep", name = "Jeep Rmod" , model = "rmodjeep", point = 1000, place = 2, vitesse = 443},
		{img = "m5", name = "Bmw M5 E34" , model = "rmodm5e34", point = 1000, place = 2, vitesse = 442},
		{img = "golf", name = "Golf 7R" , model = "rmodmk7", point = 1000, place = 2, vitesse = 441},
		{img = "skyline", name = "Nissan Skyline R34" , model = "rmodskyline34", point = 1000, place = 2, vitesse = 440},
		{img = "zl1", name = "Chevrolet Camaro ZL1" , model = "rmodzl1", point = 1000, place = 2, vitesse = 439}
	},
	------------------------------------------------------------------------------------------------
	ActiveWeapon = true, 
	WeaponList = {
		{category = "↓ ~r~Weapon~s~ ↓"}, -- exemple of categorie
		{img = "Screenshot_127", name = "Couteau" , model = "weapon_knife", point = 10},
		{img = "baseball-bat", name = "Bat de baseball" , model = "weapon_bat", point = 10},
		{img = "hachet", name = "Hachette" , model = "weapon_machete", point = 10},
		{img = "pistol", name = "Pistolet" , model = "weapon_pistol", point = 1500},
		{img = "revolvermk2", name = "Revolver MK2" , model = "weapon_revolver_mk2", point = 2000},
		{img = "minismg", name = "Mini-SMG" , model = "weapon_microsmg", point = 2200},
		{img = "smgmk2", name = "Mini-SMG MK2" , model = "weapon_smg_mk2", point = 2500},
		{img = "assault-rifle-mk2", name = "AK47" , model = "weapon_assaultrifle", point = 4200},
		{img = "m4", name = "M4" , model = "weapon_carbinerifle", point = 4200},
		{img = "sniper", name = "Sniper" , model = "weapon_sniperrifle", point = 5000}
	}, 
	------------------------------------------------------------------------------------------------
	ActiveMoney = true, 
	MoneyList = {
		{category = "↓ ~r~Money Pack~s~ ↓"}, -- exemple of categorie
		{img = "money", name = "10,000$" , model = 10000, point = 500},
		{img = "money", name = "20,000$" , model = 20000, point = 1000},
		{img = "money", name = "45,000$" , model = 45000, point = 1500},
		{img = "money", name = "75,000$" , model = 75000, point = 2000}
	},
	------------------------------------------------------------------------------------------------
	ActiveCaisse = true, 
	LesCaisse = {
		{category = "↓ ~r~Box Pack~s~ ↓"}, -- exemple of categorie
		{img = "gold_case", name = "Gold Box" , item = "gold_case", point = 1000, lootdesc = "Bugatti, AK-47, 75,000$"},
		{img = "ruby_case", name = "Ruby Box" , item = "ruby_case", point = 750, lootdesc = "BMW M5, SMG, 50,000$"},
		{img = "diamond_case", name = "Diamond Box" , item = "diamond_case", point = 500, lootdesc = "Nissan Skyline, Pistolet de combat, 25,000$"},
	}
}
------------------------------------------------------------------------------------------------

reduction = 0.75
taxe = 100 * reduction

------------------------------------------------------------------------------------------------
Config["image_source"] = "nui://boutiquev3/html/img/"

Config.Chance = {
	[1] = { name = "Common", rate = 50 }, -- tier 1
	[2] = { name = "Rare", rate = 40 }, -- tier 2
	[3] = { name = "Epic", rate = 8 }, -- tier 3 
	[4] = { name = "Unique", rate = 1.7} , -- tier 4 
	[5] = { name = "Legendary", rate = 0.1 }, -- tier 5
}

Config.Case = {
	["gold_case"] = {
		name = "Gold Caisse",
		list = {
			{ money = 75000, tier = 1},
			{ weapon = "weapon_assaultrifle", amount=1, tier = 1},
			{ vehicle = "rmodbugatti", amount=1, tier = 1}
		}
	},
	["ruby_case"] = {
		name = "Ruby Caisse",
		list = {
			{ money = 50000, tier = 1},
			{ weapon = "weapon_smg", amount=1, tier = 1},
			{ vehicle = "rmodm5e34", amount=1, tier = 1}
		}
	},
	["diamond_case"] = {
		name = "Diamond Caisse",
		list = {
			{ money = 25000, tier = 1},
			{ weapon = "weapon_combatpistol", amount=1, tier = 1},
			{ vehicle = "rmodskyline34", amount=1, tier = 1}
		}
	},
}