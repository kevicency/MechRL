module MechRL
  module View
    class Base
      include Accessors

      attr_reader :state

      def initialize state
        @state = state
      end

      def update delta

      end
    end
  end
end
