class SurveysController < ApplicationController
  unloadable

  before_filter :find_project
  before_filter :find_survey, only: [:show, :fill, :selfdelete]
  before_filter :find_peers, only: [:fill]
  # authorize this is implemented in the init.rb  
  before_filter :authorize

  def index
    # Listing the surveys that are currently open for this project and user.
  	@surveys = Peer.all(:joins => :survey, 
                :conditions=>{:peers => {:project_id => @project, :user_id=> User.current}})
    # All the surveys that are currently open for this user.
    @otherSurveys = Peer.all(:joins => :survey, 
                :conditions=>{:peers => {:user_id=> User.current}, :surveys => {:published => true, :archive => false}})
    # Removing surveys currently open for this project and user from all the open surveys for this user
    @surveys.each do |survey|
      @otherSurveys = @otherSurveys.reject{|s| s.project_id == survey.project_id && s.survey_id == survey.survey_id || s.survey.end_date <= Date.current}
    end
    # OtherSurveys now contains only the surveys that are open for this user and not in the current project.

    # Surveys that are published
    @published_surveys = Survey.published_surveys_scope
  end

  def show
  end
    
  def fill
  end

  # A peer has the possibility to delete the answers that he provided in a suurvey.
  # Also the peer will be mailed to let him know he needs to fill in the survey again.
  def selfdelete
    # Request to find the questions that are included to a specific survey. Returns an array.
    @question = Question.find :all, :joins => [:survey], :conditions => ["questions.survey_id = ?", @survey.id]
    if @question.present?
      # Because the @question is an array, we want to access each element of the array.
      @question.each do |q|
      # Request to find the answers that are included to a specific question and to the connected user. Returns an array.
      @answer =  Answer.find :all, :joins => [:question], :conditions => ["answers.question_id = ? and answers.user_id = ?", q.id, User.current]
        if @answer.present? && @survey.published && @survey.end_date >= Date.current
          # Because the @question is an array, we want to access each element of the array.
          @answer.each do |a|
          # We enable the attr_accessor to send confirmation mail after delete of answers.
          a.mail_accessor = true
          a.destroy
          # If the peer already completed the survey the value is set to false.
          @peer = Peer.where(user_id: User.current, project_id: @project, survey_id: @survey.id).first
          if @peer.completed 
            @peer.reset
          end
          flash[:notice] = "You have successfully deleted your answers for the Survey #{@survey.title}."
          end 
        else 
          flash[:warning] = "You have not filled the Survey #{@survey.title} yet or it is unpublished/out of date."
        end
      end  
    end   
    redirect_to surveys_path(:project_id => @project)
  end

  private
  # Finding the project
  def find_project
    @project = Project.find(params[:project_id])
  end

  # Finding the survey
  def find_survey
    @survey = Survey.find(params[:id])
  end

  # Finding the peers that belong to the survey and project
  def find_peers
    @peers = Peer.where({survey_id: params[:id], project_id: @project.id}).where("user_id != ?", User.current.id)
  end
end
