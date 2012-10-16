var clienteFirma;

function cargarMiniApplet(base, keystore)
{
	var codeBase = base;
	if (codeBase == undefined || codeBase == null) {
		codeBase = '.';
	}

	var keystoreConfig = keystore;
	if (keystoreConfig == undefined) {
		keystoreConfig = null;
	}

	var jarArchive = codeBase + '/' + "miniapplet-full.jar";
	
	var attributes = {
		id: 'miniApplet',
	 	width: 1,
		height: 1
	};
	var parameters = {
		jnlp_href: codeBase + '/miniapplet-full.jnlp',
		keystore: keystoreConfig,
		userAgent: window.navigator.userAgent,
		code: 'es.gob.afirma.miniapplet.MiniAfirmaApplet.class',
		archive: jarArchive,
		codebase: codeBase,
		java_arguments: '-Djnlp.packEnabled=true -Xms512M -Xmx512M',
		separate_jvm: true
	};

 	deployJava.runApplet(attributes, parameters, '1.6');

	clienteFirma = document.getElementById("miniApplet");
}

var KEYSTORE_WINDOWS = "WINDOWS";

var KEYSTORE_APPLE = "APPLE";

var KEYSTORE_PKCS12 = "PKCS12";

var KEYSTORE_PKCS11 = "PKCS11";

var KEYSTORE_FIREFOX = "MOZ_UNI";

function sign(dataB64, algorithm, format, params) {
	return clienteFirma.sign(dataB64, algorithm, format, params);
}

function coSign(signB64, dataB64, algorithm, format, params) {
	return clienteFirma.coSign(signB64, dataB64, algorithm, format, params);
}

function counterSign(signB64, algorithm, format, params) {
	return clienteFirma.counterSign(signB64, algorithm, format, params);
}

function getSignersStructure(signB64) {
	return clienteFirma.getSignersStructure(signB64);
}

function getBase64FromText(plainText, charset) {
	return clienteFirma.getBase64FromText(plainText, charset);
}

function getTextFromBase64(dataB64, charset) {
	return clienteFirma.getTextFromBase64(dataB64, charset);
}

function saveDataToFile(dataB64, title, fileName, extension, description) {
	return clienteFirma.saveDataToFile(dataB64, title, fileName, extension, description);
}

function getFileNameContentBase64(title, extensions, description) {
	return clienteFirma.getFileNameContentBase64(title, extensions, description);
}

function getMultiFileNameContentBase64(title, extensions, description) {
	return clienteFirma.getMultiFileNameContentBase64(title, extensions, description);
}

function getErrorMessage() {
	return clienteFirma.getErrorMessage();
}

