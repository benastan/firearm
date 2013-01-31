module Jekyll
  module AssetsPlugin
    class Renderer
      def render_asset_path type
        unless @site.static_files.include? asset
          @site.static_files << AssetFile.new(@site, asset)
        end

        if type
          if @site.assets_config.respond_to?(prefix_key = "#{type}_prefix")
            prefix = @site.assets_config.send(prefix_key)
          end
        end

        path = []
        [ @site.assets_config.baseurl, prefix ].each do |segment|
          path << segment unless segment.nil? || segment == ''
        end
        path << asset.digest_path

        return path.join '/'
      end

      def render_javascript
        @path << '.js' if File.extname(@path).empty?

        JAVASCRIPT % render_asset_path(:js)
      end

      def render_stylesheet
        @path << '.css' if File.extname(@path).empty?

        STYLESHEET % render_asset_path(:css)
      end
    end

    class AssetFile
      def destination dest
        type = File.extname(@asset.digest_path)[1..-1]
        if @site.assets_config.respond_to?(prefix_key = "#{type}_prefix")
          prefix = @site.assets_config.send(prefix_key)
        end

        path = []
        [ @site.assets_config.baseurl, prefix ].each do |segment|
          path << segment unless segment.nil? || segment == ''
        end

        File.join(dest, path, @asset.digest_path)
      end
    end
  end
end
