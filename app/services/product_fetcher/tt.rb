
# wellcome product list
Wombat.crawl do
  base_url 'https://sbd-ec.wellcome.com.tw'
  path '/product/listByCategory/7'

  products({ css: '.category-item-container .row .item-col' }, :iterator) do
    image_thumb_url({css: '.item-image-wrapper figure.item-image-container' }, :html) do |value|
      html_doc = Nokogiri::HTML(value)
      html_doc.css('a > img')[0]['src']
    end
    url({css: '.item-image-wrapper figure.item-image-container' }, :html) do |value|
      html_doc = Nokogiri::HTML(value)
      html_doc.css('a')[0]['href']
    end
    title({css: '.item-meta-container .item-name'})
    price(css: '.item-meta-container .item-price-container.inline')
  end  
end

# wellcone product category
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
# wellcome product pages
@mutex = Mutex.new
url = 'https://sbd-ec.wellcome.com.tw/product/listByCategory/66'
page = Mechanize.new.get(url)
page_urls = [url]
next_page_link = page.link_with(css: '.next-page a')
next_page = page # for beginning
until(next_page.link_with(css: '.next-page.disabled > a'))
  Thread.new do
    @mutex.synchronize { page_urls << 'https://sbd-ec.wellcome.com.tw' + next_page_link.href.to_s }
    next_page = next_page_link.click
    next_page_link = next_page.link_with(css: '.next-page a')
  end.join
end
page_urls