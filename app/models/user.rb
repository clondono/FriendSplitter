# @author Christian/Angel
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  # Associate a user with a set of users that they owe
  has_many :debts, foreign_key: "owner_id", dependent: :destroy
  has_many :owed_users, through: :debts, source: :indebted

  # Associate a user with a set of users that owe him/her
  has_many :owed_debts, foreign_key: "indebted_id",
                                   class_name:  "Debt",
                                   dependent:   :destroy
  has_many :debtors, through: :owed_debts, source: :owner
  has_many :events, foreign_key: "creator_id", dependent: :destroy
  has_many :participationInEvent, through: :contributions, source: :event
  
  # Associate a user with contributions
  has_many :contributions, dependent: :destroy

  # Creates a contribution for the user for the given params.
  def setContribution!(event, amount, paid)
    contributions.create!(event_id: event.id, amount: amount, paid: paid)
  end

  # Checks if the user owes another user.
  def owes?(otherUser)
    debts.find_by(indebted_id: otherUser.id)
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:email => auth.info.email).first
    puts 
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           last_name:auth.info.last_name,
                           first_name:auth.info.first_name
                           )

    end
    user
  end

  # Checks that all emails in the contribution attributes
  # are belong to users.
  def self.validEmails?(contributionAttributes)
    valid = true
    contributionAttributes.each do |contribution|
      contributor = User.find_by_email(contribution[1]["email"])
      if contributor.nil?
        valid = false
      end
    end
    return valid
  end

end
