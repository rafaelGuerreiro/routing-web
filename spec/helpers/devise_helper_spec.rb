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
  class Dummy
    extend ActiveModel::Naming
    include ActiveModel::Validations

    attr_reader :attribute, :errors

    validates :attribute, presence: true

    def initialize
      @attribute = nil
      @errors = ActiveModel::Errors.new(self)
    end

    def validate!(context = nil)
      valid?(context) || errors.add(:attribute, :blank, message: 'cannot be nil')
    end
  end

  class DummyResource
    def initialize(model = nil)
      @model = model
    end

    def errors
      return [] unless @model

      @model.validate!
      @model.errors
    end

    def self.model_name
      Dummy.model_name
    end
  end

  let(:dummy_resource) { DummyResource.new(Dummy.new) }
  let(:dummy_resource_without_errors) { DummyResource.new }

  context 'when there are errors' do
    before do
      dummy = dummy_resource
      helper.class.__send__(:define_method, :resource) do
        return dummy
      end
    end

    describe '#devise_error_messages!' do
      it 'returns an html snippet with the sentence and all errors' do
        expect(helper.devise_error_messages!).to eq(
          <<-HTML
<div id="error_explanation" class="alert alert-danger">
  <p class="margin-0"><strong>2 errors prohibited this dummy from being saved:</strong></p>
  <ul><li>Attribute can&#39;t be blank</li><li>Attribute cannot be nil</li></ul>
</div>
          HTML
        )
      end
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
      it 'returns an empty string' do
        expect(helper.devise_error_messages!).to eq('')
      end
    end

    describe '#devise_error_messages?' do
      it { expect(helper.devise_error_messages?).to be_falsy }
    end
  end
end
