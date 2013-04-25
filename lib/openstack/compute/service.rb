module OpenStack
    module Compute
        class Service

            attr_accessor :services   

            def initialize(id,compute)
                @id = id
                @compute = compute
                populate
           end
            
            def populate
                path = "/os-services/#{URI.escape(self.id.to_s)}"
                response = @compute.connection.req("GET", path)
                OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
                data = JSON.parse(response.body)['services']
                @services = data['services']
                return true
            end
            
            alias :refresh :populate

            def status(host,service)
                populate
                @services.select { |service| service['host'] == host and service['binary'] == service }.first['status']
            end

            def disable!(host,service)
                path="/os-services/#{URI.escape(self.id.to_s)}/disable"
                request = JSON.generate(:host=>host,:binary=>service)
                OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
                populate
            end

            def enable!(host)
                path="/os-services/#{URI.escape(self.id.to_s)}/enable"
                request = JSON.generate(:host=>host,:binary=>service)
                OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
                populate
            end


        end

    end
end
