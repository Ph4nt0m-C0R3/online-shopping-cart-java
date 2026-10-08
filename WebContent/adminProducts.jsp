<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*" %>

<%
	String userName = (String) session.getAttribute("username");
	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<>();
	
	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String message = "All Products";
	
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
%>

	<div class="text-center"
		style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>

	<div class="row" style="margin-top: 10px;">
        <%
        for (ProductBean product : products) {
        %>
        <div class="col-xs-12 col-sm-6 col-md-4" style="margin-bottom: 20px;">
            <div class="card" style="border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 10px; padding-bottom: 20px; background-color: #fff; height: 100%;">
                
                <div class="text-center" style="margin-bottom: 10px; display: flex; justify-content: center; align-items: center; height: 150px; padding: 10px; margin-bottom: 10px;">
				    <img src="./ShowImage?pid=<%=product.getProdId()%>" 
				         alt="Product" 
				         class="img-responsive" 
				         style="max-height: 100%; max-width: 100%; object-fit: contain;">
				</div>
					                
                <h4 class="text-center" style="font-weight: bold; margin-bottom: 5px;">
                    <%=product.getProdName()%>
                </h4>
                <p class="text-center text-muted" style="font-size: 12px; margin-bottom: 10px;">
                    ID: <%=product.getProdId()%>
                </p>
                <p class="text-center" style="font-size: 13px; color: #555; min-height: 40px;">
                    <%=product.getProdInfo()%>
                </p>
                
                <p class="text-center" style="font-weight: bold; font-size: 16px; color: #28a745;">
                    <%=product.getProdPrice()%> MMK
                </p>
                
                <div class="text-center">
                    <form method="post" style="display: flex; justify-content: center; gap: 10px;">
                        <button type="submit"
                                formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>"
                                class="btn btn-danger btn-sm">Remove</button>
                        <button type="submit"
                                formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>"
                                class="btn btn-primary btn-sm">Update</button>
                    </form>
                </div>
            </div>
        </div>
        <%
        }
        %>
    </div>
