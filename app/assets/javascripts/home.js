//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/
$(function(){
  console.log("in home.js");
  $(".payButton").each(function(){
    debt_id = $(this).attr('id').slice(3);
    console.log(debt_id);
      this.onclick = function(argument) {
        valid=false;
        while(!valid) {
          var payment = window.prompt("Input the amount you paid this user (round to nearest whole dollar)","");
          if (payment.length !== 0) {
            if(!isNaN(payment)) {
                valid = true;
            }
          }
       }
        var urlLink = "/debts/pay";
        $.ajax({
            url: urlLink,
            type:'PUT',
            data: { 'debt_id': debt_id, 'amount':payment},
            datatype: 'json',
            success: function(data){
          } 
          });
          location.reload();
        };

  });
});


