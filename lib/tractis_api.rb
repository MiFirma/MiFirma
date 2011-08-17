require 'httpclient'
require 'hpricot'

class TractisApi
  
  def self.signature_request(signature)
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/gateway"
    client.set_auth(target_url, "sergio.espeja@gmail.com", "testmifirma")
    data = "<contract>
 	   <name>#{signature.proposal.name}</name>
 	   <redirect-when-signed>#{signature.return_url}</redirect-when-signed>
 	   <template>#{signature.tractis_template_code}</template>
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
  
  def self.contract(contract_code="604622863")
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/#{contract_code}"
    client.set_auth(target_url, "sergio.espeja@gmail.com", "testmifirma")

  	response = client.get target_url, nil, "Accept" => "application/xml"
    response.content
  end
  
  def self.contract_signed?(response)
    (Hpricot(response)/"signed").text == "true"
  end
  
  def self.get_signatures(contract_code="604622863")
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/#{contract_code}/get_signatures"
    client.set_auth(target_url, "sergio.espeja@gmail.com", "testmifirma")

    response = client.get target_url
  end
  
end