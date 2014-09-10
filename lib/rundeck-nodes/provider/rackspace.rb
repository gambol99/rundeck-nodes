#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-14 10:26:56 +0100 (Thu, 14 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
module RundeckNodes
  module Providers
    class Rackspace < Provider
      private
      def servers
        ( rackspace.list_servers.body || {} )['servers'] || []
      end

      def rackspace
        @rackspace ||= ::Fog::Compute.new( :provider => :Rackspace,
          :rackspace_username => configuration['rackspace_username'],
          :rackspace_api_key  => configuration['rackspace_api_key'],
          :rackspace_region   => configuration['rackspace_region'],
        )
      end
      alias_method :connection, :rackspace
    end
  end
end
