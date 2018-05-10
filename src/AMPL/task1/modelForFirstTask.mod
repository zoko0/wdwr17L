set months;
set oilsTypes;

param marketPrices { months, oilsTypes };
#param n := 5;

var oils { months, oilsTypes } >= 0;
var production {months} >= 0;

maximize RESULT:
	(sum { k in months } production[k]) * 170 -
	(sum { k in months, i in oilsTypes} marketPrices[k, i] * oils[k, i]);