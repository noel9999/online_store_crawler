module CrawlerExecution
  class RtMartStrategy < BaseStrategy    
    def extract_data
      # cause Wombat use clean room skill so that 
      # I have to do these ugly things 
      # to pass our own variable or method into it
      klass = Class.new do
        class << self
          def url=(url)
            @url = url
          end

          def url
            @url
          end
        end
      end    
      klass.url = url
      klass.class_eval do
        include Wombat::Crawler
        base_url "#{url.scheme}://#{url.host}"
        path url.request_uri    

        products({ css: '.classify_centerBox .classify_prolistBox ul li .indexProList' }, :iterator) do
          image_thumb_url({css: ' .for_imgbox a' }, :html) do |value|
            html_doc = Nokogiri::HTML(value)
            html_doc.css('img')[0]['src']
          end
          url({css: 'h5.for_proname'}, :html) do |value|
            html_doc = Nokogiri::HTML(value)
            html_doc.css('a')[0]['href']
          end
          title(css: 'h5.for_proname a')
          price({css: '.for_pricebox div'})
        end  
      end
      klass.new.crawl
    end
  end
end