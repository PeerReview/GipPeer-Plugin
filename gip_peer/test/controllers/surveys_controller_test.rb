require File.expand_path('../../test_helper', __FILE__)

class SurveysControllerTest < ActionController::TestCase
  test "should get index" do
  	s = Survey.new
	s.title = "Title"
	s.start_date = Date.current
	s.end_date = Date.current + 1
	s.save
	get(:index, {:id => s.id, :project_id => "1"})
	assert_response :success
    #get :index
    #assert_response :success
    #assert_not_nil assigns(:surveys)
  end
  test "should get index with user" do
  	s = Survey.new
	s.title = "Title"
	s.start_date = Date.current
	s.end_date = Date.current + 1
	s.save
	count = Peer.count
	p = Peer.new
	p.project_id = 1
	p.survey_id = s.id
	p.user_id = 1
	p.save
	count2 = Peer.count
	assert count + 1 == count2, "Peer user is not saved"
	get(:index, {:id => s.id, :project_id => "1"})
	assert_response :success
    #get :index
    #assert_response :success
    #assert_not_nil assigns(:surveys)
  end
end