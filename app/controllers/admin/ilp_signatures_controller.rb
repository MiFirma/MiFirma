class Admin::IlpSignaturesController < Admin::ResourcesController
	cache_sweeper :signature_sweeper  
end
