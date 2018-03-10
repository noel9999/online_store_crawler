class WellcomeExecuteCrawlerService
  include Concerns::ActsAsServiceObject

  def initialize(args = {})
    args = args.symbolize_keys
    @store, @tag, @url = args.values_at :store, :tag, :url
    fail ActiveRecord::RecordNotFound unless @store.kind_of? Store
    fail URI::InvalidURIError unless URI.regexp =~ @url
    @url = URI(@url)
    @products_data = []
  end

  protected

  attr_reader :store, :url, :tag, :products_raw_data, :products_data

  def process
    extract_data
    normalize_products_data
    store_or_update_data
  end

  def extract_data
    @products_raw_data or begin
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
      @products_raw_data = klass.new.crawl
    end
  end

  def normalize_products_data
    products_raw_data.symbolize_keys[:products].each do |raw_data|
      products_data << ProductData.create(raw_data.merge(store_id: store.id, tags: tag))
    end
  end

  def store_or_update_data
    products_data.each do |product_data|
      product = Product.find_or_initialize_by(url: product_data.url)
      if product.new_record?
        product.attributes = product_data.as_json
      else
        next if product.price == product_data.price
        product.price = product_data.price
      end
      product.save
    end
  end

  ProductData = Struct.new :name, :price, :store_id, :url, :image, :tags do
    Module.new do
      def price
        value = super
        return value if value.kind_of? Integer
        value.to_s.gsub(/[\s\$]/, '').to_i
      end

      def tags
        value = super
        value.tr(' ', '').split(/[\|\\\/,\｜\＼／]/)
      end
    end.tap { |mod| self.prepend mod }

    def as_json
      {
        name: name,
        price: price,
        store_id: store_id,
        url: url,
        image: image,
        tags: tags
      }
    end

    def self.create(attributes = {})
      attributes = attributes.symbolize_keys
      args = attributes.values_at(:title, :price, :store_id, :url, :image_thumb_url, :tags)
      self.new(*args)
    end
  end
end