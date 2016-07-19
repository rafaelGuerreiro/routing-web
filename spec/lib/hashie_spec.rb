describe Hashie do
  before do
    stub_const('DummyClass', Class.new do
      include Hashie
      include PrettyStringfy

      attr_reader :first_value, :second_value

      def initialize(first_value, second_value)
        @first_value = first_value
        @second_value = second_value
      end

      def inspect
        to_s
      end
    end)

    stub_const('OtherDummyClass', Class.new do
      include Hashie
      include PrettyStringfy

      attr_reader :first_value, :second_value

      def initialize(first_value, second_value)
        @first_value = first_value
        @second_value = second_value
      end

      def inspect
        to_s
      end
    end)
  end

  let(:first_value) { 'a string value' }
  let(:second_value) { 123_123 }

  let(:other_first_value) { 'other string value' }
  let(:other_second_value) { 234_234 }

  subject { DummyClass.new(first_value, second_value) }

  context 'when objects are equals' do
    context 'when objects are exactly the same' do
      let(:other) { subject }

      it { is_expected.to be(other) }
      it { is_expected.to eql(other) }
      it { is_expected.to eq(other) }

      describe '#hash' do
        it 'has the same hash' do
          expect(subject.hash).to eql(other.hash)
        end
      end
    end

    context 'when objects share the same class' do
      let(:other) { DummyClass.new(first_value, second_value) }

      it { is_expected.to_not be(other) }
      it { is_expected.to eql(other) }
      it { is_expected.to eq(other) }

      describe '#hash' do
        it 'has the same hash' do
          expect(subject.hash).to eql(other.hash)
        end
      end
    end

    context 'when objects have different classes' do
      let(:other) { OtherDummyClass.new(first_value, second_value) }

      it { is_expected.to_not be(other) }
      it { is_expected.to_not eql(other) }
      it { is_expected.to eq(other) }

      describe '#hash' do
        it 'has the same hash' do
          expect(subject.hash).to eql(other.hash)
        end
      end
    end
  end

  context 'when objects are different' do
    context 'when objects share the same class' do
      context 'when there are no nil attributes' do
        context 'when only the first attribute is different' do
          let(:other) { DummyClass.new(other_first_value, second_value) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end

        context 'when only the second attribute is different' do
          let(:other) { DummyClass.new(first_value, other_second_value) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end

        context 'when both attributes are different' do
          let(:other) { DummyClass.new(other_first_value, other_second_value) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end
      end

      context 'when there are nil attributes' do
        context 'when only the first attribute is nil' do
          let(:other) { DummyClass.new(nil, second_value) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end

        context 'when only the second attribute is nil' do
          let(:other) { DummyClass.new(first_value, nil) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end

        context 'when both attributes are nil' do
          let(:other) { DummyClass.new(nil, nil) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end
      end
    end

    context 'when objects have different classes' do
      context 'when there are no nil attributes' do
        context 'when only the first attribute is different' do
          let(:other) { OtherDummyClass.new(other_first_value, second_value) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end

        context 'when only the second attribute is different' do
          let(:other) { OtherDummyClass.new(first_value, other_second_value) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end

        context 'when both attributes are different' do
          let(:other) { OtherDummyClass.new(other_first_value, other_second_value) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end
      end

      context 'when there are nil attributes' do
        context 'when only the first attribute is nil' do
          let(:other) { OtherDummyClass.new(nil, second_value) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end

        context 'when only the second attribute is nil' do
          let(:other) { OtherDummyClass.new(first_value, nil) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end

        context 'when both attributes are nil' do
          let(:other) { OtherDummyClass.new(nil, nil) }

          it { is_expected.to_not be(other) }
          it { is_expected.to_not eql(other) }
          it { is_expected.to_not eq(other) }

          describe '#hash' do
            it 'has different hash' do
              expect(subject.hash).to_not eql(other.hash)
            end
          end
        end
      end
    end
  end
end
