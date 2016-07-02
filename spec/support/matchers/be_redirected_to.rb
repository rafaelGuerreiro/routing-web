require 'rspec/expectations'

def was_redirected?(controller)
  controller.response.respond_to?(:redirect?) && response.redirect?
end

RSpec::Matchers.define :be_redirected do
  match do |controller|
    was_redirected?(controller)
  end

  failure_message do |_|
    'Expected that the request was redirected.'
  end

  failure_message_when_negated do |_|
    "Expected that the request wasn't redirected."
  end
end

RSpec::Matchers.define :be_redirected_to do |url|
  match do |controller|
    return false unless was_redirected?(controller)

    controller.response.respond_to?(:redirect_url) && controller.response.redirect_url == url
  end

  failure_message do |controller|
    msg = "Expected that the request was redirected to `#{url}`."

    return msg unless was_redirected?(controller)
    msg << " But was redirected to `#{controller.response.redirect_url}` instead."
  end

  failure_message_when_negated do |controller|
    msg = "Expected that the request wasn't redirected to `#{url}`."

    return msg if was_redirected?(controller)
    msg << " But wasn't redirected."
  end
end
