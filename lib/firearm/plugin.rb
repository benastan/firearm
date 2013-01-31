require 'bundler/cli'

module Firearm
  class Plugin
    def self.inherited base
      subclasses << base
      subclasses.sort!
    end

    def self.subclasses
      @subclasses ||= []
    end

    def self.path
      @path ||= File.expand_path('vendor/assets', Bundler::CLI.new.send(:locate_gem, @gem))
    end

    def self.asset_paths
      %w(javascripts stylesheets images).collect do |dir|
        File.expand_path(dir, path)
      end
    end
  end
end
