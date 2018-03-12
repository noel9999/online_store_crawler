# README

## 介紹
  此專案目的為爬行線上商場的商品資料，並提供 API 供人查詢資料

* 系統需求
  - redis
  - postrgresql
  - rails 5.1 
  - ruby 2.4.0

* 啟動專案
  - clone 專案
  - run `bundle`
  - setup database.yml
  - run `rails db:create` or `rails db:create:all`
  - run `rails db:migrate` 
  - run `redis-server` 啟動 redis 
  - run `rails s`
  - run `bundle exec sidekiq -c 3` 啟動 sidekiq 並指定 concurrency 數為 3

* 運行爬蟲
  1. run `rails crawler:fetch_online_store_products[store_key]` store_key 例如 'wellcome' or 'rt_mart'
  2. run `rails 'crawler:fetch_online_store_products[store_key,iterate_product_pages]'` 第二個參數為是否需要爬行商品分類下所有的分頁的資料，不提供此參數時僅爬行該分類的第一頁
  3. ~專案有安裝 `whenever` 可可以慢慢等或自行調整你想要的時程~
  4. 進入 rails c, 執行 `ProductFetchService.new(store_key: store_key).execute`

* API 範例
  > localhost:3000/api/products?q[name]=奶茶&q[price_max]=23

  詳情可參閱 doc/index.html，文件建立方法: 
  1. run `npm install apidoc -g` 
  2. 在專案下 run `apidoc`
  3. run `open project/doc/index.html`
  4. [APIDOC](http://apidocjs.com/#install)




* Todo List
  此專案是本人第一次寫爬蟲相關需求，而隨著爬蟲的開發，也不斷發現此專案甚至該領域內仍有許許多多可改善的議題、可優化的效能、或是可以拓展的功能；然而在有限的時間、經驗以及資源下，僅能先推目前的版本，期以未來有更多的時間與資源去投入下，去推出更好的版本；目前列出些未來可以做的事項如下：

  1. 失效、過期商品自動下架功能
  2. product tags 或可拉出來成獨立的表並可搭配如 `acts-as-taggable-on` 增加可檢索的選擇
  3. 當篩選、查詢的參數越來越複雜時，可以引用 QueryObject
  4. 當需要更彈性、更複雜的檢索、篩選功能，可以使用 elasticsearch
  5. 當 product 需要更詳盡的資料，可以增加 product 的 cached_key 來優化效能
  6. Wombat 不如想像的彈性，為了兼顧程式碼的品質與效能未來可能尋找其他的替代工具
  7. 增加即時查詢的功能，如使用者查詢的商品尚未有資料，可即時搜尋線上商城，並且取得資料
  8. 尋找更適合的商品 uniq_key
  9. 研究、評估使用語意分析來分辨相同商品不同商品名稱的可行性與成本
* ...
