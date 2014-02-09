class MessagesController < ApplicationController
  before_action :user_allowed_to_respond, except: [:new, :create]
  
  def update
    if params["response"]
      @message.read = true
      @message.recipient_action = params["response"]
      
      if params["response"] == "accept"
        current_user.linkup(@message.from) 
        current_user.save
        @message.from.save
      end
      
      @message.reported_as_spam = true if params["response"] == "report_as_spam"
      
      @message.save
    end
    
    redirect_to home_user_path(current_user)
  end
  
  def new
    @message = Message.new
 end
 
 def create
   current_user.send_invitation(params["message"]["to_id"])
   redirect_to edit_user_path(current_user)
 end
  
  private
  
  def user_allowed_to_respond
    @message = Message.find(params["id"])
    @message.to == current_user || not_found
  end
end
