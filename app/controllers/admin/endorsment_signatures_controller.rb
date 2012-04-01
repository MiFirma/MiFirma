class Admin::EndorsmentSignaturesController < Admin::ResourcesController
	cache_sweeper :signature_sweeper  
end
