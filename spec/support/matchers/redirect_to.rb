require 'rspec/expectations'

RSpec::Matchers.define :redirect do
  match(&:redirect?)

  failure_message do |_|
    'Expected that the request was redirected.'
  end

  failure_message_when_negated do |_|
    "Expected that the request wasn't redirected."
  end
end

RSpec::Matchers.define :redirect_to do |url|
  match do |response|
    response.redirect? && response.redirect_url == url
  end

  failure_message do |response|
    msg = "Expected that the request was redirected to `#{url}`."

    return msg unless response.redirect?
    msg << " But was redirected to `#{response.redirect_url}` instead."
  end

  failure_message_when_negated do |response|
    msg = "Expected that the request wasn't redirected to `#{url}`."

    return msg if response.redirect?
    msg << " But wasn't redirected at all. Response status: #{response.status}"
  end
end
