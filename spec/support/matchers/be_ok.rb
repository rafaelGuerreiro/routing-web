require 'rspec/expectations'

RSpec::Matchers.define :be_ok do
  match(&:ok?)

  failure_message do |response|
    "Expected that the response would be ok. The status was #{response.status}"
  end

  failure_message_when_negated do |response|
    "Expected that the response would not be ok. The status was #{response.status}"
  end
end
