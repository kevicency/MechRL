module MechRL
  module AsciiMeta

    def self.timber_wolf
      return TimberWolf.new
    end

    class TimberWolf

      def is_shoulders? x,y
        x = mirror x if x > center
        (y < 4) ||
          (y < 7 && x < 14) ||
          (y < 10 && ((11..13).include? x))
      end

      def is_left_arm? x,y
        (((7..13).include? y) && x < 11) ||
          (((14..17).include? y) && x < 10)
      end

      def is_right_arm? x,y
        x > center ? (is_left_arm? (mirror x), y) : false
      end

      def is_left_leg? x,y
        (((13..17).include? y) && ((6..15).include? x)) ||
          (y > 17 && x < center)
      end

      def is_right_leg? x,y
        x > center ? (is_left_leg? (mirror x),y) : false
      end

      def is_head? x,y
        (((8..10).include? y) && ((17..21).include? x)) ||
          (y == 1 && ((18..20).include? x))
      end

      private

      def center
        19
      end

      def mirror x
        x = center - (x % center)
      end
    end
  end
end
