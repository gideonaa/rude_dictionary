## Dictionary API Caller
require "net/http"
require "uri"
require "open-uri"


class ApiCaller
    
    # Use Net::HTTP to do GET Requests
    def http_get(api_query, api_key)
        
        # make sure the string is encoded as a URL
        uri = URI(api_query)
        
        # create a net/http GET object with basic_auth
        begin
        req = Net::HTTP::Get.new(uri)
        req.add_field 'X-Mashape-Key', api_key
        
        # use https to make the request
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
            http.request(req)
        }

        # rescue any errors and return error message
        rescue StandardError, Timeout::Error => e
            err_msg = Hash.new
            puts e.message
            err_msg["error"] = e.message  + e.backtrace.inspect #for more details
            return err_msg
        end

        data =  res.body

        # if no exceptions/errors rescued, return results
        return data
    end
    
    
end

### USAGE EXAMPLE ###

#connectAPI = ApiCaller.new
#puts connectAPI.http_get('http://www.dictionaryapi.com/api/v1/references/collegiate/xml/beguile?&key=ab920a47-caa9-42ad-874d-cf68679d407b')

