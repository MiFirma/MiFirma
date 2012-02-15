class SignatureSweeper < ActionController::Caching::Sweeper
  observe Signature # This sweeper is going to keep an eye on the Signature model
 
  # If our sweeper detects that a Signature was created call this
  def after_create(signature)
		if signature.state == 1 
			expire_cache_for(signature)
		end
  end
 
  # If our sweeper detects that a Signature was updated call this
  def after_update(signature)
    expire_cache_for(signature)
  end
 
  # If our sweeper detects that a Signature was deleted call this
  def after_destroy(signature)
    expire_cache_for(signature)
  end
 
  private
  def expire_cache_for(signature)
    # Expire the index page now that we added a new signature
    expire_page('/')
  end
end