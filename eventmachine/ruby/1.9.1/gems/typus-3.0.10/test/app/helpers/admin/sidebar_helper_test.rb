# -*- encoding: utf-8 -*-

require "test_helper"

class Admin::SidebarHelperTest < ActiveSupport::TestCase

  include Admin::SidebarHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper

  def render(*args); args; end
  def link_to(*args); args; end

  setup do
    default_url_options[:host] = 'test.host'
  end

  context "export" do

    should "return array with expected values" do
      params = { :controller => '/admin/posts', :action => 'index' }

      output = export(Post , params)
      expected = [["Export as CSV", { :action => "index", :format => "csv", :controller => "/admin/posts" }],
                  ["Export as XML", { :action => "index", :format => "xml", :controller => "/admin/posts" }]]

      assert_equal expected, output
    end

  end

end
