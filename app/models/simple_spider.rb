require 'kimurai'

class SimpleSpider < Kimurai::Base
  @csv_text = File.read(Rails.root.join('db', 'upload', 'urls.csv'))
  @csv = CSV.parse(@csv_text).to_a.flatten

  @results_text = File.read(Rails.root.join('archive','results.csv'))
  @results = CSV.parse(@results_text).to_a.map(&:first).flatten
  @csv = @csv.select { |x| !@results.include?(x.split("/").last)}

  @name = "simple_spider"
  @engine = :selenium_chrome

  @start_urls = @csv
  @config = {
    user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
    disable_images: true,
    before_request: { delay: 4..7 }
  }

  def parse(response, url:, data: {})

    item = {:id=>url.split('/').last, :name=>'', :tel=>'', :email=>'', :website=>''}
    item[:name] = response.xpath("//div[@class='shul-details-info-column']/div").first && response.xpath("//div[@class='shul-details-info-column']/div").first.text.titleize
    response.xpath("//div[@class='shul-details-info-column']/a/@href").each do |x|
      if x.value.include?("tel:")
        item[:tel] = x.value.gsub("tel:","")
      end
      if x.value.include?("mailto:")
        item[:email] = x.value.gsub("mailto:", "")
      end
      if x.value.include?("http")
        item[:website] = x.value
      end
    end

    save_to "results.csv", item, format: :csv

  end
end

# SimpleSpider.crawl!
