module MechRL
  module State
    class Game < Base

      def initialize
        super
        @views << (View::Game.new self)
        @views << (View::Debug.new self)

        register Gosu::KbW, Gosu::KbUp do |delta|
          if (player.target_velocity < 50)
            player.target_velocity += 10*delta
          end
        end

        register Gosu::KbS, Gosu::KbDown do |delta|
          if (player.target_velocity > 0)
            player.target_velocity -= 10*delta
          end
        end

        register Gosu::KbA do |delta|
          player.turn :left, delta
        end

        register Gosu::KbD do |delta|
          player.turn :right, delta
        end

        register Gosu::KbQ do |delta|
          player.look :left, delta
        end

        register Gosu::KbE do |delta|
          player.look :right, delta
        end

      end
    end
  end
end
