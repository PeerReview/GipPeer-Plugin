require_dependency 'project'
module ProjectPatch
  def self.included(base)
    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      has_many :peers
      has_many :surveys, :through => :peers
      has_many :users, :through => :peers
    end
  end
end

Project.send(:include, ProjectPatch)