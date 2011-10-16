module ApplicationHelper

	def page_title
		(content_for(:title) + " -- " if content_for(:title)).to_s + 'MiFirma'
	end

end
