source 'http://rubygems.org'

ruby '1.9.3'


gem 'rails', '3.0.20'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'paperclip', '2.3.15'
gem 'acts_as_list'
gem 'httpclient'
gem 'hpricot'
gem 'typus'
gem 'validates_timeliness', '~> 3.0.2'
gem 'aws-s3', '0.6.2'
gem 'nokogiri', '1.6.8.1'
gem 'rubyzip', '0.9.6.1'
gem 'sendgrid-ruby', '1.1.6'


group :development, :test do
   # Use thin as the web server
   gem 'thin'
   gem 'sqlite3'

   gem 'debugger'
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