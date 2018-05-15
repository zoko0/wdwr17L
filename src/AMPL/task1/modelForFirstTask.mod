set months;

set vege_oilsTypes;
set nonvege_oilsTypes;

param ready_oil_value;
param max_vege_oil_refining;
param max_nonvege_oil_refining;
param storing_oil_cost;

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

var vege_refined_and_stored_oils { months, vege_oilsTypes } >= 0;
var nonvege_refined_and_stored_oils { months, nonvege_oilsTypes } >= 0;

var vege_oils_storage_costs_sum { vege_oilsTypes };
var nonvege_oils_storage_costs_sum { nonvege_oilsTypes };

var production { months } >= 0;

# w danym miesiacu mozna rafinowac maksymalnie 220 ton oleju roslinnego
subject to max_refining_for_vegetable_oils {k in months}:
	0 <= sum {i in vege_oilsTypes} v_oils_refining[k,i] <= max_vege_oil_refining;

# w danym miesiacu mozna rafinowac maksymalnie 270 ton oleju nieroslinnego
subject to max_refining_for_nonvegetable_oils {k in months}:
	0 <= sum {i in nonvege_oilsTypes} n_oils_refining[k,i];
	
subject to max_refining_for_nonvegetable_oils_2 {k in months}:
	sum {i in nonvege_oilsTypes} n_oils_refining[k,i] <= max_nonvege_oil_refining * C_is_used[k];

#jezeli w danym miesiacu uzywany jest olej A, to rowniez musi zostac uzyty olej C
subject to if_oil_A_is_used_also_use_oil_C {k in months}:
	A_is_used[k] - C_is_used[k] <= 0;
	
subject to if_oil_A_is_used_also_use_oil_C_2 {k in months}:
	0 <= v_oils_refining[k, 'A'];
#ograniczenie po to, zeby otrzymac flage dodatnosci przy uzyciu oleju C 
subject to if_oil_A_is_used_also_use_oil_C_3 {k in months}:
	v_oils_refining[k, 'A'] <= 10000 * A_is_used[k];

#ograniczenie na twardosc oleju
subject to hardness:
	min_hardness <= A_hardness * vege_oil_proportion['A'] +
	B_hardness * vege_oil_proportion['B'] +
	C_hardness * nonvege_oil_proportion['C'] <= max_hardness;

#magazynowanie vege
subject to vege_oils_storage_january { i in vege_oilsTypes }:
	vege_refined_and_stored_oils['STYCZEN', i] <= 200 + v_oils_refining['STYCZEN', i];
	
subject to vege_oils_storage_febuary { i in vege_oilsTypes }:
	vege_refined_and_stored_oils['LUTY', i] <= 200 + v_oils_refining['STYCZEN', i] +
		v_oils_refining['LUTY', i] - vege_refined_and_stored_oils['STYCZEN', i];

#subject to vege_oils_storage_end { i in vege_oilsTypes }:
#	sum { k in months } vege_refined_and_stored_oils[k, i] <= sum { k in months } v_oils_refining[k, i];

#maksymalne magazynowanie vege
subject to vege_store_max { i in vege_oilsTypes }:
	200 + v_oils_refining['STYCZEN', i] + v_oils_refining['LUTY', i] - vege_refined_and_stored_oils['STYCZEN', i]  <= 800;
	

#magazynowanie nonvege
subject to nonvege_oils_storage_january { i in nonvege_oilsTypes }:
	nonvege_refined_and_stored_oils['STYCZEN', i] <= 200 + n_oils_refining['STYCZEN', i];
	
subject to nonvege_oils_storage_febuary {i in nonvege_oilsTypes}:
	nonvege_refined_and_stored_oils['LUTY', i] <= 200 + n_oils_refining['STYCZEN', i] +
		n_oils_refining['LUTY', i] - nonvege_refined_and_stored_oils['STYCZEN', i];

#subject to nonvege_oils_storage_end {i in nonvege_oilsTypes}:
#	sum { k in months } nonvege_refined_and_stored_oils[k, i] <= sum { k in months } n_oils_refining[k, i];

#maksymalne magazynowanie nonvege
subject to nonvege_store_max { i in nonvege_oilsTypes }:
	200 + n_oils_refining['STYCZEN', i] + n_oils_refining['LUTY', i] - nonvege_refined_and_stored_oils['STYCZEN', i]  <= 800;

#koszty magazynowania
subject to vege_storage_costs {i in vege_oilsTypes}: #koszty magazynowania oleju roslinnego
	vege_oils_storage_costs_sum[i] = 200 * 3 * storing_oil_cost +
	2 * storing_oil_cost * v_oils_refining['STYCZEN', i] +
	storing_oil_cost * v_oils_refining['LUTY', i] -
	2 * storing_oil_cost * vege_refined_and_stored_oils['STYCZEN', i] - storing_oil_cost * vege_refined_and_stored_oils['LUTY', i]; ; 
	
subject to nonvege_storage_costs {i in nonvege_oilsTypes}: #koszty magazynowania oleju nieroslinnego
	nonvege_oils_storage_costs_sum[i] = 200 * 3 * storing_oil_cost +
	2 * storing_oil_cost * n_oils_refining['STYCZEN', i] + storing_oil_cost * n_oils_refining['LUTY', i] -
	2 * storing_oil_cost * nonvege_refined_and_stored_oils['STYCZEN', i] - storing_oil_cost * nonvege_refined_and_stored_oils['LUTY', i]; 


#proporcje
subject to sum_of_proportion_equals_1:
	(sum { i in vege_oilsTypes } vege_oil_proportion[i] ) +
	(sum { i in nonvege_oilsTypes } nonvege_oil_proportion[i] ) = 1;

#produkcja
subject to vege_production { k in months, i in vege_oilsTypes }:
	production[k] * vege_oil_proportion[i] <= vege_refined_and_stored_oils[k,i];

subject to nonvege_production { k in months, i in nonvege_oilsTypes }:
	production[k] * nonvege_oil_proportion[i] <= nonvege_refined_and_stored_oils[k,i];

#funkcja celu
maximize RESULT:
	(sum { k in months } production[k]) * ready_oil_value -
	(
		(sum { k in months, i in vege_oilsTypes } vege_marketPrices[k, i] * v_oils_refining[k, i] ) +
		(sum { k in months, i in nonvege_oilsTypes} nonvege_marketPrices[k, i] * n_oils_refining[k, i] ) +
		(sum { i in vege_oilsTypes } vege_oils_storage_costs_sum[i] + sum{ i in nonvege_oilsTypes } nonvege_oils_storage_costs_sum[i] )
		
	);