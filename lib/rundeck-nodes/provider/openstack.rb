#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-13 16:56:51 +0100 (Wed, 13 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
module RundeckNodes
  module Providers
    class Openstack < Provider
      def setup
        validate_configuration
      end

      def list
        nodes = []
        servers.each do |instance|
          debug "list: instance name: #{instance.name}, id: #{instance.id}"
          node = {
            'id'         => instance.id,
            'hostname'   => instance.name,
            'state'      => instance.state,
            'created'    => instance.created,
            'tags'       => [],
            'tenant_id'  => instance.tenant_id,
            'user_id'    => instance.user_id,
            'key_name'   => instance.key_name
          }
          unless options[:no_details]
            node['flavor_id'] = instance.flavor['id']
            node['image_id']  = instance.image['id']
            node['flavor']    = flavor_name( instance.flavor['id'] ) || 'deleted'
            node['image']     = image_name( instance.image['id'] ) || 'deleted'
          end
          nodes << node
        end
        nodes
      end

      private
      def servers
        openstack.servers || []
      end

      def openstack
        @openstack ||= ::Fog::Compute.new( :provider => :OpenStack,
          :openstack_auth_url => configuration['openstack_auth_url'],
          :openstack_api_key  => configuration['openstack_api_key'],
          :openstack_username => configuration['openstack_username'],
          :openstack_tenant   => configuration['openstack_tenant']
        )
      end
      alias_method :connection, :openstack
    end
  end
end
