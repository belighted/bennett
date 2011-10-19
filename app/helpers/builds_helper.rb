module BuildsHelper
  def build_information(build)
    content_tag(:div, '@' + build.short_hash, :class => 'commit-hash') +
    content_tag(:div, build.commit_message, :class => 'commit-message') +
    content_tag(:div, author_and_date(build), :class => 'commit-details')
  end
  
  def build_results_in_tds(build)
    build.results.collect do |result|
      content_tag :td do
        content_tag :span, result.status, :class => "status-#{result.status.to_s}"
      end
    end.join.html_safe
  end
  
  def author_and_date(build)
    ('by ' + content_tag(:span, build.commit_author, :class => 'commit-author') +
    ' on ' + content_tag(:span, build.commit_date, :class => 'commit-date')).html_safe
  end
end
