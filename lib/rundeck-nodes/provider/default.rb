module RundeckNodes
  module Providers
    class DefaultProvider < Provider
      def setup
        connection
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
            'tags'       => instance.metadata.to_hash.values,
            'user_id'    => instance.user_id,
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

      def connection
        unless @connection
          provider_options = {}
          configuration.each_pair do |name,value|
            provider_options[name.to_sym] = value
          end
          @connection = ::Fog::Compute.new( provider_options )
        end
        @connection
      end
    end
  end
end
