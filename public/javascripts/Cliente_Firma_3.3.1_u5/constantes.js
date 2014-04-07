/* Copyright (C) 2012 [Gobierno de Espana]
 * This file is part of "Cliente @Firma".
 * "Cliente @Firma" is free software; you can redistribute it and/or modify it under the terms of:
 *   - the GNU General Public License as published by the Free Software Foundation; 
 *     either version 2 of the License, or (at your option) any later version.
 *   - or The European Software License; either version 1.1 or (at your option) any later version.
 * Date: 11/01/11
 * You may contact the copyright holder at: soporte.afirma5@seap.minhap.es
 */

/*******************************************************************************
 * Ruta al directorio de los instalables.									   *
 * Si no se establece, supone que estan en el mismo directorio que el HTML	   *
 * desde el que se carga el cliente.										   *
 * Las rutas absolutas deben comenzar por "file:///", "http://" o "https://"   *
 * (por ejemplo, "file:///C:/ficheros", "http://www.mpr.es/ficheros",...).	   *
 * Se debe usar siempre el separador "/", nunca "\". 	 					   *
 * El fichero "version.properties" se toma de esta ruta.					   *
 *******************************************************************************/
var baseDownloadURL = '/javascripts/Cliente_Firma_3.3.1_u5'

/*******************************************************************************
 * Ruta al directorio del instalador (Bootloader), los ficheros de			   *
 * configuración de JNLP y los núcleos del Cliente.							   *
 * Si no se establece, supone que esta en el mismo directorio que el HTML	   *
 * desde el que se carga el cliente.										   *
 * Las rutas absolutas deben comenzar por "file:///", "http://" o "https://"   *
 * por ejemplo, "file:///C:/Instalador", "http://www.mpr.es/instalador",...).  *
 * Se debe usar siempre el separador "/", nunca "\".						   *
 *******************************************************************************/
var base = '/javascripts/Cliente_Firma_3.3.1_u5'

/********************************************************************************
 * Algoritmo de firma. Puede ser 'SHA1withRSA', 'MD5withRSA' o, salvo que sea	*
 * firma XML, MD2withRSA. También se puede utilizar un algoritmo SHA-2			*
 * ('SHA512withRSA', 'SHA384withRSA' o 'SHA256withRSA'), teniendo en cuenta que	*
 * el usuario sólo podrá ejecutar esta firma si cuenta con Java 6u30 o superior *
 * o Java 7u2 o superior. Se estable al llamar a configuraFirma() en firma.js	*
 *******************************************************************************/
var signatureAlgorithm = 'SHA1withRSA'; // Valor por defecto

/*******************************************************************************
 * Formato de firma. Puede ser 'CMS', 'XADES', 'XMLDSIGN' o 'NONE'.            *
 * Se estable al llamar a configuraFirma en firma.js      				 *
 * Por defecto: CADES.										 *
 ******************************************************************************/
var signatureFormat = 'XADES Detached'; // Valor por defecto

/*******************************************************************************
 * Mostrar los errores al usuario. Puede ser 'true' o 'false'.                 *
 * Se estable al llamar a configuraFirma en firma.js                           *
 * Por defecto: false.										 *
 ******************************************************************************/
var showErrors = 'false'; // Valor por defecto

/*******************************************************************************
 * Filtro de certificados (expresión que determina que certificados se le      *
 * permite elegir al usuario). Ver la documentación.                           *
 * Se estable al llamar a configuraFirma en firma.js                           *
 *                                                                             *
 * Ejemplos:                                                                   *
 * - Solo mostrar certificados de DNIe de firma:                               *
 * var certFilter = '{ISSUER.DN#MATCHES#{"CN=AC DNIE 00(1|2|3),OU=DNIE,'+      *
 *      'O=DIRECCION GENERAL DE LA POLICIA,C=ES"}&&{SUBJECT.DN#MATCHES#'+      *
 *      '{".*(FIRMA).*"}}}';                                                   *
 *                                                                             *
 * - Sólo mostrar certificados de la FNMT:                                     *
 * var certFilter = '{ISSUER.DN={"OU = FNMT Clase 2 CA,O= FNMT,C = ES"}}';     *
 *                                                                             *
 * - Mostrar todos los certificados menos el de validacion:                    *
 * var certFilter = '{SUBJECT.DN#NOT_MATCHES#{".*(AUTENTICACIÓN).*"}}}'        *
 ******************************************************************************/
var certFilter = '{SUBJECT.DN#NOT_MATCHES#{".*(AUTENTICACIÓN).*"}}}';

/*******************************************************************************
 * Indica si se debe mostrar una advertencia a los usuarios de Mozilla Firefox *
 * en el momento de arrancar el cliente de firma. Ya que en los navegadores	 *
 * Mozilla los certificados de los tokens externos, como las tarjetas		 *
 * inteligentes, sólo se mostrarán si estaban insertados en el momento de abrir*
 * el almacén, será necesario que los usuarios los mantengan insertados en sus *
 * correspondientes lectores desde el inicio de la aplicación. Esta opción	 *
 * permite avisar a los usuarios para que actúen de esta forma. Las distintas	 *
 * opciones que se pueden indicar y los comportamientos asociados son los	 *
 * siguientes:											 *
 * 	- true: Mostrar advertencia.								 *
 *	- false: No mostrar advertencia.							 *
 * Por defecto: false (No mostrar advertencia).						 *
 ******************************************************************************/
var showMozillaSmartCardWarning = 'false';

/*******************************************************************************
 * Mostrar los certificados caducados en la listas de seleccion de		 *
 * certificados.						 					 *
 * Por defecto: 'true'.										 *
 ******************************************************************************/
var showExpiratedCertificates = 'true';

/*******************************************************************************
 * Construccion del cliente que se instalara cuando no se indique			 *
 * explicitamente.										 *
 * Los valores aceptados son:									 *
 *   - 'LITE':     Incluye los formatos de firma CMS y CADES.			 *
 *   - 'MEDIA':    Incluye los formatos de firma de la LITE + XMLDSIG y XADES. *
 *   - 'COMPLETA': Incluye los formatos de firma de la MEDIA + PDF.		 *
 * Por defecto: 'LITE'.										 *
 ******************************************************************************/
var defaultBuild = 'MEDIA';

/********************************************************************************
 * Localizaci&oacute;n para la aplicaci&oacute;n. En base a esta				*
 * localizaci&oacute;n se selecciona el idioma de los textos de la				*
 * aplicaci&oacute;n.					 					 					*
 * Por ejemplo: 'en_UK'.										 				*
 ********************************************************************************/
var locale;
