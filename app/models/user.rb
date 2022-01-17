class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_many :books, dependent: :destroy
         has_many :favorites, dependent: :destroy
         has_many :post_comments, dependent: :destroy
         attachment :profile_image

         validates :name, length: { in: 2..20 }
         validates :introduction, length: { maximum: 50 }

  #フォローする側のUserから見て、フォローされる側のUserを(中間テーブルを介して)集める。なので親はfollowing_id(フォローする側)
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  # 中間テーブルを介して「follower」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower

  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  # 中間テーブルを介して「following」モデルのUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following

  def followed_by?(user)
    # 今自分(引数のuser)がフォローしようとしているユーザー(レシーバー)がフォローされているユーザー(つまりpassive)の中から、引数に渡されたユーザー(自分)がいるかどうかを調べる
    passive_relationships.find_by(following_id: user.id).present?
  end

  def self.search(search, word)
    if search == "forward_match"
                    @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
                    @book = Book.where("title LIKE?","%#{word}")
    elsif search == "perfect_match"
                    @book = Book.where("#{word}")
    elsif search == "partial_match"
                    @book = Book.where("title LIKE?","%#{word}%")
    else
                    @book = Book.all
    end
end

end
