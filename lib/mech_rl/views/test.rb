
module MechRL
  module View
    class Test < GameView

      def initialize
        @font = Gosu::Font.new(window, "Consolas", 32)
      end

      def draw
        @font.draw("Hello world", 10, 10, 1)
      end
    end
  end
end
