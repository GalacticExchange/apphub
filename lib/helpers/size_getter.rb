module Helpers
  class SizeGetter

    def self.get_size(url)
      begin
        puts url
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host)
        url_path = '/'+url.split('/')[3..-1].join('/')
        resp = http.request_head(URI.escape(url_path))
        size = resp['content-length'].to_d
        size = size/1024
        size = size/1024
        size.truncate(2)
      rescue Exception => exc
        puts exc.message
        puts exc.backtrace.inspect
        0
      end
    end

  end
end