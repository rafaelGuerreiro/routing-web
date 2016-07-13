module DistanceMatrix
  class Route
    include ActiveModel::Validations
    include Hashie
    include PrettyStringfy

    attr_reader :origin, :destination, :error_message

    validates :origin, :destination, presence: true
    validates_with DistanceMatrix::Validator::LocationValidator

    def initialize(origin:, destination:)
      @origin = origin
      @destination = destination
    end

    def distance
      @distance || -1
    end

    def distance=(distance)
      @distance = distance if distance.is_a?(::Numeric) && distance >= 0
    end

    def error_message?
      @error_message.present?
    end
  end
end
