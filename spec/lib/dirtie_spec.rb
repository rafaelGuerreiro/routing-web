describe Dirtie do
  before do
    stub_const('DummyClass', Class.new do
      include Dirtie

      attr_reader :value, :other_value

      def initialize(value)
        @value = value
      end

      def value=(value)
        return @value if @value == value

        @value = value
        dirty!
      end

      def copy_value
        @other_value = @value if dirty?
        clean!
      end
    end)
  end

  let(:initial_value) { 'initial value' }
  subject { DummyClass.new('initial value') }

  context 'when value changes' do
    before do
      subject.value = 'other value'
    end

    describe '#dirty?' do
      it 'is true after changing' do
        expect(subject.dirty?).to be_truthy
      end

      it 'is false after cleaning' do
        expect { subject.copy_value }.to change { subject.dirty? }.from(true).to(false)
      end
    end

    describe '#clean?' do
      it 'is false after changing' do
        expect(subject.clean?).to be_falsy
      end

      it 'is true after cleaning' do
        expect { subject.copy_value }.to change { subject.clean? }.from(false).to(true)
      end
    end
  end

  context 'when value does not change' do
    describe '#dirty?' do
      it 'is false by default' do
        expect(subject.dirty?).to be_falsy
      end
    end

    describe '#clean?' do
      it 'is true by default' do
        expect(subject.clean?).to be_truthy
      end
    end
  end

  describe '#clean!' do
    it 'is private' do
      expect(subject.private_methods).to include(:clean!)
    end
  end

  describe '#dirty!' do
    it 'is private' do
      expect(subject.private_methods).to include(:dirty!)
    end
  end
end
