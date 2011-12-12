class ActionView::Helpers::FormBuilder
  def labeled_input(method, options={}, &block)
    (options[:class] ||= "") << " clearfix"
    options[:class] << " error" unless @object.errors[method].empty?
    ActionView::Helpers::InstanceTag.send(:alias_method, :original_error_wrapping, :error_wrapping)
    ActionView::Helpers::InstanceTag.send(:define_method, :error_wrapping, Proc.new { |html_tag| html_tag })

    div_content = Hpricot(@template.capture(&block))
    div_content.search("div.input").append(@template.content_tag(:span, @object.errors[method].join(", "), :class => "help-inline")) unless @object.errors[method].empty?
    div_content = div_content.to_html.html_safe

    @template.concat(@template.content_tag(:div, div_content, options).html_safe)
  ensure
    ActionView::Helpers::InstanceTag.send(:alias_method, :error_wrapping, :original_error_wrapping)
    ActionView::Helpers::InstanceTag.send(:remove_method, :original_error_wrapping)
  end
end