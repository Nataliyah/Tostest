class Test < ActiveRecord::Base
    validates :title, :presence => true
    
  has_many :words, :dependent => :destroy #to ostatnie skasuje wszystkie hasla nalezace do tego testu, jesli on zostanie skasowany
  belongs_to :category
end
