require 'jekyll'

module Firearm
  class Project < Jekyll::Site

    DEFAULTS = {
      'source' => Dir.pwd,
      'destination' => File.expand_path("./src")
    }

    FIREARM_ROOT = "#{File.expand_path(File.dirname(__FILE__))}/../.."

    PLUGINS_DIR = "#{FIREARM_ROOT}/vendor/jekyll/plugins"

    def initialize options = {}
      options = Jekyll.configuration(DEFAULTS.merge(options))
      options['source'] = File.expand_path('./app')
      options['plugins'] = [options['plugins']] unless options['plugins'].is_a? Array
      options['plugins'] << PLUGINS_DIR
      super options
    end

    def process
      backup 'config.json'
      backup 'identity.json'
      result = super
      restore 'config.json'
      restore 'identity.json'
      result
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
      unless File.exists? @project_dir_path
        Dir.mkdir(@project_dir_path)
      end
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
