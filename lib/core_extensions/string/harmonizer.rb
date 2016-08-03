module CoreExtensions
  module String
    module Harmonizer
      def harmonized(*methods)
        return unless is_a?(::String) && present?

        str = strip

        methods.map { |m| harmonize_method(m) }
               .each do |hash|
          method, arguments = hash.values

          next unless method.present? && str.respond_to?(method)

          tmp = str.__send__(method, *arguments)
          str = tmp if tmp.is_a?(::String)
        end

        str.freeze
      end

      private

      def harmonize_method(m)
        return m if valid_hash(m)

        method = nil
        arguments = []

        if m.is_a?(::Symbol) || m.is_a?(::String)
          method = m.to_sym
        elsif m.is_a?(::Array) && m.present?
          method = m.first.to_sym
          arguments = m[1..-1]
        end

        { method: method, arguments: arguments }
      end

      def valid_hash(m)
        m.is_a?(::Hash) && m.key?(:method) && m.key?(:arguments)
      end
    end
  end
end
