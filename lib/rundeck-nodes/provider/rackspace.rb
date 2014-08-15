#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-14 10:26:56 +0100 (Thu, 14 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
module RundeckNodes
  module Providers
    class Rackspace < Provider
      def list
        nodes = []
        rackspace.servers.each do |instance|
          debug "retrieve_nodes: instance name: #{instance.name}, id: #{instance.id}"
          node = {
            'id'        => instance.id,
            'hostname'  => instance.name,
            'state'     => instance.state,
            'key_name'  => instance.key_name,
            'created'   => instance.created,
            'tags'      => [],
            'user_id'   => instance.user_id,
            'flavor_id' => instance.flavor_id,
            'image_id'  => instance.image_id,
            'flavor'    => flavor_name( instance.flavor_id ) || 'deleted',
            'image'     => image_name( instance.image_id ) || 'deleted'
          }
          # step: find the image
          nodes << node
        end
        nodes
      end

      private
      def rackspace
        @rackspace ||= ::Fog::Compute.new( :provider => :Rackspace,
          :rackspace_username => configuration['rackspace_username'],
          :rackspace_api_key  => configuration['rackspace_api_key'],
          :rackspace_region   => configuration['rackspace_region'],
        )
      end

      def flavor_name id
        @flavors ||= rackspace.flavors
        @flavors.each do |x|
          return x.name if x.id == id or x.name == id
        end
        nil
      end

      def image_name id
        @images  ||= rackspace.images
        @images.each do |x|
          return x.name if x.id == id or x.name == id
        end
        nil
      end
    end
  end
end
