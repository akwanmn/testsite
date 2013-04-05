class Lounge::MessagesController < ApplicationController
  before_filter :get_user_comms

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

  def create
    communication = Communication.find(message_params[:id])
    reply_to_msg = communication.messages.last
    message = Message.new
    message.from_user = current_user
    message.to_user = User.find(communication.other_party(current_user))
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

  def get_user_comms
    @mb = current_user.mailbox.communications
  end
  private :get_user_comms

  def message_params
    params.require(:message).permit(:id, :body)
  end
  private :message_params
end
