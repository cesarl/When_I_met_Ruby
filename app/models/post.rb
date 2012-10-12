class Post < ActiveRecord::Base
  attr_accessible :body, :title, :illustration

  has_attached_file :illustration, :styles => { :thumbnail => "250x140>" }

  validates :title, :presence => true, :length => { :maximum => 255}

  has_many :comments, :dependent => :destroy
end
