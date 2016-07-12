describe DistanceMatrix::Location do
  describe 'Hashie' do
    subject { DistanceMatrix::Location.new(state: 'SP', city: 'Sao Paulo') }
    it { is_expected.to be_a(Hashie) }
    it { is_expected.to be_an(ActiveModel::Validations) }
  end

  describe '.new' do
    context 'when state is not a valid String' do
      describe 'empty state name' do
        subject { DistanceMatrix::Location.new(state: '', city: 'Sao Paulo') }
        it { is_expected.to be_invalid }
      end

      describe 'numeric state name' do
        subject { DistanceMatrix::Location.new(state: 123, city: 'Sao Paulo') }
        it { is_expected.to be_invalid }
      end

      describe 'nil state name' do
        subject { DistanceMatrix::Location.new(state: nil, city: 'Sao Paulo') }
        it { is_expected.to be_invalid }
      end
    end

    context 'when city is not a valid String' do
      describe 'empty city name' do
        subject { DistanceMatrix::Location.new(state: 'SP', city: '   ') }
        it { is_expected.to be_invalid }
      end

      describe 'numeric city name' do
        subject { DistanceMatrix::Location.new(state: 'SP', city: 234) }
        it { is_expected.to be_invalid }
      end

      describe 'nil city name' do
        subject { DistanceMatrix::Location.new(state: 'SP', city: nil) }
        it { is_expected.to be_invalid }
      end
    end

    context 'when both state and city are valid String' do
      subject { DistanceMatrix::Location.new(state: '  Sp ', city: ' sao Paulo') }

      it { is_expected.to be_valid }

      it 'upcases and strips the state' do
        expect(subject.state).to eq('SP')
      end

      it 'upcases and strips the city' do
        expect(subject.city).to eq('SAO PAULO')
      end
    end
  end

  context 'when location is valid' do
    subject { DistanceMatrix::Location.new(state: 'rj', city: 'rio de janeiro') }

    describe '#valid?' do
      it { is_expected.to be_valid }
    end

    describe '#invalid?' do
      it { is_expected.to_not be_invalid }
    end

    describe '#to_s' do
      it 'joins the city and the state by a comma and space' do
        expect(subject.to_s).to eq('RIO DE JANEIRO, RJ')
      end
    end

    describe '#to_query_parameter' do
      it 'joins the city and the state and replaces spaces by the plus sign' do
        expect(subject.to_query_parameter).to eq('RIO+DE+JANEIRO+RJ')
      end
    end

    describe '#join' do
      context 'when passing an argument' do
        it 'returns the city and the state delimited by its argument' do
          expect(subject.join('&')).to eq('RIO DE JANEIRO&RJ')
        end
      end

      context 'when passing no arguments' do
        it 'returns the city and the state delimited by an empty string' do
          expect(subject.join).to eq('RIO DE JANEIRORJ')
        end
      end
    end
  end

  context 'when location is invalid' do
    subject { DistanceMatrix::Location.new(state: nil, city: 'Porto Alegre') }

    describe '#valid?' do
      it { is_expected.to_not be_valid }
    end

    describe '#invalid?' do
      it { is_expected.to be_invalid }
    end

    describe '#to_s' do
      it 'is always nil' do
        expect(subject.to_s).to be_nil
      end
    end

    describe '#to_query_parameter' do
      it 'is always nil' do
        expect(subject.to_query_parameter).to be_nil
      end
    end

    describe '#join' do
      context 'when passing an argument' do
        it 'is always nil' do
          expect(subject.join('&')).to be_nil
        end
      end

      context 'when passing no arguments' do
        it 'is always nil' do
          expect(subject.join).to be_nil
        end
      end
    end
  end
end
