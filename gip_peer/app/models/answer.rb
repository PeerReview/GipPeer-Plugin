class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates_presence_of :answer
  validates_presence_of :user_id

  attr_protected :question, :user_id, :user
  
  # Added an attr_accessor to define in which methods of the controller we want the method send_delete_message to be executed after delete of answers.
  # At default this attr_accessor is false. We have to enable it in the methods of the controller.  
  attr_accessor :mail_accessor 
  after_destroy :send_delete_message, :if => :mail_accessor

  # Method to send a delete message. We use the mailer that we created in the controller to send this message.
  def send_delete_message
    UserMailer.delete_self(User.current, Survey.unarchived).deliver
  end

  # Added an attr_accessor to define in which methods of the controller we want the method send_edit_message to be executed after delete of answers.
  # At default this attr_accessor is false. We have to enable it in the methods of the controller.  
  attr_accessor :edit_accessor 
  after_destroy :send_edit_message, :if => :edit_accessor

  # Method to send a message that a survey was editted. We use the mailer that we created in the controller to send this message.
  def send_edit_message
    UserMailer.editted_survey(User.current, Survey.unarchived).deliver
  end
end
