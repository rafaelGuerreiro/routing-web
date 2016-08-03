module DistanceMatrix
  class Location
    include ActiveModel::Validations
    include Hashie

    attr_reader :state, :city

    validates :state, :city, presence: true

    def initialize(state:, city:)
      @state = state.harmonized(:upcase)
      @city = city.harmonized(:upcase)
    end

    def to_s
      join(', ')
    end

    def to_query_parameter
      param = join(' ')

      return unless param
      param.gsub(/\s+/, '+')
    end

    def join(delimiter = nil)
      return if invalid?

      "#{@city}#{delimiter}#{@state}"
    end
  end
end
