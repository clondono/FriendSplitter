<script type="text/javascript">
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
</script>
