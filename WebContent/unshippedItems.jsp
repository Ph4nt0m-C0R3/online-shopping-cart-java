<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.beans.*,com.shashi.service.*,java.util.*"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Home</title>
<link rel="icon" type="image/png" href="images/SC.png">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="css/changes.css">
</head>

<style>
	.orders-grid {
	    display: grid;
	    grid-template-columns: repeat(2, 1fr);  /* 2 cards per row on desktop */
	    gap: 24px;                              /* spacing between cards */
	    margin: 10px 100px;                      /* outer spacing from container edges */
	}
	
	.order-card {
	    background: #fff;
	    border-radius: 16px;
	    padding: 20px;
	    box-shadow: 0 6px 18px rgba(0,0,0,0.08);
	    transition: 0.3s ease;
	
	    display: flex;
	    flex-direction: column;      /* allow pushing footer down */
	    justify-content: space-between;
	    min-height: 360px;           /* optional: consistent card height */
	}
	
	.order-body {
	    flex-grow: 1;                /* takes up available space to push footer down */
	}
	
	.order-footer.sticky-btn {
	    display: flex;
	    justify-content: flex-end;   /* push button to right */
	    margin-top: 10px;
	}
	
	.order-card:hover {
	    transform: translateY(-5px);
	    box-shadow: 0 10px 24px rgba(0,0,0,0.12);
	}
	
	.order-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 15px;
	}
	
	.order-id {
	    font-weight: 600;
	    color: #2575fc;
	    font-size: 15px;
	}
	
	.status-badge {
	    padding: 4px 10px;
	    border-radius: 12px;
	    font-size: 12px;
	    font-weight: 600;
	}
	
	.status-warning {
	    background: #fff3e0;
	    color: #ff9800;
	}
	
	.products-list {
	    margin: 0;
	    padding: 0;
	    list-style: none;
	}
	
	.products-list li {
	    padding: 6px 0;
	    border-bottom: 1px dashed #ddd;
	    font-size: 14px;
	}
	
	.products-list li:last-child {
	    border-bottom: none;
	}
	
	.order-footer {
	    font-size: 13px;
	    color: #555;
	    display: flex;
	    justify-content: space-between;
	    margin-top: 8px;
	}
	
	.order-summary {
	    margin-top: 15px;
	    padding-top: 10px;
	    border-top: 1px solid #ddd;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	}
	.order-summary span {
	    font-weight: 600;
	    font-size: 15px;
	}
	.order-summary .total {
	    color: #d32f2f;
	    font-size: 16px;
	    font-weight: bold;
	    margin-top: 5px;
	}
	
	.empty-state {
		position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    text-align: center;
	    padding: 70px 20px;
	    color: #b07fb5;
	    margin-top: 60px;
	}
	.empty-state .glyphicon {
	    font-size: 65px;
	    color: #b07fb5;
	    margin-bottom: 15px;
	    display: block;
	}

	@media (max-width: 1200px) {
	    td.products-col {
	        min-width: 300px;   /* give more breathing room */
	        font-size: 14px;    /* bump font size for readability */
	        white-space: normal;
	        word-wrap: break-word;
	    }
	}
	
	/* 🔹 Responsive */
	@media (max-width: 992px) {
	    .orders-grid {
	        grid-template-columns: 1fr;   /* single column on tablets */
	        margin: 10px 40px;            /* reduce side spacing */
	    }
	    .order-card {
	        min-height: auto;             /* let card height adjust naturally */
	    }
	    .empty-state {
	    	margin-top: 25px;
	    }
	}
	
	@media (max-width: 576px) {
	    .orders-grid {
	        grid-template-columns: 1fr;   /* still 1 column on mobile */
	        margin: 10px 15px;            /* small side margins */
	        gap: 16px;                    /* tighter gap */
	    }
	    .order-header {
	        flex-direction: column;       /* stack transaction + badge */
	        align-items: flex-start;
	        gap: 5px;
	    }
	    .order-summary {
	        flex-direction: column !important;  /* stack items vertically */
	        align-items: flex-start !important; /* left-align all children */
	        gap: 8px;                           /* spacing between items */
	    }
	
	    /* Make sure Delivery/Total/Date container is left-aligned */
	    .order-summary > div:first-child {
	        display: flex;
	        flex-direction: column;
	        align-items: flex-start;
	        text-align: left;
	    }
	
	    /* Keep the button below the summary, left-aligned */
	    .order-summary .sticky-btn {
	        align-self: flex-start;
	        margin-top: 10px;
	    }
	    .order-footer {
	        flex-direction: column;       /* stack email + address */
	        align-items: flex-start;
	        gap: 4px;
	    }
	    .order-summary .total {
	        font-size: 14px;
	    }
	    .order-id {
	        font-size: 14px;
	    }
	}
</style>

<body>
	<%
	/* Checking the user credentials */
	String userType = (String) session.getAttribute("usertype");
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("loginFirst.jsp");

	}

	if (userName == null || password == null) {

		response.sendRedirect("loginFirst.jsp");
	}
	%>

	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: #b07fb5; font-size: 24px; font-weight: bold; margin-bottom: 10px;">UnShipped
		Orders</div>
	<div class="container-fluid">
    <div class="orders-grid">
        <%
        OrderServiceImpl orderdao = new OrderServiceImpl();
        List<String> unshippedTransIds = orderdao.getUnshippedTransactionIds();

        // Create a map of TransactionBean to transactionId
        Map<TransactionBean, String> transMap = new HashMap<>();
        for (String transId : unshippedTransIds) {
            TransactionBean trans = new TransServiceImpl().getTransactionById(transId);
            if (trans != null) {
                transMap.put(trans, transId);
            }
        }

        // Sort transactions by date descending
        List<TransactionBean> sortedTrans = new ArrayList<>(transMap.keySet());
        sortedTrans.sort((t1, t2) -> t2.getTransDateTime().compareTo(t1.getTransDateTime()));

        int count = 0;
        for (TransactionBean trans : sortedTrans) {
            String transId = transMap.get(trans);
            String userId = new TransServiceImpl().getUserId(transId);
            String userAddr = new UserServiceImpl().getUserAddr(userId);
            List<OrderBean> transOrders = orderdao.getOrdersByTransaction(transId);

            double subTotal = 0;
            for (OrderBean o : transOrders) {
                subTotal += o.getAmount();
            }
            double deliveryFee = trans.getDeliveryFee();
            double total = subTotal + deliveryFee;
            count++;

            // pick delivery address
            String deliveryAddr = !transOrders.isEmpty() ? transOrders.get(0).getDeliveryAddress() : null;
            String finalAddr = (deliveryAddr != null && !deliveryAddr.trim().isEmpty()) ? deliveryAddr : userAddr;
        %>

        <!-- Order Card -->
		<div class="order-card">
		    <div class="order-header">
		        <span class="order-id">Transaction ID: <%= transId %></span>
		        <span class="status-badge status-warning">READY_TO_SHIP</span>
		    </div>
		
		    <!-- Product list -->
		    <div class="order-body">
		        <ul class="products-list">
		            <%
		                for (OrderBean o : transOrders) {
		                    double totalPrice = o.getAmount();
		                    int qty = o.getQuantity();
		                    double unitPrice = (qty > 0) ? totalPrice / qty : totalPrice;
		            %>
		                <li>
		                    <a href="./updateProduct.jsp?prodid=<%= o.getProductId() %>">
		                        <%= o.getProductId() %>
		                    </a>
		                    (x<%= qty %>) - <%= String.format("%.1f", unitPrice) %> MMK
		                </li>
		            <%
		                }
		            %>
		        </ul>
		    </div>
		
		    <!-- User + Address -->
		    <div class="order-footer">
		        <span><strong>Email:</strong> <%= userId %></span>
		    </div>
		    <div class="order-footer">
		        <span><strong>Address:</strong> <%= finalAddr %></span>
		    </div>
		
		    <!-- Delivery + Total + Date + Ship Button -->
		    <div class="order-summary" style="justify-content: space-between; align-items: center;">
		        <div>
				    <div>Delivery: <%= String.format("%.1f", deliveryFee) %> MMK</div>
				    <div class="total">Total: <%= String.format("%.1f", total) %> MMK</div>
				    <div style="margin-top: 10px;">
				        <span style="font-weight: normal; font-size: 13px; color: #555;">
				            <span class="glyphicon glyphicon-time"></span>
				            <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(trans.getTransDateTime()) %>
				        </span>
				    </div>
				</div>
		        <div class="order-footer sticky-btn">
		            <a href="ShipmentServlet?transid=<%= transId %>&userid=<%= userId %>"
		               class="btn btn-success">SHIP NOW</a>
		        </div>
		    </div>
		</div>

        <%
            }
            if (count == 0) {
        %>
        <div class="empty-state">
            <span class="glyphicon glyphicon-inbox"></span>
            <h5>No Orders Available</h5>
        </div>
        <%
            }
        %>
    </div>
</div>

	<%@ include file="footer.html"%>
</body>
</html>