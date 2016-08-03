module CoreExtensions
  module String
    module Harmonizer
      def harmonized(*methods)
        return unless is_a?(::String) && present?

        str = strip

        methods.each do |m|
          next unless str.respond_to?(m)

          tmp = str.__send__(m)
          str = tmp if tmp.is_a?(::String)
        end

        str.freeze
      end
    end
  end
end
