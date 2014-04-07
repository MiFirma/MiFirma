/* Copyright (C) 2012 [Gobierno de Espana]
 * This file is part of "Cliente @Firma".
 * "Cliente @Firma" is free software; you can redistribute it and/or modify it under the terms of:
 *   - the GNU General Public License as published by the Free Software Foundation; 
 *     either version 2 of the License, or (at your option) any later version.
 *   - or The European Software License; either version 1.1 or (at your option) any later version.
 * Date: 11/01/11
 * You may contact the copyright holder at: soporte.afirma5@seap.minhap.es
 */

function getStyles(doc)
{
	if(!doc)
	{
		return "";
	}

	var xml = "";
	
	if(!isEmpty(doc.styleSheets))
	{
		var i;
		for(i=0; i<doc.styleSheets.length; i++)
		{
			var styleSheet = doc.styleSheets[i];
			xml += getStyleSheetText(styleSheet) + '\n';
		}
	}
	
	var text = xml;
	var aux;	
	while(text.indexOf("-moz")!=-1 && aux!=text)
	{	/* Eliminamos las reglas que comiencen por "-moz", exclusivas de mozilla */
		aux = text;
		text= text.replace(/-moz[^\:]*\:[^\;\}]*;/, "");
		text= text.replace(/-moz[^\:]*\:[^\;\}]*}/, "}");
	}
	
	aux = "";
	while(text.indexOf("rgb")!=-1 && aux!=text)
	{	/* Convertimos los rgb pq el visor no los interpreta bien */
		aux = text;
		
		var posIni = aux.search(/rgb[\\s]*\([^\)]*\)/);
		var posFin = aux.indexOf(")", posIni);
		var rgbStr1 = aux.substring(posIni, posFin+1);
		var pos1 = rgbStr1.indexOf("(");
		var pos2 = rgbStr1.indexOf(")");
		var rgbStr2 = rgbStr1.substring(pos1+1, pos2);
		var rgbNum = rgbStr2.split(",");
		var red   = toHex(rgbNum[0]);
		var green = toHex(rgbNum[1]);
		var blue  = toHex(rgbNum[2]);
		var newColor = "#"+red+green+blue;
		
		text= text.replace(rgbStr1, newColor);
	}
	xml = text;
	
	return xml;
}

function getStyleSheetText(styleSheet)
{
	if(!styleSheet)
	{
		return "";
	}

	var xml = "";

	// styleSheet.cssRules -> Mozilla, styleSheet.rules -> IE4+
	var cssRules = styleSheet.cssRules?styleSheet.cssRules:styleSheet.rules; 
	if(!isEmpty(cssRules))
	{
		var j;
		for(j=0; j<cssRules.length; j++)
		{
			var cssRule = cssRules[j];
			xml+= getStyleCSSRuleText(cssRule) + '\n';
		}
	}
	
	if(!isEmpty(styleSheet.imports))
	{	/* IE4+ */
		var k;
		for(k=0; k<styleSheet.imports.length; k++)
		{
			var imp = styleSheet.imports[k];
			xml += getStyleSheetText(imp) + '\n';
		}
	}
	
	return xml;
}

function getStyleCSSRuleText(cssRule)
{
	if(!cssRule)
	{
		return "";
	}

	var xml = "";

	if(cssRule && cssRule.type!= 3)
	{	/* cssRule.type = 3 -> import */
		if(cssRule.cssText)
		{	/* W3C DOM -> IE6+, NN6+, Mozilla */
			xml = cssRule.cssText;
		}
		else if(cssRule.selectorText && cssRule.style.cssText)
		{	/* IE4+ */
			xml = cssRule.selectorText + " { " + cssRule.style.cssText+" }";
		}
	}
	
	return xml;
}

