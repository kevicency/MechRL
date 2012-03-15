module MechRL
  module State
    class Base
      include Accessors

      attr_reader :views

      def initialize
        @commands = {}
        @views = []
      end

      def update delta
        @commands.each do |key, command|
          if window.button_down? key
            command.call delta
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

      private

      def add_command *keys, &blk
        keys.each {|key| @commands[key] = blk }
      end

      def add_view view_class
        @views << (view_class.new self)
      end
    end
  end
end
