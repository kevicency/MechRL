module MechRL
  module Accessors
      def window
        GameWindow.instance
      end

      def game
        window.game
      end

      def player
        game.player unless game.nil?
      end

      def mech
        player.mech unless player.nil?
      end
  end
end
