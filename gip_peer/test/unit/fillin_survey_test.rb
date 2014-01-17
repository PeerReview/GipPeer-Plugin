require File.expand_path('../../test_helper', __FILE__)

class FillinSurveyTest < ActiveSupport::TestCase

	test "answer should not save without an answer" do 
		s = Survey.new
		s.title = "Title"
    s.start_date = "3/10/2013"
    s.end_date = "5/10/2013"
    q = s.questions.build
    q.question = "What is your name?"
    q.save
    a = q.answers.build
    a.user_id = 1
    assert !a.save, "Save the answer without an answer"
	end

	test "answer should not save without a user_id" do
		s = Survey.new
		s.title = "Title"
    s.start_date = "3/10/2013"
    s.end_date = "5/10/2013"
    q = s.questions.build
    q.question = "What is your name?"
    q.save
    a = q.answers.build
    a.answer = "Yannic"
    assert !a.save, "Save the answer without a user_id"
	end

	test "answer should save with answer and user_id" do
		s = Survey.new
		s.title = "Title"
    s.start_date = "3/10/2013"
    s.end_date = "5/10/2013"
    q = s.questions.build
    q.question = "What is your name?"
    q.save
    a = q.answers.build
    a.user_id = 1
    a.answer = "Yannic"
    assert a.save, "Save the answer with user_id and answer"
	end
end