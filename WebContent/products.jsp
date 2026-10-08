<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*" %>

<%
    String userName = (String) session.getAttribute("username");
    ProductServiceImpl prodDao = new ProductServiceImpl();
    List<ProductBean> products = new ArrayList<>();

    String search = request.getParameter("search");
    String type = request.getParameter("type");
    String sort = request.getParameter("sort");
    String message = "All Products";

    // ===== Get Products =====
    if (search != null && !search.trim().isEmpty()) {
        products = prodDao.searchAllProducts(search);
        message = "Showing Results for '" + search + "'";
    } else if (type != null) {
        products = prodDao.getAllProductsByType(type);
        message = "Showing Results for '" + type + "'";
    } else {
        products = prodDao.getAllProducts();
    }

    if (products.isEmpty()) {
        message = "No items found for '" + (search != null ? search : type) + "'";
    }

    // ===== Sorting Logic =====
    if (sort != null && !products.isEmpty()) {
        if ("az".equals(sort)) {
            products.sort(Comparator.comparing(ProductBean::getProdName));
        } else if ("za".equals(sort)) {
            products.sort(Comparator.comparing(ProductBean::getProdName).reversed());
        } else if ("high".equals(sort)) {
            products.sort(Comparator.comparingDouble(ProductBean::getProdPrice).reversed());
        } else if ("low".equals(sort)) {
            products.sort(Comparator.comparingDouble(ProductBean::getProdPrice));
        } else if ("newest".equals(sort)) {
            products.sort(Comparator.comparing(ProductBean::getProdId).reversed()); 
        }
    }
%>

<style>
	/* Equal-height ONLY on rows that actually contain product cards */
	#productList .row:has(.card) {
	  display: flex;
	  flex-wrap: wrap;
	}
	#productList .row:has(.card) > [class*="col-"] {
	  display: flex;
	}
	#productList .row:has(.card) > [class*="col-"] .card {
	  display: flex;
	  flex-direction: column;
	  width: 100%;
	}
	
	/* Keep the "Sort by" block hard-aligned to the right edge */
	#productList .container > .row > .col-md-6.col-sm-6.text-right {
	  float: right;        /* override Bootstrap 3 left-float */
	  width: auto;         /* let it shrink to content */
	}
	#productList #sortForm {
	  margin-left: auto;   /* if the row is flex, still pushes to end */
	}

  /* Label styling */
  .sort-label {
    font-weight: 500;
    color: #444;
    margin: 0;
    white-space: nowrap;
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
  }

  /* Wrapper to style dropdown arrow and menu */
  .custom-select-wrapper {
    position: relative;
    display: inline-block;
    width: auto;
  }

  /* Custom select */
  .custom-select {
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    padding: 8px 30px 8px 12px;
    border-radius: 25px;
    border: 1px solid #ddd;
    font-size: 14px;
    font-family: 'Poppins', sans-serif;
    color: #444;
    background: linear-gradient(to right, #fff, #f9f9fb);
    box-shadow: 0 2px 6px rgba(0,0,0,0.08);
    cursor: pointer;
    transition: all 0.3s ease;
  }

  /* Custom arrow */
  .custom-select-wrapper::after {
    content: "";
    position: absolute;
    top: 50%;
    right: 12px;
    width: 12px;
    height: 12px;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3Csvg width='12' height='8' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23666' stroke-width='2' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
    background-size: 12px;
    background-repeat: no-repeat;
    background-position: center;
    pointer-events: none;
    transform: translateY(-50%);
  }

  .custom-select:hover {
    border-color: #c8a2c8;
    box-shadow: 0 3px 8px rgba(200,162,200,0.3);
  }

  .custom-select:focus {
    outline: none;
    border-color: #c8a2c8;
    box-shadow: 0 0 0 3px rgba(200,162,200,0.25);
  }

  /* Mobile responsiveness */
  @media (max-width: 768px) {
    .row {
      flex-direction: column;
      align-items: center;
      text-align: center;
    }
    .row .col-md-6 {
      width: 100%;
      margin-top: 40px;
      text-align: center !important;
    }
    .custom-select {
      width: 100%;
    }
  }
</style>

<!-- Sorting + Message Row -->
<div class="container" style="margin-bottom: 15px; position: relative;">
  <div class="row" style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap;">

    <!-- Header Message -->
    <div style="position: absolute; left: 50%; transform: translateX(-50%);
                font-size: 16px; font-weight: bold; color: black; text-align: center; white-space: nowrap;">
      <%=message%>
    </div>

    <!-- Sorting Dropdown -->
    <div class="col-md-6 col-sm-6 text-right" style="margin-left: auto;">
      <form id="sortForm" method="get" action="userHome.jsp" style="display: inline-flex; align-items: center; gap: 10px;">

        <%-- Preserve search/type if present --%>
        <% if (search != null) { %>
          <input type="hidden" name="search" value="<%=search%>">
        <% } %>
        <% if (type != null) { %>
          <input type="hidden" name="type" value="<%=type%>">
        <% } %>

        <label for="sort" class="sort-label">Sort by :</label>

        <div class="custom-select-wrapper">
          <select name="sort" id="sort" class="custom-select">
            <option value="products" <%= "products".equals(sort) ? "selected" : "" %>>Products</option>
            <option value="az" <%= "az".equals(sort) ? "selected" : "" %>>Name A &rarr; Z</option>
            <option value="za" <%= "za".equals(sort) ? "selected" : "" %>>Name Z &rarr; A</option>
            <option value="high" <%= "high".equals(sort) ? "selected" : "" %>>Price High &rarr; Low</option>
            <option value="low" <%= "low".equals(sort) ? "selected" : "" %>>Price Low &rarr; High</option>
          </select>
        </div>

      </form>
    </div>

  </div>
</div>

<script>
  // auto-submit form on change
  document.getElementById("sort").addEventListener("change", function() {
      document.getElementById("sortForm").submit();
  });
</script>

<!-- Product Grid -->
<div class="container" style="margin-top: 10px;">
  <div class="row">
    <%
    for (ProductBean product : products) {
        int cartQty = 0;

        // only check cart if user is logged in
        if (userName != null) {
            cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
        }
    %>
    <div class="col-xs-12 col-sm-6 col-md-4" style="margin-bottom: 20px;">
        <div class="card" 
     	style="border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 10px; padding-bottom: 20px; background-color: #fff;">
            
            <div style="display: flex; justify-content: center; align-items: center; height: 150px; padding: 10px; margin-bottom: 10px;">
                <img src="./ShowImage?pid=<%=product.getProdId()%>" 
                     alt="Product" 
                     style="max-height: 100%; max-width: 100%; object-fit: contain;">
            </div>
            
            <h4 class="text-center" style="font-weight: bold; margin-bottom: 5px;">
                <%=product.getProdName()%>
            </h4>
            
            <p class="text-center text-muted" style="font-size: 12px; margin-bottom: 10px;">
                ID: <%=product.getProdId()%>
            </p>
            
            <%
            String description = product.getProdInfo();
            description = description.substring(0, Math.min(description.length(), 100));
            %>
            <p class="text-center" style="font-size: 13px; color: #555; min-height: 40px;">
                <%=description%>..
            </p>
            
            <p class="text-center" style="font-weight: bold; font-size: 16px; color: #28a745;">
                <%=product.getProdPrice()%> MMK
            </p>
            
            <div class="text-center">
                <form method="post" style="display: flex; justify-content: center; gap: 10px; flex-wrap: wrap;">
                    <%
                    if (userName == null) {
                        // Guest user → only allow browsing
                    %>
                        <a href="login.jsp" class="btn btn-primary btn-sm">Buy</a>
                    <%
                    } else {
                        // Logged-in user → show cart options
                        if (cartQty == 0) {
                    %>
                            <button type="submit"
                                    formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
                                    class="btn btn-success btn-sm">Add to Cart</button>
                            <button type="submit"
							        formaction="payment.jsp?amount=<%=product.getProdPrice()%>&singlePid=<%=product.getProdId()%>&singleQty=1"
							        class="btn btn-primary btn-sm">Buy Now</button>
                    <%
                        } else {
                    %>
                            <button type="submit"
                                    formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
                                    class="btn btn-danger btn-sm">Remove From Cart</button>
                            <button type="submit" formaction="cartDetails.jsp"
                                    class="btn btn-success btn-sm">Checkout</button>
                    <%
                        }
                    }
                    %>
                </form>
            </div>
        </div>
    </div>
    <%
    }
    %>
  </div>
</div>
