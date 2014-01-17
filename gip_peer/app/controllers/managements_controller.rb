class ManagementsController < ApplicationController
  unloadable

  before_filter :find_project
  before_filter :find_survey, only: [:edit, :show, :update, :destroy, :fill, :saveAnswers, :archive, :unarchive, :publish, :unpublish, :reset, :report, :duplicate, :export]
  before_filter :authorize

  def index
    #@surveys = @project.surveys.unarchived.uniq # Listing only surveys for the current project
    @surveys = Survey.unarchived
    @archived_surveys = Survey.archived
    @published_surveys = Survey.published_surveys_scope
  end

  def new
    @survey = Survey.new
    @projects = Project.find(:all)
  end

  def create
    # Create a new survey
    @survey = Survey.new(params[:survey])
    # We enable the attr_accessor to enable the date validation in this method.
    @survey.enable_strict_validation = true
    # Get the peers for the survey
    @peer_projects = params[:peers]
    # All the projects in redmine
    @projects = Project.find(:all)
    # Temporary array.
    peers = Array.new

    # Check if we can save the survey.
    if @survey.save
      # Getting all the peers for the survey per project that are selected.
      @peer_projects.each do |project, users|
        users.each do |user,selected|
          # Check if the peer is selected for the survey.
          if(selected.last == "1")
            # Add the peer to a temporary array.
            peers << Peer.new(:survey_id => @survey.id, :project_id => project, :user_id => user)
          end
        end
      end
      # Save all the peers that are selected.
      for peer in peers do
        peer.save
      end
      flash[:notice] = 'Survey created'
      redirect_to managements_path(project_id: @project)
    else
      render 'new'
    end
  end

  # Archiving a survey, a user can archive a survey, so it will not be listed in the main survey list.
  # If the survey is also published it will be unpublished automatically.
  def archive
    # See if it is already archived or not.
    if !@survey.archive
      @survey.archiving
    end
    # Unpublishing the survey.
    if @survey.published
      @survey.unpublishing
    end
    flash[:notice] = "Survey #{@survey.title} has been archived."
    redirect_to managements_path(project_id: @project)
  end

  # Activating the survey. If a survey is archived it can be unarchived .
  def unarchive
    # Activating the survey.
    if @survey.archive
      @survey.unarchiving
    end
    flash[:notice] = "Survey #{@survey.title} has been activated."
    redirect_to managements_path(project_id: @project)
  end

  def edit
    # Find all projects in redmine
    @projects = Project.find(:all)
    # Find the peers that belong the the survey and map them by project
    @peers = Peer.where(survey_id: @survey.id).map{|p| {:project_id => p.project_id, :user_id => p.user_id}}
  end

  # Duplicates a survey
  def duplicate
    @new_survey = Survey.new
    @new_survey.attributes = @survey.attributes
    # Looking for the first free id for new survey
    @id = 1
    while Survey.exists?(@id)
      @id+=1
    end
    @new_survey.id = @id
    # Doing this 'num' thing for case, when we want to duplicate a survey twice or more - we will get Survey (1), then Survey (2), etc.
    @num = 1
    while Survey.exists?(title: @new_survey.title + " (" + @num.to_s() + ")")
      @num+=1
    end
    @new_survey.title = @new_survey.title + " (" + @num.to_s() + ")"
    if @new_survey.published
      @new_survey.unpublishing
    end
    if @new_survey.archive
      @new_survey.unarchiving
    end
    @new_survey.questions = @survey.questions
    @new_survey.save
    redirect_to edit_management_path(@new_survey, project_id: @project)
  end

  # Survey reporting, this action will so the survey admin a report about the survey.
  def report
  end

  # Showing what the survey contains. This action is to so the survey admin who is invited and what questions are asked.
  def show
  end

  # Resetting the survey. This means that all the answers that already filled in are deleted.
  # Also the peer will be mailed to let him know he needs to fill in the survey again.
  def reset
    # Request to find the questions that are included to a specific survey. Returns an array.
    @question = Question.find :all, joins: [:survey], conditions: ["questions.survey_id = ?", @survey.id]
    if @question.present?
      # Because the @question is an array, we want to access each element of the array.
      @question.each do |q|
        # Request to find the answers that are included to a specific question. Returns an array.
        @answer =  Answer.find :all, joins: [:question], conditions: ["answers.question_id = ?", q.id]
        if @answer.present?
          # Because the @question is an array, we want to access each element of the array.
          @answer.each do |a|
            a.destroy
            # Set all peers that completed the survey to false
            Peer.where(:survey_id => @survey.id).each do |peer|
              peer.reset
            end
            flash[:notice] = "Survey #{@survey.title} has been resetted."
          end 
        else 
          flash[:warning] = "There were no answers in the Survey #{@survey.title}"
        end
      end  
    end
    redirect_to managements_path(project_id: @project)
  end

  # Updating the values of the survey.
  def update
    # We enable the attr_accessor to enable the date validation in this method.
    @survey.enable_strict_validation = true

    # Get the users that are selected for the survey
    @peer_projects = params[:peers]
    peersproject = Array.new
    # Check is survey attributes can be updated
    if @survey.update_attributes(params[:survey])
      # Delete all peers that are already in the survey
      Peer.where(:survey_id => @survey.id).delete_all
      
      # Check the new peers for the survey
      @peer_projects.each do |project, users|
        users.each do |user,selected|
          if(selected.last == "1")
            peersproject << Peer.new(:survey_id => @survey.id, :project_id => project, :user_id => user)
          end
        end
      end
      # Save the new peers
      for peer in peersproject do
        peer.save
      end

      @question = Question.find :all, joins: [:survey], conditions: ["questions.survey_id = ?", @survey.id]
      if @question.present?
        @question.each do |q|
          @answer =  Answer.find :all, joins: [:question], conditions: ["answers.question_id = ?", q.id]
          if @answer.present?
            @answer.each do |a|
              a.edit_accessor = true
              a.destroy
            end
          end
        end
      end
      
      redirect_to managements_path(:project_id => @project)
    else
      # Projects and Peers needed if the submit failed
      @projects = Project.find(:all)
      @peers = Peer.where(survey_id: @survey.id).map{|p| {:project_id => p.project_id, :user_id => p.user_id}}
      render 'edit'
    end
  end

  # Deleting a survey and all the related relations.
  def destroy
    if @survey.destroy
      flash[:notice] = 'Survey deleted'
    else
      flash[:warning] = 'Could not delete survey'
    end
    redirect_to managements_path(project_id: @project)
  end

  # Publishing the Survey. This allows the participants of the survey to fill in the questions.
  def publish
    # Check if the surveys end date is before the current date, this mean we can't publish the survey.
    if @survey.end_date < Date.current
      flash[:error] = "Could not publish #{@survey.title} with overdue end date."
      redirect_to managements_path(:project_id => @project)
      return
    end
    if @survey.published == false
      # Publishing the survey.
      @survey.publishing
    end

    flash[:notice] = "Survey #{@survey.title} has been published."
    redirect_to managements_path(project_id: @project)
  end

  # Unpublishing the survey. The survey will be inactive and participants can't fill in the survey.
  def unpublish
    if @survey.published == true
      # Survey is published so we can unpublish it.
      @survey.unpublishing
    end
    flash[:notice] = "Survey #{@survey.title} has been unpublished."
    redirect_to managements_path(project_id: @project)
  end
  
  # Exporting the survey results, report and all information that is related to the survey for extended analyzing.
  def export
    csv_string = CSV.generate({ col_sep: ";"}) do |csv|
      # Survey information
      csv << ["Title", @survey.title]
      csv << ["Start date", @survey.start_date.strftime("%d-%m-%Y")]
      csv << ["End date", @survey.end_date.strftime("%d-%m-%Y")]
      csv << ["Introduction",  @survey.introduction]
      csv << ["Outroduction", @survey.outroduction]
      # Showing all the peers in the survey per project.
      # Also displays if the peer completed the survey.
      csv << ["Users in survey per project"]
      @survey.projects.uniq.each do |project|
        csv << [project.name]
        csv << ["Peer ID", "User ID","Name", "Email", "Completed"]
        @survey.peers.group_by{|project| project[:project_id] }.each do |project_id, peers|
          if(project_id == project.id)
          for peer in peers
            csv << [peer.id, peer.user_id, peer.user.name, peer.user.mail, peer.completed]
          end
        end        
        end
      end
      # Showing all the question that are asked and if it is a matrix question
      csv << ["Questions"]
      csv << ["ID", "Question", "Question type", "Matrix"]
      @survey.questions.each do |question|
        csv << [question.id, question.question_type,question.matrix]
      end
      # Showing all the answers that peers filled in sorted by question
      csv << ["Answers per Question"]
      csv << ["Answer ID", "Question ID", "Answer", "User", "Answer about User (matrix)"]
      @survey.questions.each do |question|
        question.answers.each do |answer|
          if question.matrix
            peer = User.find(answer.peer_id)
            csv << [answer.id, question.id, answer.answer, answer.user.name, peer.name]
          else 
            csv << [answer.id, question.id, answer.answer, answer.user.name, '']  
          end
        end
      end
    end         
    # Setting the file format to csv
    send_data csv_string,
    :type => 'text/csv; charset=iso-8859-1; header=present',
    :disposition => "attachment; filename=export-#{@survey.title}.csv" 
  end

  private
  # Finding the project.
  def find_project
    @project = Project.find(params[:project_id])
  end

  # Finding the survey.
  def find_survey
    @survey = Survey.find(params[:id])
  end
end
