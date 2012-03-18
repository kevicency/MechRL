module MechRL
  module View
    class Sidebar < Base
      attr_reader :width, :height

      def initialize state
        super state
        @medium_font = Resources::Fonts[:label_m]
        @small_font  = Resources::Fonts[:label_s]
        @ascii_font  = Resources::Fonts[:ascii]
        @mech_data  = Mech::Data[mech.type]
        @ascii_art   = @mech_data.ascii_art

        @char_width  = @ascii_font.text_width("w")-1
        @char_height = @ascii_font.height-1

        @sidebar_bg  = Gosu::Color.new 0xFF303030
        @overlay_bg  = Gosu::Color.new 0xFF151515
        @selected_color = Gosu::Color.new 0xFF007F00
        @reload_color = Gosu::Color.new 0xFFFF7B00
        @heat_color = Gosu::Color.new 0xFFFF0000

        @blink_alpha = 0
        @blink_decreasing = false

        @margin_x    = @char_width*2
        @margin_y    = @char_height*1.5

        @width       = @margin_x*2 + (2 + @ascii_art.map(&:length).max)*@char_width
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

        top = @margin_y
        top = draw_weapons top
        top = draw_heat top
        top = draw_torso_rotation top

        draw_mech
      end

      def draw_bg
        window.draw_rect @left, 0, @right, @height, @sidebar_bg
      end

      def draw_torso_rotation top
        left             = @left + @margin_x
        right            = @right - @margin_x

        marker_width     = 4
        marker_offset_y  = 2
        indicator_width  = 2
        indicator_offset = 3

        #header
        @small_font.draw_rel "Torso Rotation", left + @bar_width/2, top, ZOrder::Text, 0.5, 1
        top += @small_font.height/3
        bar_bottom = top + @bar_height

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
                         @heat_color

        bar_bottom + @margin_y
      end

      def draw_weapons top
        left  = @left + @margin_x
        right = @right - @margin_x
        reload_height = 2
        text_margin = 5

        @small_font.draw_rel "Weapons", left + @bar_width/2, top, ZOrder::Text, 0.5, 1
        top += @small_font.height/3

        mech.weapons.each_with_index do |weapon, i|
          color = weapon.is_selected? ? @selected_color : @overlay_bg

          window.draw_rect left,
                           top-1,
                           right,
                           top + @bar_height-1,
                           color

          @medium_font.draw "#{state.weapon_keys[i]}: #{weapon.name}",
                            left + text_margin,
                            top, ZOrder::Text

          if weapon.has_ammo?
            mid = left + @bar_width/2
            reload_ratio = if weapon.is_reloading?
                             weapon.reloading_timer / weapon.reload_time
                           else
                             0
                           end

            window.draw_rect mid - @bar_width/2 * reload_ratio,
                             top + @bar_height - reload_height,
                             mid + @bar_width/2 * reload_ratio,
                             top + @bar_height,
                             @reload_color

            @medium_font.draw_rel weapon.ammo_count,
              right - text_margin,
              top,
              ZOrder::Text,
              1,
              0
          end
          top += 1.5*@bar_height
        end
        top - 0.5*@bar_height + @margin_y
      end

      def draw_heat top
        left = @left + @margin_x
        right = @right - @margin_x
        heat_ratio = mech.heat / mech.max_heat
        mid = left + @bar_width/2

        @small_font.draw_rel "Heat", left + @bar_width/2, top, ZOrder::Text, 0.5, 1
        top += @small_font.height/3

        window.draw_rect left,
                         top,
                         right,
                         top + @bar_height,
                         @overlay_bg
        window.draw_rect mid - @bar_width/2 * heat_ratio,
                         top + 1,
                         mid + @bar_width/2 * heat_ratio,
                         top + @bar_height - 1,
                         Gosu::Color.from_hsv(120*(1-heat_ratio), 1, 1)

        window.draw_rect left, top, right, top+2, @overlay_bg

        top + @bar_height + @margin_y
      end

      def draw_mech
        base_top = @height - @mech_height
        @ascii_art.each_with_index do |s,y|
          x = 0
          s.chars do |c|
            left   = @left + @margin_x + (x+2)*@char_width
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
          .select { |c| @mech_data.send "is_#{c}?", x, y}
          .first || :torso
        component = mech.send component_name
        ratio = (1 - component.damage_percentage)
        if ratio > 0.2
          Gosu::Color.from_hsv(120*ratio, 1, 1)
        elsif ratio > 0
          alpha = 0.25 + 0.75*@blink_alpha
          Gosu::Color.from_ahsv(alpha*255, 120*ratio, 1, 1)
        else
          Gosu::Color::BLACK
        end
      end
    end
  end
end
