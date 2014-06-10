class User < ActiveRecord::Base
	has_many :rec
	geocoded_by :curloc
end
