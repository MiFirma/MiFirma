require 'httpclient'
require 'hpricot'

class TractisApi
  
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
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/#{contract_code}/get_signatures"
    client.set_auth(target_url, "#{TRACTIS_USER}+#{signature.proposal.promoter_short_name}@#{TRACTIS_DOMAIN}", TRACTIS_PASS)


    response = client.get target_url
  end
  
end