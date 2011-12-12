class PaginationListLinkRenderer < WillPaginate::ActionView::LinkRenderer

  def to_html
    links = @options[:page_links] ? windowed_links : []

    links.unshift(page_link_or_span(@collection.previous_page, 'prev', @options[:previous_label].html_safe))
    links.push(page_link_or_span(@collection.next_page, 'next', @options[:next_label].html_safe))

    html = links.join(@options[:separator])
    @options[:container] ? html_container(@template.content_tag(:ul, html.html_safe)) : html.html_safe
  end

  protected

  def windowed_links
    windowed_page_numbers.map { |n| page_link_or_span(n, (n == current_page ? 'active' : nil)) }
  end

  def page_link_or_span(page, span_class, text = nil)
    text ||= page.to_s
    if text == "gap"
      text = "..."
      span_class = "disabled"
    end
    if page && page != current_page && text != "..."
      page_link(page, text, :class => span_class)
    else
      page_span(page, text, :class => span_class)
    end
  end

  def page_link(page, text, attributes = {})
    @template.content_tag(:li, @template.link_to(text, url(page)), attributes)
  end

  def page_span(page, text, attributes = {})
    if attributes[:class] != "active" && attributes[:class] != "disabled"
      attributes[:class] ||= ""
      attributes[:class] << " disabled"
    end
    @template.content_tag(:li, @template.link_to(text, "#", attributes), attributes)
  end

end