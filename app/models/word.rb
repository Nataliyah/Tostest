class Word < ActiveRecord::Base
  # attr_accesible ?
  validates :ang, :presence => true
  validates :pol1, :presence => true
  
  belongs_to :test
  has_one :word_stat
end
