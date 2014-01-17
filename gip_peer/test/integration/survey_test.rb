 require File.expand_path('../../test_helper', __FILE__)

 class SurveyTest < ActionController::TestCase
    def test_report
      s = Survey.new
      s.title = "Title"
      s.start_date = "3/10/2013"
      s.end_date = "5/10/2023"
      q = Question.new(:survey_id => s.id, :question => "Test question", :matrix => false, :type => 'Text')
      s.questions << q
      q.save
      s.save
      get :report
      assert_responce :success
      #s1 = Survey.find
      #assert_recognizes ({:controller => 'surveys', :action => 'report'}), 'surveys'
    end
end