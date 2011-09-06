class Admin::SignaturesController < Admin::ResourcesController
	cache_sweeper :signature_sweeper  
end
