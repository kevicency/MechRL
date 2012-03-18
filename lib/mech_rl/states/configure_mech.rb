module MechRL
  module State
    class ConfigureMech < Base
      attr_reader :selection_state

      SELECTION_STATES = [
        :component,
        :addon,
        :inventory
      ]

      def initialize
        super

        @addon_mappings = {}
        @selection_state = SELECTION_STATES[0]
        @selections = []

        Constants::Alphabet.each do |c|
          add_command (Gosu.const_get "Kb#{c.upcase}") do
            advance_selection c
          end
        end

        add_command Gosu::KbEscape do
          cancel_last_selection
        end

        add_command Gosu::KbSpace do
          game.transition_to State::Ingame.new
        end

        add_command Gosu::KbUp do
          increase_armor
        end

        add_command Gosu::KbDown do
          decrease_armor
        end

        add_command Gosu::KbDelete, Gosu::KbEnter do
          remove_addon
        end
      end

      def remove_addon
        return unless @selection_state == :inventory

        addon = @last_selection[:addon]
        @last_selection[:slot][:addon] = nil
        inventory.items << addon
        @addon_mappings = {}
        clear_selections
      end

      def increase_armor
        return unless @selection_state == :addon

        component = @last_selection[:component]
        if (component.armor < component.max_armor)
          component.armor += 1
        end
      end

      def decrease_armor
        return unless @selection_state == :addon

        component = @last_selection[:component]
        if (component.armor > component.max_armor/2)
          component.armor -= 1
        end
      end

      def component_mappings
        if @component_mappings.nil?
          @component_mappings = {}

          Mech::COMPONENTS.each_with_index do |c,i|
            component = mech.send c

            @component_mappings[Constants::Alphabet[i]] = {
              symbol: c,
              component: component,
              selected: false
            }
          end
        end
        @component_mappings
      end

      def addon_mappings component
        if @addon_mappings[component].nil?
          @addon_mappings[component] = {}
          component.addon_slots.each_with_index do |slot, i|
            addon = slot[:addon]

            @addon_mappings[component][Constants::Alphabet[i]] = {
              addon: addon,
              restrictions: slot[:restrictions],
              slot: slot,
              selected: false
            }
          end
        end
        @addon_mappings[component]
      end

      def inventory_items restrictions
        items = []
        restrictions.each do |r|
          inventory.items.each do |item|
            items << item if item.is_a? r
          end
        end
        i = 0
        x = {}
        items.map do |item|
          x[Constants::Alphabet[i]] = item
          i+=1
        end
        x
      end

      def advance_selection key
        case @selection_state
        when :component
          return if component_mappings[key].nil?
          @last_selection = component_mappings[key]
          @selection_state = :addon
          @last_selection[:selected] = true
          @selections << @last_selection
        when :addon
          component = @last_selection[:component]
          return if (addon_mappings component)[key].nil?
          @last_selection = (addon_mappings component)[key]
          @selection_state = :inventory
          @last_selection[:selected] = true
          @selections << @last_selection
        else
          items = inventory_items @last_selection[:restrictions]
          return if items[key].nil?
          item = items[key]
          item.attach_to mech
          removed = @last_selection[:addon]
          removed.attach_to nil unless removed.nil?
          inventory.items << removed unless removed.nil?
          inventory.items.delete item
          @last_selection[:slot][:addon] = item
          @addon_mappings = {}
          clear_selections
        end
        @last_selection[:selected] = true
        @selections << @last_selection
      end

      def cancel_last_selection
        return if @selection_state == :component

        @last_selection[:selected] = false
        @selections.delete @last_selection

        @selection_state = case
                           when :addon
                             :component
                           else
                             :addon
                           end
      end

      def clear_selections
        @selections.each {|s| s[:selected] = false }
        @selection_state = :component
      end
    end
  end
end
