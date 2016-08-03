describe CoreExtensions::String::Harmonizer do
  describe '#harmonized' do
    context 'when the object is a String' do
      context 'when string is present' do
        subject { '  a test string  ' }

        it 'is stripped' do
          expect(subject.harmonized).to eq('a test string')
        end

        it 'is frozen' do
          expect(subject.harmonized.frozen?).to be_truthy
        end

        context 'when valid methods are called' do
          it 'upcases when passed :upcase' do
            expect(subject.harmonized(:upcase)).to eq('A TEST STRING')
          end

          it 'reserves when passed :reverse' do
            expect(subject.harmonized(:reverse)).to eq('gnirts tset a')
          end

          it 'calls various methods' do
            expect(subject.harmonized(:upcase, :reverse)).to eq('GNIRTS TSET A')
          end

          context 'when the string can be stripped' do
            it 'does not modify the original string' do
              expect { subject.harmonized(:upcase!) }.to_not change { subject }
            end
          end

          context 'when the string cannot be stripped' do
            subject { 'a test string' }

            it 'does not modify the original string' do
              expect { subject.harmonized(:upcase!) }.to_not change { subject }
            end
          end

          context 'when method is in hash' do
            it 'accepts hashes with arguments' do
              expect(subject.harmonized(method: :<<, arguments: ' TEST')).to eq('a test string TEST')
            end

            it 'does not accept hashes without arguments' do
              expect(subject.harmonized(method: :reverse)).to eq('a test string')
            end
          end

          context 'when method is in array' do
            it 'accepts arrays with arguments' do
              expect(subject.harmonized(:upcase, [:<<, ' test'])).to eq('A TEST STRING test')
            end

            it 'accepts arrays without arguments' do
              expect(subject.harmonized(:upcase, [:reverse])).to eq('GNIRTS TSET A')
            end
          end
        end

        context 'when invalid methods are called' do
          context 'when String does not respond to method' do
            it 'is ignored' do
              expect(subject.harmonized(:a_weird_method, :reverse)).to eq('gnirts tset a')
            end

            context 'when method is in the hash' do
              it 'is ignored' do
                method = {
                  method: :a_weird_method,
                  arguments: ['a weird parameter']
                }

                expect(subject.harmonized(method, :reverse)).to eq('gnirts tset a')
              end

              context 'when hash has no :method key' do
                it 'is ignored' do
                  expect(subject.harmonized({ arguments: [] }, :reverse)).to eq('gnirts tset a')
                end
              end

              context 'when hash has no :arguments key' do
                it 'is ignored' do
                  expect(subject.harmonized({ method: 'a_weird_method' }, :reverse)).to eq('gnirts tset a')
                end
              end
            end

            context 'when method is in the array' do
              it 'is ignored' do
                expect(subject.harmonized([:a_weird_method, 'a weird parameter'], :reverse)).to eq('gnirts tset a')
              end

              context 'when array is empty' do
                it 'is ignored' do
                  expect(subject.harmonized([], :reverse)).to eq('gnirts tset a')
                end
              end

              context 'when array has no arguments' do
                it 'is ignored' do
                  expect(subject.harmonized([:a_weird_method], :reverse)).to eq('gnirts tset a')
                end
              end
            end
          end

          context 'when the method is not a Symbol nor a String' do
            it 'is ignored' do
              expect(subject.harmonized(123, 'reverse')).to eq('gnirts tset a')
            end
          end

          context 'when the type returned by the method is not a String' do
            it 'is ignored' do
              expect(subject.harmonized(:length, :reverse)).to eq('gnirts tset a')
            end
          end
        end
      end

      context 'when string is blank' do
        subject { '   ' }

        it 'returns nil' do
          expect(subject.harmonized).to be_nil
        end
      end
    end

    context 'when the object is an Object' do
      context 'when the object is nil' do
        subject { nil }

        it 'returns nil' do
          expect(subject.harmonized).to be_nil
        end
      end

      context 'when the object is a Number' do
        subject { 123 }

        it 'returns nil' do
          expect(subject.harmonized).to be_nil
        end
      end
    end
  end
end
