require "test_helper"

class Admin::FilePreviewHelperTest < ActiveSupport::TestCase

  include Admin::FilePreviewHelper

  context "get_type_of_attachment" do

    setup do
      @asset = Factory(:asset)
    end

    should "return :dragonfly" do
      assert_equal :dragonfly, get_type_of_attachment(@asset.dragonfly)
    end

    should "return :paperclip" do
      assert_equal :paperclip, get_type_of_attachment(@asset.paperclip)
    end

  end

  context "link_to_detach_attribute" do

    setup do
      @asset = @item = Factory(:asset)
    end

    should "work for :dragonfly and return nil when attribute is required" do
      assert_nil link_to_detach_attribute('dragonfly_required')
    end

    should "work for :dragonfly and return link when attribute is not required" do
      assert_match /Remove/, link_to_detach_attribute('dragonfly')
    end

  end

  context "typus_file_preview_for_dragonfly" do

    should "return link for non image files" do
      file = File.new("#{Rails.root}/config/database.yml")
      @asset = Factory(:asset, :dragonfly => file)
      assert_equal @asset.dragonfly.name, typus_file_preview_for_dragonfly(@asset.dragonfly).first
      assert_match /media/, typus_file_preview_for_dragonfly(@asset.dragonfly).last
    end

    should "return image and link for image files" do
      @asset = Factory(:asset)
      assert_equal "admin/helpers/file_preview", typus_file_preview_for_dragonfly(@asset.dragonfly).first
      assert_match /media/, typus_file_preview_for_dragonfly(@asset.dragonfly).last[:preview]
      assert_match /media/, typus_file_preview_for_dragonfly(@asset.dragonfly).last[:thumb]
    end

  end

  context "typus_file_preview_for_paperclip" do

    setup do
      @asset = Factory(:asset)
    end

    should "return link for non image files" do
      Typus.expects(:file_preview).at_least_once.returns(nil)
      assert_equal "rails.png", typus_file_preview_for_paperclip(@asset.paperclip).first
      assert_equal "/system/paperclips/#{@asset.id}/original/rails.png", typus_file_preview_for_paperclip(@asset.paperclip).last
    end

    should "return image and link for image files" do
      expected = ["admin/helpers/file_preview",
                  {:preview => "/system/paperclips/#{@asset.id}/medium/rails.png",
                   :thumb => "/system/paperclips/#{@asset.id}/thumb/rails.png",
                   :options=>{}}]
      assert_equal expected, typus_file_preview_for_paperclip(@asset.paperclip)
    end

  end

  def link_to(*args); args; end
  def render(*args); args; end

end
