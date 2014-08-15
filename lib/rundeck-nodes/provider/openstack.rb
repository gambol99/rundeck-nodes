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
        openstack
      end

      def list
        nodes = []
        openstack.servers.each do |instance|
          debug "list: instance name: #{instance.name}, id: #{instance.id}"
          node = {
            'id'         => instance.id,
            'hostname'   => instance.name,
            'state'      => instance.state,
            'key_name'   => instance.key_name,
            'created'    => instance.created,
            'tags'       => [],
            'tenant_id'  => instance.tenant_id,
            'user_id'    => instance.user_id,
            'hypervisor' => instance.os_ext_srv_attr_host,
            'flavor_id'  => instance.flavor['id'],
            'image_id'   => instance.image['id'],
            'flavor'     => flavor_name( instance.flavor['id'] ) || 'flavor deleted',
            'image'      => image_name( instance.image['id'] ) || 'image deleted'
          }
          nodes << node
        end
        nodes
      end

      private
      def flavor_name id
        @flavors ||= openstack.flavors
        @flavors.each do |x|
          return x.name if x.id == id or x.name == id
        end
        nil
      end

      def image_name id
        @images  ||= openstack.images
        @images.each do |x|
          return x.name if x.id == id or x.name == id
        end
        nil
      end

      def openstack
        @openstack ||= ::Fog::Compute.new( :provider => :OpenStack,
          :openstack_auth_url => configuration['openstack_auth_url'],
          :openstack_api_key  => configuration['openstack_api_key'],
          :openstack_username => configuration['openstack_username'],
          :openstack_tenant   => configuration['openstack_tenant']
        )
      end

      def validate_configuration
        debug "validate_configuration: #{configuration}"
        %w(openstack_auth_url openstack_api_key openstack_username openstack_tenant).each do |x|
          unless configuration.has_key? x
            raise ArgumentError, 'the credentials are incomplete, you must have the %s field for %s' % [ x, configuration['name'] ]
          end
        end
      end
    end
  end
end
