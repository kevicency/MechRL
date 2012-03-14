module MechRL
  module Resources


    class << self
      def ascii_art
        @ascii_art ||= {}
      end

      def ascii_meta
        @ascii_mets ||= {}
      end

      def fonts
        @fonts ||= {}
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

        fonts[:ascii] = Gosu::Font.new(window, "Impact", 14)
        fonts[:log] = Gosu::Font.new(window, "Consolas", 16)

        nil
      end

    end
  end
end
