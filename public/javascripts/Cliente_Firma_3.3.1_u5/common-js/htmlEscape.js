/* Copyright (C) 2012 [Gobierno de Espana]
 * This file is part of "Cliente @Firma".
 * "Cliente @Firma" is free software; you can redistribute it and/or modify it under the terms of:
 *   - the GNU General Public License as published by the Free Software Foundation; 
 *     either version 2 of the License, or (at your option) any later version.
 *   - or The European Software License; either version 1.1 or (at your option) any later version.
 * Date: 11/01/11
 * You may contact the copyright holder at: soporte.afirma5@seap.minhap.es
 */

function htmlEscape(html)
{
	var escaped= "";
	
	html = "" + html;
	
	var i, pos=0;
	for(i=0; i<html.length; i++)
	{
		if( !isAlfaNum( html.charAt(i) ) )
		{
			escaped += html.substring(pos, i);
			escaped += "&#" + html.charCodeAt(i) + ";";
			pos = i+1;
		}
	}
	escaped += html.substring(pos, html.length);

	return escaped;
}

function isAlfaNum(c)
{
	return isLetter(c) || isNumber(c) || isOtherAlphaNum(c);
}

function isOtherAlphaNum(c)
{
	switch (c)
	{
		case ' ':
		case '\t':
		case '\r':
		case '\n':
			return true;
	}
	return false;
}

function isLetter(c)
{
	return (c>='a' && c<='z') || (c>='A' && c<='Z');
}

function isNumber(c)
{
	return (c>='0' && c<='9');
}