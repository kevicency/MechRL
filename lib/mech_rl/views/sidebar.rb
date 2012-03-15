module MechRL
  module View
    class Sidebar < Base

      def initialize state
        super state
        @font = Resources.fonts[:ascii]
        @mech_ascii = Resources.ascii_art[mech.type]
        @ascii_meta = Resources.ascii_meta[mech.type]

        @char_width = (@font.text_width "w")-1
        @char_height = @font.height - 1

        @offset_x = 2*@char_width
        @offset_y = 2*@char_height
        @width = 2*@offset_x + @mech_ascii.map(&:length).max*@char_width
      end

      def draw
        base_x = Constants::Window::ScreenWidth - @width + @offset_x
        base_y = @offset_y
        bg = Gosu::Color::BLACK

        window.draw_quad(
          base_x - @offset_x             , 0                              , bg, 
          Constants::Window::ScreenWidth, 0                              , bg, 
          base_x - @offset_x             , Constants::Window::ScreenHeight, bg, 
          Constants::Window::ScreenWidth, Constants::Window::ScreenHeight, bg
        )

        @mech_ascii.each_with_index do |s,y|
          x = 0
          s.chars do |c|
            color = Gosu::Color::GRAY
            left = base_x + x*@char_width
            right = base_x + (x+1)*@char_width
            top = base_y + y*@char_height
            bottom = base_y + (y+1)*@char_height + 6

            window.draw_quad(
              left , top   , color,
              right, top   , color,
              left , bottom, color,
              right, bottom, color
            ) if c != " "

            @font.draw(c,
                       left,
                       top,
                       1,
                       1,
                       1.5,
                       (get_color x+1, y+1)
                      )
                      x += 1
          end
        end
      end

      def get_color x,y
        component_name = MechRL::Mech::COMPONENTS
        .select { |c| c != :torso }
        .select { |c| @ascii_meta.send "is_#{c}?", x, y}
        .first || :torso
        component = mech.send component_name
        ratio = component.durability_percentage
        Gosu::Color.from_hsv(120*ratio, 1, 1)
      end
    end
  end
end
