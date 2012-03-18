module MechRL
  module State
    class NewGame < Base
      def initialize
        super
        add_view View::NewGame

        Mech::Data.each_with_index do |data,i|
          gosu_keys = [Gosu.const_get("Kb#{i+1}"), Gosu.const_get("KbNumpad#{i+1}")]
          add_command *gosu_keys do
            choose_mech data[0]
          end
        end
      end

      def choose_mech type
        game.transition_to State::ConfigureMech.new
      end
    end
  end
end
