module MechRL
  module View
    class Base
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
