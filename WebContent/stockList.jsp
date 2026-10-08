<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*" %>

<%
    ProductServiceImpl productDao = new ProductServiceImpl();
    List<ProductBean> products = new ArrayList<>();

    String search = request.getParameter("search");

    if (search != null && !search.trim().isEmpty()) {
        products = productDao.searchAllProducts(search);
    } else {
        products = productDao.getAllProducts();
    }
%>

<% for (ProductBean product : products) { %>
<tr>
    <td><img src="./ShowImage?pid=<%=product.getProdId()%>" style="width: 50px; height: 50px;"></td>
    <td><a href="./updateProduct.jsp?prodid=<%=product.getProdId()%>"><%=product.getProdId()%></a></td>
    <td><%=product.getProdName().length() > 25 ? product.getProdName().substring(0, 25) + ".." : product.getProdName()%></td>
    <td><%=product.getProdType().toUpperCase()%></td>
    <td><%=product.getProdPrice()%></td>
    <td><%=new OrderServiceImpl().countSoldItem(product.getProdId())%></td>
    <td><%=product.getProdQuantity()%></td>
    <td>
        <form method="post">
            <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary">Update</button>
        </form>
    </td>
    <td>
        <form method="post">
            <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger">Remove</button>
        </form>
    </td>
</tr>
<% } %>

<% if (products.size() == 0) { %>
<tr style="background-color: grey; color: white;">
    <td colspan="8" style="text-align: center;">No Items Available</td>
</tr>
<% } %>
