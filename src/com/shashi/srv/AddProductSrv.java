package com.shashi.srv;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.shashi.service.impl.ProductServiceImpl;

@WebServlet("/AddProductSrv")
@MultipartConfig(maxFileSize = 16177215)
public class AddProductSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied!");
            return;
        } else if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again to Continue!");
            return;
        }

        String prodName = request.getParameter("name");
        String prodType = request.getParameter("type");
        String prodInfo = request.getParameter("info");
        double prodPrice = Double.parseDouble(request.getParameter("price"));
        int prodQuantity = Integer.parseInt(request.getParameter("quantity"));
        Part part = request.getPart("image");

     // Read once into bytes
     byte[] prodImageBytes = part.getInputStream().readAllBytes();

     ProductServiceImpl productService = new ProductServiceImpl();
     String status;

     // Check duplicate name
     if (productService.isProductNameExists(prodName)) {
         status = "Product with this name already exists!";
     }
     // Check duplicate image
     else if (productService.isProductImageExists(prodImageBytes)) {
         status = "Product with this image already exists!";
     }
     // Add product (wrap bytes into InputStream again)
     else {
         InputStream prodImageStream = new ByteArrayInputStream(prodImageBytes);
         status = productService.addProduct(prodName, prodType, prodInfo, prodPrice, prodQuantity, prodImageStream);
     }

     RequestDispatcher rd = request.getRequestDispatcher("addProduct.jsp?message=" + status);
     rd.forward(request, response);
     
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
