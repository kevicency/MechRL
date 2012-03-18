module MechRL
  module View
    class ConfigureMech < Base
      def initialize state
        super state

        @title_font = Resources::Fonts[:menu_xl]
        @component_font = Resources::Fonts[:menu_l]
        @addon_font = Resources::Fonts[:menu_m]
        @stats_font = Resources::Fonts[:menu_m]

        @active_color = Gosu::Color::WHITE
        @deactive_color = Gosu::Color::GRAY
        @selected_color = Gosu::Color.new 0xFF007F00

        @addon_margin = @screen_margin
      end

      def draw
        top = @screen_margin
        left = @screen_margin

        @title_font.draw "Configure your Mech", left, top, ZOrder::Text
        top += 3*@title_font.height
        top = draw_components top, left
        top = draw_stats top, left
      end

      private

      def draw_components top, left
        state.component_mappings.each do |key, mapping|
          color = get_component_color mapping
          component = mapping[:component]
          armor_part = "Armor: #{component.armor}/#{component.max_armor}"
          @component_font.draw "#{key}. #{component_name mapping[:symbol]} (#{armor_part})",
            left, top, ZOrder::Text,
            1, 1, color
          top += @component_font.height

          left += @addon_margin
          top = draw_addons mapping, top, left
          left -= @addon_margin

          top += @component_font.height
        end
        top
      end

      def draw_inventory addon_mapping
        top = @screen_margin
        left = Window::ScreenWidth/2 + @screen_margin
        return unless addon_mapping[:selected]
        @title_font.draw "Inventory", left, top, ZOrder::Text
        top += 3*@title_font.height

        items = state.inventory_items addon_mapping[:restrictions]
        items.each do |key, item|
          @component_font.draw "#{key}. #{item.name}",
                               left, top, ZOrder::Text
          top += @component_font.height
        end
      end

      def draw_addons component_mapping, top, left
        mappings = state.addon_mappings component_mapping[:component]
        mappings.each do |key, mapping|
          color = get_addon_color component_mapping, mapping
          addon = mapping[:addon]
          addon_name = if addon.nil?
                         "#{key}. unused"
                       else
                         "#{key}. #{addon.name}"
                       end
          addon_restrictions = prettify_restrictions mapping[:restrictions]
          @addon_font.draw "#{addon_name} (#{addon_restrictions})",
            left, top, ZOrder::Text,
            1, 1, color
          top += @addon_font.height

          draw_inventory mapping
        end

        top
      end

      def draw_stats top, left
        status = [
          "Weight: %.2f / %.2f" % [mech.weight, mech.max_weight],
          "Engine Power: %.2f" % mech.torso.engine.power,
          "Max velocity: %2f" % mech.max_velocity,
          "Max acceleration: %.2f" % mech.max_acceleration,
          "Max torso rotation: %.2f" % mech.torso.max_rotation,
        ]
        status.each_with_index do |s,i|
          @stats_font.draw s,
                           left,
                           top,
                           1
          top += @stats_font.height
        end
        top
      end

      def component_name component
        component.to_s.capitalize.gsub(/_\w/){|m| " " + m[1].upcase}
      end

      def prettify_class klass
        klass.to_s.split("::").last.gsub(/[A-Z]/) do |m|
          " " + m
        end.strip
      end

      def prettify_restrictions restrictions
        (restrictions || []).map do |r|
          prettify_class r
        end.join ", "
      end

      def get_component_color mapping
        return @active_color if state.selection_state == :component
        return @selected_color if mapping[:selected]
        @deactive_color
      end

      def get_addon_color component_mapping, addon_mapping
        return @active_color if state.selection_state == :addon && component_mapping[:selected]
        return @selected_color if addon_mapping[:selected]
        @deactive_color
      end
    end
  end
end
