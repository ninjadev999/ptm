ActsAsTaggableOn::Tag.class_eval do
  scope :promotions, -> { joins(:taggings).where(["taggings.context = ?", 'promotions']) }
  scope :topics, -> { joins(:taggings).where(["taggings.context = ?", 'topics']) }
  scope :expertises, -> { joins(:taggings).where(["taggings.context = ?", 'expertises']) }
end