# Primary author: Christian

class DebtsController < ApplicationController
  
  def update
    @debt = Debt.find_by_id(params[:debt_id])
    @payment=params[:amount].to_i

    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    if current_user.id==@debt.owner.id
      if @debt.amount > @payment
        @debt.updateVal(@debt.amount-@payment)
      elsif @debt.amount == @payment
        @debt.destroy
      else
          @debt.destroy
      end
    else
      #shouldn't be paying debt

    end
  end

end
