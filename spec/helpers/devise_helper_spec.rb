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
  let(:dummy_resource) do
    Class.new do
      attr_reader :errors

      def initialize(errors = [])
        @errors = errors
      end
    end
  end

  let(:dummy_resource_with_errors) { dummy_resource.new(['error', 'another error']) }
  let(:dummy_resource_without_errors) { dummy_resource.new }

  context 'when there are errors' do
    before(:each) do
      helper.class.__send__(:define_method, :resource) do
        return dummy_resource_with_errors
      end
      # allow(helper).to receive(:resource).and_return(Resource.new)
    end

    describe '#devise_error_messages!' do
      it { expect(helper.devise_error_messages?).to be_truthy }
    end

    describe '#devise_error_messages?' do
      it { expect(helper.devise_error_messages?).to be_truthy }
    end
  end

  context 'when there are no errors' do
    before(:each) do
      helper.class.__send__(:define_method, :resource) do
        return dummy_resource_without_errors
      end
    end

    # its (:devise_error_messages?) { is_expected.to be_falsy }
  end
end
