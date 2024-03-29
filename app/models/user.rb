# @author Christian/Angel
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :omniauthable, :omniauth_providers => [:facebook, :venmo, :google_oauth2]

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

  has_many :authentications, dependent: :destroy

  # Sets the time out for inactive users to 15 minutes.
  def timeout_in
    15.minutes
  end

  # Creates a contribution for the user for the given params.
  def setContribution!(event, amount, paid)
    contributions.create!(event_id: event.id, amount: amount, paid: paid)
  end

  # Checks if the user owes another user.
  def owes?(otherUser)
    debts.find_by(indebted_id: otherUser.id)
  end

  #method handles responses from API for faceboook and creates users or authentications if necessary
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:email => auth.info.email).first
    unless user
      user = User.create(  email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           last_name:auth.info.last_name,
                           first_name:auth.info.first_name
                           )

    end
    @authentication = user.authentications.where(provider: auth.provider).first
    unless @authentication
      @authentication = user.authentications.create(provider: auth.provider, uid: auth.uid)
      user.send_reset_password_instructions
    end
    user

  end

  #method handles responses from API for venmo and creates users or authentications if necessary
  def self.find_for_venmo_oauth(auth, signed_in_resource=nil)
    user = User.where(:email => auth.info.email).first

    
    unless user
      user = User.create(  email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           last_name:auth.extra.raw_info.lastname,
                           first_name:auth.extra.raw_info.firstname
                           )

    end
    @authentication = user.authentications.where(provider: auth.provider).first
    unless @authentication
      @authentication = user.authentications.create(provider: auth.provider, uid: auth.uid)
      user.send_reset_password_instructions
    end
    user
  end

  #method handles responses from API for google and creates users or authentications if necessary
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:email => data["email"]).first
          
      unless user
          user = User.create(email: data["email"],
                             first_name: data["first_name"],
                             last_name: data["last_name"],
                             password: Devise.friendly_token[0,20]
                             )
      end
      @authentication = user.authentications.where(provider: access_token.provider).first
      unless @authentication
        @authentication = user.authentications.create(provider: access_token.provider, uid: access_token.uid)
        user.send_reset_password_instructions
      end
      user
  end

  # Checks that all emails in the contribution attributes
  # are belong to users and aren't repeated.
  def self.validEmails?(contributionAttributes)
    valid = true
    emails = {}
    contributionAttributes.each do |contribution|
      contributor = User.find_by_email(contribution[1]["email"])
      if contributor.nil?
        valid = false
        break
      elsif emails[contributor]
        valid = false
        break
      else
        emails[contributor] = true
      end
    end
    return valid
  end

  # Returns the users events, seperated
  # into confirmed and pending events.
  def getEvents
    pendingEvents = []
    confirmedEvents = []
    allEvents = self.participationInEvent
    allEvents.each do |event|
      if event.isPending?
        pendingEvents.push(event)
      else
        confirmedEvents.push(event)
      end
    end
    organizedEvents = {}
    organizedEvents["confirmed"] = confirmedEvents
    organizedEvents["pending"] = pendingEvents
    return organizedEvents
  end


  # Returns whether or not the user confirmed the event. Assumes the 
  # user has a contribution in the event.
  def confirmedEvent?(event)
    return !Contribution.find_by(event_id: event.id, user_id: self.id).pending
  end


  # Returns the user contribution in a given event
  def getContribution(event)
    return Contribution.find_by(event_id: event.id, user_id: self.id)
  end

end
