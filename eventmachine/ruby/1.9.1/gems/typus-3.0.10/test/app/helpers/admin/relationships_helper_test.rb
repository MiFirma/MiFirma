require "test_helper"

class Admin::RelationshipsHelperTest < ActiveSupport::TestCase

  include Admin::RelationshipsHelper

  should_eventually "test setup_relationship"
  should_eventually "test typus_form_has_many"
  should_eventually "test typus_form_has_and_belongs_to_many"
  should_eventually "test build_pagination"
  should_eventually "test build_relate_form"
  should_eventually "test build_relationship_table"
  should_eventually "test build_add_new"
  should_eventually "test set_condition"
  should_eventually "test set_conditions"
  should_eventually "test typus_form_has_one"
  should_eventually "test typus_belongs_to_field"

end
