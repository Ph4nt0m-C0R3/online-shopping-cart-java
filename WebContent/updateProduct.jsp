<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
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
  /* Always keep preview image small & centered */
  .preview-img {
    height: 100px !important;   /* your previous size */
    width: auto;
    display: block;
    margin: 0 auto;
  }
</style>

<body>
	<%
	/* Checking the user credentials */
	String utype = (String) session.getAttribute("usertype");
	String uname = (String) session.getAttribute("username");
	String pwd = (String) session.getAttribute("password");
	String prodid = request.getParameter("prodid");
	ProductBean product = new ProductServiceImpl().getProductDetails(prodid);
	if (prodid == null || product == null) {
		response.sendRedirect("updateProductById.jsp?message=Please Enter a valid product Id");
		return;
	} else if (utype == null || !utype.equals("admin")) {
		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");
		return;
	} else if (uname == null || pwd == null) {
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
			<form action="./UpdateProductSrv" method="post" enctype="multipart/form-data" id="updateForm"
				class="col-md-6 col-md-offset-3"
				style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
				<div style="font-weight: bold;" class="text-center">
					<div class="form-group">
						<h2 style="color: #b07fb5;">Product Update Form</h2>
					</div>

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
				<div class="row">
					<input type="hidden" name="pid" class="form-control"
						value="<%=product.getProdId()%>" id="last_name" required>
						
					<div class="form-group text-center">
					    <div class="row">
							<div class="col-xs-12 text-center">
								<!-- Current Product Image (preview) -->
								<img id="previewImage"
										src="./ShowImage?pid=<%=product.getProdId()%>"
										alt="Product Image"
										class="preview-img" />
						
								<!-- File Input, centered and not too wide -->
								<div class="form-group" style="max-width:300px; margin:10px auto 0;">
									<label for="productImage" class="control-label" style="display:block;">Change Product Image</label>
									<input type="file" name="productImage" id="productImage"
												class="form-control center-block" accept="image/*">
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-6 form-group">
						<label for="last_name">Product Name</label> <input type="text"
							placeholder="Enter Product Name" name="name" class="form-control"
							value="<%=product.getProdName()%>" id="last_name" required>
					</div>
					<div class="col-md-6 form-group">
						<%
						String ptype = product.getProdType();
						%>
						<label for="producttype">Product Type</label> <select name="type"
							id="producttype" class="form-control" required>
							<option value="makeup"
								<%="makeup".equalsIgnoreCase(ptype) ? "selected" : ""%>>MAKEUP</option>
							<option value="skin-care"
								<%="skin-care".equalsIgnoreCase(ptype) ? "selected" : ""%>>SKIN CARE</option>
							<option value="hair-care"
								<%="hair-care".equalsIgnoreCase(ptype) ? "selected" : ""%>>HAIR CARE</option>
							<option value="roll-on"
								<%="roll-on".equalsIgnoreCase(ptype) ? "selected" : ""%>>ROLL ON</option>
							<option value="perfume"
								<%="perfume".equalsIgnoreCase(ptype) ? "selected" : ""%>>PERFUME</option>
							<option value="lotion"
								<%="lotion".equalsIgnoreCase(ptype) ? "selected" : ""%>>LOTION</option>
							<option value="other"
								<%="other".equalsIgnoreCase(ptype) ? "selected" : ""%>>Some
								Other Appliances</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="last_name">Product Description</label>
					<textarea name="info" class="form-control text-align-left"
						id="last_name" required><%=product.getProdInfo()%></textarea>
				</div>
				<div class="row">
					<div class="col-md-6 form-group">
						<label for="last_name">Unit Price</label> <input type="number"
							value="<%=product.getProdPrice()%>"
							placeholder="Enter Unit Price" name="price" class="form-control"
							id="last_name" required>
					</div>
					<div class="col-md-6 form-group">
						<label for="last_name">Stock Quantity</label> <input type="number"
							value="<%=product.getProdQuantity()%>"
							placeholder="Enter Stock Quantity" class="form-control"
							id="last_name" name="quantity" required>
					</div>
				</div>
				<div class="row text-center">
					<div class="col-xs-6">
				        <button formaction="adminStock.jsp" 
				                class="btn btn-danger" 
				                style="min-width: 100px;">
				            Cancel
				        </button>
				    </div>
				    <div class="col-xs-6">
				        <button type="submit" 
				                class="btn btn-success" 
				                style="min-width: 100px;">
				            Update Product
				        </button>
				    </div>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="footer.html"%>
	
	<script>
		document.getElementById("productImage").addEventListener("change", function (event) {
		  const file = event.target.files[0];
		  if (!file) return;
		
		  // Optional lightweight validation
		  if (!file.type.startsWith("image/")) {
		    alert("Please select an image file.");
		    event.target.value = "";
		    return;
		  }
		  // Example 5MB limit to match server config below
		  if (file.size > 5 * 1024 * 1024) {
		    alert("Image too large (max 5MB).");
		    event.target.value = "";
		    return;
		  }
		
		  const reader = new FileReader();
		  reader.onload = function (e) {
		    document.getElementById("previewImage").src = e.target.result;
		  };
		  reader.readAsDataURL(file);
		});
		
		// Scroll to form on page load
	    window.onload = function() {
		  document.getElementById("updateForm").scrollIntoView({ behavior: "smooth" });
		};

	</script>
</body>
</html>