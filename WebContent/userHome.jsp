<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Smart Care Cosmetics</title>
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
	/* Hide floating cart on desktop by default */
	.cart-fab { display: none; }
	.cart-nav-item { display: block; }

	@media (max-width: 1200px) {
	  .cart-nav-item { display: none !important; }

	  .cart-fab {
		  position: fixed !important;
		  right: 25px;
		  bottom: 25px;
		  width: 56px;
		  height: 56px;
		  border-radius: 50%;
		  background: #ffffff;
		  box-shadow: 0 6px 16px rgba(0,0,0,0.25);
		  z-index: 9999;
		  text-decoration: none !important;

		  /* perfect centering */
		  display: flex;
		  align-items: center;
		  justify-content: center;
	  }
	  
	  .cart-fab:hover,
	  .cart-fab:focus,
	  .cart-fab:active {
	      text-decoration: none !important;  /* no underline on hover */
	      color: #B07FB5; !important;         /* prevent blue link */
	  }

	  .cart-fab i {
		  font-size: 26px;          /* size of the cart icon */
		  line-height: 1;           /* remove text line spacing */
		  display: flex;            /* ensures clean centering */
		  align-items: center;
		  justify-content: center;
	  }

	  .fab-badge {
	    position: absolute;
	    top: 4px;
	    right: 4px;
	    min-width: 18px;
	    height: 18px;
	    padding: 0 5px;
	    border-radius: 9px;
	    background: #d9534f;
	    color: #fff;
	    font-size: 11px;
	    line-height: 18px;
	    text-align: center;
	    font-weight: 600;
	  }
	}
</style>

<body>

    <%
    /* User session info (can be null for guests) */
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");
    String userType = (String) session.getAttribute("usertype");

    boolean isGuest = (userName == null || password == null || userType == null);
    %>

    <jsp:include page="header.jsp" />
    
    <%
	  int cartCount = new com.shashi.service.impl.CartServiceImpl()
	                     .getCartCount((String) session.getAttribute("username"));
	  if (cartCount > 0) {
	%>
	  <!-- Mobile floating cart (only on userHome.jsp) -->
	  <a href="cartDetails.jsp" class="cart-fab" aria-label="Open cart">
	    <i class="fa fa-shopping-cart"></i>
	    <span class="fab-badge"><%=cartCount%></span>
	  </a>
	<%
	  }
	%>

    <!-- Start of Product Items List -->
    <div id="productList">
        <jsp:include page="products.jsp" />
    </div>
    <!-- End of Product Items List -->

    <%@ include file="footer.html"%>

</body>
</html>