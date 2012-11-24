class Admin::OrdersController < AdminController
  before_filter :find_orders_by_user

  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.new
  end

  def create
    @user = User.find(params[:user_id])
    @order = @user.orders.new
    @order.card_expires_on = Date.parse("#{params[:order]['card_expires_on(1i)']}-#{params[:order]['card_expires_on(2i)']}-01").end_of_month
    params[:order].delete('card_expires_on(1i)')
    params[:order].delete('card_expires_on(2i)')
    params[:order].delete('card_expires_on(3i)')
    @order.ip_address = request.remote_ip
    @order.attributes = params[:order]
    #@order.save!
    
    respond_to do |format|
      if @order.save #&& @order.purchase
        #@order.purchase
        flash[:info] = 'Order has been processed.'
        format.html { redirect_to admin_user_orders_path(@user) }
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'new'}
      end
    end
  end

  def latest 
    @orders = Order.order_by('created_at DESC').page params[:page]
  end

  def find_orders_by_user
    @orders = Order.where(:user_id => params[:user_id]).order_by('created_at DESC').page params[:page]
  end
end
