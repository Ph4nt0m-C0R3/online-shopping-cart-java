<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Remove Product</title>
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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<style>
	/* Button container: make it flex for RemoveProduct */
	form[action="./RemoveProductSrv"] .row:last-child {
	    display: flex;
	    justify-content: center;
	    gap: 16px;    /* space between buttons */
	    margin-top: 10px;
	}
	
	/* Buttons: consistent size and style */
	form[action="./RemoveProductSrv"] .btn {
	    border-radius: 6px;
	    padding: 8px 18px;
	    font-size: 14px;
	    font-weight: 600;
	    border: none;
	    transition: all 0.3s ease;
	    min-width: 120px;
	}
	
	/* Cancel button (blue gradient, same as Add Product submit) */
	form[action="./RemoveProductSrv"] .btn-info {
	    background: linear-gradient(135deg, #4a90e2, #357ab8);
	    color: #fff;
	}
	form[action="./RemoveProductSrv"] .btn-info:hover {
	    background: linear-gradient(135deg, #357ab8, #2c5f8a);
	    box-shadow: 0 3px 8px rgba(53,122,184,0.25);
	}
	
	/* Remove button (neutral gray gradient, same as Add Product reset) */
	form[action="./RemoveProductSrv"] .btn-danger {
	    background: linear-gradient(135deg, #95a5a6, #7f8c8d);
	    color: #fff;
	}
	form[action="./RemoveProductSrv"] .btn-danger:hover {
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

		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

	}

	else if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}
	%>

	<jsp:include page="header.jsp" />

	<%
	String message = request.getParameter("message");
	%>
	<div class="container">
		<div class="row"
			style="margin-top: 5px; margin-left: 2px; margin-right: 2px;">
			<form action="./RemoveProductSrv" method="post"
				class="col-md-4 col-md-offset-4"
				style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
				<div style="font-weight: bold;" class="text-center">
					<h3 style="color: #b07fb5;">Product Deletion Form</h3>
					<%
					if (message != null) {
					    boolean isSuccess = message.toLowerCase().contains("success");
					%>
					<script>
					    Swal.fire({
					        title: "<%= isSuccess ? "Product Successfully Removed!" : "Error" %>",
					        text: "<%= message %>",
					        icon: "<%= isSuccess ? "success" : "error" %>",
					        confirmButtonText: "OK"
					    });
					</script>
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
						<button type="submit" class="btn btn-danger">Remove
							Product</button>
					</div>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="footer.html"%>
	
	<script>
		document.querySelector('form[action="./RemoveProductSrv"]').addEventListener("submit", function (e) {
		    e.preventDefault(); // stop default form submit
		    let form = this;
		    Swal.fire({
		        title: "Are you sure?",
		        text: "This will permanently remove the product.",
		        icon: "warning",
		        showCancelButton: true,
		        confirmButtonColor: "#d33",
		        cancelButtonColor: "#3085d6",
		        confirmButtonText: "Yes, delete it!"
		    }).then((result) => {
		        if (result.isConfirmed) {
		            form.submit(); // proceed with deletion
		        }
		    });
		});
	</script>
	
</body>
</html>