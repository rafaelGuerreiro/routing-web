require 'rspec/expectations'

def redirect?(response)
  response.redirect?
end

RSpec::Matchers.define :redirect do
  match do |response|
    redirect?(response)
  end

  failure_message do |_|
    'Expected that the request was redirected.'
  end

  failure_message_when_negated do |_|
    "Expected that the request wasn't redirected."
  end
end

RSpec::Matchers.define :redirect_to do |url|
  match do |response|
    return false unless redirect?(response)

    response.respond_to?(:redirect_url) && response.redirect_url == url
  end

  failure_message do |response|
    msg = "Expected that the request was redirected to `#{url}`."

    return msg unless redirect?(response)
    msg << " But was redirected to `#{response.redirect_url}` instead."
  end

  failure_message_when_negated do |response|
    msg = "Expected that the request wasn't redirected to `#{url}`."

    return msg if redirect?(response)
    msg << " But wasn't redirected."
  end
end
