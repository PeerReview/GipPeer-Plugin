class UserMailer < ActionMailer::Base

  # In order to check if we can send a mail in the development environment we have to edit the configuration.yml
  # file in the location peer_reviewing_2013/config/configuration.yml. At the end of this file there is  an option to
  # send test mails through gmail servers. We have to add a valid username and password to send these test mails.

  # Sets the default sender email address
  default from: 'admin@giphouse.nl'

  # Implementation of the mailer to send a message that a survey was deleted
  def delete_self(user, survey)
    @user = user
    @survey = survey
    mail(to: @user.mail,
         subject: "Delete answers of survey")
  end

  # Implementation of the mailer to send a message that a survey was editted
  def editted_survey(user, survey)
    @user = user
    @survey = survey
    mail(to: @user.mail,
         subject: "The survey was editted and as a result your answers were deleted")
  end
end