<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Payments</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/png" href="images/SC.png">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

<style>
    .payment-card {
        background: #fff;
        border-radius: 12px;
        padding: 25px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        margin-top: 40px;
    }
    .payment-header {
        text-align: center;
        margin-bottom: 20px;
    }
    .payment-header img {
        height: 80px;
    }
    .payment-header h2 {
        margin-top: 10px;
        color: #b07fb5;
        font-weight: bold;
    }
    .payment-card .btn-pay {
	    font-size: 16px;
	    font-weight: bold;
	    padding: 10px;
	    border-radius: 8px;
	    white-space: normal;
	    word-wrap: break-word;
	    min-width: 120px;
	}
	.input-group-btn .btn {
	    height: 34px;          /* same as default Bootstrap input height */
	    padding: 6px 12px;     /* match input padding */
	    line-height: 1.428571; /* same line height as .form-control */
	    border-radius: 0 4px 4px 0; /* match right side rounding */
	}
	
	@media (max-width: 480px) {
	    .payment-card .btn-pay {
	        font-size: 14px;
	        padding: 10px;
	    }
	}
</style>

</head>
<body>
<%
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
    }

    String sAmount = request.getParameter("amount");
    double amount = 0;
    if (sAmount != null) {
        amount = Double.parseDouble(sAmount);
    }
%>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <form action="./OrderServlet" method="post" class="payment-card">
                <div class="payment-header">
                    <img src="images/SC.png" alt="Payment Proceed">
                    <h2>Credit Card Payment</h2>
                </div>

                <div class="form-group">
                    <label>Name of Card Holder</label>
                    <input type="text" name="cardholder" class="form-control" placeholder="Enter Card Holder Name" required>
                </div>

                <div class="form-group">
                    <label>Credit Card Number</label>
                    <input type="text" name="cardnumber" class="form-control" placeholder="4242-4242-4242-4242" required>
                </div>

                <div class="row">
                    <div class="col-xs-6 form-group">
                        <label>Expiry Month</label>
                        <input type="number" name="expmonth" class="form-control" placeholder="MM" max="12" min="1" required>
                    </div>
                    <div class="col-xs-6 form-group">
                        <label>Expiry Year</label>
                        <input type="number" name="expyear" class="form-control" placeholder="YYYY" required>
                    </div>
                </div>
                
                <div class="form-group">
				    <label>Postal Code</label>
				    <div class="input-group">
				        <input type="number" id="postalCode" name="postalCode" class="form-control" placeholder="Enter Postal Code" required>
				        <span class="input-group-btn">
				            <button type="button" class="btn btn-info" onclick="checkDelivery()">Check Delivery</button>
				        </span>
				    </div>
				</div>
				
				<div id="chatbot-box" style="display:none; margin-top:12px; margin-bottom:12px; padding:15px; border:1px solid #e6e6e6; border-radius:10px; background:#fafafa;">
				    <!-- Chat messages will stack here -->
				</div>
				
				<input type="hidden" id="deliveryFee" name="deliveryFee" value="0">
				<input type="hidden" id="waitingDays" name="waitingDays" value="0">
				<input type="hidden" id="postalCodeHidden" name="postalCodeHidden" value="">
				<input type="hidden" id="deliveryAddressHidden" name="deliveryAddressHidden" value="">
				
				<!-- NEW: single product forwarding -->
  				<input type="hidden" id="singlePid" name="singlePid" value="<%= request.getParameter("singlePid") != null ? request.getParameter("singlePid") : "" %>">
  				<input type="hidden" id="singleQty" name="singleQty" value="<%= request.getParameter("singleQty") != null ? request.getParameter("singleQty") : "1" %>">

                <!-- Total Amount Row -->
				<div class="row">
				    <div class="col-xs-12 text-right" style="margin-bottom: 15px;">
				        <strong>Total Amount: <span id="totalAmount"><%=amount%> MMK</span></strong>
				    </div>
				</div>
				
				<!-- CVV + Place Order Row -->
				<div class="row">
				    <div class="col-xs-6 form-group">
				        <label>CVV</label>
				        <input type="password" name="cvv" class="form-control" placeholder="123" required>
				        <input type="hidden" id="finalAmount" name="amount" value="<%=amount%>">
				    </div>
				    <div class="col-xs-6 form-group text-right">
				        <button type="submit" id="payBtn" class="btn btn-success btn-block btn-pay" style="margin-top: 20px;">
				            Place Order
				        </button>
				    </div>
				</div>
            </form>
        </div>
    </div>
</div>

<%@ include file="footer.html"%>

	<script>
	$(document).ready(function () {
	    // Smooth scroll to the payment form and center it vertically
	    $('html, body').animate({
	        scrollTop: $(".payment-card").offset().top - ($(window).height() - $(".payment-card").outerHeight())/2
	    }, 400);
	});
	
	  // Base product amount from server
	  var baseAmount = <%= (sAmount != null ? sAmount : "0") %>;
	  var lastAreaName = ""; // NEW

	  function pushMsg(html, right) {
	      var align = right ? 'text-right' : 'text-left';
	      $("#chatbot-box").show().append(
	        '<div class="'+align+'" style="margin:6px 0;">' +
	          '<span style="display:inline-block;padding:10px 12px;border-radius:14px;'+
	          (right ? 'background:#d1f7d6;' : 'background:#e9ecf1;') +
	          '">'+ html +'</span>' +
	        '</div>'
	      );
	      $("#chatbot-box").scrollTop($("#chatbot-box")[0].scrollHeight);
	  }

	  function checkDelivery() {
	      var postalCode = $("#postalCode").val().trim();
	      if (!postalCode) { pushMsg("Please enter a postal code.", false); return; }

	      pushMsg("Checking delivery for postal code <b>" + $('<div/>').text(postalCode).html() + "</b>", true);

	      $.ajax({
	          url: "checkDeliveryAjax",
	          type: "GET",
	          dataType: "json",
	          data: { postalCode: postalCode },
	          success: function(data) {
	        	  if (data.available) {
	        	      lastAreaName = data.areaName || "";
	        	      pushMsg(
	        	        "Delivery <b>available</b>.<br>" +
	        	        "Area: <b>" + (lastAreaName || "Unknown") + "</b><br>" +
	        	        "Fee: <b>" + data.fee + " MMK</b><br>" +
	        	        "Estimated waiting time: <b>" + data.waitingDays + " day(s)</b><br>" +
	        	        "Would you like to include the delivery fee in your payment?<br>" +
	        	        "<button type='button' class='btn btn-success btn-sm' style='margin-top:6px' " +
	        	        "onclick='includeDelivery("+data.fee+","+data.waitingDays+")'>Yes, add it</button> " +
	        	        "<button type='button' class='btn btn-default btn-sm' style='margin-top:6px' " +
	        	        "onclick='skipDelivery()'>No, skip</button>"
	        	      , false);
	        	  } else {
	        	      	lastAreaName = "";
	            	    pushMsg(
	            	    	      "Sorry, delivery is not available for that postal code.<br>" +
	            	    	      "What would you like to do?<br>" +
	            	    	      "<button type='button' class='btn btn-info btn-sm' style='margin-top:6px' " +
	            	    	      "onclick='reEnterPostal()'>Re-enter Postal Code</button> " +
	            	    	      "<button type='button' class='btn btn-default btn-sm' style='margin-top:6px' " +
	            	    	      "onclick='skipDelivery()'>Skip Delivery & Proceed</button>"
	            	    	    , false);

	            	    	    $("#deliveryFee").val(0);
	            	    	    $("#waitingDays").val(0);
	            	    	    $("#finalAmount").val(baseAmount);
	            	    	    $("#totalAmount").html(baseAmount + " MMK");
	            	    	}
	          },
	          error: function() {
	              pushMsg("Something went wrong while checking delivery.<br> Please try again.", false);
	          }
	      });
	  }

	  function includeDelivery(fee, waiting) {
	      $("#deliveryFee").val(fee);
	      $("#waitingDays").val(waiting);

	      var postal = $("#postalCode").val().trim();
	      $("#postalCodeHidden").val(postal);

	      var composed = (lastAreaName ? lastAreaName : "Postal Area") + " (" + postal + ")";
	      $("#deliveryAddressHidden").val(composed);

	      var total = Number(baseAmount) + Number(fee);
	      $("#finalAmount").val(total);
	      $("#totalAmount").html(total + " MMK");

	      pushMsg("Added delivery fee of <b>" + fee + " MMK</b> to <b>" + composed + "</b>.<br> New total: <b>" + total + " MMK</b>.", true);
	  }

	  function skipDelivery() {
	      $("#deliveryFee").val(0);
	      $("#waitingDays").val(0);
	      $("#postalCodeHidden").val("");
	      $("#deliveryAddressHidden").val("");

	      $("#finalAmount").val(baseAmount);
	      $("#totalAmount").html(baseAmount + " MMK");

	      pushMsg("Skipped delivery fee.<br> Total stays at <b>" + baseAmount + " MMK</b>.", true);
	  }
	  
	  function reEnterPostal() {
		    pushMsg("Please enter a new postal code.", true);
		    $("#postalCode").val("").focus();
		}
	
	</script>

</body>
</html>
