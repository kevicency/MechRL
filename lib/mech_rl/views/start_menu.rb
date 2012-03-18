module MechRL
  module View
    class StartMenu < Base

      def initialize state
        super state
        @font = Resources::Fonts[:menu_xl]
      end

      def draw
        top = @screen_margin
        left = @screen_margin

        ["Welcome to MechRL", "s. Start Game", "q. Quit", "h. Help"].each do |item|
          @font.draw item, left, top, ZOrder::Text
          top += @font.height
        end
      end
    end
  end
end
