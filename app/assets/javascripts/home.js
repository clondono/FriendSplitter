//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


$("document").ready(function() {
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
  
  // Binds evenPay button to a function that calculates
  // an even split of the total amount and populates
  // the "owes" field of each participant with the 
  // split value
  // author: Lucy
  $("#evenPay").click( function() {

      var totalamount = $("#event_amount").val();

      totalamount = parseFloat(totalamount)

      if (totalamount > 0) {
          numParticipants = 0
          
          $(".contrEmail").each( function() {
              if ( !($(this).val() == null || $(this).val() == "") ){
                  numParticipants += 1;
              }
          });
          var split = totalamount / numParticipants;

          $(".contrEmail").each( function() {
              if ( !($(this).val() == null || $(this).val() == "") ){
                  $(this).next(".contrAmt").val(split.toFixed(2));
              }
          });
      }

  });
});

$(document).on("page:change", function() {
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

  // Binds evenPay button to a function that calculates
  // an even split of the total amount and populates
  // the "owes" field of each participant with the 
  // split value
  // author: Lucy
  $("#evenPay").click( function() {

      var totalamount = $("#event_amount").val();

      totalamount = parseFloat(totalamount)

      if (totalamount > 0) {
          numParticipants = 0
          
          $(".contrEmail").each( function() {
              if ( !($(this).val() == null || $(this).val() == "") ){
                  numParticipants += 1;
              }
          });
          var split = totalamount / numParticipants;

          $(".contrEmail").each( function() {
              if ( !($(this).val() == null || $(this).val() == "") ){
                  $(this).next(".contrAmt").val(split.toFixed(2));
              }
          });
      }

  });

});



