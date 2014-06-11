class User < ActiveRecord::Base
	has_many :recs
	geocoded_by :curloc
end
