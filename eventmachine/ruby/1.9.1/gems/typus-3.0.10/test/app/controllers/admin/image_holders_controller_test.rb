require "test_helper"

=begin

  What's being tested here?

    - Polymorphic associations.

=end

class Admin::ImageHoldersControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
  end

  context "create polymorphic association" do

    setup do
      @bird = Factory(:bird)
    end

    should "contain a message" do
      get :new, { :resource => @bird.class.name, :resource_id => @bird.id }
      assert_select 'body div#flash', "Cancel adding a new image holder?"
    end

    should "work" do
      assert_difference('@bird.image_holders.count') do
        post :create, { :image_holder => { :name => "ImageHolder" },
                        :resource => "Bird", :resource_id => @bird.id }
      end

      assert_response :redirect
      assert_redirected_to "http://test.host/admin/birds/edit/#{@bird.id}"
      assert_equal "Bird successfully updated.", flash[:notice]
    end

  end

  ##
  # TODO: Eventually this code should be run in the Original model, so ideally
  #       a Bird unrelates ImageHolder and not ImageHolder unrelates Bird.
  #
  context "unrelate" do

    ##
    # We are in:
    #
    #   /admin/birds/edit/1
    #
    # And we see a list of comments under it:
    #
    #   /admin/image_holders/unrelate/1?resource=Bird&resource_id=1
    #   /admin/image_holders/unrelate/2?resource=Bird&resource_id=1
    #   ...
    ##

    setup do
      @image_holder = Factory(:image_holder)
      @bird = Factory(:bird)
      @bird.image_holders << @image_holder
      @request.env['HTTP_REFERER'] = "/admin/birds/edit/#{@bird.id}"
    end

    should "work" do
      assert_difference('@bird.image_holders.count', -1) do
        post :unrelate, :id => @image_holder.id, :resource => "Bird", :resource_id => @bird.id
      end
    end

  end

end
