class Lounge::MessagesController < ApplicationController
  def index
    @box = 'Inbox'
    @communications = current_user.mailbox.communications.inbox.order_by(:touched_at.desc).page params[:page].to_i
  end

  def archives
    @box = 'Archives'
    @communications = current_user.mailbox.communications.archive.order_by(:touched_at.desc).page params[:page].to_i
    render 'index'
  end

  def trash
    @box = 'Trash'
    @communications = current_user.mailbox.communications.trash.order_by(:touched_at.desc).page params[:page].to_i
    render 'index'
  end

  def sent
    @box = 'Sent Messages'
    @communications = Message.where(:from_user => current_user)
    render 'index'
  end

  def show
    @messages = current_user.mailbox.communications.find(params[:id]).messages.order_by('messages.created_at DESC')
  end
end
