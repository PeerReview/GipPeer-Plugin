class Survey < ActiveRecord::Base
  has_many :questions, :dependent => :destroy
  has_many :peers, dependent: :destroy
  has_many :projects, :through => :peers
  has_many :users, :through => :peers
  accepts_nested_attributes_for :questions, :allow_destroy => true, :reject_if => lambda { |a| a[:question].blank? }

  # We use this attr_accessor to define the methods of the controller in which the date validation must be present. 
  # At default this attr_accessor is false. We have to enable it in the methods of the controller.
  attr_accessor :enable_strict_validation

  validates_presence_of :title
  validates_uniqueness_of :title

  validates_presence_of :start_date
  
  validates_presence_of :end_date

  # The validates_date is using the gem validates_timeliness
  validates_date :end_date, :after => :start_date
  # We are using the attr_accessor for this validation
  validates_date :start_date, :on_or_after => :today, if: :enable_strict_validation

  scope :unarchived, where(:archive => false)
  scope :archived, where(:archive => true)

  scope :published_surveys_scope, where(:published => :true)
  scope :unpublished, where(:published => :false)

  def archiving
    self.archive = true
    save
  end

  def unarchiving
    self.archive = false
    save
  end

  def unpublishing
    self.published = false
    save
  end

  def publishing
    self.published = true
    save
  end

end
