class Lounge::MessagesController < ApplicationController
  before_filter :get_user_comms
  load_and_authorize_resource :communication
  load_and_authorize_resource :user

  def index
    @box = 'Inbox'
    @communications = @mb.inbox.order_by(:touched_at.desc).page params[:page].to_i
  end

  def archives
    @box = 'Archives'
    @communications = @mb.archive.order_by(:touched_at.desc).page params[:page].to_i
    render 'index'
  end

  def trash
    @box = 'Trash'
    @communications = @mb.trash.order_by(:touched_at.desc).page params[:page].to_i
    render 'index'
  end

  def sent
    @box = 'Sent Messages'
    @communications = Message.where(:from_user => current_user).order_by('created_at DESC').page params[:page]
    render 'index'
  end

  def show
    @message = Message.new
    @communication = @mb.find(params[:id])#.messages.order_by('messages.created_at DESC')
    @messages = @communication.messages.order_by('created_at DESC').page params[:page].to_i
  end

  # view a message, not a communication
  def view
    @message = Message.find(params[:id].to_s)
  end

  def ping
    Rails.logger.debug "*" * 40
    communication       = Communication.new
    message             = Message.new(new_message_params)
    message.from_user   = current_user
    message.to_user     = User.find(new_message_params[:to])
    message.subject     = new_message_params[:subject]
    message.body        = new_message_params[:body]
    respond_to do |format|
      if message.valid? && message.send_message
        @error = false
      else
        @error = true
      end
      format.js
    end
  end

  def create
    communication = Communication.find(message_params[:id])
    reply_to_msg = communication.messages.last
    message = Message.new
    message.from_user = current_user
    message.to_user = communication.other_party(current_user)
    message.subject = reply_to_msg.subject
    message.body = message_params[:body]
    message.communications = reply_to_msg.communications
    respond_to do |format|
      if message.reply_message
        format.html { redirect_to lounge_message_path(communication) }
      else
        format.html { flash[:error] = 'Body cannot be left blank!'; redirect_to action: 'show', id: communication.id }
      end
    end
  end


  def archive_communications
    @comm = Communication.find(params[:id])
    @comm.archive!
    respond_to do |format|
      format.js
    end
  end

  def delete_communications
    @comm = Communication.find(params[:id])
    @comm.delete!
    respond_to do |format|
      format.js
    end
  end

  def get_user_comms
    @mb = current_user.mailbox.communications
  end
  private :get_user_comms


  def message_params
    params.require(:message).permit(:id, :body)
  end
  private :message_params

  def new_message_params
    params.require(:message).permit(:body, :subject, :to)
  end
  private :new_message_params
end