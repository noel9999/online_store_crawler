module ProductFetcher
  class Wellcome
    attr_reader :options, :data, :store

    def initialize(args = {})
      @options = default_options.merge(args.symbolize_keys)
      @store = Store.find_by!(name: Store::PROVIDERS[:wellcome])
      @mutex = Mutex.new 
    end

    def execute
      extract_data.each_slice(options.fetch(:slice_count)) do |slice_data|
        slice_data.each do |tag, url|
          tag_product_page_urls = options.fetch(:iterate_product_pages) ? fetch_product_pages(url) : url
          enqueue_crawlers_dispatch_job(store.id, tag, Array(tag_product_page_urls))
        end
        sleep 2
      end
    end

    protected

    def extract_data
      page = Mechanize.new.get(store.url)
      @data = page.search('nav#main-nav > ul.menu.clearfix').css('li>a').reduce({}) do |result, node|
        tag = node.children[0].try(:text)
        next result unless tag
        url = case node['href']
              when URI.regexp
                node['href']
              when /listByBrand/
                next result
              when /^\/product/
                'https://sbd-ec.wellcome.com.tw' + node['href']
              else
                next result
              end
        (result[tag] = url) && result
      end
    end

    def default_options
      {
        iterate_product_pages: false,
        slice_count: 10
      }
    end

    def enqueue_crawlers_dispatch_job(*args)
      DispatchCrawlersJob.perform_later(*args)
    end

    def fetch_product_pages(url)      
      page = Mechanize.new.get(url)
      page_urls = [url]
      next_page_link = page.link_with(css: '.next-page a')
      next_page = page # for beginning
      until(next_page.link_with(css: '.next-page.disabled > a'))
        Thread.new do
          @mutex.synchronize { page_urls << store.url + next_page_link.href.to_s }
          next_page = next_page_link.click
          next_page_link = next_page.link_with(css: '.next-page a')
        end.join
      end
      page_urls
    end
  end
end