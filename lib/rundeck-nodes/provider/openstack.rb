#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-13 16:56:51 +0100 (Wed, 13 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
class OpenstackProvider < Provider

  attr_reader :instance_id

  def initialize instance_name, configuration
    @instance_id   = instance_name
    @configuration = validate_configuration configuration
  end

  def list
    nodes = []
    openstack.servers.each do |instance|
      debug "retrieve_nodes: instance name: #{instance.name}, id: #{instance.id}"
      node = {
        'cluster'    => credentials['name'],
        'id'         => instance.id,
        'hostname'   => instance.name,
        'state'      => instance.state,
        'key_name'   => instance.key_name,
        'created'    => instance.created,
        'tags'       => instance.metadata.to_hash.values,
        'image_id'   => instance.image['id'],
        'tenant_id'  => instance.tenant_id,
        'user_id'    => instance.user_id,
        'hypervisor' => instance.os_ext_srv_attr_host,
        'flavor_id'  => instance.flavor['id'],
      }
      # step: lets add any tags from the config
      apply_node_tags node
      # step: find the image
      node['image'] = cached instance.image['id'] do
        get_image( instance.image['id'], connection ) || 'image_deleted'
      end
      node['tenant'] = cached instance.tenant_id do
        get_tenant( instance.tenant_id, connection ) || 'tenant_deleted'
      end
      nodes << node
    end
    nodes

  end

  def server instance_name


  end

  private
  def name; 'openstack'; end

  def get_image id, connection
    images = openstack.images.select { |x| x.id == id }
    return ( !images.empty? ) ? images.first.name : nil
  end

  def get_tenant id, connection
    tenants = openstack.tenants.select { |x| x if x.id == id }
    return ( !tenants.empty? ) ? tenants.first.name : nil
  end

  def openstack
    @openstack ||= ::Fog::Compute.new( :provider => :OpenStack,
      :openstack_auth_url => configuration['auth_url'],
      :openstack_api_key  => configuration['api_key'],
      :openstack_username => configuration['username'],
      :openstack_tenant   => configuration['tenant']
    )
  end

  def validate_configuration configuration
    %w(username tenant api_key auth_url).each do |x|
      unless configuration.has_key? x
        raise ArgumentError, 'the credentials are incomplete, you must have the %s field for %s' % [ x, configuration['name'] ]
      end
    end
  end
end
