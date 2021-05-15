class Recipe < ApplicationRecord

  belongs_to :farmer
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  has_many :recipe_favorites, dependent: :destroy
  attr_accessor :tag_ids

  with_options presence: true do
    validates :title
    validates :recipe_image
    validates :duration, numericality: true
    validates :amount, numericality: true
    validates :ingredient
    validates :recipe
    validates :tag_ids, presence: true
  end

  attachment :recipe_image

  def save_tags(input_tags)
    current_tags = self.tags.pluck(:tag) unless self.tags.nil?
    delete_tags = current_tags - input_tags
    add_tags = input_tags - current_tags

    delete_tags.each do |delete_tag|
      self.tags.delete Tag.find_by(tag: delete_tag)
    end

    add_tags.each do |add_tag|
      recipe_tag = Tag.find_or_create_by(tag: add_tag)
      self.tags << recipe_tag
    end
  end

  def favorited_by?(customer)
    recipe_favorites.where(customer_id: customer.id).exists?
  end
end
