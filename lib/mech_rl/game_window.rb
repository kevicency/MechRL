require 'singleton'

module MechRL
  class GameWindow < Gosu::Window
    include Singleton
    include Constants

    attr_reader :views
    attr_reader :game

    def initialize
      super Window::ScreenWidth,
            Window::ScreenHeight,
            Window::Fullscreen
      self.caption = Window::ScreenCaption

      @views = []
      @bg_color = Gosu::Color.new 0xFFc0c0c0
      @is_first_update = true
    end

    def update
      if (@is_first_update)
        Resources.load self
        @game = Game.new
        @game.transition_to State::Ingame.new

        @is_first_update = false
      end

      @game.update update_interval/1000 unless game.nil?
    end

    def draw
      draw_background

      @game.state.views.each &:draw
    end
    private

    def draw_background
      draw_quad(
      0                  , 0                   , @bg_color, 
      Window::ScreenWidth, 0                   , @bg_color, 
      0                  , Window::ScreenHeight, @bg_color, 
      Window::ScreenWidth, Window::ScreenHeight, @bg_color
      )
    end
  end
end
