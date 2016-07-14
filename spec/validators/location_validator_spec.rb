describe LocationValidator do
  subject { DistanceMatrix::Route.new(origin: origin, destination: destination) }

  let(:valid_location_sp) { DistanceMatrix::Location.new(city: 'SAO PAULO', state: 'SP') }
  let(:valid_location_rs) { DistanceMatrix::Location.new(city: 'PORTO ALEGRE', state: 'RS') }

  let(:invalid_location_sp) { DistanceMatrix::Location.new(city: nil, state: 'SP') }
  let(:invalid_location_rs) { DistanceMatrix::Location.new(city: nil, state: 'RS') }

  before { subject.valid? }

  context 'when origin and destination are valid' do
    let(:origin) { valid_location_sp }
    let(:destination) { valid_location_rs }

    it { is_expected.to be_valid }
  end

  context 'when origin is invalid' do
    let(:origin) { invalid_location_sp }
    let(:destination) { valid_location_rs }

    it { is_expected.to be_invalid }

    it 'has only one error for origin' do
      errors = subject.errors[:origin]

      expect(errors).to eq(['The origin is not a valid location'])
      expect(errors.count).to eq(1)
    end

    it "doesn't have errors for destination" do
      expect(subject.errors[:destination]).to be_empty
    end
  end

  context 'when destination is invalid' do
    let(:origin) { valid_location_sp }
    let(:destination) { invalid_location_rs }

    it { is_expected.to be_invalid }

    it 'has only one error for destination' do
      errors = subject.errors[:destination]

      expect(errors).to eq(['The destination is not a valid location'])
      expect(errors.count).to eq(1)
    end

    it "doesn't have errors for origin" do
      expect(subject.errors[:origin]).to be_empty
    end
  end

  context 'when both origin and destination are invalid' do
    let(:origin) { invalid_location_sp }
    let(:destination) { invalid_location_rs }

    it { is_expected.to be_invalid }

    it 'has only one error for origin' do
      errors = subject.errors[:origin]

      expect(errors).to eq(['The origin is not a valid location'])
      expect(errors.count).to eq(1)
    end

    it 'has only one error for destination' do
      errors = subject.errors[:destination]

      expect(errors).to eq(['The destination is not a valid location'])
      expect(errors.count).to eq(1)
    end
  end
end