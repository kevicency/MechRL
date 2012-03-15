require 'set'

module MechRL
  module State
    class Base
      include Accessors

      attr_reader :views

      def initialize
        @commands = {}
        @views = []
        @down_keys = Set.new
      end

      def update delta
        @commands.each do |key, command|
          if window.button_down? key
            if (command.is_repeatable?)
              command.execute delta
            else
              command.execute unless @down_keys.include? key
            end
            @down_keys << key
          else
            @down_keys.delete key
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
        keys.each {|key| @commands[key] = Command.new blk, false }
      end

      def add_repeatable_command *keys, &blk
        keys.each {|key| @commands[key] = Command.new blk, true }
      end

      def add_view view_class
        @views << (view_class.new self)
      end
    end

    class Command
      def initialize block, is_repeatable
        @block = block
        @is_repeatable = is_repeatable
      end

      def is_repeatable?
        @is_repeatable
      end

      def execute *args
        @block.call *args
      end
    end
  end
end
