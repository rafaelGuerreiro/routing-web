module DeviseHelper
  def devise_error_messages!
    return '' unless devise_error_messages?

    html_error_explanation
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

  private

  def html_error_explanation
    html = <<-HTML
<div id="error_explanation" class="alert alert-danger">
  <p class="margin-0"><strong>#{sentence}</strong></p>
  <ul>#{messages}</ul>
</div>
    HTML

    html.html_safe
  end

  def sentence
    I18n.t('errors.messages.not_saved',
           count: resource.errors.count,
           resource: resource.class.model_name.human.downcase)
  end

  def messages
    resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
  end
end
