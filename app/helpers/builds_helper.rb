module BuildsHelper
  def status_for_build(build)
    if project.builds.none?
      content_tag :div, 'No branches configured', :class => 'results'
    else
      project.branches.collect do |branch|
        content_tag :div, :class => 'results' do
          content_tag(:p, branch_name(branch), :class => 'results-branch') +
          content_tag(:p, branch.last_commit_sha_and_message, :class => 'results-commit')
        end
      end.join.html_safe
    end
  end
end
