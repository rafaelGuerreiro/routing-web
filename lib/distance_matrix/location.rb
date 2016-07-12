module DistanceMatrix
  class Location
    include ActiveModel::Validations
    include Hashie

    attr_reader :state, :city

    validates :state, :city, presence: true

    def initialize(state:, city:)
      @state = harmonize(state)
      @city = harmonize(city)
    end

    def to_s
      join(', ')
    end

    def to_query_parameter
      join(' ').gsub(/\s+/, '+')
    end

    def join(delimiter = nil)
      "#{@city}#{delimiter}#{@state}"
    end

    private

    def harmonize(str)
      return nil unless str.is_a?(String) && str.present?

      str.upcase.strip
    end
  end
end
