module MechRL
  module View
    class Base
      include Accessors
      include Constants

      attr_reader :state

      def initialize state
        @state = state
        @screen_margin = 10
      end

      def update delta

      end
    end
  end
end
