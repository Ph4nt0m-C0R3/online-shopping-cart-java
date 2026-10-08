package com.shashi.srv;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shashi.beans.UserBean;
import com.shashi.service.impl.UserServiceImpl;

@WebServlet("/RegisterSrv")
public class RegisterSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        String userName = request.getParameter("username");
        String mobileStr = request.getParameter("mobile");
        String emailId = request.getParameter("email");
        String address = request.getParameter("address");
        String postalCode = request.getParameter("postal_code");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String status = "";

        // Keep user input in case of failure
        request.setAttribute("username", userName);
        request.setAttribute("email", emailId);
        request.setAttribute("address", address);
        request.setAttribute("mobile", mobileStr);
        request.setAttribute("postal_code", postalCode);

        try {
            Long mobileNo = Long.parseLong(mobileStr);

            if (password != null && password.equals(confirmPassword)) {
            	UserBean user = new UserBean(userName, mobileNo, emailId, address, postalCode, password);
                UserServiceImpl dao = new UserServiceImpl();
                status = dao.registerUser(user);

                if (status != null && status.toLowerCase().contains("success")) {
                    response.sendRedirect("login.jsp?message=Registration successful! Please login.");
                    return;
                }
            } else {
                status = "Password not matching!";
            }
        } catch (NumberFormatException e) {
            status = "Invalid mobile number";
        }

        // If registration failed → stay on register page
        RequestDispatcher rd = request.getRequestDispatcher("register.jsp?message=" + status);
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
