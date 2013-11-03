# Event model 

# Associates an event with many contributions.

# @author Angel/Christian

class Event < ActiveRecord::Base
    # Makes sure every collection is associated with a user.
    # belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
    # validates :creator_id, presence: true

    # Associate an event with many contributions.
    has_many :contributions, dependent: :destroy
    has_many :participants, through: :contributions, source: :user

    # Used to create contributions while creating events.
    accepts_nested_attributes_for :contributions

    # Before creating an event, make sure the following fields exist.
    validates :amount, presence: true
    validates :title, presence: true
    validates :description, presence: true

    # Creates the debts associated with an event where
    # the bill is divided evenly amongst all participants.
    # TODO: Find an optimal pairing between positive 
    # and negative contributions such that the number of
    # pairings are minimized. 
    def createDebts
        owedUsers = {}
        debtedUsers = {}

        # Separate users into those who owe and those who
        # are owed. O(n)
        self.contributions.each do |contribution|
            owedAmount = contribution.amount - contribution.paid
            if owedAmount > 0
                debtedUsers[contribution.user.id] = [owedAmount, contribution.user]
            elsif owedAmount < 0
                owedUsers[contribution.user.id] = [owedAmount * -1, contribution.user]
            end 
        end

        # First, create debts for perfect matches. O(n squared)
        debtedUsers.each do |debtedKey, debtedUser|
            owedUsers.each do |owedKey, owedUser|
                if (debtedUser[0] == owedUser[0])
                    Debt.settleDebt(owedUser[1], debtedUser[1], owedUser[0])
                    owedUsers.delete(owedKey) #removes this contribution from Owed
                    debtedUsers.delete(debtedKey) #TODO check this. removes this contribution from Owers
                end
            end
        end

        # Now, if debts stll remain, use a greedy approach to 
        # settle the remainder of debts. Match the users who 
        # owe the most with those who are owed the least.

        # debtedUsers.sort{|x,y| x[0] <=> y[0]}.reverse!
        # owedUsers.sort{|x,y| x[0] <=> y[0]}


        # Pay off debts.
        debtedUsers.each do |debtedKey, debtedUser|
            amountToPay = debtedUser[0]

            owedUsers.each do |owedKey, owedUser|
                amountToReceive = owedUser[0]

                # If debtedUser can pay off owedUser and more,
                # settle the debt and update amount to pay.
                if (amountToPay > amountToReceive)
                    amountToPay = amountToPay - amountToReceive
                    Debt.settleDebt(owedUser[1], debtedUser[1], amountToReceive)
                    owedUsers.delete(owedKey)

                # If debtedUser can only pay off part of owedUser,
                # settle debt, and leave debted user alone.
                elsif (amountToPay < amountToReceive)
                    owedUser[0] = amountToReceive - amountToPay
                    Debt.settleDebt(owedUser[1], debtedUser[1], amountToPay)
                    debtedUsers.delete(debtedKey)
                    break

                # It is possible that after paying off debts,
                # there is now a perfect match. In case, settle debt.
                else
                    Debt.settleDebt(owedUser[1], debtedUser[1], owedUser[0])
                    owedUsers.delete(owedKey)
                    debtedUsers.delete(debtedKey)
                    break
                end
            end
        end
    end


    # Given a set of contribution attributes, 
    # create the contributions for each user.
    def createContributions(eventContributions)
        eventContributions.each do |contribution|
            contributor = User.find_by_email(contribution[1]["email"])
            contributor.setContribution!(self, contribution[1]["amount"], contribution[1]["paid"])
        end
    end  

    # TODO: This is repetitive...Should be combined with createContribution 
    #       when implemented -Comment by: Angel
    def createEvenContributions(eventContributions)
        @count = self.contributions.length
        @evenSplit = self.amount/@count

        eventContributions.each do |contParams|
            contParams[:amount]=@evenSplit
            contributor= User.find_by_email(contParams[:email])
            contributor.setContribution!(self, contParams[:amount], contParams[:paid])
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

    # Returns whether or not the event is pending
    def isPending?
        self.pending
    end

    # Checks if all of the event's contributions
    # were confirmed.
    def confirmed?
        self.contributions.each do |contribution|
            return false if contribution.isPending?
        end
        return true
    end

    # Checks if all of the event's contributions
    # were confirmed.
    def confirm!
        self.pending = false
        self.save
        self.createDebts
    end

    
end
