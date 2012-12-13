class Admin::HitsController < Admin::ResourcesController

  def index
    @items = Hit.paginate(:per_page => 15, :page => params[:page])
    add_resource_action("Edit", {:action => 'edit'}, {})
    add_resource_action("Trash", {:action => "destroy"}, {:confirm => "#{Typus::I18n.t("Trash")}?", :method => 'delete'})
  end

  def new
    @item = Hit.new
  end

  def create
    @item = Hit.new(params[:hit])
    if @item.save
      flash[:notice] = Typus::I18n::t("Hit was successfully created.")
      redirect_to :action => 'edit', :id => @item.id
    else
      render :action => 'new'
    end
  end

  def edit
    @item = Hit.find(params[:id])
  end

  def update
    @item = Hit.find(params[:id])
    if @item.update_attributes(params[:entry])
      flash[:notice] = Typus::I18n::t("Hit was successfully updated.")
      redirect_to :action => 'edit', :id => @item.id
    else
      render :action => "edit"
    end
  end

  def set_scope; end
  private :set_scope

end
