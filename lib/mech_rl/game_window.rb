module MechRL
  class GameWindow < Gosu::Window
    include Constants

    def initialize
      super Window::ScreenWidth,
            Window::ScreenHeight,
            Window::Fullscreen
      self.caption = Window::ScreenCaption

      @bg_color = Gosu::Color.new 0xFFc0c0c0
      @font = Gosu::Font.new(self, "Consolas", 32)
    end

    def update
    end

    def draw
      draw_quad(
        0                   , 0                    , @bg_color ,
        Window::ScreenWidth , 0                    , @bg_color ,
        0                   , Window::ScreenHeight , @bg_color ,
        Window::ScreenWidth , Window::ScreenHeight , @bg_color
      )
      msg = "Hello World !"
      offset_x = @font.text_width(msg)/2
      offset_y = @font.height/2
      @font.draw(msg, Window::ScreenWidth/2 - offset_x, Window::ScreenHeight/2 - offset_y, ZOrder::Text)
    end
  end
end
