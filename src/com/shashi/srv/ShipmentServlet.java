package com.shashi.srv;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shashi.beans.OrderBean;
import com.shashi.beans.TransactionBean;
import com.shashi.service.impl.OrderServiceImpl;
import com.shashi.service.impl.TransServiceImpl;
import com.shashi.service.impl.UserServiceImpl;
import com.shashi.service.impl.ProductServiceImpl; 
import com.shashi.utility.MailMessage;

/**
 * Servlet implementation class ShipmentServlet
 */
@WebServlet("/ShipmentServlet")
public class ShipmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ShipmentServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        if (userType == null) {
            response.sendRedirect("login.jsp?message=Access Denied, Login Again!!");
            return;
        }

        String transId = request.getParameter("transid");
        String userName = request.getParameter("userid");

        OrderServiceImpl orderService = new OrderServiceImpl();
        List<OrderBean> orderList = orderService.getOrdersByTransaction(transId); // implemented

        double subtotal = 0.0;
        for (OrderBean order : orderList) {
            subtotal += (order.getAmount() != null ? order.getAmount() : 0.0);
            orderService.shipNow(order.getTransactionId(), order.getProductId()); // mark shipped
        }

        TransactionBean trans = new TransServiceImpl().getTransactionById(transId);
        double deliveryFee = (trans != null ? trans.getDeliveryFee() : 0.0);
        double totalAmount = subtotal + deliveryFee;

        String pagename = "shippedItems.jsp";

        String customerName = new UserServiceImpl().getFName(userName);

        // === build product lines (simple one-line per item) ===
        String productLinesHtml = buildProductLinesHtml(orderList);

        // === pass product lines to MailMessage ===
        MailMessage.orderShipped(userName, customerName, transId, subtotal, deliveryFee, totalAmount, productLinesHtml);

        PrintWriter pw = response.getWriter();
        response.setContentType("text/html");

        RequestDispatcher rd = request.getRequestDispatcher(pagename);
        rd.include(request, response);
        pw.println("<script>document.getElementById('message').innerHTML='Order Shipped'</script>");
        
        pw.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
        pw.println("<script>");
        pw.println("Swal.fire({");
        pw.println("  title: 'Success',");
        pw.println("  text: 'Order shipped successfully!',");
        pw.println("  icon: 'success',");
        pw.println("  confirmButtonText: 'OK'");
        pw.println("});");
        pw.println("</script>");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // ---------------- helper methods ----------------

    // minimal HTML-escape for safety
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
    }

    // builds lines like: "Chanel Chance EAU Splendide (x1) - 855000.0 MMK<br/>"
    private String buildProductLinesHtml(List<OrderBean> orderList) {
        if (orderList == null || orderList.isEmpty()) return "";

        ProductServiceImpl prodSvc = new ProductServiceImpl();
        StringBuilder sb = new StringBuilder();

        for (OrderBean o : orderList) {
            int qty = o.getQuantity() > 0 ? o.getQuantity() : 1;
            double lineTotal = o.getAmount() != null ? o.getAmount() : 0.0;
            double unitPrice = (qty > 0) ? (lineTotal / qty) : lineTotal;

            String prodName = o.getProductId(); // fallback to id
            try {
                com.shashi.beans.ProductBean pb = prodSvc.getProductDetails(o.getProductId());
                if (pb != null && pb.getProdName() != null && !pb.getProdName().trim().isEmpty()) {
                    prodName = pb.getProdName();
                }
            } catch (Exception ignore) { }

            sb.append(esc(prodName))
              .append(" (x").append(qty).append(") - ")
              .append(String.format("%.1f", unitPrice)).append(" MMK")
              .append("<br/>");
        }
        return sb.toString();
    }
}