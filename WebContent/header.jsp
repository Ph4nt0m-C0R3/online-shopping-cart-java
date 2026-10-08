<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Header</title>
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
	#headerCarousel .carousel-indicators {
	  bottom: -1px;  /* move 10px below default */
	}
	
	#headerCarousel {
	  margin-bottom: 30px; /* give space so indicators don’t overlap other content */
	}
	
	#headerCarousel .carousel-caption {
	  pointer-events: none; /* don't block clicks */
	}
	
	#headerCarousel .carousel-caption input,
	#headerCarousel .carousel-caption button {
	  pointer-events: auto; /* allow typing & clicks in search */
	}
</style>

<body>
	<%
	String userType = (String) session.getAttribute("usertype");
	int unshippedCount = new OrderServiceImpl().getUnshippedCount();
	%>
	
	<!--Company Header Starting  -->
	<div id="headerCarousel" class="carousel slide" data-ride="carousel" data-interval="4000" 
     style="margin-top:50px; margin-bottom:10px; height:200px; overflow:hidden;">

	  <!-- Indicators -->
	  <ol class="carousel-indicators">
	    <li data-target="#headerCarousel" data-slide-to="0" class="active"></li>
	    <li data-target="#headerCarousel" data-slide-to="1"></li>
	    <li data-target="#headerCarousel" data-slide-to="2"></li>
	    <li data-target="#headerCarousel" data-slide-to="3"></li>
	    <li data-target="#headerCarousel" data-slide-to="4"></li>
	    <li data-target="#headerCarousel" data-slide-to="5"></li>
	  </ol>
	
	  <!-- Carousel items -->
	  <div class="carousel-inner">
	    <div class="item active">
	    	<img src="images/carousel/makeup.jpg" alt="Makeup"
     			style="width:100%; height:200px; object-fit:cover; display:block; opacity:0.6;">
	    </div>
	    <div class="item">
			<img src="images/carousel/skin-care.jpg" alt="Skin Care"
     			style="width:100%; height:200px; object-fit:cover; display:block; opacity:0.6;">
     	</div>
	    <div class="item">
	      <img src="images/carousel/hair-care.jpg" alt="Hair Care"
     			style="width:100%; height:200px; object-fit:cover; display:block; opacity:0.6;">
	    </div>
	    <div class="item">
	      <img src="images/carousel/roll-on.jpg" alt="Roll On"
     			style="width:100%; height:200px; object-fit:cover; display:block; opacity:0.6;">
	    </div>
	    <div class="item">
	      <img src="images/carousel/perfume.jpg" alt="Perfume"
     			style="width:100%; height:200px; object-fit:cover; display:block; opacity:0.6;">
	    </div>
	    <div class="item">
	      <img src="images/carousel/lotion.jpg" alt="Lotion"
     			style="width:100%; height:200px; object-fit:cover; display:block; opacity:0.6;">
	    </div>
	  </div>
	
	  <!-- Controls -->
	  <a class="left carousel-control" href="#headerCarousel" data-slide="prev">
	    <span class="glyphicon glyphicon-chevron-left" style="opacity: 0.6;"></span>
	  </a>
	  <a class="right carousel-control" href="#headerCarousel" data-slide="next">
	    <span class="glyphicon glyphicon-chevron-right" style="opacity: 0.6;"></span>
	  </a>
	
	  <!-- Overlay Content -->
		<div class="carousel-caption"
		     style="top:10px; bottom:auto; left:0; right:0; text-align:center;">
		 <h2 style="margin:5px 0; color:white; text-shadow:1px 1px 4px rgba(0,0,0,0.7);">
		   Smart Care Cosmetics
		 </h2>
		 <h6 class="fade-text" style="margin:5px 0;">
		   <span>We specialize in Cosmetics</span>
		   <span>Glow with Confidence</span>
		   <span>Your Beauty, Our Care</span>
		 </h6>
		 <div class="search-container" style="margin-top:10px;">
		    <form action="index.jsp" method="get" class="search-form">
		      <input type="text" name="search" id="searchBox" placeholder="Search for beauty & care..." required>
		      <button type="submit"><i class="glyphicon glyphicon-search"></i></button>
		    </form>
		  </div>
		</div>
	</div>
	<!-- Company Header Ending -->

	<%
	/* Checking the user credentials */
	if (userType == null) { //LOGGED OUT
	%>

	<!-- Starting Navigation Bar -->
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="index.jsp">
				    <img src="images/SC.png" alt="Smart Care Logo" style="height: 24px; margin-top: -4px; display: inline-block;">
				    &nbsp;Smart Care
				</a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav navbar-right">
					<li><a href="login.jsp">Login</a></li>
					<li><a href="register.jsp">Register</a></li>
					<li><a href="index.jsp">Products</a></li>
					<li class="dropdown">
					<a class="dropdown-toggle"
						data-toggle="dropdown" href="#">Category <span class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="index.jsp?type=makeup">Makeup</a></li>
							<li><a href="index.jsp?type=skin-care">Skin Care</a></li>
							<li><a href="index.jsp?type=hair-care">Hair Care</a></li>
							<li><a href="index.jsp?type=roll-on">Roll On</a></li>
							<li><a href="index.jsp?type=perfume">Perfume</a></li>
							<li><a href="index.jsp?type=lotion">Lotion</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</nav>
	<%
	} else if ("customer".equalsIgnoreCase(userType)) { //CUSTOMER HEADER

	int notf = new CartServiceImpl().getCartCount((String) session.getAttribute("username"));
	%>
	<nav class="navbar navbar-default navbar-fixed-top">

		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="userHome.jsp">
				    <img src="images/SC.png" alt="Smart Care Logo" style="height: 24px; margin-top: -4px; display: inline-block;">
				    &nbsp;Smart Care
				</a>
			</div>

			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav navbar-right">
					<li><a href="userHome.jsp">Products</a></li>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">Category <span class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="userHome.jsp?type=makeup">Makeup</a></li>
							<li><a href="userHome.jsp?type=skin-care">Skin Care</a></li>
							<li><a href="userHome.jsp?type=hair-care">Hair Care</a></li>
							<li><a href="userHome.jsp?type=roll-on">Roll On</a></li>
							<li><a href="userHome.jsp?type=perfume">Perfume</a></li>
							<li><a href="userHome.jsp?type=lotion">Lotion</a></li>
						</ul></li>
					<% if (notf == 0) { %>
					  <li class="cart-nav-item">
					    <a href="cartDetails.jsp">
					      <span class="glyphicon glyphicon-shopping-cart"></span> Cart
					    </a>
					  </li>
					<% } else { %>
					  <li class="cart-nav-item">
					    <a href="cartDetails.jsp" style="margin:0; padding:0;" id="mycart">
					      <i data-count="<%=notf%>" 
					         class="fa fa-shopping-cart fa-3x icon-white badge"
					         style="background: #d8bfd8; color: #B07FB5; margin: 0; padding: 5px; border-radius: 6px;">
					      </i>
					    </a>
					  </li>
					<% } %>
					<li><a href="orderDetails.jsp">Orders</a></li>
					<li><a href="userProfile.jsp">Profile</a></li>
					<li><a href="./LogoutSrv">Logout</a></li>
				</ul>
			</div>
		</div>
	</nav>
	
	<%
	} else { //ADMIN HEADER
	%>
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button"
				        class="navbar-toggle collapsed"
				        data-toggle="collapse"
				        data-target="#myNavbar"
				        aria-expanded="false">
				    <span class="icon-bar"></span>
				    <span class="icon-bar"></span>
				    <span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="adminViewProduct.jsp">
				    <img src="images/SC.png" alt="Smart Care Logo" style="height: 24px; margin-top: -4px; display: inline-block;">
				    &nbsp;Smart Care
				</a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav navbar-right">
					<li><a href="adminViewProduct.jsp">Products</a></li>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">Category <span class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="adminViewProduct.jsp?type=makeup">Makeup</a></li>
							<li><a href="adminViewProduct.jsp?type=skin-care">Skin Care</a></li>
							<li><a href="adminViewProduct.jsp?type=hair-care">Hair Care</a></li>
							<li><a href="adminViewProduct.jsp?type=roll-on">Roll On</a></li>
							<li><a href="adminViewProduct.jsp?type=perfume">Perfume</a></li>
							<li><a href="adminViewProduct.jsp?type=lotion">Lotion</a></li>
						</ul></li>
					<li><a href="adminStock.jsp">Stock</a></li>
					<li><a href="shippedItems.jsp">Shipped</a></li>
					<% if (unshippedCount == 0) { %>
					    <li><a href="unshippedItems.jsp">Orders</a></li>
					<% } else { %>
					    <li class="hidden-xs"> <!-- hide on mobile -->
					      <a href="unshippedItems.jsp" style="margin:0; padding:0;">
					        <i data-count="<%=unshippedCount%>"
					           class="fa fa-shopping-bag fa-2x icon-white badge"
					           style="background: #d8bfd8; color: #B07FB5; margin: 0; padding: 5px; border-radius: 6px;">
					        </i>
					      </a>
					    </li>
					<% } %>
					<!-- <li><a href=""> <span class="glyphicon glyphicon-shopping-cart"></span>&nbsp;Cart</a></li> -->
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">Update Items <span
							class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="addProduct.jsp">Add Product</a></li>
							<li><a href="removeProduct.jsp">Remove Product</a></li>
							<li><a href="updateProductById.jsp">Update Product</a></li>
						</ul></li>
					<li><a href="./LogoutSrv">Logout</a></li>

				</ul>
			</div>
		</div>
	</nav>
	
	<%
	   String currentPage = request.getRequestURI();
	   if ("admin".equalsIgnoreCase(userType) 
	       && (currentPage.contains("adminViewProduct.jsp") || currentPage.contains("shippedItems.jsp")) 
	       && unshippedCount > 0) {   
	%>
	   <!-- Floating Unshipped Icon -->
	   <div class="floating-unshipped">
	     <a href="unshippedItems.jsp">
	       <i data-count="<%=unshippedCount%>" 
	          class="fa fa-shopping-bag fa-3x icon-white badge"
	          style="background: #d8bfd8; color: #B07FB5;">
	       </i>
	     </a>
	   </div>
	<% } %>
	
	<%
	}
	%>
	<!-- End of Navigation Bar -->
	
	<script>
		$(function () {
		  var $collapse = $('#myNavbar');         // collapsible div
		  var $navbar   = $('.navbar');
		
		  // 1) Close when clicking any non-dropdown link
		  $collapse.on('click', 'a:not(.dropdown-toggle)', function () {
		    $collapse.collapse('hide');
		  });
		
		  // 2) Close when clicking outside the navbar (touch & click)
		  $(document).on('click touchstart', function (e) {
		    if ($collapse.hasClass('in') && $(e.target).closest($navbar).length === 0) {
		      $collapse.collapse('hide');
		    }
		  });
		
		  // 3) Close dropdowns whenever the collapse hides (by ANY trigger)
		  $collapse.on('hide.bs.collapse', function () {
		    // remove Bootstrap's "open" state from any dropdowns
		    $(this).find('.dropdown.open')
		      .removeClass('open')
		      .find('[aria-expanded="true"]').attr('aria-expanded', 'false');
		  });
		
		  // 4) Make the hamburger close everything when menu is open.
		  //    We DO NOT preventDefault — let Bootstrap handle open/close.
		  $('.navbar-toggle').on('click', function () {
		    if ($collapse.hasClass('in')) {
		      // menu is open -> force a clean close; dropdowns will also close via (3)
		      $collapse.collapse('hide');
		      // return here to avoid double-toggling visual glitches
		      return false;
		    }
		    // else: closed -> Bootstrap will open it normally
		  });
		});
		
		// For Android Hamburger
		$(document).ready(function () {
		  var $btn = $(".navbar-toggle");
		  var $menu = $("#myNavbar");

		  // Ensure button starts in collapsed (hamburger) state
		  if (!$menu.hasClass("in")) {
		    $btn.addClass("collapsed").attr("aria-expanded", "false");
		  }

		  // Sync state when Bootstrap toggles the collapse
		  $menu.on("shown.bs.collapse", function () {
		    $btn.removeClass("collapsed").attr("aria-expanded", "true");
		  });
		  $menu.on("hidden.bs.collapse", function () {
		    $btn.addClass("collapsed").attr("aria-expanded", "false");
		  });
		});
		
		// For live search
		$(document).ready(function () {
		  let typingTimer;
		
		  $(".search-form").on("submit", function (e) {
		    e.preventDefault(); // prevent reload on enter
		  });
		
		  $("#searchBox").on("keyup", function () {
		    clearTimeout(typingTimer);
		    let query = $(this).val();
		
		    typingTimer = setTimeout(function () {
		      $.ajax({
		        url: "<%= "admin".equalsIgnoreCase(userType) ? "adminProducts.jsp" : "products.jsp" %>",
		        type: "GET",
		        data: { search: query },
		        success: function (data) {
		          $("#productList").html(data);
		        }
		      });
		    }, 300);
		  });
		});
	</script>
</body>
</html>