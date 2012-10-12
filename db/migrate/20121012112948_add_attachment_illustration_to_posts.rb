class AddAttachmentIllustrationToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.has_attached_file :illustration
    end
  end

  def self.down
    drop_attached_file :posts, :illustration
  end
end
