extends Node

var craftings = {
	"H2SO4": {
		"name": "Kwas siarkowy (VI)",
		"description": "Ale mocny kwas!",
		"ingredients": {
			"Sulfur": 1,
			"WaterTube": 1
		},
		"result": {
			"res://Items/Resources/H2SO4Tube.tres": 3
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
