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
    @order.card_used = @order.credit_card.display_number
    #@order.save!
    
    respond_to do |format|
      if @order.save #&& @order.purchase
        if @order.purchase
          flash[:info] = 'Order has been processed.'
          format.html { redirect_to admin_user_orders_path(@user) }
        else
          format.html { flash[:error] = 'Unable to process order..'; redirect_to admin_user_orders_path(@user) }
        end
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'new'}
      end
    end
  end

  # refund a transaction
  def refund
    order = Order.where(id: params[:id], user_id: params[:user_id]).first
    respond_to do |format|
      if order
        transaction = order.transactions.where(id: params[:order_transaction][:transaction_id], is_refunded: false).first
        if transaction.refund
          flash[:info] = 'Order has been processed.'
          format.html { redirect_to admin_user_orders_path(order.user) }
        else
          format.html { flash[:error] = "Unable to refund transaction. (#{transaction.message}"; redirect_to admin_user_orders_path(order.user)}
        end
        
      else
        format.html { flash[:error] = 'Unable to locate order.'; redirect_to admin_user_orders_path(order.user) }
      end
    end
  end

  def latest 
    @orders = Order.order_by('created_at DESC').page params[:page]
  end

  def find_orders_by_user
    @user = User.find(params[:user_id])
    @orders = Order.where(:user_id => params[:user_id]).order_by('created_at DESC').page params[:page]
  end
end
