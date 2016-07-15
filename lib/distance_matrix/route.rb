module DistanceMatrix
  class Route
    include ActiveModel::Validations
    include Hashie
    include PrettyStringfy

    attr_reader :origin, :destination, :error_message

    validates :origin, :destination, presence: true, location: true

    # validates_with DistanceMatrix::Validator::RouteValidator

    def initialize(origin:, destination:)
      @origin = origin
      @destination = destination
    end

    def distance
      @distance || -1
    end

    def distance=(distance)
      distance = -1 if invalid?
      @distance = distance if distance.is_a?(::Numeric) && distance >= 0
    end

    def error_message?
      return errors.present? if invalid?
      @error_message.present?
    end

    def error_message=(error_message)
      error_message = nil if invalid?
      @error_message = error_message if error_message.is_a?(::Symbol)
    end
  end
end
