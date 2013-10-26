# Event model 

# Ensures a debt has a "creator" and many contributions.

# @author Angel

class Event < ActiveRecord::Base
  # Makes sure every collection is associated with a user.
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  validates :creator_id, presence: true

  # Associate an event with many contributions.
  has_many :contributions, dependent: :destroy

  validates :amount, presence: true
  validates :title, presence: true
  validates :description, presence: true


  # Creates the debts associated with an event where
  # the bill is divided evenly amongst all participants.
  def createDebts()
	owed = []
	owes = []

	self.contributions.each do |contribs|
		balance = contribs.paid - contribs.amount
		if balance > 0
			owed.push([balance,contribs])
		elsif balance <0
			owes.push([balance,contribs])
		end	
	end
	
	# TODO: sort owed and owes from greatest to smallest
	
	owed.each do |posBal,posCont|
		ower.each do |negBal, negCont|
			
			#if  ower can't pay off Owed's full balance
			if postBal+negBal > 0
				debt = negBal*-1 #Ower is indebted to Owed his full balance
				ower.delete([negBal,negCont]) #TODO check this. removes this contribution from Owers
				posBal=posBal+negBal #oweds new balance is old balance-Owed's debt

				#TODO CREATE THE DEBT OBJECT

			#if after owed pays off all of oweds balance they still owe
			elsif postBal+negBal <0
				debt = posBal #Ower will pay off all that the Owed is owed
				owed.delete([posBal,posCont]) #removes this contribution from Owed
				negBal= negBal+posBal 

				#TODO CREATE THE DEBT OBJECT

				break
			#ower can pay off oweds full balance while finishing his own balance	
			else
				debt = posBal 
				owed.delete([posBal,posCont]) #removes this contribution from Owed
				ower.delete([negBal,negCont]) #TODO check this. removes this contribution from Owers

				#TODO CREATE THE DEBT OBJECT

				break
			end


		end
	end

  end

    # Find an optimal pairing between positive 
    # and negative contributions such that the number of
    # pairings are minimized. 
  def createContributions(eventContributions)
  	#this is for an event split. must be changed 
  	#if allowing uneven splits of bills
  	@count = self.contributions.length
  	@evenSplit = self.amount/@count
  	
  	eventContributions.each do |contParams|
  		puts("in createContributions")
  		debugs("what im doing dawg")
  		contParams[:amount]=@evenSplit
  		self.contributions.create(contParams)
  	end
  end
end
