require 'set'
require 'byebug'

module DistanceMatrix
  class RouteCluster
    include ActiveModel::Validations
    include Hashie
    include Dirtie
    include PrettyStringfy

    attr_reader :origin

    validates :origin, presence: true, location: true
    validates :routes, presence: true

    def initialize(origin:, routes: [])
      @origin = origin
      @routes = Set.new
      routes.each { |d| self << d }
    end

    def <<(route)
      return unless valid_route?(route)

      dirty! if @routes.add?(route)
    end
    alias add <<

    def size
      @routes.size
    end
    alias length size

    def to_cluster
      return @cluster || [] if clean?

      @cluster = gather_cluster
    end

    def routes
      @routes.to_a
    end

    def each
      return to_cluster unless block_given?

      to_cluster.each do |hash|
        yield hash[:origin], hash[:routes], hash[:query_parameter]
      end
    end

    private

    def valid_route?(route)
      route.is_a?(DistanceMatrix::Route) && route.valid? && route.origin == @origin
    end

    def gather_cluster
      cluster = []

      @routes.each_slice(100) do |slice|
        cluster << to_cluster_hash(slice)
      end

      clean!
      cluster.freeze
    end

    def to_cluster_hash(routes)
      {
        origin: @origin,
        routes: routes,
        query_parameter: to_query_parameter(routes)
      }
    end

    def to_query_parameter(routes)
      return '' unless routes.present?
      "origins=#{@origin.to_query_parameter}&destinations=#{to_query_parameters(routes)}"
    end

    def to_query_parameters(routes)
      routes.map(&:destination).map(&:to_query_parameter).join('|')
    end
  end
end
