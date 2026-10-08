<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,java.util.stream.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Order Details</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/png" href="images/SC.png">
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="css/changes.css">
</head>

<style>
	.orders-grid {
	    display: grid;
	    grid-template-columns: repeat(2, 1fr);  
	    gap: 24px;
	    margin: 10px 100px;
	}
	
	.order-card {
	    background: #fff;
	    border-radius: 16px;
	    padding: 20px;
	    box-shadow: 0 6px 18px rgba(0,0,0,0.08);
	    transition: 0.3s ease;
	
	    display: flex;
	    flex-direction: column;
	    min-height: 330px;   /* keeps cards consistent height */
	}
	
	.order-body {
	    flex-grow: 1;       /* product list grows to fill available space */
	    text-align: left;   /* make sure products stay left aligned */
	}
	
	.order-summary {
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
	.status-success {
	    background: #e6f9ee;
	    color: #28a745;
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
	    font-weight: bold;
	    font-size: 16px;
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
	        min-width: 350px;
	        font-size: 14px;
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
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
    }

    OrderService dao = new OrderServiceImpl();
    List<OrderDetails> orders = dao.getAllOrderDetails(userName);

    // group by transaction (orderId)
    Map<String, List<OrderDetails>> ordersByTrans =
        orders.stream().collect(Collectors.groupingBy(OrderDetails::getOrderId));
%>

<jsp:include page="header.jsp" />

<div class="text-center"
    style="color: #b07fb5; font-size: 24px; font-weight: bold; margin-bottom: 10px;">
    Order Details
</div>

<div class="container-fluid">
    <div class="orders-grid">
        <%
            // sort orders by latest time
            List<Map.Entry<String, List<OrderDetails>>> sortedOrders = new ArrayList<>(ordersByTrans.entrySet());
            sortedOrders.sort((e1, e2) -> {
                java.sql.Timestamp t1 = e1.getValue().get(0).getTime();
                java.sql.Timestamp t2 = e2.getValue().get(0).getTime();
                return t2.compareTo(t1); // latest first
            });

            for (Map.Entry<String, List<OrderDetails>> entry : sortedOrders) {
                String transId = entry.getKey();
                List<OrderDetails> transOrders = entry.getValue();

                double subTotal = 0;
                int shippedFlag = 1;
                java.sql.Timestamp time = null;
                double deliveryFee = 0;

                // avoid duplicate products
                Map<String, String> productMap = new LinkedHashMap<>();

                for (OrderDetails o : transOrders) {
                    subTotal += Double.parseDouble(o.getAmount());
                    if (o.getShipped() == 0) shippedFlag = 0;
                    time = o.getTime();
                    deliveryFee = o.getDeliveryFee();

                    double totalPrice = Double.parseDouble(o.getAmount());
                    int qty = 0;
                    try { qty = Integer.parseInt(String.valueOf(o.getQty())); }
                    catch (Exception e) { qty = 1; }
                    if (qty <= 0) qty = 1;
                    double unitPrice = totalPrice / qty;

                    productMap.put(o.getProdName(),
                        "(x" + qty + ") - " + String.format("%.1f", unitPrice) + " MMK");
                }

                double total = subTotal + deliveryFee;
        %>

        <!-- Order Card -->
		<div class="order-card">
		    <div class="order-header">
		        <span class="order-id">Transaction ID: <%= transId %></span>
		        <span class="status-badge <%= shippedFlag == 1 ? "status-success" : "status-warning" %>">
		            <%= shippedFlag == 1 ? "ORDER_SHIPPED" : "ORDER_PLACED" %>
		        </span>
		    </div>
		
		    <!-- Product list stays at the top -->
		    <div class="order-body">
		        <ul class="products-list">
		            <%
		                for (Map.Entry<String, String> prodEntry : productMap.entrySet()) {
		            %>
		                <li>
		                    <strong><%= prodEntry.getKey() %></strong>
		                    <%= prodEntry.getValue() %>
		                </li>
		            <%
		                }
		            %>
		        </ul>
		    </div>
		
		    <!-- Stick these at the bottom -->
		    <div class="order-summary">
			    <div>Delivery: <%= String.format("%.1f", deliveryFee) %> MMK</div>
			    <div class="total">Total: <%= String.format("%.1f", total) %> MMK</div>
			</div>
		
		    <div style="margin-top: 10px;">
		        <span><span class="glyphicon glyphicon-time"></span>
				    <%= (time != null)
				          ? new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a")
				                .format(time)
				          : "" %>
				</span>
		    </div>
		</div>
		
		        <%
		            }
		            if (ordersByTrans.isEmpty()) {
		        %>
		        <div class="empty-state">
		            <span class="glyphicon glyphicon-inbox"></span>
		            <h5>No Orders Available</h5>
		            <p>You have not placed any orders yet.</p>
		        </div>
		        <%
		            }
		        %>
		    </div>
		</div>

<%@ include file="footer.html"%>
</body>
</html>