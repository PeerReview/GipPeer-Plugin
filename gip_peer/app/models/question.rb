class Question < ActiveRecord::Base
  belongs_to :survey
  has_many :answers, :dependent => :destroy
  has_many :qoptions, :dependent => :destroy
  accepts_nested_attributes_for :qoptions, :allow_destroy => true, :reject_if => lambda { |a| a[:option].blank? }
  accepts_nested_attributes_for :answers, :allow_destroy => true, :reject_if => lambda { |a| a[:answer].blank? }

  attr_protected :answers

  validates_presence_of :question
end
