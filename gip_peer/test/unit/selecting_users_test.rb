 require File.expand_path('../../test_helper', __FILE__)

 class SelectingUsersTest < ActiveSupport::TestCase


    #This test will check if we can save a survey without users it should work
    test "Survey is saved without any user selected" do
      s = Survey.new
      s.title = "Selecting users"
      s.start_date = Date.current #we add a start and an end date because in our model these are obligatory. Otherwise we had to remove the presence validation in the model which is preferable to test only this feature. I tested both of them and both work.
      s.end_date = Date.current+1
      s.enable_strict_validation = true 
      assert s.save, "Save the survey without users failed" 
    end
     #This test will check if we can save a survey without users it should work
    test "Survey is saved with any user selected" do
      s = Survey.new
      s.title = "Selecting users"
      s.start_date = Date.current #we add a start and an end date because in our model these are obligatory. Otherwise we had to remove the presence validation in the model which is preferable to test only this feature. I tested both of them and both work.
      s.end_date = Date.current+1
      s.enable_strict_validation = true 
      assert s.save, "Save the survey without users failed" 
      count = Peer.count
      p = Peer.new
      p.project_id = 1
      p.survey_id = s.id
      p.user_id = 1
      assert p.save, "Saving peer failed"
      count2 = Peer.count
      assert count + 1 == count2, "Peer user is not saved"
      
    end
end
