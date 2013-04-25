module OpenStack
    module Compute
        class Service

            attr_reader :status
            attr_reader :zone
            attr_reader :updated_at
            attr_reader :state
            attr_reader :host
            attr_reader :service

            def initialize(compute,host,service)
                @host = host
                @service = service
                @compute = compute
                populate
           end
            
            def populate
                path = "/os-services"
                response = @compute.connection.req("GET", path)
                OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
                data = JSON.parse(response.body)['services'] 
                @host_service = data.select {|data| data['host'] = @host and data['binary'] == @service }.first
                @status = @host_service['status']
                @zone = @host_service['zone']
                @state = @host_service['state']
                @updated_at = @host_service['updated_at']
                return true
            end
            
            alias :refresh :populate

            def disable!
                path="/os-services/disable"
                request = JSON.generate(:host=>@host,:binary=>@service)
                puts request
                response = @compute.connection.req("PUT", path, :data => request)
                puts response.code
                OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
                populate
            end

            def enable!
                path="/os-services/enable"
                request = JSON.generate(:host=>@host,:binary=>@service)
                response = @compute.connection.req("PUT", path, :data => request)
                OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
                populate
            end


        end

    end
end
