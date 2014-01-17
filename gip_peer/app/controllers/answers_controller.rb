class AnswersController < ApplicationController
	unloadable

	before_filter :find_project
	before_filter :find_survey
  before_filter :find_peers

	def saveAnswers
    errors = false
    new_answers = []
    user = User.current

    # The params will look like: "survey => 
    #                               {"questions_attributes" => 
    #                                 { "0" => { "answers_attributes" => 
    #                                             { "0" => { "answer" => answer}}, "id" => question id}}} "
    # Loops over all values of the question attributes
    params[:survey][:questions_attributes].values.each do |q|
      question_id = q[:id]

      # if no answer is given, q[:answers_attributes] will be nil, so check for that
      if q[:answers_attributes].nil?
        flash[:error] = 'All questions have to be filled in'
        render 'surveys/fill' and return
      end

      # Loop over all answers for a question
      q[:answers_attributes].values.each do |a|
        answer = a[:answer]

        # If multiple checkboxes are selected for a checkbox question, 
        # answer will contain an array of answers, so check for that
        if answer.instance_of?(Array)
          answer.each do |an|
            new_answer = Answer.new(question_id: question_id, answer: an)
            new_answer.user = user
            new_answer.peer_id = a[:peer_id]
            new_answer.project_id = a[:project_id]
            new_answers << new_answer
          end
        else
          new_answer = Answer.new(question_id: question_id, answer: answer)
          new_answer.user = user
          new_answer.peer_id = a[:peer_id]
          new_answer.project_id = a[:project_id]
          new_answers << new_answer
        end
      end
    end

    # Create a transaction for all answers, so if one answer does not go through the validation, no answer is saved
    Answer.transaction do
      new_answers.each do |answer|
        unless answer.save
          errors = true
        end
      end
    end

    # If there are errors in the answer, show an error and render the fill in page again
    if errors
      @answers = new_answers
      flash[:error] = 'All questions have to be filled in'
      render 'surveys/fill' and return
    else
      @peer = @survey.peers.find(:first, conditions: { user_id: User.current, project_id: @project.id } )
      if @peer == nil
        @answers = new_answers
        flash[:error] = 'You are not allowed to fill in this survey'
        render 'surveys/fill' and return
      elsif !@peer.completed
        @peer.completing
      end
      flash[:notice] = 'Survey filled in'
      redirect_to surveys_path(project_id: @project)
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_survey
    @survey = Survey.find(params[:id])
  end
  def find_peers
    @peers = Peer.where({survey_id: params[:id], project_id: @project.id, user_id: !User.current.id})
  end
end