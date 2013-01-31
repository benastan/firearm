require 'firearm/plugin'
require 'jekyll'
require 'jekyll-haml'
require 'jekyll-assets'
require 'jekyll-assets/compass'

module Firearm
  class Project < Jekyll::Site

    DEFAULTS = {
      'source' => Dir.pwd,
      'destination' => File.expand_path("./src"),
      'assets' => {
        'baseurl' => '',
        'js_prefix' => 'js',
        'css_prefix' => 'css'
      }
    }

    FIREARM_ROOT = File.expand_path('../../', File.dirname(__FILE__))

    PLUGINS_DIR = File.expand_path('lib/firearm/plugins', FIREARM_ROOT)

    PROJECTS_PATH = File.expand_path('.projects', FIREARM_ROOT)
    Dir.mkdir(PROJECTS_PATH) unless File.exists?(PROJECTS_PATH)

    def initialize options = {}
      options = Jekyll.configuration(DEFAULTS.merge(options))
      options['source'] = File.expand_path('./app')
      options['plugins'] = [options['plugins']] unless options['plugins'].is_a? Array
      options['plugins'] << PLUGINS_DIR
      result = super options
      backup 'config.json'
      backup 'identity.json'
      result
    end

    def setup
      Firearm::Plugin.subclasses.each do |plugin|
        plugin.asset_paths.each do |path|
          self.assets.append_path path
        end
      end
      super
    end

    def process
      setup
      result = super
      restore 'config.json'
      restore 'identity.json'
      result
    end

    def copy_assets type, ext
      assets_dest = File.expand_path(type, dest)
      Dir.mkdir(assets_dest) unless File.exists?(assets_dest)
      `cp #{dest}/assets/*.#{ext} #{assets_dest}`
    end

    def forge_build platform
      `cd #{Dir.pwd} && forge build #{platform}`
    end

    def forge_run platform
      `cd #{Dir.pwd} && forge run #{platform}`
    end

    private

    def project_dir
      @project_dir_path ||= File.expand_path("#{FIREARM_ROOT}/.projects/#{source.gsub('/', '-')}")
      Dir.mkdir(@project_dir_path) unless File.exists? @project_dir_path
      @project_dir_path
    end

    def config_file_path file_name
      File.expand_path(file_name, dest)
    end

    def backup file_name
      `cp #{config_file_path file_name} #{project_dir}`
    end

    def restore file_name
      `cp #{project_dir}/#{file_name} #{config_file_path file_name}`
    end
  end
end
