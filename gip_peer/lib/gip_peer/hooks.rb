module GipPeer
  class GipPeerHookListener < Redmine::Hook::ViewListener
   def view_projects_show_left(context = { })
    host_name = Survey.find(:all)
    context[:surveys] = host_name
    context[:controller].send(:render_to_string, {
      :partial => "/projects/project_overview" ,
      :locals => context
      })
  end
  end
end
