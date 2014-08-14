#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-08-14 10:26:07 +0100 (Thu, 14 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
require 'provider/provider'

module RundeckNodes
  module Providers
    require 'provider/default'
    require 'provider/openstack'
    require 'provider/rackspace'

    def provider? name
      provider_classes.include? name.to_sym
    end

    def providers
      provider_classes
    end

    def provider id, name, configuration = {}
      pluginName = "RundeckNodes::Providers::#{name}"
      raise ArgumentError, "the provider class: #{pluginName} does not exists" unless provider? name
      debug "provider: classes in module: " << RundeckNodes::Providers.constants.join(', ')
      plugin = RundeckNodes::Providers.const_get( pluginName ).new( id, options, configuration )
      plugin.setup if plugin.respond_to? :setup
      plugin
    end

    private
    def provider_classes
      RundeckNodes::Providers.constants.select do |x|
        Class === RundeckNodes::Providers.const_get( x )
      end
    end
  end
end
