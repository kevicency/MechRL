module MechRL
  module View
    class Mech < Base

      def initialize state
        super state
        @font = Gosu::Font.new(window, "Impact", 16)
        @mech_ascii = File.read("/home/kev/dev/7drl/data/mechs/timber_wolf.txt").split "\n"
        @char_width = (@font.text_width "w")-1
        @char_height = @font.height - 1
        @mid = 19
      end

      def draw
        @mech_ascii.each_with_index do |s,y|
          x = 0
          s.chars do |c|
            color = Gosu::Color::GRAY
            window.draw_quad(
            (x)*@char_width  , (y)*@char_height  , color,
            (x+1)*@char_width, (y)*@char_height  , color,
            (x)*@char_width  , (y+1)*@char_height+6, color,
            (x+1)*@char_width, (y+1)*@char_height+6, color
            ) if c != " "
            @font.draw(c,
                       x*@char_width,
                       y*@char_height,
                       1,
                       1,
                       1.5,
                       (get_color x+1, y+1)
                      )
                      x += 1
          end
        end
      end

      def get_color x,y
        if is_shoulder? x,y
          Gosu::Color::GREEN
        elsif is_left_arm? x,y
          Gosu::Color::AQUA
        elsif is_right_arm? x,y
          Gosu::Color::RED
        elsif is_left_leg? x,y
          Gosu::Color::BLUE
        elsif is_right_leg? x,y
          Gosu::Color::YELLOW
        elsif is_head? x,y
          Gosu::Color::CYAN
        else
          Gosu::Color::FUCHSIA
        end

          Gosu::Color::GREEN
      end

      def mirror x
        x = @mid - (x % @mid)
      end

      def is_shoulder? x,y
        x = mirror x if x > @mid
        (y < 4) ||
          (y < 7 && x < 14) ||
          (y < 10 && ((11..13).include? x))
      end

      def is_left_arm? x,y
        (((7..13).include? y) && x < 11) ||
          (((14..17).include? y) && x < 10)
      end

      def is_right_arm? x,y
        x > @mid ? (is_left_arm? (mirror x), y) : false
      end

      def is_left_leg? x,y
        (((13..17).include? y) && ((6..15).include? x)) ||
          (y > 17 && x < @mid)
      end

      def is_right_leg? x,y
        x > @mid ? (is_left_leg? (mirror x),y) : false
      end

      def is_head? x,y
        (((8..10).include? y) && ((17..21).include? x)) ||
          (y == 1 && ((18..20).include? x))
      end
    end
  end
end
