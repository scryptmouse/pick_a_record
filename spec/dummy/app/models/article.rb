class Article < ActiveRecord::Base
  attr_accessible :body, :title

  pick_a_weekly 'featured_article'

  pick_a_daily
end
