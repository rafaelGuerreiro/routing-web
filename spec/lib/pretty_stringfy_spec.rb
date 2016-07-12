describe PrettyStringfy do
  class DummyClassWithoutAttribute
    include PrettyStringfy
  end

  context 'when there are no attributes' do
    subject { DummyClassWithoutAttribute.new.to_s }

    it { is_expected.to eq('[ DummyClassWithoutAttribute => (no attributes) ]') }
  end

  class DummyClass
    include PrettyStringfy

    attr_reader :first_value, :second_value

    def initialize(first_value, second_value)
      @first_value = first_value
      @second_value = second_value
    end
  end

  context 'when there are attributes' do
    context 'when an attribute is nil' do
      subject { DummyClass.new(nil, nil).to_s }

      it { is_expected.to eq('[ DummyClass => first_value: nil, second_value: nil ]') }
    end

    context 'when an attribute is a String' do
      subject { DummyClass.new('nil', 'a value').to_s }

      it { is_expected.to eq("[ DummyClass => first_value: 'nil', second_value: 'a value' ]") }
    end

    context 'when an attribute is not nil nor a String' do
      subject { DummyClass.new(123_123, DummyClass.new(234, 456)).to_s }

      it do
        is_expected.to eq('[ DummyClass => first_value: 123123, second_value: ' \
                             '[ DummyClass => first_value: 234, second_value: 456 ] ]')
      end
    end
  end
end
