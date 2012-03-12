module MechRL
  module State
    class Game < Base

      def initialize
        super
        @views << (View::Game.new self)

        register Gosu::KbW, Gosu::KbUp do
          if (player.target_velocity < 0.2)
            player.target_velocity += 0.005
          end
        end

        register Gosu::KbA, Gosu::KbLeft do
          player.turn_left
        end

        register Gosu::KbS, Gosu::KbDown do
          if (player.target_velocity > 0)
            player.target_velocity -= 0.005
          end
        end

        register Gosu::KbD, Gosu::KbRight do
          player.turn_right
        end
      end
    end
  end
end
