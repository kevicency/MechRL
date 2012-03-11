require 'singleton'

module MechRL
  class GameWindow < Gosu::Window
    include Singleton
    include Constants

    attr_reader :views

    def initialize
      super Window::ScreenWidth,
            Window::ScreenHeight,
            Window::Fullscreen
      self.caption = Window::ScreenCaption

      @views = []
      @bg_color = Gosu::Color.new 0xFFc0c0c0
    end

    def update
      view.update unless view.nil?
    end

    def draw
      draw_background

      view.draw unless view.nil?
    end

    def view
      views.first
    end

    private

    def draw_background
      draw_quad(
        0                   , 0                    , @bg_color ,
        Window::ScreenWidth , 0                    , @bg_color ,
        0                   , Window::ScreenHeight , @bg_color ,
        Window::ScreenWidth , Window::ScreenHeight , @bg_color
      )
    end
  end
end
