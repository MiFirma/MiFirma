/* Copyright (C) 2012 [Gobierno de Espana]
 * This file is part of "Cliente @Firma".
 * "Cliente @Firma" is free software; you can redistribute it and/or modify it under the terms of:
 *   - the GNU General Public License as published by the Free Software Foundation; 
 *     either version 2 of the License, or (at your option) any later version.
 *   - or The European Software License; either version 1.1 or (at your option) any later version.
 * Date: 11/01/11
 * You may contact the copyright holder at: soporte.afirma5@seap.minhap.es
 */

/*
 * Depende de instalador.js y de constantes.js (opcional)
 *
 * initialize():
 *      Vuelve el applet a su estado inicial
 *
 * getEstructuraNodos():
 *      Devuelve una cadena que contiene los nombres de los firmantes de cada firma, co-firma y contra-firma. Los nombres van separados por '\n' y
 *      empiezan por tantos '\t' como nivel ocupe el nodo en el arbol. P. ej, para la siguiente estructura de nodos:
 *       +---> A
 *       | +---> C
 *       | +---> D
 *       +---> B
 *       +---> E
 *      El documento est? co-firmado por A, B y E, y la co-firma de A, est? contra-firmada por C y D. La cadena que devolver?a getEstructuraNodos() es
 *      la siguiente: "A\n\tC\n\tD\nB".
 *
 * firmar(), coFirmar(), contraFirmarNodos([cadenaDeIndices]), contraFirmarArbol(), contraFirmarHojas(), contraFirmarFirmantes([cadenaDeFirmantes]):
 *      Inician los respectivos procesos de firma
 *		-> cadenaDeIndices es una cadena de enteros separados por '\n' que indican qu? nodos contraFirmar. Los indices(0, 1, ...) est?n referidos al 
 *        resultado de getEstructuraNodos(). Por ejemplo, para firmar los nodos 0 y 4 la cadena ser?a '0\n4'
 *      -> cadenaDeFirmantes es una cadena de nombres de firmantes separados por '\n' que indican qu? firmantes contrafirmar. Los nombres de los
 *        posibles firmantes se obtienen de getEstructuraNodos().
 *
 * getCertificatesAlias(), getCertificates():
 *      Recuperan los alias de los certificados del keystore activo y los propios certificados codificados
 *      en Base 64, respectivamente. Los elementos son devueltos en forma de array.
 */


/**
 * Establece los valores de firma. Ver constantes.js.
 */ 
function configuraFirma()
{
	var command	= "";

	if( certFilter != undefined )
	command	+= "clienteFirma.setCertFilter('"+certFilter+"');";

	if( signatureAlgorithm != undefined )
	{
		command	+= "clienteFirma.setSignatureAlgorithm('"+signatureAlgorithm+"');";
	}
	if( signatureFormat != undefined )
	{
		command	+= "clienteFirma.setSignatureFormat('"+signatureFormat+"');";
	}

	eval(command);
}

/**
 * Prepara el cliente para iniciar un proceso de firma.
 */
function initialize()
{
	clienteFirma.initialize();
	clienteFirma.setShowErrors(showErrors=='true');
}

function firmar()
{
	clienteFirma.sign();
}

function coFirmar()
{
	clienteFirma.coSign();
}

function contraFirmarNodos(cadenaDeIndices)
{
	var command	= "clienteFirma.counterSignIndexes()";
	if(cadenaDeIndices != undefined)
	{
		command	= "clienteFirma.setSignersToCounterSign('"+cadenaDeIndices+"'); " + command;
	}
	
	eval(command);
}

function contraFirmarArbol()
{
	clienteFirma.counterSignTree();
}

function contraFirmarHojas()
{
	clienteFirma.counterSignLeafs();
}

function contraFirmarFirmantes(cadenaDeFirmantes)
{
	var command	= "clienteFirma.counterSignSigners()";
	if(cadenaDeFirmantes != undefined)
	{
		command	= "clienteFirma.setSignersToCounterSign('"+cadenaDeFirmantes+"'); " + command;
	}
	
	eval(command);
}

function getEstructuraNodos()
{
	return clienteFirma.getSignersStructure();
}

/*
 * Devuelve un array con los alias de los certificados del keystore activo.
 */
function getCertificatesAlias()
{

	/* Ya que en Firefox 2 no funciona la funcion split() de cadenas en JavaScript, hacemos un
	 * proceso distinto de la cadena para obtener el mismo resultado que esta funcion.
	 */
	if(isFireFox2()) {
		return dividir(clienteFirma.getCertificatesAlias(), clienteFirma.STRING_SEPARATOR);
	} else {
		return clienteFirma.getCertificatesAlias().split(clienteFirma.STRING_SEPARATOR);
	}
}

/*
 * Devuelve un array con los certificados del keystore activo codificados en Base 64.
 */
function getCertificates()
{
	return dividir(clienteFirma.getCertificates(), clienteFirma.STRING_SEPARATOR);
}

/*
 * Comprueba que el navegador Web sea Firefox 2.
 */
function isFireFox2()
{
	if(window.navigator.appName == 'Netscape') {
		var userAgent = window.navigator.userAgent;
		
		//posici�n de la cadena que coge la parte  de la versi�n de Firefox
		posfinal = userAgent.lastIndexOf('/') + 2; 
		//posicion de la cadena que devuelve si realmente es Firefox
		posinicial=  userAgent.lastIndexOf('/') - 7;
		navigator = userAgent.substring(posinicial, posfinal);
	
		if(navigator== 'Firefox/2') {
			return true;
		}
	}
	return false;
}

/*
 * Divide una cadena en un array de cadenas en donde el criterio de separacion era un delimitador.
 */
function dividir(text, delimitator)
{
	var nDel = 0;
	var tempPos = 0;
	var tempPos2 = 0;

	/* Contamos el numero de cadenas que debemos extraer de la principal. */
	while((tempPos = text.indexOf(delimitator, tempPos)) != -1) {
		nDel++;
		tempPos += delimitator.length;
	}
	
	/* Creamos el array en donde almacenaremos las cadenas. */
	var substrings = new Array(nDel+1);

	/* Recorremos la cadena principal extrayendo las subcadenas. */
	tempPos = 0;
	for(var i=0; i < nDel; i++) {
		tempPos2 = text.indexOf(delimitator, tempPos);
		substrings[i] = text.substring(tempPos, tempPos2);
		tempPos = tempPos2 + delimitator.length;
	}
	substrings[nDel] = text.substring(tempPos);

	return substrings;
}