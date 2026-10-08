package com.shashi.srv;

import java.io.IOException;
import java.io.ByteArrayInputStream;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.shashi.beans.ProductBean;
import com.shashi.service.impl.ProductServiceImpl;

@WebServlet("/UpdateProductSrv")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB limit
public class UpdateProductSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateProductSrv() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied, Login As Admin!!");
            return;
        } else if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return;
        }

        // Get form fields
        String prodId = request.getParameter("pid");
        String prodName = request.getParameter("name");
        String prodType = request.getParameter("type");
        String prodInfo = request.getParameter("info");
        double prodPrice = Double.parseDouble(request.getParameter("price"));
        int prodQuantity = Integer.parseInt(request.getParameter("quantity"));

        // DAO and existing product
        ProductServiceImpl dao = new ProductServiceImpl();
        ProductBean prevProduct = dao.getProductDetails(prodId);

        // Prepare updated product bean
        ProductBean updated = new ProductBean();
        updated.setProdId(prodId);
        updated.setProdName(prodName);
        updated.setProdType(prodType);
        updated.setProdInfo(prodInfo);
        updated.setProdPrice(prodPrice);
        updated.setProdQuantity(prodQuantity);

        // Handle uploaded image
        Part imagePart = request.getPart("productImage");
        String status;

        if (imagePart != null && imagePart.getSize() > 0) {
            byte[] imageBytes = imagePart.getInputStream().readAllBytes();

            // Duplicate name check
            if (dao.isProductNameExistsExcept(prodId, prodName)) {
                request.getRequestDispatcher("updateProduct.jsp?prodid=" + prodId + "&message=Product with this name already exists!")
                       .forward(request, response);
                return;
            }

            // Duplicate image check
            if (dao.isProductImageExistsExcept(prodId, new ByteArrayInputStream(imageBytes))) {
                request.getRequestDispatcher("updateProduct.jsp?prodid=" + prodId + "&message=Product with this image already exists!")
                       .forward(request, response);
                return;
            }

            updated.setProdImage(new ByteArrayInputStream(imageBytes));
            status = dao.updateProduct(prevProduct, updated);

        } else {
            // Only check name duplicate if no new image
            if (dao.isProductNameExistsExcept(prodId, prodName)) {
                request.getRequestDispatcher("updateProduct.jsp?prodid=" + prodId + "&message=Product with this name already exists!")
                       .forward(request, response);
                return;
            }

            // keep old image
            updated.setProdImage(prevProduct.getProdImage());
            status = dao.updateProductWithoutImage(prodId, updated);
        }

        if (status != null && status.toLowerCase().contains("success")) {
            response.sendRedirect("adminStock.jsp?message=" + status);
        } else {
            RequestDispatcher rd = request.getRequestDispatcher(
                    "updateProduct.jsp?prodid=" + prodId + "&message=" + status);
            rd.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
