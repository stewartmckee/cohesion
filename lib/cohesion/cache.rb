module Cohesion
  class Cache
    def self.clear_public
      Cobweb::Cache.flush_public
    end
    def self.clear_crawls
      Cobweb::Cache.flush_all_private
    end
    def self.clear_crawl(crawl_id)
      Cobweb::Cache.flush_crawl(crawl_id)
    end

  end

end
