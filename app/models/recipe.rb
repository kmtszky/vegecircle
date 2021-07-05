class Recipe < ApplicationRecord

  belongs_to :farmer
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  has_many :recipe_favorites, dependent: :destroy
  attr_accessor :tag_list

  with_options presence: true do
    validates :title
    validates :recipe_image
    validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    validates :ingredient
    validates :recipe
    validates :tag_list
  end

  attachment :recipe_image

  def save_tags(inputted_tags)
    current_tags = tags.pluck(:tag) unless tags.nil?
    tags_to_be_added = inputted_tags - current_tags
    tags_to_be_deleted = current_tags - inputted_tags

    tags_to_be_added.each do |tag_to_be_added|
      recipe_tag = Tag.find_or_create_by(tag: tag_to_be_added)
      tags << recipe_tag
    end

    tags_to_be_deleted.each do |tag_to_be_deleted|
      tags.delete Tag.find_by(tag: tag_to_be_deleted)
    end
  end

  def favorited_by?(customer)
    recipe_favorites.where(customer_id: customer.id).exists?
  end

  def self.title_like(title)
    where('title like ?', '%' + content + '%')
  end

  def self.sorts(method)
    if method == 'new'
      all.order('created_at DESC')
    else
      includes(:recipe_favorites).sort {|a, b| b.recipe_favorites.size <=> a.recipe_favorites.size }
    end
  end
end
