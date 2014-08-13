#
#   Author: Rohith
#   Date: 2014-05-22 11:07:10 +0100 (Thu, 22 May 2014)
#
#  vim:ts=2:sw=2:et
#
$:.unshift File.join(File.dirname(__FILE__),'.','./')

require 'erb'
require 'config'
require 'utils'
require 'logging'

module RundeckNodes
  class Nodes
    include RundeckNodes::Utils
    include RundeckNodes::Logging

    attr_reader :options

    def initialize options
      # step: validate the configuration file
      @options = options
      @nodes   = []
    end

    def classify filter = {}
      begin
        # step: check if the configuration has changed and if so reload it
        settings.reload if settings.changed?
        # step: specify the defaults
        filter['cluster'] ||= '.*'
        filter['hostname'] ||= '.*'
        # step: iterate and pull the nodes
        @nodes = []
        settings['openstack'].each do |os|
          # step: are we filtering our certain openstack clusters
          next unless os['name'] =~ /#{filter['cluster']}/
          # step: classifiy the nodes
          retrieve_nodes( os ).each do |node|
            # step: filter out anything we don't care about
            next unless node['hostname'] =~ /#{filter['hostname']}/
            @nodes << node
          end
        end
        # step: if requested, lets template the output
        ERB.new( settings['erb'], nil, '-' ).result( binding )
      rescue Exception => e
        puts 'classify: we have encountered an error: %s' % [ e.message ]
        raise Exception, e.message
      end
    end

    private
    def openstack_connection credentials
      debug 'openstack_connection: attemping to connect to openstack: %s' % [ credentials['auth_url'] ]
      connection = ::Fog::Compute.new( :provider => :OpenStack,
        :openstack_auth_url   => credentials['auth_url'],
        :openstack_api_key    => credentials['api_key'],
        :openstack_username   => credentials['username'],
        :openstack_tenant     => credentials['tenant']
      )
      debug 'successfully connected to openstack, username: ' << credentials['username'] << ' auth: ' << credentials['auth_url']
      connection
    end

    def retrieve_nodes credentials
      debug 'retrieve_nodes: retrieving a list of the nodes from openstack: ' << credentials['auth_url']
      # step: get a connection to openstack
      connection = openstack_connection( credentials )
      # step: retrieve the nodes

    end

    def apply_node_tags node
      if settings['tags']
        settings['tags'].keys.each do |regex|
          next unless node['hostname'] =~ /#{regex}/
          ( node['tags'] || [] ) << settings['tags'][regex]
        end
      end
    end

    def settings options = @options
      @config ||= RunDeckOpenstack::Config::new options[:config], options
    end

    def options
      @options ||= default_options
    end

    def default_options
      {
        :config => "#{ENV['HOME']}/openstack.yaml"
      }
    end
  end
end

