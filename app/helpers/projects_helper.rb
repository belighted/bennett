module ProjectsHelper
  def status_for_project(project)
    content_tag :div, :class => 'project-status' do
      if project.builds.none?
        content_tag :span, 'Not built yet', :class => 'status-pending'
      else
        content_tag :span, status_image(project.status), :class => "status-#{project.status.to_s}"
      end
    end
  end
end
