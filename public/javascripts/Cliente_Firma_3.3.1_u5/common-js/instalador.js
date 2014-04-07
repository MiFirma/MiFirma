/* Copyright (C) 2013 [Gobierno de Espana]
 * This file is part of "Cliente @Firma".
 * "Cliente @Firma" is free software; you can redistribute it and/or modify it under the terms of:
 *   - the GNU General Public License as published by the Free Software Foundation; 
 *     either version 2 of the License, or (at your option) any later version.
 *   - or The European Software License; either version 1.1 or (at your option) any later version.
 * Date: 11/01/11
 * You may contact the copyright holder at: soporte.afirma5@seap.minhap.es
 */

/**
 *
 * Version: 4.0.0
 *
 * Dependencia opcional de constantes.js
 *
 * Si se ha definido baseDownloadURL en constantes.js se usa como URL base para la descarga de los instalables.
 *
 * cargarAppletFirma():
 *      Carga el applet de firma en la variable "clienteFirma".
 */

var clienteFirma;

function cargarAppletFirma(build)
{
	/* Si ya esta cargado, no continuamos con el proceso */
	if (clienteFirma != undefined) {
		return;
	}
	
	/* Definimos las contruccion que se va a utilizar */
	var confBuild = configureBuild(build);
	var jarArchive = confBuild + "_j6_afirma5_core.jar";
		
	var codeBase = base;
	if (codeBase == undefined || codeBase == null) {
		codeBase = '.';
	}

	var defaultLocale = locale;
	if (defaultLocale == undefined) {
		defaultLocale = null;
	}

	var attributes = {
		id: 'firmaApplet',
		name: 'Applet Cliente @firma (Gobierno de Espa\u00F1a)',
		type: 'application/x-java-applet',
	 	width: 1,
		height: 1
	};
	
	// Se configuran los parametrospara un despliegue tradicional del applet debido a los problema con
	// JNLP en Mac OS X, Linux con IcedTea y algunos entornos Windows 7/8
	var parameters = {
			userAgent: window.navigator.userAgent,
			appName: window.navigator.appName,
			showExpiratedCertificates: showExpiratedCertificates,
			showMozillaSmartCardWarning: showMozillaSmartCardWarning,
			code: 'es.gob.afirma.applet.SignApplet',
			archive: codeBase + "/" + jarArchive,
			locale: defaultLocale,
			java_arguments: '-Xms512M -Xmx512M',
			codebase_lookup: false,
			separate_jvm: true
	};

	loadApplet(attributes, parameters);

	clienteFirma = document.getElementById("firmaApplet");
	
	/* Realizamos una espera para que de tiempo a cargarse el applet */
	for (var i = 0; i < 100; i++) {
		try {
			setTimeout("clienteFirma != undefined && clienteFirma.isInitialized()", 100);
			break;
		} catch (e) {
			/*
			 * Capturamos la excepcion que se produciria si no se hubiese cargado aun el applet, aunque no se lanzaria
			 * una vez estuviese cargado aunque no iniciado
			 */
		}
	}
};

/**
 * Si no se ha indicado una construccion por parametro, ni hay establecida una por defecto en "constantes.js", se instala la 'LITE'
 */
function configureBuild(build)
{
	var confBuild = null;
	if(build != null && build != undefined)
	{
		confBuild = build;
	}
	else if(defaultBuild != null && defaultBuild != undefined) {
		confBuild = defaultBuild;
	}
	else {
		confBuild = 'LITE';
	}
	return confBuild;
};

function loadApplet (attributes, parameters) {

	// Segun sea Internet Explorer 7/8 o cualquier otro navegador, inicializamos de una forma u otra el applet
	if (navigator.appVersion.toUpperCase().indexOf("MSIE 7.0") != -1 || navigator.appVersion.toUpperCase().indexOf("MSIE 8.0") != -1) {
		
		var appletTag = "<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93' width='1' height='1' id='" + attributes["id"] + "'>";
			
		if (attributes != undefined && attributes != null) {
			for (var attribute in attributes) {
				appletTag += "<param name='" + attribute + "' value='" + attributes[attribute] + "' />";
			}
		}

		if (parameters != undefined && parameters != null) {
			for (var parameter in parameters) {
				appletTag += "<param name='" + parameter + "' value='" + parameters[parameter] + "' />";
			}
		}

		appletTag += "</object>";
		document.write(appletTag);

	}
	else {
		var embed = document.createElement("embed");

		if (attributes != undefined && attributes != null) {
			for (var attribute in attributes) {
				var att = document.createAttribute(attribute);
				var attValue = attributes[attribute];
				att.value = attValue;
				embed.setAttributeNode(att);
			}
		}

		if (parameters != undefined && parameters != null) {
			for (var parameter in parameters) {
				var att = document.createAttribute(parameter);
				att.value = parameters[parameter];
				embed.setAttributeNode(att);
			}
		}

		document.body.appendChild(embed);
	}
}