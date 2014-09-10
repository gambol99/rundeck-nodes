#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-13 16:55:16 +0100 (Wed, 13 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
require 'fog'

module RundeckNodes
  module Providers
    class Provider
      include RundeckNodes::Logging

      def initialize instance_id, plugin_options, plugin_configuration = {}
        @options       = plugin_options
        @configuration = plugin_configuration
        @id = instance_id
      end

      def list
        nodes = []
        servers.each do |instance|
          debug "retrieve_nodes: instance name: #{instance['name']}, id: #{instance['id']}"
          node = {
            'id'        => instance['id'],
            'hostname'  => instance['name'],
            'state'     => instance['status'],
            'created'   => instance['created'],
            'tenant_id' => instance['tenant_id'],
            'tags'      => [],
            'user_id'   => instance['user_id'],
            'key_name'   => instance['key_name']
          }
          unless options[:no_details]
            node['flavor_id'] = instance['flavor']['id']
            node['image_id']  = instance['image']['id']
            node['flavor']    = flavor_name( instance['flavor']['id'] ) || 'deleted'
            node['image']     = image_name( instance['image']['id'] ) || 'deleted'
          end
          nodes << node
        end
        nodes
      end

      def flavor_name id
        @flavors ||= connection.flavors
        @flavors.each do |x|
          return x.name if x.id == id or x.name == id
        end
        nil
      end

      def image_name id
        @images  ||= connection.images
        @images.each do |x|
          return x.name if x.id == id or x.name == id
        end
        nil
      end

      def configuration; @configuration ||= {}; end
      def options; @options ||= {}; end
    end
  end
end
