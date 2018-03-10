module CrawlerExecution
  class WellcomeStrategy < BaseStrategy
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
        page_domain = "#{url.scheme}://#{url.host}"
        base_url page_domain
        path url.request_uri    
        products({ css: '.category-item-container .row .item-col' }, :iterator) do
          image_thumb_url({css: '.item-image-wrapper figure.item-image-container' }, :html) do |value|
            html_doc = Nokogiri::HTML(value)
            page_domain + html_doc.css('a > img')[0]['src']
          end
          url({css: '.item-image-wrapper figure.item-image-container' }, :html) do |value|
            html_doc = Nokogiri::HTML(value)
            page_domain + html_doc.css('a')[0]['href']
          end
          title({css: '.item-meta-container .item-name'})
          price(css: '.item-meta-container .item-price-container.inline')
        end  
      end
      klass.new.crawl
    end
  end
end