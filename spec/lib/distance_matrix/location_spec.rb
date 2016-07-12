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

      it 'upcases and strips the state' do
        expect(subject.state).to eq('SP')
      end

      it 'upcases and strips the city' do
        expect(subject.city).to eq('SAO PAULO')
      end
    end
  end

  describe '#to_s' do
  end

  describe '#to_query_parameter' do
  end

  describe '#join' do
  end

  describe '#valid?' do
  end
end
