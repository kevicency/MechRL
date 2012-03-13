module MechRL
  module View
    class Base
      attr_reader :state

      def initialize state
        @state = state
      end

      def update delta

      end

      def window
        GameWindow.instance
      end
    end
  end
end
