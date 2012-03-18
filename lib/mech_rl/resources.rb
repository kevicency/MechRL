module MechRL
  module Resources

    class << (Fonts = Hash.new); end
    class << (Images = Hash.new); end

    class << self
          def load window
        @window = window

        root = File.dirname(__FILE__) + "/../.."

        Dir.glob(root + "/assets/ascii_art/*.rb").each do |file|
          require file.sub "txt", "rb"
        end

        Dir.glob(root + "/assets/images/*").each do |file|
          name = File.basename file, ".txt"
          image = Gosu::Image.new(window, file, true)
          Images[:name] = image
        end

        Fonts[:ascii] = Gosu::Font.new(window, "Impact", 14)
        Fonts[:log] = Gosu::Font.new(window, "Consolas", 16)
        Fonts[:label_s] = Gosu::Font.new(window, "Consolas", 12)
        Fonts[:label_m] = Gosu::Font.new(window, "Consolas", 15)
        Fonts[:menu_xl] = Gosu::Font.new(window, "Consolas", 24)
        Fonts[:menu_l] = Gosu::Font.new(window, "Consolas", 20)
        Fonts[:menu_m] = Gosu::Font.new(window, "Consolas", 16)
        nil
      end

    end
  end
end
