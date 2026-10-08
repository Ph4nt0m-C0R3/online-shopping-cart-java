package com.shashi.srv;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.shashi.beans.DeliveryResult;
import com.shashi.service.DeliveryService;
import com.shashi.service.impl.DeliveryServiceImpl;

@WebServlet("/checkDeliveryAjax")
public class DeliveryAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final DeliveryService deliveryService = new DeliveryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String postalCode = request.getParameter("postalCode");
        DeliveryResult result = deliveryService.checkDelivery(postalCode);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        new Gson().toJson(result, response.getWriter());
    }
}