class News < ActiveRecord::Base
	validates_presence_of :title, :description, :expiration_date

	#When the proposal still can collect signatures
	scope :not_expirated, lambda { where("expiration_date >= ?", Time.now ) }
end
