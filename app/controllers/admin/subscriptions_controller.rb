class Admin::SubscriptionsController < AdminController
  before_filter :find_subscription, except: [:index, :new, :create]
  def index
    @subscriptions = Subscription.page params[:page]
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new
    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to admin_subscriptions_path, notice: 'Subscription has been created.'}
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to admin_subscriptions_path, notice: 'Subscription has been updated.'}
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'edit' }
      end
    end
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
