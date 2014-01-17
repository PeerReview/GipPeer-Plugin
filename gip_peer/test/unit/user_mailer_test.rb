require File.expand_path('../../test_helper', __FILE__)

class UserMailerTest < ActiveSupport::TestCase
  FIXTURES_PATH = File.expand_path('../../../app/controllers', __FILE__)

  def setup
  	# Set the delivery method to test mode in order the mail not actually to be delivered
    ActionMailer::Base.delivery_method = :test
    # The mail will be sent with the method specified by Base.perform_deliveries
    ActionMailer::Base.perform_deliveries = true
    # Sets the array of sent messages to empty 
    ActionMailer::Base.deliveries = []

    @expected = Mail.new
  end

  test "delete_self" do
    @expected.subject = 'Delete answers of survey'
    #@expected.body    = read_fixture('deleted the answers')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}")
    end
end
