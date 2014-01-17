require File.expand_path('../../test_helper', __FILE__)

class AnswersControllerTest < ActionController::TestCase

	test "should redirect to index view" do
		put :saveAnswers
		response.should redirect_to surveys_path()
	end
end
