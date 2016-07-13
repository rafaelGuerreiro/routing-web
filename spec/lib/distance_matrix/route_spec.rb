describe DistanceMatrix::Route do
  describe 'modules' do
    subject { DistanceMatrix::Route }

    it { is_expected.to include(Hashie) }
    it { is_expected.to include(PrettyStringfy) }
    it { is_expected.to include(ActiveModel::Validations) }
  end

  let(:valid_location_sp) { DistanceMatrix::Location.new(city: 'SAO PAULO', state: 'SP') }
  let(:valid_location_rj) { DistanceMatrix::Location.new(city: 'RIO DE JANEIRO', state: 'RJ') }
  let(:valid_location_rs) { DistanceMatrix::Location.new(city: 'PORTO ALEGRE', state: 'RS') }

  let(:invalid_location_sp) { DistanceMatrix::Location.new(city: nil, state: 'SP') }
  let(:invalid_location_rj) { DistanceMatrix::Location.new(city: nil, state: 'RJ') }
  let(:invalid_location_rs) { DistanceMatrix::Location.new(city: nil, state: 'RS') }

  context 'when origin is not a valid location' do
    subject { DistanceMatrix::Route.new(origin: invalid_location_sp, destination: valid_location_rs) }

    it { is_expected.to be_invalid }
    it { is_expected.to_not be_valid }
  end

  context 'when origin is nil' do
    subject { DistanceMatrix::Route.new(origin: nil, destination: valid_location_rs) }

    it { is_expected.to be_invalid }
    it { is_expected.to_not be_valid }
  end

  context 'when destination is not a valid location' do
    subject { DistanceMatrix::Route.new(origin: valid_location_sp, destination: invalid_location_rs) }

    it { is_expected.to be_invalid }
    it { is_expected.to_not be_valid }
  end

  context 'when destination is nil' do
    subject { DistanceMatrix::Route.new(origin: valid_location_sp, destination: nil) }

    it { is_expected.to be_invalid }
    it { is_expected.to_not be_valid }
  end

  context 'when both origin and destination are not valid locations' do
    subject { DistanceMatrix::Route.new(origin: invalid_location_sp, destination: invalid_location_rs) }

    it { is_expected.to be_invalid }
    it { is_expected.to_not be_valid }
  end

  context 'when both origin and destination are nil' do
    subject { DistanceMatrix::Route.new(origin: nil, destination: nil) }

    it { is_expected.to be_invalid }
    it { is_expected.to_not be_valid }
  end

  context 'when both origin and destination are valid locations' do
    subject { DistanceMatrix::Route.new(origin: valid_location_sp, destination: valid_location_rs) }

    it { is_expected.to_not be_invalid }
    it { is_expected.to be_valid }

    describe '#distance' do
      it 'defaults to -1' do
        expect(subject.distance).to eq(-1)
      end

      context 'when distance is valid' do
        it 'is mutable' do
          expect { subject.distance = 10.5 }.to change { subject.distance }.from(-1).to(10.5)
        end

        it 'can be zero' do
          expect { subject.distance = 0 }.to change { subject.distance }.from(-1).to(0)
        end
      end

      context 'when distance is invalid' do
        context 'when distance is nil' do
          it 'does not change' do
            expect { subject.distance = nil }.to_not change { subject.distance }
          end
        end

        context 'when distance is not a Numeric' do
          it 'does not change' do
            expect { subject.distance = '10' }.to_not change { subject.distance }
          end
        end

        context 'when distance is a negative number' do
          it 'does not change' do
            expect { subject.distance = -2 }.to_not change { subject.distance }
          end
        end
      end
    end
  end
end
