describe CoreExtensions::String::Harmonizer do
  # def harmonized(*methods)
  #   return self unless self.is_a?(String)
  #   return nil unless self.present?
  #
  #   str = self.strip
  #
  #   methods.each { |m| str = str.__send__(m) }
  #   return str.freeze
  # end

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
        end

        context 'when invalid methods are called' do
          it 'ignores the method when string does not respond to it' do
            expect(subject.harmonized(:a_weird_method, :reverse)).to eq('gnirts tset a')
          end

          it 'ignores the method when the return is not a string' do
            expect(subject.harmonized(:length, :reverse)).to eq('gnirts tset a')
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
