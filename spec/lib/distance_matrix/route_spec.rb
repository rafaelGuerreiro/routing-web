describe DistanceMatrix::Route do
  describe 'modules' do
    subject { DistanceMatrix::Route }

    it { is_expected.to include(Hashie) }
    it { is_expected.to include(PrettyStringfy) }
    it { is_expected.to include(ActiveModel::Validations) }
  end

  subject { DistanceMatrix::Route.new(origin: origin, destination: destination) }

  let(:sp) { DistanceMatrix::Location.new(city: 'SAO PAULO', state: 'SP') }
  let(:rs) { DistanceMatrix::Location.new(city: 'PORTO ALEGRE', state: 'RS') }

  let(:invalid_sp) { DistanceMatrix::Location.new(city: nil, state: 'SP') }
  let(:invalid_rs) { DistanceMatrix::Location.new(city: nil, state: 'RS') }

  context 'when route is invalid' do
    context 'when origin is not a valid location' do
      let(:origin) { invalid_sp }
      let(:destination) { rs }

      it { is_expected.to be_invalid }

      describe '#distance' do
        it 'is always -1' do
          expect { subject.distance = 10.5 }.to_not change { subject.distance }.from(-1)
        end
      end

      describe '#error_message?' do
        it { expect(subject.error_message?).to be_truthy }
      end
    end

    context 'when origin is nil' do
      let(:origin) { nil }
      let(:destination) { rs }

      it { is_expected.to be_invalid }

      describe '#distance' do
        it 'is always -1' do
          expect { subject.distance = 10.5 }.to_not change { subject.distance }.from(-1)
        end
      end

      describe '#error_message?' do
        it { expect(subject.error_message?).to be_truthy }
      end
    end

    context 'when destination is not a valid location' do
      let(:origin) { sp }
      let(:destination) { invalid_rs }

      it { is_expected.to be_invalid }

      describe '#distance' do
        it 'is always -1' do
          expect { subject.distance = 10.5 }.to_not change { subject.distance }.from(-1)
        end
      end

      describe '#error_message?' do
        it { expect(subject.error_message?).to be_truthy }
      end
    end

    context 'when destination is nil' do
      let(:origin) { sp }
      let(:destination) { nil }

      it { is_expected.to be_invalid }

      describe '#distance' do
        it 'is always -1' do
          expect { subject.distance = 10.5 }.to_not change { subject.distance }.from(-1)
        end
      end

      describe '#error_message?' do
        it { expect(subject.error_message?).to be_truthy }
      end
    end

    context 'when both origin and destination are not valid locations' do
      let(:origin) { invalid_sp }
      let(:destination) { invalid_rs }

      it { is_expected.to be_invalid }

      describe '#distance' do
        it 'is always -1' do
          expect { subject.distance = 10.5 }.to_not change { subject.distance }.from(-1)
        end
      end

      describe '#error_message?' do
        it { expect(subject.error_message?).to be_truthy }
      end
    end

    context 'when both origin and destination are nil' do
      let(:origin) { nil }
      let(:destination) { nil }

      it { is_expected.to be_invalid }

      describe '#distance' do
        it 'is always -1' do
          expect { subject.distance = 10.5 }.to_not change { subject.distance }.from(-1)
        end
      end

      describe '#error_message?' do
        it { expect(subject.error_message?).to be_truthy }
      end
    end
  end

  context 'when route is valid' do
    let(:origin) { sp }
    let(:destination) { rs }

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
          it { expect { subject.distance = nil }.to_not change { subject.distance } }
        end

        context 'when distance is not a Numeric' do
          it { expect { subject.distance = '10' }.to_not change { subject.distance } }
        end

        context 'when distance is a negative number' do
          it { expect { subject.distance = -2 }.to_not change { subject.distance } }
        end
      end
    end

    describe '#error_message?' do
      it 'is mutable' do
        expect { subject.error_message = :not_found }.to change { subject.error_message? }.from(false).to(true)
      end

      it 'can be truthy and the subject will still be valid' do
        expect { subject.error_message = :not_found }.to_not change { subject.valid? }
      end
    end
  end
end
