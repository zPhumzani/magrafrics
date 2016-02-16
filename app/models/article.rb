class Article < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  has_many :comments
  has_many :taggings
  has_many :tags, through: :taggings
  has_attached_file :image, styles: {large: '600x330', medium: '300x300', thumb: '100x100'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :recent_article, lambda {order('created_at DESC')[5]}

  def tag_list
  	self.tags.collect do |tag|
  		tag.name
  	end.join(", ")
  end

  def tag_list=(tags_string)
  	tag_names = tags_string.split(", ").collect{|s| s.strip.downcase}.uniq
  	new_or_found_tags = tag_names.collect {|name| Tag.find_or_create_by(name: name)}
  	self.tags = new_or_found_tags
  end
end
