require '../lib/openstack'

USERNAME = 'admin'
API_KEY = 'nova'
TENANT = 'admin'
API_URL = 'http://172.16.0.23:5000/v2.0/'

os = OpenStack::Connection.create(:username => USERNAME, :api_key => API_KEY, :authtenant => TENANT, :auth_url => API_URL, :service_type => "compute")

#puts os

#puts os.list_services
service = os.get_service('fuel-compute-01','nova-compute')
puts service.status
service.disable!
puts service.status
