ENV["RAILS_ENV"] = "test"

##
# Boot rails_app and load the schema.
#
require "fixtures/rails_app/config/environment"
require "fixtures/rails_app/db/schema"

require "rails/test_help"
require "factories"

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
