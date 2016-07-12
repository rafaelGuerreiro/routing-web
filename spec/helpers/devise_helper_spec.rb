# Specs in this file have access to a helper object that includes
# the DeviseHelper. For example:
#
# describe DeviseHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe DeviseHelper, type: :helper do
  class DummyResource
    attr_reader :errors

    def initialize(errors = [])
      @errors = errors
    end
  end

  let(:dummy_resource) { DummyResource.new(['error', 'another error']) }
  let(:dummy_resource_without_errors) { DummyResource.new }

  context 'when there are errors' do
    before do
      dummy = dummy_resource
      helper.class.__send__(:define_method, :resource) do
        return dummy
      end
    end

    describe '#devise_error_messages!' do
    end

    describe '#devise_error_messages?' do
      it { expect(helper.devise_error_messages?).to be_truthy }
    end
  end

  context 'when there are no errors' do
    before do
      dummy = dummy_resource_without_errors
      helper.class.__send__(:define_method, :resource) do
        return dummy
      end
    end

    describe '#devise_error_messages!' do
    end

    describe '#devise_error_messages?' do
      it { expect(helper.devise_error_messages?).to be_falsy }
    end
  end
end
