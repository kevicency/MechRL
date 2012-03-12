module MechRL
  module State
    class Base
      attr_reader :views

      def initialize
        @commands = {}
        @views = []
      end

      def update delta
        @commands.each do |key, command|
          if window.button_down? key
            command.call game
          end
        end
        @views.each do |view|
          view.update delta
        end
      end

      def activate

      end

      def deactivate

      end

      def finished?
        false
      end

      def window
        GameWindow.instance
      end

      def game
        window.game
      end

      def player
        game.player unless game.nil?
      end

      private

      def register *keys, &blk
        keys.each {|key| @commands[key] = blk }
      end
    end
  end
end
