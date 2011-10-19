module BuildsHelper
  def build_information(build)
    build.hash
  end
  
  def build_results_in_tds(build)
    build.results.sorted.collect do |result|
      content_tag :td do
        content_tag :span, result.status, :class => "status-#{result.status.to_s}"
      end
    end.join.html_safe
  end
end
