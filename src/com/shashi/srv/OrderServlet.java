package com.shashi.srv;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shashi.service.impl.OrderServiceImpl;
import com.shashi.service.impl.DeliveryServiceImpl;
import com.shashi.beans.DeliveryResult;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return;
        }

        // Final total sent by client (finalAmount hidden). We parse it but we'll still validate on server
        double paidAmount = 0;
        try {
            paidAmount = Double.parseDouble(request.getParameter("amount"));
        } catch (Exception ignore) { }

        // Read the hidden postal (set only if user accepted delivery)
        String postalCode = request.getParameter("postalCodeHidden"); // IMPORTANT: name matches the hidden input

        // Server-side check of delivery availability (authoritative)
        double computedDeliveryFee = 0;
        int waitingDays = 0;
        if (postalCode != null && !postalCode.trim().isEmpty()) {
            postalCode = postalCode.trim();
            DeliveryResult dr = new DeliveryServiceImpl().checkDelivery(postalCode);
            if (dr != null && dr.isAvailable()) {
                computedDeliveryFee = dr.getFee();
                waitingDays = dr.getWaitingDays();
            } else {
                // postal code invalid or not serviceable → treat as skip
                postalCode = null;
                computedDeliveryFee = 0;
                waitingDays = 0;
            }
        } else {
            // user did not choose delivery or hidden field was not set
            postalCode = null;
            computedDeliveryFee = 0;
            waitingDays = 0;
        }

        // Call service. Pass delivery fee as 0 or computedDeliveryFee.
        // Payment service will recompute/validate again, but passing computedDeliveryFee is fine too.
        String singlePid = request.getParameter("singlePid");
        String singleQtyS = request.getParameter("singleQty");
        String status = null;

        if (singlePid != null && !singlePid.trim().isEmpty()) {
            int singleQty = 1;
            try { singleQty = Integer.parseInt(singleQtyS); } catch(Exception ignore) { }
            status = new OrderServiceImpl()
                         .paymentSuccessForSingleProduct(userName, singlePid.trim(), singleQty, paidAmount, computedDeliveryFee, postalCode);
        } else {
            status = new OrderServiceImpl()
                         .paymentSuccess(userName, paidAmount, computedDeliveryFee, postalCode);
        }

        // forward/include to your orderDetails page and show message
        response.setContentType("text/html;charset=UTF-8");
        RequestDispatcher rd = request.getRequestDispatcher("orderDetails.jsp");
        rd.include(request, response);

        // Print the message into an element with id="message" on orderDetails.jsp
        PrintWriter pw = response.getWriter();
        String safeStatus = status == null ? "" : status.replace("'", "\\'").replace("\n","\\n").replace("\r","");
        pw.println("<script>var el=document.getElementById('message'); if(el) el.innerHTML='" + safeStatus + "';</script>");
        
        // ✅ Add SweetAlert to show payment success
        pw.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
        pw.println("<script>");
        pw.println("Swal.fire({");
        pw.println("  title: 'Success!',");
        pw.println("  text: 'The order placed successfully!',");
        pw.println("  icon: 'success',");
        pw.println("  confirmButtonText: 'OK'");
        pw.println("});");
        pw.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}