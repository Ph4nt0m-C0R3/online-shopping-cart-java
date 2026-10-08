<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Product Stocks</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/png" href="images/SC.png">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body>
	<%
	/* Checking the user credentials */
	String userType = (String) session.getAttribute("usertype");
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

	}

	else if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}
	%>

	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: #b07fb5; font-size: 24px; font-weight: bold; margin-bottom: 10px;">Stock
		Products</div>
	<div class="container-fluid">
		<div class="table-responsive ">
			<table class="table table-hover table-sm">
				<thead
					style="background-color: #2c6c4b; color: white; font-size: 18px;">
					<tr>
						<th>Image</th>
						<th>Product ID</th>
						<th>Name</th>
						<th>Type</th>
						<th>Price</th>
						<th>Sold Qty</th>
						<th>Stock Qty</th>
						<th colspan="2" style="text-align: center">Actions</th>
					</tr>
				</thead>
				<tbody id="stockList">
				    <jsp:include page="stockList.jsp" />
				</tbody>
			</table>
		</div>
	</div>

	<%@ include file="footer.html"%>
	
	<script>
	$(document).ready(function () {
	    $(".search-form").on("submit", function (e) {
	        e.preventDefault();
	    });

	    $("#searchBox").on("keyup", function () {
	        let query = $(this).val();

	        if (window.location.pathname.indexOf("adminStock.jsp") !== -1) {
	            clearTimeout(window.typingTimer);
	            window.typingTimer = setTimeout(function () {
	                $.ajax({
	                    url: "stockList.jsp",
	                    type: "GET",
	                    data: { search: query },
	                    success: function (data) {
	                        $("#stockList").html(data);
	                    }
	                });
	            }, 300);
	        } else {
	            // existing code for products.jsp
	            clearTimeout(window.typingTimer);
	            window.typingTimer = setTimeout(function () {
	                $.ajax({
	                    url: "products.jsp",
	                    type: "GET",
	                    data: { search: query },
	                    success: function (data) {
	                        $("#productList").html(data);
	                    }
	                });
	            }, 300);
	        }
	    });
	});
	</script>
</body>
</html>