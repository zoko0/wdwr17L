set months;

set vege_oilsTypes;
set nonvege_oilsTypes;

param vege_marketPrices { months, vege_oilsTypes };
param nonvege_marketPrices { months, nonvege_oilsTypes };

var v_oils_refining { months, vege_oilsTypes } >= 0;
var n_oils_refining { months, nonvege_oilsTypes } >= 0;

var production {months} >= 0;

 # w danym miesiacu mozna rafinowac maksymalnie 220 ton oleju roslinnego
subject to max_refining_for_vegetable_oils {k in months}:
	0 <= sum {i in vege_oilsTypes} v_oils_refining[k,i] <= 220;

maximize RESULT:
	(sum { k in months } production[k]) * 170 -
	(
		(sum { k in months, i in vege_oilsTypes} vege_marketPrices[k, i] * v_oils_refining[k, i] ) +
		(sum { k in months, i in nonvege_oilsTypes} nonvege_marketPrices[k, i] * n_oils_refining[k, i] )
	);