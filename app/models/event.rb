# Event model 

# Ensures a debt has a "creator" and many contributions.

# @author Angel

class Event < ActiveRecord::Base
    # Makes sure every collection is associated with a user.
    # belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
    # validates :creator_id, presence: true

    # Associate an event with many contributions.
    has_many :contributions, dependent: :destroy
    has_many :participants, through: :contributions, source: :user

    accepts_nested_attributes_for :contributions

    validates :amount, presence: true
    validates :title, presence: true
    validates :description, presence: true


    # Creates the debts associated with an event where
    # the bill is divided evenly amongst all participants.
    # TODO: Find an optimal pairing between positive 
    # and negative contributions such that the number of
    # pairings are minimized. 
    def createDebts
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

        owed.sort{|x,y| x[0] <=>y[0]}.reverse!
        owes.sort{|x,y| x[0] <=>y[0]}.reverse!


        owed.each do |posBal,posCont|
            owes.each do |negBal, negCont|

                #if  ower can't pay off Owed's full balance
                if posBal+negBal > 0
                    debtAmount = negBal*-1 #Ower is indebted to Owed his full balance
                    owes.delete([negBal,negCont]) #TODO check this. removes this contribution from Owers
                    posBal=posBal+negBal #oweds new balance is old balance-Owed's debt
                    negCont.user.debts.create()
                    consolidateDebts(posCont,negCont,debtAmount)

                    #if after owed pays off all of oweds balance they still owe
                elsif posBal+negBal <0
                    debtAmount = posBal #Ower will pay off all that the Owed is owed
                    owed.delete([posBal,posCont]) #removes this contribution from Owed
                    negBal= negBal+posBal 
                    consolidateDebts(posCont,negCont,debtAmount)

                    break
                    #ower can pay off oweds full balance while finishing his own balance	
                else
                    debtAmount = posBal 
                    owed.delete([posBal,posCont]) #removes this contribution from Owed
                    owes.delete([negBal,negCont]) #TODO check this. removes this contribution from Owers
                    consolidateDebts(posCont,negCont,debtAmount)
                    break
                end
            end
        end

    end

    # This is repetitive...Combine with createContribution -Angel
    def createEvenContributions(eventContributions)
        @count = self.contributions.length
        @evenSplit = self.amount/@count

        eventContributions.each do |contParams|
            contParams[:amount]=@evenSplit
            contributor= User.find_by_email(contParams[:email])
            contributor.setContribution!(self, contParams[:amount], contParams[:paid])
        end
    end

    def createContributions(eventContributions)
        eventContributions.each do |contribution|
            contributor = User.find_by_email(contribution[1]["email"])
            contributor.setContribution!(self, contribution[1]["amount"], contribution[1]["paid"])
        end
    end  



    # Checks that a set of contributions adds up
    # to the total amount of a event cost.
    # The total amout owed should equal the total 
    # amount paid which should equal the event cost.
    def self.validContributions?(contributionsInfo,amount)
        totalAmountOwed = 0
        totalAmountPaid = 0
        contributionsInfo.each do |contribution|
            totalAmountOwed += Integer(contribution[1]["amount"])
            totalAmountPaid += Integer(contribution[1]["paid"])
        end
        (totalAmountOwed == totalAmountPaid and totalAmountPaid == Integer(amount))
    end



    private 
    def consolidateDebts(posCont, negCont, debtAmount)
        ower=negCont.user
        owed=posCont.user
        # if the new ower already owes the owed
        if ower.owes?(owed)
            debt = ower.debts.find_by(indebted_id: owed.id)
            debt.updateVal(debt.amount+debtAmount)

            #If the new owere is owed money from the new owed      
        elsif owed.owes?(ower)
            debt = owed.debts.find_by(indebted_id: ower.id)
            newDebt = debt.amount-debtAmount

            if newDebt > 0
                debt.updateVal(newDebt)
            elsif newDebt < 0
                debt.destroy!
                newDebt=newDebt*-1
                ower.debts.create!(owner_id: ower.id, indebted_id: owed.id, amount: newDebt)
            else
                debt.destroy!
            end

            #if there is no debt between these users
        else
            ower.debts.create!(owner_id: ower.id, indebted_id: owed.id, amount: debtAmount)
        end
    end
end
