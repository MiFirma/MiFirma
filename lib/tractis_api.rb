class TractisApi
  
  def self.signature_request(signature)
    sess = Patron::Session.new
    sess.base_url = "https://sergio.espeja%40gmail.com:testmifirma@www.tractis.com"
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
 	 response = sess.post("/contracts/gateway", data, {"Content-Type" => "application/xml", "Accept" => "application/xml"})

   #TODO: Catch errors
 	 {:location => response.headers["Location"]}
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