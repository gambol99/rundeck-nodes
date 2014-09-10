#
#   Author: Rohith
#   Date: 2014-05-22 12:16:53 +0100 (Thu, 22 May 2014)
#
#  vim:ts=4:sw=4:et
#
require 'yaml'

module RundeckNodes
  module Configuration
    Default_Template = <<-EOF
---
<% @nodes.each do |node| %>
<%= node['hostname'] %>:
  hostname: <%= node['hostname'] %>
  nodename: <%= node['hostname'].split('.').first %>
  tags: '<%= node['tags'].join(', ') %>'
  username: rundeck
  <% node.each_pair do |k,v| -%>
<%- next if k =~ /^(hostname|tags)$/ or v.nil? -%>
<%= k %>: <%= v %>
  <% end -%>
<% end -%>
EOF

    def settings
      @settings ||= {}
    end

    def options initial_configutation = nil
      @options ||= initial_configutation || default_options
    end

    def default_options
      {
        :config => "#{ENV['HOME']}/openstack.yaml",
        :debug  => false,
        :color  => false
      }
    end

    private
    def load_configuration options = {}
      # step: check the configuration file exists
      validate_file options[:config]
      # step: read in the configution file
      config = YAML.load(File.read(options[:config]))
      # step: check we have everything we need
      raise ArgumentError, 'the configuration does not contain the clouds config' unless config['clouds']
      raise ArgumentError, 'the clouds field should be an hash'                   unless config['clouds'].is_a? Hash
      # step: we have to make sure we have 0.{username,api_key,auth_uri}
      config['clouds'].each_pair do |name,cfg|
        raise ArgumentError, "the config for: #{name} does not include a provider" unless cfg['provider']
      end
      # step: lets validate templates or inject the default one
      config[:erb] = config['template'] || Default_Template
      config
    end
  end
end
