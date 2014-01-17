require 'redmine'
require 'csv'
require_dependency 'gip_peer/hooks'
require_dependency 'project_patch'
require_dependency 'user_patch'
Redmine::Plugin.register :gip_peer do
  name 'Gip Peer plugin'
  author 'Sakis Brouzioutis, Sergey Makarov, Jochem Monsma, Ben Siebert, Yannic Smeets'
  description 'Redmine Peer Review developed for GipHouse'
  version '0.8.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://giphouse.nl'

  project_module :gip_peer do
  	permission :view_surveys, :surveys => [:index, :fill, :show, :selfdelete], :require => :member
    permission :view_admin, :managements => [:index, :new, :create, :archive, :unarchive, :edit, :report, :show, :reset, :update, :fill, :destroy, :publish, :unpublish, :duplicate, :export], :require => :member
  end

  menu :project_menu, :surveys, { :controller => 'surveys', :action => 'index' }, :caption => 'Surveys', :after => :activity, :param => :project_id
  menu :project_menu, :managements, { :controller => 'managements', :action => 'index' }, :caption => 'Surveys Admin', :after => :activity, :param => :project_id

end
