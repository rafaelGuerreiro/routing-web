describe DistanceMatrix::Location do
  describe 'modules' do
    subject { DistanceMatrix::Location }

    it { is_expected.to include(Hashie) }
    it { is_expected.to include(ActiveModel::Validations) }
  end

  subject { DistanceMatrix::Location.new(state: state, city: city) }

  describe '.new' do
    context 'when state is not a valid String' do
      describe 'empty state name' do
        let(:state) { '' }
        let(:city) { 'Sao Paulo' }

        it { is_expected.to be_invalid }
      end

      describe 'numeric state name' do
        let(:state) { 123 }
        let(:city) { 'Sao Paulo' }

        it { is_expected.to be_invalid }
      end

      describe 'nil state name' do
        let(:state) { nil }
        let(:city) { 'Sao Paulo' }

        it { is_expected.to be_invalid }
      end
    end

    context 'when city is not a valid String' do
      describe 'empty city name' do
        let(:state) { 'SP' }
        let(:city) { '   ' }

        it { is_expected.to be_invalid }
      end

      describe 'numeric city name' do
        let(:state) { 'SP' }
        let(:city) { 234 }

        it { is_expected.to be_invalid }
      end

      describe 'nil city name' do
        let(:state) { 'SP' }
        let(:city) { nil }

        it { is_expected.to be_invalid }
      end
    end

    context 'when both state and city are valid String' do
      let(:state) { '  Sp ' }
      let(:city) { ' sao Paulo' }

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
    let(:state) { 'rj' }
    let(:city) { 'rio de janeiro' }

    it { is_expected.to be_valid }
    it { is_expected.to_not be_invalid }

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
    let(:state) { nil }
    let(:city) { 'Porto Alegre' }

    it { is_expected.to_not be_valid }
    it { is_expected.to be_invalid }

    describe '#to_s' do
      it { expect(subject.to_s).to be_nil }
    end

    describe '#to_query_parameter' do
      it { expect(subject.to_query_parameter).to be_nil }
    end

    describe '#join' do
      context 'when passing an argument' do
        it { expect(subject.join('&')).to be_nil }
      end

      context 'when passing no arguments' do
        it { expect(subject.join).to be_nil }
      end
    end
  end
end
