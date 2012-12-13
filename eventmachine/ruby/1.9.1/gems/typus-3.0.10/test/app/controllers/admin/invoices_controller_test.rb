require "test_helper"

=begin

  What's being tested here?

    - Invoice belongs_to Order

=end

class Admin::InvoicesControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
  end

  ##
  # Here we are using the create_with_back_to method.
  #
  #   /admin/invoices/new?back_to=&order_id=4&resource=Order&resource_id=4
  #
  context "Create an invoice from an Order" do

    setup do
      @order = Factory(:order)
      @invoice = { :number => "Invoice#0000001" }
    end

    should "initialize the object with the params passed on the url" do
      get :new, { :resource => "Order", :resource => "Order", :order_id => @order.id }
      assert assigns(:item)
      assert_equal @order.id, assigns(:item).order_id
    end

    # TODO: Take a look at this to refactor the create method.
    should "create new invoice assign it to order and redirect to order" do
      @invoice = { :number => "Invoice#0000001", :order_id => @order.id }

      assert_difference('Invoice.count') do
        post :create, { :invoice => @invoice, :resource => "Order", :order_id => @order.id }
      end
      assert_response :redirect
      assert_redirected_to "/admin/orders/edit/#{@order.id}"
    end

    should_eventually "raise an error if we try to add an invoice to an order which already has an invoice" do
      @invoice = Factory(:invoice)
      get :new, { :resource => "Order", :resource_id => @invoice.order.id, :order_id => @invoice.order.id }
      assert_response :unprocessable_entity
    end

    should_eventually "raise an error if we try to create an invoice to an order which already has an invoice" do
      @invoice = Factory(:invoice)
      post :create, { :invoice => { :number => "Invoice#0000001" },
                      :resource => "Order", :resource_id => @invoice.order.id, :order_id => @invoice.order.id }
      assert_response :unprocessable_entity
    end

  end

  context "Unrelate" do

    setup do
      @invoice = Factory(:invoice)
      @order = @invoice.order
      @request.env['HTTP_REFERER'] = "/admin/orders/edit/#{@order.id}"
    end

    should "work for unrelate Invoice from Order" do
      post :unrelate, :id => @invoice.id, :resource => 'Order', :resource_id => @order.id
      assert @order.reload.invoice.nil?
      assert_equal "Order successfully updated.", flash[:notice]
    end

  end

end
