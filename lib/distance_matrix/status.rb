module DistanceMatrix
  class Status
    include Hashie

    class << self
      def parse(id)
        @status[id.to_sym]
      end

      private

      def status(id, message = nil)
        @status ||= {}
        @status[id] = new(id: id, message: message)
      end
    end

    attr_reader :id, :message

    def initialize(id:, message:)
      @id = id
      @message = message.harmonized
    end

    def to_s
      error? ? "[#{@id}] #{@message}".freeze : "[#{@id}]".freeze
    end

    def error?
      @message.present?
    end

    def ok?
      !error?
    end
  end
end
