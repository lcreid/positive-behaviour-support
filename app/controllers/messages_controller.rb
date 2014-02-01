class MessagesController < ApplicationController
  before_action :user_allowed_to_respond
  
  def update
    if params["response"]
      @message.read = true
      @message.recipient_action = params["response"]
    
      @message.to.linkup(@message.from) if params["response"] == "accept"
      @message.reported_as_spam = true if params["response"] == "report_as_spam"
      
      @message.save
    end
    
    redirect_to :back
  end
  
  private
  
  def user_allowed_to_respond
    @message = Message.find(params["id"])
    @message.to == current_user || not_found
  end
end
