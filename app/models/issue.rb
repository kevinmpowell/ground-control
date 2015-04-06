class Issue < ActiveRecord::Base
   validates :url, presence: true, uniqueness: true
   validates :user_id, presence: true
   validates :number, presence: true
   validates :issue_created_at, presence: true

   belongs_to :user

	def text_color_for_hex hex
		match =  hex.scan(/.{2}/)
		(match[0].to_i(16) + match[1].to_i(16) + match[2].to_i(16)) < 382.5 ? 'white' : 'black'
	end

   def as_json(options = {})
	  json = super(options.reverse_merge(:except => :labels))
	  json[:labels] = JSON.parse(labels)
	  json[:labels].each do |label|
	  	label["text_color"] = text_color_for_hex(label["color"])
	  end
	  json
	end
end