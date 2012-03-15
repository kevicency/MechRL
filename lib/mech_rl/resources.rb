module MechRL
  module Resources

    class << (Fonts = Hash.new)

    end

    class << self
      def ascii_art
        @ascii_art ||= {}
      end

      def ascii_meta
        @ascii_mets ||= {}
      end

      def images
        @images ||= {}
      end

      def load window
        @window = window

        root = File.dirname(__FILE__) + "/../.."

        Dir.glob(root + "/assets/ascii_art/*.txt").each do |file|
          name = (File.basename file, ".txt").to_sym
          content = File.read(file).split "\n"
          ascii_art[name] = content
          begin
            require file.sub "txt", "rb"
            ascii_meta[name] = AsciiMeta.send name
          rescue
          end
        end

        Dir.glob(root + "/assets/images/*").each do |file|
          name = File.basename file, ".txt"
          image = Gosu::Image.new(window, file, true)
          images[name.to_sym] = image
        end

        Fonts[:ascii] = Gosu::Font.new(window, "Impact", 14)
        Fonts[:log] = Gosu::Font.new(window, "Consolas", 16)
        Fonts[:label_s] = Gosu::Font.new(window, "Consolas", 12)
        Fonts[:label_m] = Gosu::Font.new(window, "Consolas", 15)

        nil
      end

    end
  end
end
