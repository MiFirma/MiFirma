source 'http://rubygems.org'

gem 'rails', '3.0.20'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'paperclip'
gem 'acts_as_list'
gem 'httpclient'
gem 'hpricot'
gem 'typus', '3.0.10'
gem 'validates_timeliness', '~> 3.0.2'
gem 'aws-s3'
gem 'nokogiri'
gem 'rubyzip'


group :development, :test do
   # Use thin as the web server
   gem 'thin'
   gem 'sqlite3'

   gem 'ruby-debug19', :require => 'ruby-debug'
   gem 'annotate'
end

# Bundle gems for heroku
group :staging, :production do
	gem 'newrelic_rpm'
	gem 'pg'
	platform :ruby do
		gem 'unicorn'
	end
end
	
gem 'rack-ssl', :require => 'rack/ssl'