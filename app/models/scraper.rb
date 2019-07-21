class Scraper < ApplicationRecord

  def self.all_shuls
    @doc = HTTParty.get("https://www.godaven.com/shul-details/190")
    @parse_page = Nokogiri::HTML(@doc)
  end
end
