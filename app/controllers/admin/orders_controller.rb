class Admin::OrdersController < AdminController
  before_filter :find_orders_by_user

  def latest 
    @orders = Order.order_by('created_at DESC').page params[:page]
  end

  def find_orders_by_user
    @orders = Order.where(:user_id => params[:user_id]).order_by('created_at DESC')
  end
end
