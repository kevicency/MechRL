module MechRL
  module State
    class StartMenu < Base
      def initialize
        super
        add_view View::StartMenu

        add_command Gosu::KbS do
          game.transition_to State::NewGame.new
        end

        add_command Gosu::KbQ do
          window.close
        end

        add_command Gosu::KbH do
          game.transition_to State::Help
        end
      end
    end

    class Help < Base
    end
  end
end
