# @author Christian/Angel
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associate a user with a set of users that they owe
  has_many :debts, foreign_key: "owner_id", dependent: :destroy
  has_many :owed_users, through: :debts, source: :indebted

  # Associate a user with a set of users that owe him/her
  has_many :owed_debts, foreign_key: "indebted_id",
                                   class_name:  "Debt",
                                   dependent:   :destroy
  has_many :debtors, through: :owed_debts, source: :owner
  has_many :events, foreign_key: "creator_id", dependent: :destroy
  
  # Associate a user with contributions
  has_many :contributions, dependent: :destroy

end
