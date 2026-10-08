<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Update Product</title>
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

<style>
	/* Button container: flex with spacing */
	form[action="./RemoveProductSrv"] .row:last-child,
	form[action="updateProduct.jsp"] .row:last-child {
	    display: flex;
	    justify-content: center; /* center buttons */
	    gap: 16px;               /* space between */
	    margin-top: 10px;
	}
	
	/* Buttons: smaller, modern look */
	form[action="./RemoveProductSrv"] .btn,
	form[action="updateProduct.jsp"] .btn {
	    border-radius: 6px;
	    padding: 8px 18px;
	    font-size: 14px;
	    font-weight: 600;
	    border: none;
	    transition: all 0.3s ease;
	    min-width: 120px;  /* balanced sizing */
	}
	
	/* Cancel button (blue gradient, like success in AddProduct) */
	form[action="./RemoveProductSrv"] .btn-info,
	form[action="updateProduct.jsp"] .btn-info {
	    background: linear-gradient(135deg, #4a90e2, #357ab8);
	    color: #fff;
	}
	form[action="./RemoveProductSrv"] .btn-info:hover,
	form[action="updateProduct.jsp"] .btn-info:hover {
	    background: linear-gradient(135deg, #357ab8, #2c5f8a);
	    box-shadow: 0 3px 8px rgba(53,122,184,0.25);
	}
	
	/* Action button (danger) with gray gradient */
	form[action="./RemoveProductSrv"] .btn-danger,
	form[action="updateProduct.jsp"] .btn-danger {
	    background: linear-gradient(135deg, #95a5a6, #7f8c8d);
	    color: #fff;
	}
	form[action="./RemoveProductSrv"] .btn-danger:hover,
	form[action="updateProduct.jsp"] .btn-danger:hover {
	    background: linear-gradient(135deg, #7f8c8d, #626d70);
	    box-shadow: 0 3px 8px rgba(127,140,141,0.25);
	}
</style>

<body>
	<%
	/* Checking the user credentials */
	String userType = (String) session.getAttribute("usertype");
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userType == null || !userType.equals("admin")) {
		response.sendRedirect("login.jsp?message=Access Denied, Login As Admin!!");
		return;

	} else if (userName == null || password == null) {
		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
		return;
	}
	%>

	<jsp:include page="header.jsp" />

	<%
	String message = request.getParameter("message");
	%>
	<div class="container">
		<div class="row"
			style="margin-top: 5px; margin-left: 2px; margin-right: 2px;">
			<form action="updateProduct.jsp" method="post"
				class="col-md-4 col-md-offset-4"
				style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
				<div style="font-weight: bold;" class="text-center">
					<h3 style="color: #b07fb5;">Product Update Form</h3>
					<%
					if (message != null) {
					%>
					<p style="color: blue;">
						<%=message%>
					</p>
					<%
					}
					%>
				</div>
				<div></div>
				<div class="row">
					<div class="col-md-12 form-group">
						<label for="last_name">Product Id</label> <input type="text"
							placeholder="Enter Product Id" name="prodid" class="form-control"
							id="last_name" required>
					</div>
				</div>
				<div class="row">
					<div class="col-md-6 text-center" style="margin-bottom: 2px;">
						<a href="adminViewProduct.jsp" class="btn btn-info">Cancel</a>
					</div>
					<div class="col-md-6 text-center">
						<button type="submit" class="btn btn-danger">Update
							Product</button>
					</div>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="footer.html"%>
</body>
</html>