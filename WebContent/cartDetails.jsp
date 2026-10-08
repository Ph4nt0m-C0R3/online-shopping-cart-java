<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Cart Details</title>
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
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>

<style>
	/* ----- General Page Styling ----- */
	body {
	  background-color: #fdf6f9; /* soft pastel background */
	  font-family: 'Helvetica Neue', Arial, sans-serif;
	  color: #444;
	}
	
	.text-center {
	  color: #b07fb5 !important; /* cosmetic purple */
	  font-size: 26px !important;
	  font-weight: bold !important;
	  margin-bottom: 20px;
	}
	
	/* ----- Table Styling ----- */
	.table {
	  background: #fff;
	  border-radius: 12px;
	  overflow: hidden;
	  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
	}
	
	.table > thead {
	  background: linear-gradient(to right, #b07fb5, #e67ab7);
	  color: #fff;
	  font-size: 15px;
	  text-transform: uppercase;
	}
	
	.table > tbody > tr {
	  transition: background 0.3s ease;
	}
	
	.table > tbody > tr:hover {
	  background-color: #fceaf6;
	}
	
	/* Product images */
	.table img {
	  width: 60px;
	  height: 60px;
	  border-radius: 10px;
	  object-fit: cover;
	  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
	}
	
	/* Quantity input + update button */
	input[type="number"] {
	  border-radius: 6px;
	  padding: 4px;
	  border: 1px solid #ddd;
	  text-align: center;
	}
	
	input[type="submit"],
	button {
	  border-radius: 20px !important;
	  padding: 5px 15px;
	  font-weight: bold;
	  transition: all 0.3s ease;
	}
	
	/* Action buttons - perfectly centered in circles */
	a .fa-plus,
	a .fa-minus {
	  font-size: 18px;           /* good size for visibility */
	  width: 40px;               /* circle size */
	  height: 40px;
	  border-radius: 50%;
	  color: #fff;
	  display: flex;             /* modern centering */
	  align-items: center;       /* vertical centering */
	  justify-content: center;   /* horizontal centering */
	  transition: 0.3s;
	  margin: 0 auto;
	}
	
	/* Plus = lavender */
	a .fa-plus {
	  background-color: #9370db;
	}
	a .fa-plus:hover {
	  background-color: #7b5bbd;
	}
	
	/* Minus = pink */
	a .fa-minus {
	  background-color: #e67ab7;
	}
	a .fa-minus:hover {
	  background-color: #d65ca4;
	}
	
	/* Remove underline on links wrapping icons */
	a {
	  text-decoration: none !important;
	}
	
	a:hover, 
	a:focus {
	  text-decoration: none !important;
	}
	
	/* Table text alignment */
	.table th,
	.table td {
	  text-align: center;
	  vertical-align: middle !important;
	}
	
	/* Total Row */
	.table tr:last-child {
	  background: #ffeaf2 !important;
	  color: #444 !important;
	  font-weight: bold;
	  font-size: 16px;
	}
	
	/* ===== Unified Back + Pay Now styles ===== */
	button[formaction="userHome.jsp"],
	button[formaction^="payment.jsp"],
	.btn-action {
	  background: linear-gradient(135deg, #b07fb5, #e67ab7) !important;
	  color: #fff !important;
	  border: none;
	  border-radius: 20px !important;
	  padding: 8px 16px;
	  font-weight: bold;
	  transition: background 0.25s ease;
	}
	
	button[formaction="userHome.jsp"]:hover,
	button[formaction^="payment.jsp"]:hover,
	.btn-action:hover {
	  background: linear-gradient(135deg, #9a68a5, #d65ca4) !important;
	}
	
	/* ---- Mobile Friendly Layout ---- */
	@media (max-width: 768px) {
	  .table-responsive {
	    display: none; /* hide table on mobile */
	  }
	
	  .cart-cards {
	    display: block;
	  }
	
	  .cart-card {
	    background: #fff;
	    border-radius: 16px;         /* ⬅️ more rounded corners */
	    box-shadow: 0 3px 10px rgba(0,0,0,0.1);
	    padding: 16px;               /* ⬅️ more inner spacing */
	    margin: 0px 14px 12px;                /* ⬅️ margin around card */
	    text-align: center;
	  }
	
	  .cart-card img {
	    width: 80px;
	    height: 80px;
	    border-radius: 10px;
	    object-fit: cover;
	    margin: 0 auto 10px; /* ✅ center image */
	    display: block;
	  }
	
	  .cart-card h5,
	  .cart-card .price {
	    text-align: center; /* ✅ center name + price */
	  }
	
	  .cart-card .actions {
	    display: flex;
	    justify-content: center; /* ✅ center all buttons together */
	    align-items: center;
	    gap: 8px; /* ✅ small spacing between +, qty/update, - */
	    margin-top: 10px;
	  }
	
	  .cart-card .qty-update {
	    display: flex;
	    align-items: center;
	    gap: 5px;
	  }
	
	  .cart-card .qty-update input[type="number"] {
	    width: 60px;
	    text-align: center;
	  }
	
	  .cart-card .action-btn i {
	    width: 35px;
	    height: 35px;
	    font-size: 16px;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	  }
	
	  .cart-card a .fa-plus,
	  .cart-card a .fa-minus {
	    width: 35px;
	    height: 35px;
	    font-size: 16px;
	  }
	}
	
	/* ---- Desktop ---- */
	@media (min-width: 769px) {
	  .cart-cards {
	    display: none; /* hide cards on desktop */
	  }
	}
	
	/* ---- Mobile Bottom Bar ---- */
	@media (max-width: 768px) {
	  .mobile-checkout-bar {
	    position: fixed;
	    bottom: 0;
	    left: 0;
	    right: 0;
	    background: #ffeaf2;
	    color: #000;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    padding: 12px 15px;
	    box-shadow: 0 -2px 6px rgba(0,0,0,0.1);
	    z-index: 1000;
	  }
	
	  .mobile-checkout-bar .total {
	    font-weight: bold;
	    font-size: 15px;
	  }
	
	  .mobile-checkout-bar .btn {
	    border-radius: 20px;
	    font-weight: bold;
	    padding: 6px 14px;
	    border: none;
	  }
	
	  .mobile-checkout-bar .btn-back {
	    background: #444;
	    color: #fff;
	  }
	
	  .mobile-checkout-bar .btn-pay {
	    background: #007bff;
	    color: #fff;
	  }
	}
	
	/* hide this on desktop */
	@media (min-width: 769px) {
	  .mobile-checkout-bar {
	    display: none;
	  }
	}
</style>

<body>

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}

	String addS = request.getParameter("add");
	if (addS != null) {

		int add = Integer.parseInt(addS);
		String uid = request.getParameter("uid");
		String pid = request.getParameter("pid");
		int avail = Integer.parseInt(request.getParameter("avail"));
		int cartQty = Integer.parseInt(request.getParameter("qty"));
		CartServiceImpl cart = new CartServiceImpl();

		if (add == 1) {
			//Add Product into the cart
			cartQty += 1;
			if (cartQty <= avail) {
		cart.addProductToCart(uid, pid, 1);
			} else {
		response.sendRedirect("./AddtoCart?pid=" + pid + "&pqty=" + cartQty);
			}
		} else if (add == 0) {
			//Remove Product from the cart
			cart.removeProductFromCart(uid, pid);
		}
	}
	%>



	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: #b07fb5; font-size: 24px; font-weight: bold; margin-bottom: 10px;">Cart
		Items</div>
	<!-- <script>document.getElementById('mycart').innerHTML='<i data-count="20" class="fa fa-shopping-cart fa-3x icon-white badge" style="background-color:#333;margin:0px;padding:0px; margin-top:5px;"></i>'</script>
 -->
	<!-- Start of Product Items List -->
	<div class="container">
		<div class="table-responsive"> <!-- Added -->
			<table class="table table-hover">
				<thead
					style="background-color: #186188; color: white; font-size: 16px; font-weight: bold;">
					<tr>
						<th>Picture</th>
						<th>Products</th>
						<th>Price</th>
						<th>Quantity</th>
						<th>Remove</th>
						<th>Add</th>
						<th>Amount</th>
					</tr>
				</thead>
				<tbody
					style="background-color: white; font-size: 15px; font-weight: bold;">
	
	
	
					<%
					CartServiceImpl cart = new CartServiceImpl();
					List<CartBean> cartItems = new ArrayList<CartBean>();
					cartItems = cart.getAllCartItems(userName);
					double totAmount = 0;
					for (CartBean item : cartItems) {
	
						String prodId = item.getProdId();
	
						int prodQuantity = item.getQuantity();
	
						ProductBean product = new ProductServiceImpl().getProductDetails(prodId);
	
						double currAmount = product.getProdPrice() * prodQuantity;
	
						totAmount += currAmount;
	
						if (prodQuantity > 0) {
					%>
	
					<tr>
						<td><img src="./ShowImage?pid=<%=product.getProdId()%>"
							style="width: 50px; height: 50px;"></td>
						<td><%=product.getProdName()%></td>
						<td><%=product.getProdPrice()%></td>
						<td><form method="post" action="./UpdateToCart">
								<input type="number" name="pqty" value="<%=prodQuantity%>"
									style="max-width: 70px;" min="0"> <input type="hidden"
									name="pid" value="<%=product.getProdId()%>"> <input
									type="submit" name="Update" value="Update"
									style="max-width: 80px;">
							</form></td>
						<td><a
							href="cartDetails.jsp?add=0&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQuantity%>"><i
								class="fa fa-minus"></i></a></td>
						<td><a
							href="cartDetails.jsp?add=1&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQuantity%>"><i
								class="fa fa-plus"></i></a></td>
						<td><%=currAmount%></td>
					</tr>
	
					<%
					}
					}
					%>
	
					<tr style="background-color: grey; color: white;">
						<td colspan="6" style="text-align: center;">Total Amount to
							Pay (in MMK)</td>
						<td><%=totAmount%></td>
					</tr>
					<%
					if (totAmount != 0) {
					%>
					<tr style="background-color: grey; color: white;">
						<td colspan="4" style="text-align: center;">
						<td><form method="post">
								<button formaction="userHome.jsp"
									style="background-color: black; color: white;">Back</button>
							</form></td>
						<td colspan="2" align="center"><form method="post">
								<button style="background-color: blue; color: white;"
									formaction="payment.jsp?amount=<%=totAmount%>">Pay Now</button>
							</form></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
	</div>
	<!-- End of Product Items List -->
	
	<!-- For Mobile -->
	<div class="cart-cards">
	  <%
	    for (CartBean item : cartItems) {
	      String prodId = item.getProdId();
	      int prodQuantity = item.getQuantity();
	      ProductBean product = new ProductServiceImpl().getProductDetails(prodId);
	      double currAmount = product.getProdPrice() * prodQuantity;
	  %>
	  <div class="cart-card">
	    <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product">
	    <h5><%=product.getProdName()%></h5>
	    <div class="price">Price: <%=product.getProdPrice()%> MMK</div>
	    <div class="actions">
		  <a href="cartDetails.jsp?add=0&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQuantity%>" class="action-btn">
		    <i class="fa fa-minus"></i>
		  </a>
		
		  <form method="post" action="./UpdateToCart" class="qty-update">
		    <input type="number" name="pqty" value="<%=prodQuantity%>" min="0">
		    <input type="hidden" name="pid" value="<%=product.getProdId()%>">
		    <input type="submit" value="Update" class="btn btn-xs btn-info">
		  </form>
		  
		  <a href="cartDetails.jsp?add=1&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQuantity%>" class="action-btn">
		    <i class="fa fa-plus"></i>
		  </a>
		</div>
	    <div style="margin-top:10px; font-weight:bold;">
	      Amount: <%=currAmount%> MMK
	    </div>
	  </div>
	  <% } %>
	</div>
	
	<%
	  if (totAmount != 0) {
	%>
	<div class="mobile-checkout-bar">
	  <div class="total">Total: <%=totAmount%> MMK</div>
	  <div>
	    <form method="post" style="display:inline;">
	      <button formaction="userHome.jsp" class="btn btn-back">Back</button>
	    </form>
	    <form method="post" style="display:inline;">
	      <button formaction="payment.jsp?amount=<%=totAmount%>" class="btn btn-pay">Pay Now</button>
	    </form>
	  </div>
	</div>
	<%
	  }
	%>

	<%@ include file="footer.html"%>

</body>
</html>