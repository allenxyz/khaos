class User < ActiveRecord::Base
	has_many :recs
	geocoded_by :curloc

	has_many :tags
end
