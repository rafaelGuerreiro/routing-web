describe LocationValidator do
  subject { DistanceMatrix::Route.new(origin: origin, destination: destination) }

  let(:valid_location_sp) { DistanceMatrix::Location.new(city: 'SAO PAULO', state: 'SP') }
  let(:valid_location_rs) { DistanceMatrix::Location.new(city: 'PORTO ALEGRE', state: 'RS') }

  let(:invalid_location_sp) { DistanceMatrix::Location.new(city: nil, state: 'SP') }
  let(:invalid_location_rs) { DistanceMatrix::Location.new(city: nil, state: 'RS') }

  context 'when origin and destination are valid' do
    let(:origin) { valid_location_sp }
    let(:destination) { valid_location_rs }

    it { is_expected.to be_valid }
  end

  context 'when origin is invalid' do
    let(:origin) { invalid_location_sp }
    let(:destination) { valid_location_rs }

    it { is_expected.to be_invalid }
  end

  context 'when destination is invalid' do
    let(:origin) { valid_location_sp }
    let(:destination) { invalid_location_rs }

    it { is_expected.to be_invalid }
  end
end