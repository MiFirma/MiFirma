require 'httpclient'
require 'nokogiri'

class PSISApi
  #resultats de validació de PSIS
	PSIS_RESULTMAJOR_OK = "urn:oasis:names:tc:dss:1.0:resultmajor:Success"
	PSIS_RESULTMINOR_VALID = "urn:oasis:names:tc:dss:1.0:profiles:XSS:resultminor:valid:certificate:Definitive"
	PSIS_RESULTMINOR_EXPIRED = "urn:oasis:names:tc:dss:1.0:profiles:XSS:resultminor:invalid:certificate:Expired"
	PSIS_RESULTMINOR_REVOKED = "urn:oasis:names:tc:dss:1.0:profiles:XSS:resultminor:invalid:certificate:Revoked"
	PSIS_RESULTMINOR_UNKNOWN = "urn:oasis:names:tc:dss:1.0:profiles:XSS:resultminor:unknown:certificate:Status_NoCertificatePathFound"
	PSIS_RESULTMINOR_POLICYNOTSUPPORTED = "urn:oasis:names:tc:dss:1.0:profiles:XSS:resultminor:invalid:certificate:CertificatePolicyNotSupported"
	
	attr_reader  :psisNIF
	
	def initialize
      @target_url = "http://psis.catcert.net/psis/catcert/dss"
  end
	
	def isValid?
			return @valid_cert
	end

	# Cert in BASE64
	def validate(cert)
			
		xml = "<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
		   <SOAP-ENV:Body>
		   <VerifyRequest Profile=\"urn:oasis:names:tc:dss:1.0:profiles:XSS\" xmlns=\"urn:oasis:names:tc:dss:1.0:core:schema\" xmlns:urn=\"urn:oasis:names:tc:dss:1.0:profiles:XSS\" xmlns:xd=\"http://www.w3.org/2000/09/xmldsig#\">
		   <OptionalInputs><urn:ReturnX509CertificateInfo><urn:AttributeDesignator Name=\"urn:catcert:psis:certificateAttributes:KeyOwnerNIF\"/></urn:ReturnX509CertificateInfo></OptionalInputs>
		   <SignatureObject><Other><xd:X509Data><xd:X509Certificate>#{cert}</xd:X509Certificate></xd:X509Data></Other></SignatureObject>
		   </VerifyRequest>
		   </SOAP-ENV:Body>
			 </SOAP-ENV:Envelope>"
		
		#http client
		httpClient = HTTPClient.new
    
			
	    #retrieve response body
		response = httpClient.post(@target_url, xml, "Content-Type" => "application/xml")
	        
	  if response
			::Rails.logger.debug "Respuesta PSIS content"
			::Rails.logger.debug response.content
			#puts  "Respuesta PSIS content"
			#puts response.content
			
			::Rails.logger.debug "Respuesta PSIS status"
			::Rails.logger.debug response.status
	
			#puts "Respuesta PSIS status"
			#puts response.status
			
			doc = Nokogiri::XML(response.content)
			
			doc.remove_namespaces!
			@psisNIF = doc.xpath('/Envelope/Body/VerifyResponse/OptionalOutputs/X509CertificateInfo/Attribute[@Name="urn:catcert:psis:certificateAttributes:KeyOwnerNIF"]/AttributeValue').inner_text

			::Rails.logger.debug "PSIS NIF:"
			::Rails.logger.debug @psisNIF
			
			@valid_cert = (response != nil) && (response.content.include? PSIS_RESULTMAJOR_OK) && (response.content.include? PSIS_RESULTMINOR_VALID)
			
    else
	    @valid_cert = false
	  end
	end
end
