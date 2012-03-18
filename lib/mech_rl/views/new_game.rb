module MechRL
  module View
    class NewGame < Base
      def initialize state
        super state
        @font = Resources::Fonts[:menu_xl]
      end

      def draw
        top = @screen_margin
        left = @screen_margin

        @font.draw "Choose your Mech", left, top, ZOrder::Text
        top += @font.height

        Mech::Data.each_with_index do |data,i|
          mech = data[1]
          s = "#{i+1}. #{mech.name}"
          @font.draw s, left, top, ZOrder::Text
          top += @font.height
        end
      end
    end
  end
end
