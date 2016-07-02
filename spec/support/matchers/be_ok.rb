require 'rspec/expectations'

RSpec::Matchers.define :be_ok do
  match do |controller|
    controller.response.respond_to?(:ok?) && controller.response.ok?
  end

  failure_message do |controller|
    "Expected that the response would be ok. The status was #{controller.response.status}"
  end

  failure_message_when_negated do |controller|
    "Expected that the response would not be ok. The status was #{controller.response.status}"
  end
end
