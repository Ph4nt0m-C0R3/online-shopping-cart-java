<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Add Product</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/png" href="images/SC.png">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="css/changes.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
	/* Card style like register.jsp */
	form[action="./AddProductSrv"] {
	    background: #fff;
	    border-radius: 15px;
	    padding: 30px 25px;
	    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
	    transition: transform 0.3s ease, box-shadow 0.3s ease;
	    margin-top: 80px;
	    border: none !important;
	}
	form[action="./AddProductSrv"]:hover {
	    transform: translateY(-5px);
	    box-shadow: 0 12px 25px rgba(0,0,0,0.2);
	}
	
	/* Title */
	form[action="./AddProductSrv"] h2 {
	    font-weight: bold;
	    color: #4a90e2; /* blue accent (different from register pink) */
	    margin-bottom: 20px;
	}
	
	/* Messages */
	form[action="./AddProductSrv"] p {
	    font-size: 14px;
	    margin-bottom: 10px;
	    font-weight: 500;
	    color: #4a90e2;
	}
	
	/* Inputs */
	form[action="./AddProductSrv"] .form-control {
	    border-radius: 8px;
	    border: 1px solid #ddd;
	    box-shadow: none;
	    transition: border-color 0.3s, box-shadow 0.3s;
	}
	form[action="./AddProductSrv"] .form-control:focus {
	    border-color: #4a90e2;
	    box-shadow: 0 0 6px rgba(74,144,226,0.4);
	}
	
	/* Image preview */
	#preview {
	    border: 1px solid #ddd;
	    border-radius: 10px;
	    margin: 10px auto;
	    max-width: 100%;
	    max-height: 160px;
	    object-fit: contain;
	    display: none;
	    background: #f9f9f9;
	    padding: 5px;
	}
	
	/* Button container: make it flex */
	form[action="./AddProductSrv"] .row:last-child {
	    display: flex;
	    justify-content: center;  /* center align horizontally */
	    gap: 16px;                /* space between buttons */
	    margin-top: 10px;
	}
	
	/* Buttons: smaller, balanced */
	form[action="./AddProductSrv"] .btn {
	    border-radius: 6px;
	    padding: 8px 18px;
	    font-size: 14px;
	    font-weight: 600;
	    border: none;
	    transition: all 0.3s ease;
	    min-width: 120px;          /* keeps them balanced in size */
	}
	
	/* Submit (blue gradient) */
	form[action="./AddProductSrv"] .btn-success {
	    background: linear-gradient(135deg, #4a90e2, #357ab8);
	    color: #fff;
	}
	form[action="./AddProductSrv"] .btn-success:hover {
	    background: linear-gradient(135deg, #357ab8, #2c5f8a);
	    box-shadow: 0 3px 8px rgba(53,122,184,0.25);
	}
	
	/* Reset (neutral gray gradient) */
	form[action="./AddProductSrv"] .btn-danger {
	    background: linear-gradient(135deg, #95a5a6, #7f8c8d);
	    color: #fff;
	}
	form[action="./AddProductSrv"] .btn-danger:hover {
	    background: linear-gradient(135deg, #7f8c8d, #626d70);
	    box-shadow: 0 3px 8px rgba(127,140,141,0.25);
	}
</style>

<script>
	function previewImage(event) {
		var reader = new FileReader();
		reader.onload = function () {
			var output = document.getElementById('preview');
			output.src = reader.result;
			output.style.display = "block";
		};
		reader.readAsDataURL(event.target.files[0]);
	}
</script>

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

	<%
	String message = request.getParameter("message");
	%>
	<div class="container">
		<div class="row"
			style="margin-top: 5px; margin-left: 2px; margin-right: 2px;">
			<form action="./AddProductSrv" method="post"
				enctype="multipart/form-data" class="col-md-6 col-md-offset-3 product-card"
				style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
				<div style="font-weight: bold;" class="text-center">
					<h2 style="color: #b07fb5;">Product Addition Form</h2>
					<%
					if (message != null) {
					    boolean isSuccess = message.contains("Successfully");
					    String prodId = "";
					    if (isSuccess && message.contains("Product Id:")) {
					        prodId = message.substring(message.lastIndexOf(":") + 1).trim();
					    }
					%>
					<script>
					    Swal.fire({
					        title: "<%= isSuccess ? "Product Successfully Added!" : "Error" %>",
					        text: "<%= isSuccess ? "Product ID: " + prodId : message %>",
					        icon: "<%= isSuccess ? "success" : "error" %>",
					        confirmButtonText: "OK"
					    });
					</script>
					<%
					}
					%>
				</div>
				
				<!-- Product Image Upload + Preview -->
				<div class="form-group text-center">
					<label for="productImage">Product Image</label>
					<img id="preview" alt="Image Preview" />
					<input type="file" name="image" class="form-control"
						id="productImage" accept="image/*" onchange="previewImage(event)" required>
				</div>
				
				<div class="row">
					<div class="col-md-6 form-group">
						<label for="productName">Product Name</label>
						<input type="text" placeholder="Enter Product Name" name="name"
							class="form-control" id="productName" required>
					</div>
					<div class="col-md-6 form-group">
						<label for="producttype">Product Type</label>
						<select name="type" id="producttype" class="form-control" required>
							<option value="makeup">MAKEUP</option>
							<option value="skin-care">SKIN CARE</option>
							<option value="hair-care">HAIR CARE</option>
							<option value="roll-on">ROLL ON</option>
							<option value="perfume">PERFUME</option>
							<option value="lotion">LOTION</option>
							<option value="other">Some Other Appliances</option>
						</select>
					</div>
				</div>

				<div class="form-group">
					<label for="productDescription">Product Description</label>
					<textarea name="info" class="form-control" id="productDescription" required></textarea>
				</div>

				<div class="row">
					<div class="col-md-6 form-group">
					    <label for="price">Unit Price</label>
					    <input type="number" placeholder="Enter Unit Price" name="price"
					        class="form-control" id="price" min="1" step="0.01" required>
					</div>
					<div class="col-md-6 form-group">
					    <label for="quantity">Stock Quantity</label>
					    <input type="number" placeholder="Enter Stock Quantity" name="quantity"
					        class="form-control" id="quantity" min="1" step="1" required>
					</div>
				</div>

				<div class="row">
					<div class="col-md-6 text-center" style="margin-bottom: 2px;">
						<button type="reset" class="btn btn-danger">Reset</button>
					</div>
					<div class="col-md-6 text-center">
						<button type="submit" class="btn btn-success">Add Product</button>
					</div>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="footer.html"%>
	
	<script>
		// Reset preview when form is reset
	    document.querySelector('form[action="./AddProductSrv"]').addEventListener("reset", function () {
	        var preview = document.getElementById("preview");
	        var fileInput = document.getElementById("productImage");
	
	        // Clear image preview
	        preview.src = "";
	        preview.style.display = "none";
	
	        // Clear file input
	        fileInput.value = "";
	
	        // Scroll back to top smoothly
	        window.scrollTo({ top: 230, behavior: 'smooth' });
	    });
		
	    $(document).ready(function () {
		    // Smooth scroll to product form
		    $('html, body').animate({
		        scrollTop: $(".product-card").offset().top - ($(window).height() - $(".product-card").outerHeight())/2
		    }, 400);
		});
	</script>
</body>
</html>