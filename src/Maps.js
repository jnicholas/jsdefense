rock = { cls : 'rock' };
water = { cls : 'water' };
grass = { cls : 'grass' };
entrance = { cls : 'grass', entrance : true };
exit = { cls : 'grass', exit : true };

MAPS = {
	Basic : {
		tiles : [
			[rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock,rock],
			[rock,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[rock,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[rock,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[rock,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[rock,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[entrance,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,exit],
			[water,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[water,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[water,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[water,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[water,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,grass,rock],
			[water,water,water,water,water,water,water,water,water,water,water,water,water,water,water,water,water,water,water,water]
		]
	}
}