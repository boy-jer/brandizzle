class Search < ActiveRecord::Base
  validates_presence_of :term
  belongs_to :brand
  has_many :results, :class_name => "SearchResult", :foreign_key => "search_id"
  
  class << self
    def run
      searches = Search.find(:all)
      searches.each do |search|
        search.run_against_twitter
        search.run_against_blog_search
      end
    end
  end
  
  def run_against_twitter
    twitter_search = latest_id.blank? ? Twitter::Search.new(term) : Twitter::Search.new(term).since(latest_id)
    twitter_results = twitter_search.fetch().results
    
    max_id = 0
    twitter_results.each do |result|
      max_id = [result["id"], max_id].max
      results.create(
        :source => 'twitter',
        :created_at => result["created_at"],
        :body => result["text"],
        :url => "http://twitter.com/#{result['from_user']}/statuses/#{result['id']}"
      )
    end
    
    if latest_id.blank? || max_id > latest_id.to_i
      self.latest_id = max_id 
      save
    end
  end

  def run_against_blog_search
    pages = [0]
    loop do
      page = pages.pop
      url = "http://ajax.googleapis.com/ajax/services/search/blogs?v=1.0&q=#{term}&rsz=large&start=#{page}"

      json_results = JSON.parse(open(url).read)
      json_results["responseData"]["results"].each do |r|
        results.create(
          :source => 'blog',
          :body => r["content"],
          :url => r["postUrl"],
          :created_at => r["publishedDate"]
        )
      end

      if (page == 0)
        json_results["responseData"]["cursor"]["pages"].each do |p|
          pages << p["start"] unless p["start"] == "0"
        end
      end
      break if pages.empty?

    end
  end
end
