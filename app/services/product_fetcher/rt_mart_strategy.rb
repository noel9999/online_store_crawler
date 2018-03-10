module ProductFetcher
  class RtMartStrategy < BaseStrategy
    def extract_data
      page = Mechanize.new.get(store.url)
      page.search('.rtmartHEADER02.clearFix ul.main_nav').css('li>a').reduce({}) do |result, node|
        tag = node.children[0].try(:text)
        next result unless tag
        url = case node['href']
              when URI.regexp
                node['href']
              when /^index/
                'http://www.rt-mart.com.tw/direct/' + node['href']
              else
                next result
              end
        (result[tag] = url) && result
      end
    end

    def fetch_product_pages(url)      
      page = Mechanize.new.get(url)
      page_urls = [url]
      next_page_link = page.link_with(text: 'Next')
      until(next_page_link.href == '#')
        Thread.new do
          @mutex.synchronize { page_urls << store.url + next_page_link.href.to_s }
          next_page = next_page_link.click
          next_page_link = next_page.link_with(text: 'Next')
        end.join
      end
      page_urls
    end
  end
end