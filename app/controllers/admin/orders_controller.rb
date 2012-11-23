class Admin::OrdersController < AdminController
  before_filter :find_orders_by_user

  def find_orders_by_user
    @orders = Order.where(:user_id => params[:user_id])
  end
end
