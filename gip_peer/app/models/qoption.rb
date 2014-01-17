class Qoption < ActiveRecord::Base
  belongs_to :question

  validates_presence_of :option
end
