module MechRL
  module State
    class Ingame < Base

      def initialize
        super

        add_view View::Map
        add_view View::Sidebar
        add_view View::Debug

        add_command Gosu::KbW, Gosu::KbUp do |delta|
          if (mech.target_velocity < 50)
            mech.target_velocity += 10*delta
          end
        end

        add_command Gosu::KbS, Gosu::KbDown do |delta|
          if (mech.target_velocity > 0)
            mech.target_velocity -= 10*delta
          end
        end

        add_command Gosu::KbA do |delta|
          mech.rotate :left, delta
        end

        add_command Gosu::KbD do |delta|
          mech.rotate :right, delta
        end

        add_command Gosu::KbQ do |delta|
          mech.torso.rotate :left, delta
        end

        add_command Gosu::KbE do |delta|
          mech.torso.rotate :right, delta
        end
      end

      def update delta
        super delta
        mech.location[:x] %= Constants::Window::ScreenWidth
        mech.location[:y] %= Constants::Window::ScreenHeight
      end
    end
  end
end
