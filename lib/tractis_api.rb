require 'httpclient'
require 'hpricot'

class TractisApi

  def self.signature_request_attestor(signature)
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/gateway"
    client.set_auth(target_url, "#{TRACTIS_USER}+#{signature.proposal.promoter_short_name}@#{TRACTIS_DOMAIN}", TRACTIS_PASS)
    data = "<contract>
 	   <name>#{signature.proposal.name}</name>
 	   <redirect-when-signed>#{signature.return_url}</redirect-when-signed>
 	   <template>#{signature.attestor_template_code}</template>
		 <auto-complete>
		  <nacimiento>
				<fecha>#{signature.date_of_birth}</fecha>
				<municipio>#{signature.municipality_of_birth.name}</municipio>
				<provincia>#{signature.province_of_birth.name}</provincia>
			</nacimiento>
			<censo>
				<direccion>#{signature.address}</direccion>
				<provincia>#{signature.province.name}</provincia>
				<municipio>#{signature.municipality.name}</municipio>
			</censo>
			<fedatario>
				<email>#{signature.email}</email>
			</fedatario>
		 </auto-complete>
 	   <team>
 	     <member>
         <nombre>#{signature.name}</nombre>
         <apellidos>#{signature.surname}</apellidos>
         <dni>#{signature.dni}</dni>
 	       <email>#{signature.email}</email>
 	       <sign>true</sign>
 	       <invited>false</invited>
         <invitation_notify>false</invitation_notify>
 	     </member>
 	   </team>
 	 </contract>"
	 ::Rails.logger.debug data
	 response = client.post(target_url, data, "Content-Type" => "application/xml", "Accept" => "application/xml")
	 ::Rails.logger.debug "Respuesta - body"
	 ::Rails.logger.debug response.content
	 ::Rails.logger.debug "Respuesta - status"
	 ::Rails.logger.debug response.status
	 ::Rails.logger.debug "Respuesta - reason"
	 ::Rails.logger.debug response.reason
	 ::Rails.logger.debug "Respuesta - Headers - Location"
	 ::Rails.logger.debug response.header["Location"]
	 
 	 {:location => response.header["Location"].first}
  end

  def self.signature_request_endorsment(signature)
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/gateway_raw"
    client.set_auth(target_url, "#{TRACTIS_USER}+#{signature.proposal.promoter_short_name}@#{TRACTIS_DOMAIN}", TRACTIS_PASS)

		dataOCE = createXMLOCE(signature)
		::Rails.logger.debug(dataOCE)
		
    errors = self.validates_against_xsd(dataOCE)
		
		if !errors.empty? then
			::Rails.logger.debug(errors)
			raise StandardError, "XML del Aval no es correcto. Contacte con mifirma."
		end

		dataTRACTIS = "<contract>
			<name>#{signature.endorsment_proposal.name}</name>dd
			<redirect-when-signed>#{signature.return_url}</redirect-when-signed>
			<template>#{signature.tractis_template_code}</template>
			<notes>A continuación te mostramos el texto que vas a firmar, tal cual se enviará a la Junta Electoral Central. Como verás, incluye los siguientes datos separados por espacios:
* Nombre completo del avalista
* Fecha de nacimiento del avalista
* Tipo de documento del avalista ('1' para NIF, '2' para NIE)
* Número de DNI del avalista
* Órgano al que se presenta el partido avalado ('Congreso', 'Senado' o 'Congreso y Senado').
* Circunscripción a la que pertenece el avalista
* Nombre del partido avalado
Si los datos están correctos, por favor, pulsa el botón de 'Firmar'
Este documento a firmar sigue la estructura (XML) exigida por la Junta Electoral Central</notes>
			<sticky-notes>true</sticky-notes>
			<raw-xml-content>
				#{dataOCE}
			</raw-xml-content>
			<team>
	     <member>
         <nombre>#{signature.name}</nombre>
         <apellidos>#{signature.surname}</apellidos>
         <dni>#{signature.dni}</dni>
 	       <email>#{signature.email}</email>
 	       <sign>true</sign>
 	       <invited>false</invited>
         <invitation_notify>false</invitation_notify>
 	     </member>
			</team>
		</contract>"
		
		::Rails.logger.debug dataTRACTIS
		
    response = client.post(target_url, dataTRACTIS, "Content-Type" => "application/xml", "Accept" => "application/xml")
		
    location = response.header["Location"].first
		if :location
			signature.update_attribute :tractis_contract_location, location
			return true
		else
			raise StandardError, "Error de comunicación con Tractis, por favor vuelva a intentarlo."
		end
  end

  def self.signature_request_ilp(signature)
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/gateway"
    client.set_auth(target_url, "#{TRACTIS_USER}+#{signature.proposal.promoter_short_name}@#{TRACTIS_DOMAIN}", TRACTIS_PASS)
    data = "<contract>
 	   <name>#{signature.proposal.name}</name>
 	   <redirect-when-signed>#{signature.return_url}</redirect-when-signed>
 	   <template>#{signature.tractis_template_code}</template>
		 <auto-complete>
		  <nacimiento>
				<fecha>#{signature.date_of_birth}</fecha>
				<municipio>#{signature.municipality_of_birth.name}</municipio>
				<provincia>#{signature.province_of_birth.name}</provincia>
			</nacimiento>
			<censo>
				<direccion>#{signature.address}</direccion>
				<provincia>#{signature.province.name}</provincia>
				<municipio>#{signature.municipality.name}</municipio>
				<codpostal>#{signature.zipcode}</codpostal>
			</censo>
		 </auto-complete>
 	   <team>
 	     <member>
         <nombre>#{signature.name}</nombre>
         <apellidos>#{signature.surname}</apellidos>
         <dni>#{signature.dni}</dni>
 	       <email>#{signature.email}</email>
 	       <sign>true</sign>
 	       <invited>false</invited>
         <invitation_notify>false</invitation_notify>
 	     </member>
 	   </team>
 	 </contract>"
	 ::Rails.logger.debug data
	 response = client.post(target_url, data, "Content-Type" => "application/xml", "Accept" => "application/xml")
 	 {:location => response.header["Location"].first}
  end
  
  def self.contract(contract_code="604622863",signature)
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/#{contract_code}"
    client.set_auth(target_url, "#{TRACTIS_USER}+#{signature.proposal.promoter_short_name}@#{TRACTIS_DOMAIN}", TRACTIS_PASS)
  	response = client.get target_url, nil, "Accept" => "application/xml"
    response.content
  end
  
	
  def self.contract_signed?(response)
    (Hpricot(response)/"signed").text == "true"
  end
  
  def self.get_signatures(contract_code="604622863",signature)
    client2 = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/#{contract_code}/get_signatures"
		::Rails.logger.debug "Usuario: #{TRACTIS_USER}+#{signature.proposal.promoter_short_name}@#{TRACTIS_DOMAIN}"
		::Rails.logger.debug "Contraseña: #{TRACTIS_PASS}"
    client2.set_auth(nil, "#{TRACTIS_USER}+#{signature.proposal.promoter_short_name}@#{TRACTIS_DOMAIN}", TRACTIS_PASS)
		client2.www_auth.basic_auth.challenge(target_url)
    response = client2.get target_url
  end
  

  private

	def self.createXMLOCE(signature)
	    dataOCE = <<-XML
      <oce>
          <avalcandidatura>
              <avalista>
                  <nomb>#{signature.name}</nomb>
                  <ape1>#{signature.surname}</ape1>
                  <ape2>#{signature.surname2}</ape2>
                  <fnac>#{signature.date_of_birth.strftime("%Y%m%d")}</fnac>
                  <tipoid>1</tipoid>
                  <id>#{signature.dni}</id>
              </avalista>
              <candidatura>
                  <elecciones>#{signature.endorsment_proposal.election_type}</elecciones>
                  <circunscripcion>#{signature.province.name}</circunscripcion>
                  <nombre>#{signature.endorsment_proposal.promoter_name}</nombre>
              </candidatura>
          </avalcandidatura>
      </oce>
    XML
		return dataOCE
	end
  #
  # Validates input xml against the xsd schema.
  #
  def self.validates_against_xsd(input_xml)
    errors = []

    begin
      xsd_file = File.join(Rails.root, 'lib', 'endorsment.xsd')
      xsd = Nokogiri::XML::Schema(File.read(xsd_file))
      doc = Nokogiri::XML(input_xml)

      xsd.validate(doc).each do |error|
        errors << error
      end
    rescue Exception => ex
      errors << ex.message
    end

    errors
  end

end
