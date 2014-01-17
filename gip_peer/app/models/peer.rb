class Peer < ActiveRecord::Base
  validates_presence_of :survey_id
  validates_presence_of :project_id
  validates_presence_of :user_id
  belongs_to :survey
  belongs_to :project
  belongs_to :user
  scope :filled_in, where(:completed => true)

  def completing
    self.completed = true
    save
  end

  def reset
    self.completed = false
    save
  end

end
