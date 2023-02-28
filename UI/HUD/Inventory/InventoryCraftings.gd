extends Node

var craftings = {
	"H2SO4": {
		"name": "Kwas siarkowy (VI)",
		"description": "Ale mocny kwas!",
		"ingredients": {
			"SO3": 1,
			"WaterTube": 1
		},
		"result": {
			"res://Items/Resources/H2SO4Tube.tres": 3
		},
		"time": 10.0
	},
	"SO3": {
		"name": "Tlenek siarki (VI)",
		"description": "Kolejna nudna receptura",
		"ingredients": {
			"SO2": 1,
			"EmptyTube": 1
		},
		"result": {
			"res://Items/Resources/SO3.tres": 1
		},
		"time": 10.0
	},
	"SO2": {
		"name": "Tlenek siarki (IV)",
		"description": "Receptura jak każda inna",
		"ingredients": {
			"Sulfur": 1,
			"EmptyTube": 1
		},
		"result": {
			"res://Items/Resources/SO2.tres": 1
		},
		"time": 10.0
	},
	"P4O10": {
		"name": "Tlenek fosforu (V)",
		"description": "Kolejna nudna receptura",
		"ingredients": {
			"P": 4,
			"EmptyTube": 5
		},
		"result": {
			"res://Items/Resources/P4O10.tres": 1
		},
		"time": 10.0
	},
	"H3PO4": {
		"name": "Kwas fosforowy (V)",
		"description": "Kwas!",
		"ingredients": {
			"P4O10": 1,
			"WaterTube": 6
		},
		"result": {
			"res://Items/Resources/H3PO4.tres": 4
		},
		"time": 10.0
	},
	"Iron": {
		"name": "Sztabka żelaza",
		"description": "Przepis do zrobienia czegoś fajnego",
		"ingredients": {
			"IronOre": 2
		},
		"result": {
			"res://Items/Resources/IronIngot.tres": 1
		},
		"time": 5.0
	}
}
