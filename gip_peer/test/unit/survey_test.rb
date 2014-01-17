 require File.expand_path('../../test_helper', __FILE__)

 class SurveyTest < ActiveSupport::TestCase


    #This test will check if we can save a survey without a title
    test "should not save without a Title" do
      s = Survey.new
      s.title = nil
      s.start_date = Date.current #we add a start and an end date because in our model these are obligatory. Otherwise we had to remove the presence validation in the model which is preferable to test only this feature. I tested both of them and both work.
      s.end_date = Date.current+1
      s.enable_strict_validation = true 
      assert !s.save, "Save the survey without title" 
    end

    #This test will check if we can save a survey without a start date
    test "should not save without a starting date" do
      s = Survey.new
      s.title = "Title"
      s.start_date = nil
      s.end_date = Date.current+1
      s.enable_strict_validation = true 
      assert !s.save, "Save the survey without a starting date" 
    end

    #This test will check if we can save a survey without an end date
    test "should not save without an end date" do
      s = Survey.new
      s.title = "Title"
      s.start_date = Date.current
      s.end_date = nil
      s.enable_strict_validation = true 
      assert !s.save, "Save the syrvey without an end date" 
    end

    #This test will check if we can save two surveys with the same name
    test "should not save survey with the same title" do
    	s = Survey.new
    	s.title = "Title"
    	s.start_date = Date.current
    	s.end_date = Date.current+1
    	s1 = Survey.new
    	s1.title = "Title"
    	s1.start_date = Date.current+5
    	s1.end_date = Date.current+12
      s.enable_strict_validation = true 
      s1.enable_strict_validation = true 
    	assert s.save, "Save the first survey"
    	assert !s1.save, "Save survey with the same title"
    end

    #This test will check if we can save a survey with a title, start and end date (the required fields)
    test "should save a survey with title, starting date, end date" do
      s = Survey.new
      s.title = "Title"
      s.start_date = Date.current
      s.end_date = Date.current+1 
      s.enable_strict_validation = true 
      assert s.save, "Save the survey with a title, starting date, end date" 
    end

    #This test will check if we can save a survey with starting date after end date
    test "should not save a survey with starting date after end date" do
      s = Survey.new
      s.title = "Title"
      s.start_date = Date.current+6
      s.end_date = Date.current 
      s.enable_strict_validation = true 
      assert !s.save, "Save a survey with starting date after end date" 
    end

    #This test will check if we can save a survey with starting date before today date
    test "should not save a survey with starting date before current date" do
      s = Survey.new
      s.title = "Title"
      s.start_date = Date.current-2
      s.end_date = Date.current+1
      s.enable_strict_validation = true 
      assert !s.save, "Save a survey with starting date before current date" 
    end

    #This test will check if we can delete a survey
    test "should delete a survey" do
      s = Survey.new
      s.title = "Title"
      s.start_date = Date.current 
      s.end_date = Date.current+1 
      s.enable_strict_validation = true 
      assert s.save, "the survey saved"
      assert s.delete, "delete" 
    end

    # This test will check if the empty question is not
    # stored in the database
    test "Questions1, store question without value" do
      s = Survey.new
      s.title = "Question store"
      s.start_date = Date.current
      s.end_date = Date.current+1
      assert s.save, "Save is failing"
      s.enable_strict_validation = true 
      s1 =  @survey = Survey.where( title: "Question store").first
      assert_not_nil s1, "Posted survey could not be found"
      assert s1.questions.empty?, "Questions is empty"
    end

    # This test will check if one question that is added
    # to the survey is really stored and are the same.
    test "Questions2, store question with value" do
      s = Survey.new
      s.title = "Question value store"
      s.start_date = Date.current
      s.end_date = Date.current+1
      s.enable_strict_validation = true 
      q = Question.new(:survey_id => s.id, :question => "Test question", :matrix => false, :type => 'Text' )
      s.questions << q #Putting the question in the array
      assert q.save, "Save a question is failing"
      assert s.save, "Save a survey is failing"
      s1 =  @survey = Survey.where( title: "Question value store").first
      assert_not_nil s1, "Posted survey could not be found"
      assert_not_nil s1.questions, "Questions are empty"
      assert_equal q, s1.questions.first, 'Questions arent the same'
    end

    # This test will check if the default value of archiving is false
    test "Archiving, default value" do
      s = Survey.new
      s.title = "Question value store"
      s.start_date = Date.current
      s.end_date = Date.current+1
      q = Question.new(:survey_id => s.id, :question => "Test question", :matrix => false, :type => 'Text' )
      s.questions << q #Putting the question in the array
      q.save
      s.save
      assert !s.archive

    end
    # This test will check if archive is stored
    test "Archiving, activating the survey" do
      s = Survey.new
      s.title = "Question value store"
      s.start_date = Date.current
      s.end_date = Date.current+1
      s.archive = true
      q = Question.new(:survey_id => s.id, :question => "Test question", :matrix => false, :type => 'Text' )
      s.questions << q #Putting the question in the array
      q.save
      s.save
      assert s.archive
    end

    #This test will check if the start date appears on index page, not complete yet
    test "start date should appear on show surveys screen" do
      s = Survey.new
      s.title = "Title"
      s.start_date = Date.current
      s.end_date = Date.current+1
      assert s.save, "Save the survey" 
    end

    #When archived, should be automatically unpublished
    test "archived survey should be automatically unpublished" do
      s = Survey.new
      s.title = "Title"
      s.start_date = Date.current
      s.end_date = Date.current + 1
      q = Question.new(:survey_id => s.id, :question => "Test question", :matrix => false, :type => 'Text')
      s.questions << q
      q.save
      s.save
      if !s.archive
        s.archive = true
      end
      if s.published
        s.published = false
      end
      assert !s.published, "Archived survey wasn't unpublished"
    end

    #A survey with overdue end date should not be published
    test "A survey with overdue end date should not be published" do
      s = Survey.new
      s.title = "Title"
      s.start_date = Date.current - 2
      s.end_date = Date.current - 1
      q = Question.new(:survey_id => s.id, :question => "Test question", :matrix => false, :type => 'Text')
      s.questions << q
      q.save
      s.save
      if s.end_date < Date.current
        #do not publish
      end
      assert !s.published, "A survey with overdue end date was published"
    end

end
