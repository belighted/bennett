module BuildsHelper
  def status_image(status)
    format = case status
      when :busy then 'gif'
      else 'png'
    end
    image_tag "/assets/#{status}.#{format}", alt: status.to_s, title: status.to_s
  end
end
