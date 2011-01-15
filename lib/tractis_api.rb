require 'httpclient'

class TractisApi
  
  def self.signature_request(signature)
    client = HTTPClient.new
    target_url = "https://www.tractis.com/contracts/gateway"
    client.set_auth(target_url, "sergio.espeja@gmail.com", "testmifirma")
    data = "<contract>
 	   <name>#{signature.proposal.name}</name>
 	   <redirect-when-signed>#{signature.return_url}</redirect-when-signed>
 	   <template>249186096</template>
 	   <team>
 	     <member>
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
    sess = Patron::Session.new
    sess.base_url = "https://sergio.espeja%40gmail.com:testmifirma@www.tractis.com"
    sess.headers['Accept'] = 'application/xml'
  	response = sess.get("/contracts/#{contract_code}")
    # (Hpricot(response.body)/"signed").text
  end
  
  def self.get_signatures(contract_code="604622863")
    sess = Patron::Session.new
    sess.base_url = "https://sergio.espeja%40gmail.com:testmifirma@www.tractis.com"
#    sess.headers['Accept'] = 'application/xml'
  	response = sess.get("/contracts/#{contract_code}/get_signatures")    
  end
  
end