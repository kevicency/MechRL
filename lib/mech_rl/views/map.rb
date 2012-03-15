module MechRL
  module View
    class Map < Base
      def initialize state
        super state
        @mech_img = Gosu::Image.new(window, "./assets/images/@.png", true)
        @view_img = Gosu::Image.new(window, "./assets/images/@view.png", true)
      end

      def draw
        mech =  game.player.mech
        @mech_img.draw_rot mech.location[:x],
                           mech.location[:y],
                           1,
                           mech.rotation

        @view_img.draw_rot mech.location[:x],
                           mech.location[:y],
                           1,
                           mech.rotation + mech.torso.rotation
      end

      def player
      end
    end
  end
end
