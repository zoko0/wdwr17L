set months;

set vege_oilsTypes;
set nonvege_oilsTypes;

param ready_oil_value;
param max_vege_oil_refining;
param max_nonvege_oil_refining;

param A_hardness;
param B_hardness;
param C_hardness;
param max_hardness;
param min_hardness;

param vege_marketPrices { months, vege_oilsTypes };
param nonvege_marketPrices { months, nonvege_oilsTypes };

var v_oils_refining { months, vege_oilsTypes } >= 0;
var n_oils_refining { months, nonvege_oilsTypes } >= 0;

#zmiennie binarne do ograniczenia if_oil_A_is_used_also_use_oil_C
var A_is_used { months } >= 0, <= 1, integer;
var C_is_used { months } >= 0, <= 1, integer;

var vege_oil_proportion { vege_oilsTypes } >= 0;
var nonvege_oil_proportion { nonvege_oilsTypes } >= 0;

var production { months } >= 0;

# w danym miesiacu mozna rafinowac maksymalnie 220 ton oleju roslinnego
subject to max_refining_for_vegetable_oils {k in months}:
	0 <= sum {i in vege_oilsTypes} v_oils_refining[k,i] <= max_vege_oil_refining;

# w danym miesiacu mozna rafinowac maksymalnie 270 ton oleju nieroslinnego
subject to max_refining_for_nonvegetable_oils {k in months}:
	0 <= sum {i in nonvege_oilsTypes} n_oils_refining[k,i];
	
subject to max_refining_for_nonvegetable_oils_2 {k in months}:
	sum {i in nonvege_oilsTypes} n_oils_refining[k,i] <= max_nonvege_oil_refining* C_is_used[k];

#jezeli w danym miesiacu uzywany jest olej A, to rowniez musi zostac uzyty olej C
subject to if_oil_A_is_used_also_use_oil_C {k in months}:
	A_is_used[k] - C_is_used[k] <= 0;
	
subject to if_oil_A_is_used_also_use_oil_C_2 {k in months}:
	0 <= v_oils_refining[k, 'A'];
		
subject to if_oil_A_is_used_also_use_oil_C_3 {k in months}:
	v_oils_refining[k, 'A'] <= 1000000 * A_is_used[k];


#ograniczenie na twardosc oleju
subject to hardness:
	min_hardness <= A_hardness * vege_oil_proportion['A'] +
	B_hardness * vege_oil_proportion['B'] +
	C_hardness * nonvege_oil_proportion['C'] <= max_hardness;

#proporcje
subject to sum_of_proportion_equals_1:
	(sum { i in vege_oilsTypes } vege_oil_proportion[i] ) +
	(sum { i in nonvege_oilsTypes } nonvege_oil_proportion[i] ) = 1;

#produkcja
subject to vege_production { k in months, i in vege_oilsTypes }:
	production[k] * vege_oil_proportion[i] <= v_oils_refining[k,i];

subject to nonvege_production { k in months, i in nonvege_oilsTypes }:
	production[k] * nonvege_oil_proportion[i] <= n_oils_refining[k,i];

#funkcja celu
maximize RESULT:
	(sum { k in months } production[k]) * ready_oil_value -
	(
		(sum { k in months, i in vege_oilsTypes } vege_marketPrices[k, i] * v_oils_refining[k, i] ) +
		(sum { k in months, i in nonvege_oilsTypes} nonvege_marketPrices[k, i] * n_oils_refining[k, i] )
	);