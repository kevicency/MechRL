module MechRL
  module View
    class Sidebar < Base
      include Constants
      attr_reader :width, :height

      def initialize state
        super state
        @medium_font = Resources::Fonts[:label_m]
        @small_font  = Resources::Fonts[:label_s]
        @ascii_font  = Resources::Fonts[:ascii]
        @ascii_art   = Resources.ascii_art[mech.type]
        @ascii_meta  = Resources.ascii_meta[mech.type]

        @char_width  = @ascii_font.text_width("w")-1
        @char_height = @ascii_font.height-1

        @sidebar_bg  = Gosu::Color.new 0xFF303030
        @overlay_bg  = Gosu::Color.new 0xFF151515
        @selected_color = Gosu::Color.new 0xFF0088FF
        @cooldown_color = Gosu::Color.new 0xFFFF0000
        @blink_alpha = 0
        @blink_decreasing = false

        @margin_x    = @char_width*2
        @margin_y    = @char_height

        @width       = @margin_x*2 + @ascii_art.map(&:length).max*@char_width
        @height      = Window::ScreenHeight

        @left        = Window::ScreenWidth - @width
        @right       = Window::ScreenWidth

        @bar_width   = @right-@left-2*@margin_x
        @bar_height  = @medium_font.height

        @mech_height= (@ascii_art.length + 0.5)*@char_height
      end

      def update delta
        if (@blink_decreasing)
          @blink_alpha -= [1.5*delta, @blink_alpha].min
          @blink_decreasing = @blink_alpha > 0
        else
          @blink_alpha += [1.5*delta, 1 - @blink_alpha].min
          @blink_decreasing = @blink_alpha >= 1
        end
      end

      def draw
        draw_bg

        top = 1.5*@margin_y
        top += draw_weapons top
        top += draw_torso_rotation top

        draw_mech top
      end

      def draw_bg
        window.draw_rect @left, 0, @right, @height, @sidebar_bg
      end

      def draw_torso_rotation top
        left             = @left + @margin_x
        right            = @right - @margin_x

        bar_bottom       = top + @bar_height
        marker_width     = 4
        marker_offset_y  = 2
        indicator_width  = 2
        indicator_offset = 3

        #header

        # bar
        window.draw_rect left, top, right, top+@bar_height, @overlay_bg

        # markers
        3.times do |i|
          marker_offset_x = marker_width / 2*i

          marker_left     = left + i*@bar_width/2 - marker_offset_x
          marker_right    = marker_left + marker_width

          window.draw_rect marker_left,
                           top - marker_offset_y,
                           marker_right,
                           bar_bottom + marker_offset_y,
                           @overlay_bg
        end

        # captions
        @small_font.draw_rel "Torso Rotation", left + @bar_width/2, top-marker_offset_y, ZOrder::Text, 0.5, 1
        [-mech.torso.max_rotation, 0, mech.torso.max_rotation].each_with_index do |rot, i|
          @small_font.draw_rel rot,
                               left + i*@bar_width/2,
                               bar_bottom + marker_offset_y + 3,
                               ZOrder::Text, i*0.5, 0
        end

        # rotation indicator
        rotation_ratio = mech.torso.rotation / mech.torso.max_rotation
        indicator_left = left + (1 + rotation_ratio)*@bar_width/2 - indicator_width/2
        window.draw_rect indicator_left,
                         top - indicator_offset,
                         indicator_left + indicator_width,
                         bar_bottom + indicator_offset,
                         Gosu::Color::RED

        bar_bottom + indicator_offset
      end

      def draw_weapons top
        left  = @left + @margin_x
        right = @right - @margin_x
        @bar_height = @medium_font.height
        cooldown_height = 2
        text_margin = 5

        @small_font.draw_rel "Weapons", left + (right-left)/2, top, ZOrder::Text, 0.5, 1
        top += @small_font.height/2

        mech.weapons.each_with_index do |weapon, i|
          color = weapon.is_selected? ? @selected_color : @overlay_bg
          cooldown_ratio = if weapon.cooldown > 0
                              weapon.cooldown_left / weapon.cooldown
                           else
                             0
                           end

          window.draw_rect left,
                           top-3,
                           right,
                           top + @bar_height,
                           color

          window.draw_rect left,
                           top + @bar_height - cooldown_height,
                           left + @bar_width * cooldown_ratio,
                           top + @bar_height,
                           @cooldown_color

          @medium_font.draw "#{state.weapon_keys[i]}: #{weapon.name}",
                            left + text_margin,
                            top, ZOrder::Text

          @medium_font.draw_rel weapon.ammo_count,
                                right - text_margin,
                                top,
                                ZOrder::Text,
                                1,
                                0
          top += 1.5*@medium_font.height
        end
        top
      end

      def draw_mech top
        base_top = @height - @mech_height
        @ascii_art.each_with_index do |s,y|
          x = 0
          s.chars do |c|
            left   = @left + @margin_x + x*@char_width
            right  = left + @char_width
            top    = base_top + y*@char_height
            bottom = top + 1.5*@char_height

            window.draw_rect left, top, right, bottom, @overlay_bg unless c == " "

            color = get_color x+1,y+1
            @ascii_font.draw(c, left, top, 1, 1, 1.5, color)
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
        alpha = if ratio < 0.25
                  0.25 + 0.75*@blink_alpha
                else
                  1
                end
        Gosu::Color.from_ahsv(alpha*255, 120*ratio, 1, 1)
      end
    end
  end
end
