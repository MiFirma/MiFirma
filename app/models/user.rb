class User < ActiveRecord::Base
	attr_accessible	:name, :email
	
	email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	
	validates :name, 	:presence 	=> true,
										:length 		=> { :maximum => 100 }
	validates :email, :presence 	=> true,
										:format 		=> { :with => email_regex },
										:uniqueness => { :case_sensitive => false }
									
end
