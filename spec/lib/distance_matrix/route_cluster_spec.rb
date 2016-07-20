require 'set'

describe DistanceMatrix::RouteCluster do
  describe 'modules' do
    subject { DistanceMatrix::RouteCluster }

    it { is_expected.to include(Hashie) }
    it { is_expected.to include(PrettyStringfy) }
    it { is_expected.to include(ActiveModel::Validations) }
  end

  let(:sp) { DistanceMatrix::Location.new(city: 'SAO PAULO', state: 'SP') }
  let(:rs) { DistanceMatrix::Location.new(city: 'PORTO ALEGRE', state: 'RS') }
  let(:rj) { DistanceMatrix::Location.new(city: 'RIO DE JANEIRO', state: 'RJ') }
  let(:sc) { DistanceMatrix::Location.new(city: 'FLORIANOPOLIS', state: 'SC') }

  let(:invalid_sp) { DistanceMatrix::Location.new(city: nil, state: 'SP') }

  let(:sp_rs) { DistanceMatrix::Route.new(origin: sp, destination: rs) }
  let(:sp_rj) { DistanceMatrix::Route.new(origin: sp, destination: rj) }
  let(:sp_sc) { DistanceMatrix::Route.new(origin: sp, destination: sc) }

  let(:invalid_sp_rs) { DistanceMatrix::Route.new(origin: invalid_sp, destination: rs) }

  let(:rs_sp) { DistanceMatrix::Route.new(origin: rs, destination: sp) }
  let(:rs_rj) { DistanceMatrix::Route.new(origin: rs, destination: sp) }

  let(:invalid_rs_sp) { DistanceMatrix::Route.new(origin: rs, destination: invalid_sp) }

  describe '.new' do
    it 'adds every route when there are any' do
      routes = [sp_rs, sp_rj, sp_sc]
      cluster = DistanceMatrix::RouteCluster.new(origin: sp, routes: routes)

      expect(cluster.routes).to contain_exactly(*routes)
    end
  end

  describe '#<<' do
    context 'when origin is valid' do
      subject { DistanceMatrix::RouteCluster.new(origin: sp) }

      context 'when added route is valid' do
        context 'when added route is from the same origin as the cluster' do
          it { expect { subject << sp_rs }.to change { subject.routes }.from([]).to([sp_rs]) }
          it { expect { subject << sp_rj }.to change { subject.routes }.from([]).to([sp_rj]) }
        end

        context 'when added route is from another origin as of the cluster' do
          it { expect { subject << rs_sp }.to_not change { subject.routes } }
          it { expect { subject << rs_rj }.to_not change { subject.routes } }
        end
      end

      context 'when added route is invalid' do
        context 'when added object is a DistanceMatrix::Route' do
          context 'when added route is from the same origin as the cluster' do
            it { expect { subject << invalid_sp_rs }.to_not change { subject.routes } }
          end

          context 'when added route is from another origin as of the cluster' do
            it { expect { subject << invalid_rs_sp }.to_not change { subject.routes } }
          end
        end

        context 'when added object is not a DistanceMatrix::Route' do
          it { expect { subject << nil }.to_not change { subject.routes } }
          it { expect { subject << 'from SP to RJ' }.to_not change { subject.routes } }
          it { expect { subject << 123 }.to_not change { subject.routes } }
        end
      end
    end

    context 'when origin is invalid' do
      subject { DistanceMatrix::RouteCluster.new(origin: invalid_sp) }

      context 'when added route is valid' do
        it { expect { subject << sp_rs }.to_not change { subject.routes } }
        it { expect { subject << sp_rj }.to_not change { subject.routes } }
      end

      context 'when added route is invalid' do
        context 'when added object is a DistanceMatrix::Route' do
          context 'when added route is from the same origin as the cluster' do
            it { expect { subject << invalid_sp_rs }.to_not change { subject.routes } }
          end

          context 'when added route is from another origin as of the cluster' do
            it { expect { subject << invalid_rs_sp }.to_not change { subject.routes } }
          end
        end

        context 'when added object is not a DistanceMatrix::Route' do
          it { expect { subject << nil }.to_not change { subject.routes } }
          it { expect { subject << 'from SP to RJ' }.to_not change { subject.routes } }
          it { expect { subject << 123 }.to_not change { subject.routes } }
        end
      end
    end
  end

  describe '#size' do
    subject { DistanceMatrix::RouteCluster.new(origin: sp) }

    context 'when route is added' do
      it { expect { subject << sp_rj }.to change { subject.size }.by(1) }
    end

    context 'when route is not added' do
      it { expect { subject << nil }.to_not change { subject.size } }
    end
  end

  describe '#routes' do
    context 'when there are routes' do
      subject { DistanceMatrix::RouteCluster.new(origin: sp, routes: [sp_rj]) }

      it 'returns an Array' do
        expect(subject.routes).to be_an(Array)
      end

      it 'does not allow the original route to be modified' do
        expect { subject.routes << 'an string' }.to_not change { subject.routes }
      end
    end

    context 'when there are no routes' do
      subject { DistanceMatrix::RouteCluster.new(origin: sp) }

      it 'returns an empty Array' do
        expect(subject.routes).to eql([])
      end

      it 'does not allow the original route to be modified' do
        expect { subject.routes << 'an string' }.to_not change { subject.routes }
      end
    end
  end

  describe '#to_cluster' do
    context 'when there are routes' do
      subject { DistanceMatrix::RouteCluster.new(origin: sp, routes: [sp_rs, sp_rj]) }

      it 'returns a frozen Array' do
        cluster = subject.to_cluster

        expect(cluster).to be_an(Array)
        expect { cluster << 'aa' }.to raise_error(RuntimeError, "can't modify frozen Array")
      end

      it 'slices the routes in 100 elements groups' do
        356.times do |number|
          destination = DistanceMatrix::Location.new(state: 'RS', city: "CITY ##{number}")
          subject << DistanceMatrix::Route.new(origin: sp, destination: destination)
        end

        expect(subject.size).to eq(358)
        expect(subject.to_cluster).to have(4).clusters
      end

      it 'process each slice and convert to query parameters' do
        params = subject.to_cluster.first[:query_parameter]
        expect(params).to eq('origins=SAO+PAULO+SP&destinations=PORTO+ALEGRE+RS|RIO+DE+JANEIRO+RJ')
      end

      it 'adds the origin and the routes for further checking' do
        routes = subject.to_cluster.first[:routes]
        origin = subject.to_cluster.first[:origin]

        expect(routes).to contain_exactly(*[sp_rs, sp_rj])
        expect(origin).to eq(sp)
      end

      context 'when cluster is dirty' do
        it 'gathers cluster once' do
          expect(subject).to receive(:gather_cluster).once.and_call_original
          expect { subject.to_cluster }.to change { subject.clean? }.from(false).to(true)
        end
      end

      context 'when cluster is clean' do
        before { subject.to_cluster }

        it 'never gather cluster because it was already memoized' do
          expect(subject).to_not receive(:gather_cluster).and_call_original
          expect { subject.to_cluster }.to_not change { subject.clean? }
        end
      end
    end

    context 'when there are no routes' do
      subject { DistanceMatrix::RouteCluster.new(origin: sp) }

      it 'returns an empty Array' do
        expect(subject.to_cluster).to eql([])
      end
    end
  end

  describe '#each' do
    subject { DistanceMatrix::RouteCluster.new(origin: sp, routes: [sp_rs, sp_rj]) }

    context 'when there are routes' do
      it 'iterates over the cluster, yielding the origin, routes and the query_parameter' do
        subject.each do |origin, routes, query_parameter|
          expect(origin).to eq(sp)
          expect(routes).to contain_exactly(*[sp_rs, sp_rj])
          expect(query_parameter).to eq('origins=SAO+PAULO+SP&destinations=PORTO+ALEGRE+RS|RIO+DE+JANEIRO+RJ')
        end
      end
    end

    context 'when there are no routes' do
      subject { DistanceMatrix::RouteCluster.new(origin: sp) }

      it 'returns the cluster' do
        expect(subject.each).to eq([])
      end
    end

    context 'when a block is given' do
      it 'yields the block passing 3 arguments' do
        subject.each do |origin, routes, query_parameter|
          expect(origin).to eq(sp)
          expect(routes).to contain_exactly(*[sp_rs, sp_rj])
          expect(query_parameter).to eq('origins=SAO+PAULO+SP&destinations=PORTO+ALEGRE+RS|RIO+DE+JANEIRO+RJ')
        end
      end
    end

    context 'when no block is given' do
      it 'returns the cluster' do
        expect(subject.each.size).to eq(1)
      end
    end
  end
end
