#
#   Author: Rohith
#   Date: 2014-05-22 11:07:10 +0100 (Thu, 22 May 2014)
#
#  vim:ts=2:sw=2:et
#
$:.unshift File.join(File.dirname(__FILE__),'.','./')
require 'misc/logging'
require 'misc/utils'
require 'misc/configuration'
require 'render'
require 'providers'
require 'pp'

module RundeckNodes
  class Nodes
    include RundeckNodes::Logging
    include RundeckNodes::Utils
    include RundeckNodes::Configuration
    include RundeckNodes::Providers
    include RundeckNodes::Render

    def initialize configuration
      # step: validate the configuration file
      @settings = load_configuration( options( configuration ) )
    end

    def list filter = {}
      begin
        # step: iterate the clouds (filtering)
        clouds filter[:clouds] do |name,config|
          debug "list: cloud: #{name}, provider: #{config['provider']}"
          # step: find a provider for this cloud
          plugin = provider name, config['provider'], config
          # step: get me a list of the nodes
          debug "list: provider: #{name}, pulling the hosts from this provider"
          render plugin.list
        end
      rescue Exception => e
        puts 'classify: we have encountered an error: %s' % [ e.message ]
        raise Exception, e.message
      end
    end

    private
    def clouds filter = nil, &block
      filter = '.*' unless filter
      settings['clouds'].each_pair do |name,cfg|
        next unless name =~ /#{filter}/
        yield name,cfg if block_given?
      end
    end

    def apply_node_tags node
      if settings['tags']
        settings['tags'].keys.each do |regex|
          next unless node['hostname'] =~ /#{regex}/
          ( node['tags'] || [] ) << settings['tags'][regex]
        end
      end
    end
  end
end

