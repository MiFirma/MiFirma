class TractisApi
  
  def self.signature_request
    sess = Patron::Session.new
    sess.base_url = "https://sergio.espeja%40gmail.com:testmifirma@www.tractis.com"
    data = '<contract>
 	   <name>Apoyo a campaña Z</name>
 	   <redirect-when-signed>http://www.mifirma.es/confirm_signature/XCJXW223KESJKDFSD23SWJSDFSDFSDFSDFSDF</redirect-when-signed>
 	   <template>249186096</template>
 	   <team>
 	     <member>
 	       <email>signers@mifirma.com</email>
 	       <sign>true</sign>
 	       <invited>false</invited>
                <invitation_notify>false</invitation_notify>
 	     </member>
 	   </team>
 	 </contract>'
 	 response = sess.post("/contracts/gateway", data, {"Content-Type" => "application/xml", "Accept" => "application/xml"})
 	 # response.headers["Location"]
  end
  
  def self.contract(contract_id="604622863")
    sess = Patron::Session.new
    sess.base_url = "https://sergio.espeja%40gmail.com:testmifirma@www.tractis.com"
    sess.headers['Accept'] = 'application/xml'
  	response = sess.get("/contracts/#{contract_id}")
    # (Hpricot(response.body)/"signed").text
  end
  
  def self.get_signatures(contract_id="604622863")
    sess = Patron::Session.new
    sess.base_url = "https://sergio.espeja%40gmail.com:testmifirma@www.tractis.com"
#    sess.headers['Accept'] = 'application/xml'
  	response = sess.get("/contracts/#{contract_id}/get_signatures")    
  end
  
end