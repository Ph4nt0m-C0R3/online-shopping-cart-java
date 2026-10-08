package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.shashi.beans.CartBean;
import com.shashi.beans.DeliveryResult;
import com.shashi.beans.OrderBean;
import com.shashi.beans.OrderDetails;
import com.shashi.beans.TransactionBean;
import com.shashi.service.OrderService;
import com.shashi.utility.DBUtil;
import com.shashi.utility.MailMessage;

public class OrderServiceImpl implements OrderService {

	@Override
	public String paymentSuccess(String userName, double paidAmount, double deliveryFee, String postalCode) {

		DeliveryResult deliveryResult = null;
		String deliveryAddress = null;
		int waitingDays = 0;

		if (postalCode != null && !postalCode.trim().isEmpty()) {
		    deliveryResult = new DeliveryServiceImpl().checkDelivery(postalCode.trim());
		    if (deliveryResult.isAvailable()) {
		        deliveryFee = deliveryResult.getFee();
		        waitingDays = deliveryResult.getWaitingDays();
		        deliveryAddress = (deliveryResult.getAreaName() != null ? deliveryResult.getAreaName() : "Delivery Area") + " (" + postalCode.trim() + ")";
		    } else {
		        deliveryFee = 0;
		        waitingDays = 0;
		        postalCode = null; // treat as skip
		    }
		} else {
		    deliveryFee = 0; waitingDays = 0; postalCode = null;
		}

	    // Now proceed with your existing order placement logic
	    List<CartBean> cartItems = new CartServiceImpl().getAllCartItems(userName);
	    if (cartItems.isEmpty()) return "Order Placement Failed!";

	    double cartTotal = cartItems.stream()
	            .mapToDouble(item -> new ProductServiceImpl().getProductPrice(item.getProdId()) * item.getQuantity())
	            .sum();

	    double grandTotal = cartTotal + deliveryFee;

	    if (paidAmount < grandTotal) {
	        return "Payment Failed! Required: " + grandTotal + " MMK (including delivery).";
	    }

	    TransactionBean transaction = new TransactionBean(userName, paidAmount, deliveryFee);
	    boolean ordered = false;
	    String transactionId = transaction.getTransactionId();

	    for (CartBean item : cartItems) {
	        double amount = new ProductServiceImpl().getProductPrice(item.getProdId()) * item.getQuantity();

	        // ✅ No delivery fee here – product order should only store product cost
	        OrderBean order = new OrderBean(transactionId, item.getProdId(), item.getQuantity(), amount, 0.0);
	        order.setPostalCode(postalCode);
	        order.setDeliveryAddress(deliveryAddress);

	        ordered = addOrder(order);
	        if (!ordered) break;

	        ordered = new CartServiceImpl().removeAProduct(item.getUserId(), item.getProdId());
	        if (!ordered) break;

	        ordered = new ProductServiceImpl().sellNProduct(item.getProdId(), item.getQuantity());
	        if (!ordered) break;
	    }

	    if (ordered) {
	        ordered = addTransaction(transaction);
	        if (ordered) {
	        	// build product lines from cartItems
	        	String productLinesHtml = buildProductLinesFromCart(cartItems);

	        	// ... after addTransaction(transaction) succeeds:
	        	MailMessage.transactionSuccess(
	        	    userName,
	        	    new UserServiceImpl().getFName(userName),
	        	    transaction.getTransactionId(),
	        	    cartTotal,
	        	    deliveryFee,
	        	    grandTotal,
	        	    productLinesHtml // <-- new
	        	);
	            return "Order Placed Successfully!"
	                 + (waitingDays > 0 ? " Delivery in " + waitingDays + " days."
	                                    : " (Self pickup / No delivery).");
	        }
	    }

	    return "Order Placement Failed!";
	}

	@Override
	public boolean addOrder(OrderBean order) {
	    boolean flag = false;
	    Connection con = DBUtil.provideConnection();
	    PreparedStatement ps = null;

	    try {
	        ps = con.prepareStatement(
	            "INSERT INTO orders(orderid, prodid, quantity, amount, shipped, postalCode, deliveryAddress) " +
	            "VALUES(?,?,?,?,?,?,?)"
	        );
	        ps.setString(1, order.getTransactionId());
	        ps.setString(2, order.getProductId());
	        ps.setInt(3, order.getQuantity());
	        ps.setDouble(4, order.getAmount());
	        ps.setInt(5, 0);
	        ps.setString(6, order.getPostalCode());
	        ps.setString(7, order.getDeliveryAddress());

	        flag = ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        DBUtil.closeConnection(ps);
	        DBUtil.closeConnection(con);
	    }
	    return flag;
	}

	@Override
	public boolean addTransaction(TransactionBean transaction) {
	    boolean flag = false;
	    Connection con = DBUtil.provideConnection();
	    PreparedStatement ps = null;

	    try {
	        ps = con.prepareStatement(
	            "INSERT INTO transactions (transid, username, time, amount, delivery_fee) VALUES (?,?,?,?,?)"
	        );
	        ps.setString(1, transaction.getTransactionId());
	        ps.setString(2, transaction.getUserName());
	        ps.setTimestamp(3, transaction.getTransDateTime());
	        ps.setDouble(4, transaction.getTransAmount());    // maps to `amount`
	        ps.setDouble(5, transaction.getDeliveryFee());    // NEW

	        flag = ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        DBUtil.closeConnection(ps);
	        DBUtil.closeConnection(con);
	    }
	    return flag;
	}

	@Override
	public int countSoldItem(String prodId) {
		int count = 0;

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;

		ResultSet rs = null;

		try {
			ps = con.prepareStatement("select sum(quantity) from orders where prodid=?");

			ps.setString(1, prodId);

			rs = ps.executeQuery();

			if (rs.next())
				count = rs.getInt(1);

		} catch (SQLException e) {
			count = 0;
			e.printStackTrace();
		}

		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);
		DBUtil.closeConnection(rs);

		return count;
	}

	@Override
	public List<OrderBean> getAllOrders() {
	    List<OrderBean> orderList = new ArrayList<>();
	    Connection con = DBUtil.provideConnection();
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {
	        ps = con.prepareStatement(
	            "SELECT orderid, prodid, quantity, amount, shipped, postalCode, deliveryAddress FROM orders"
	        );
	        rs = ps.executeQuery();
	        while (rs.next()) {
	            OrderBean order = new OrderBean(
	                rs.getString("orderid"),
	                rs.getString("prodid"),
	                rs.getInt("quantity"),
	                rs.getDouble("amount"),
	                rs.getInt("shipped")
	            );
	            order.setPostalCode(rs.getString("postalCode"));
	            order.setDeliveryAddress(rs.getString("deliveryAddress"));
	            orderList.add(order);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        DBUtil.closeConnection(rs);
	        DBUtil.closeConnection(ps);
	        DBUtil.closeConnection(con);
	    }
	    return orderList;
	}

	@Override
	public List<OrderBean> getOrdersByUserId(String emailId) {
	    List<OrderBean> orderList = new ArrayList<>();
	    Connection con = DBUtil.provideConnection();
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {
	        ps = con.prepareStatement(
	            "SELECT o.orderid, o.prodid, o.quantity, o.amount, o.shipped, o.postalCode, o.deliveryAddress " +
	            "FROM orders o " +
	            "INNER JOIN transactions t ON o.orderid = t.transid " +
	            "WHERE t.username = ?"
	        );
	        ps.setString(1, emailId);
	        rs = ps.executeQuery();

	        while (rs.next()) {
	            OrderBean order = new OrderBean(
	                rs.getString("orderid"),
	                rs.getString("prodid"),
	                rs.getInt("quantity"),
	                rs.getDouble("amount"),
	                rs.getInt("shipped")
	            );
	            order.setPostalCode(rs.getString("postalCode"));
	            order.setDeliveryAddress(rs.getString("deliveryAddress"));
	            orderList.add(order);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        DBUtil.closeConnection(rs);
	        DBUtil.closeConnection(ps);
	        DBUtil.closeConnection(con);
	    }
	    return orderList;
	}

	@Override
	public List<OrderDetails> getAllOrderDetails(String userEmailId) {
		List<OrderDetails> orderList = new ArrayList<OrderDetails>();

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement(
				    "SELECT p.pid AS prodid, o.orderid AS orderid, o.shipped AS shipped, " +
				    "       p.image AS image, p.pname AS pname, o.quantity AS qty, o.amount AS amount, " +
				    "       t.delivery_fee AS delivery_fee, t.time AS time " +
				    "FROM orders o " +
				    "JOIN product p ON p.pid = o.prodid " +
				    "JOIN transactions t ON t.transid = o.orderid " +
				    "WHERE t.username = ?"
				);
			
			ps.setString(1, userEmailId);
			rs = ps.executeQuery();

			while (rs.next()) {
			    OrderDetails order = new OrderDetails();
			    order.setOrderId(rs.getString("orderid"));
			    order.setProdImage(rs.getAsciiStream("image"));
			    order.setProdName(rs.getString("pname"));
			    order.setQty(rs.getString("qty"));
			    order.setAmount(rs.getString("amount"));
			    order.setTime(rs.getTimestamp("time"));
			    order.setProductId(rs.getString("prodid"));
			    order.setShipped(rs.getInt("shipped"));
			    order.setDeliveryFee(rs.getDouble("delivery_fee"));  // ✅ include delivery fee
			    orderList.add(order);
			}

		} catch (SQLException e) {

			e.printStackTrace();
		}

		return orderList;
	}

	@Override
	public String shipNow(String orderId, String prodId) {
		String status = "FAILURE";

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;

		try {
			ps = con.prepareStatement("update orders set shipped=1 where orderid=? and prodid=? and shipped=0");

			ps.setString(1, orderId);
			ps.setString(2, prodId);

			int k = ps.executeUpdate();

			if (k > 0) {
				status = "Order Has been shipped successfully!!";
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);

		return status;
	}
	
	public List<String> getUnshippedTransactionIds() {
	    List<String> transIds = new ArrayList<>();
	    try (Connection con = DBUtil.provideConnection()) {
	        String sql = "SELECT DISTINCT orderid FROM orders WHERE shipped = 0";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            transIds.add(rs.getString("orderid"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return transIds;
	}
	
	public List<OrderBean> getOrdersByTransaction(String transId) {
	    List<OrderBean> orders = new ArrayList<>();
	    try (Connection con = DBUtil.provideConnection()) {
	        String sql = "SELECT * FROM orders WHERE orderid = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, transId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            OrderBean order = new OrderBean();
	            order.setTransactionId(rs.getString("orderid"));
	            order.setProductId(rs.getString("prodid"));
	            order.setQuantity(rs.getInt("quantity"));
	            order.setAmount(rs.getDouble("amount"));
	            order.setShipped(rs.getInt("shipped"));
	            order.setDeliveryAddress(rs.getString("deliveryAddress"));
	            orders.add(order);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return orders;
	}
	
	public List<String> getShippedTransactionIds() {
	    List<String> transIds = new ArrayList<>();
	    try (Connection con = DBUtil.provideConnection()) {
	        String sql = "SELECT DISTINCT orderid FROM orders WHERE shipped = 1";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            transIds.add(rs.getString("orderid"));
	        }
	        DBUtil.closeConnection(rs);
	        DBUtil.closeConnection(ps);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return transIds;
	}
	
	// minimal HTML-escape
	private String esc(String s) {
	    if (s == null) return "";
	    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
	}

	// build product lines from CartBean list (CartBean has prodId, quantity)
	private String buildProductLinesFromCart(List<CartBean> cartItems) {
	    if (cartItems == null || cartItems.isEmpty()) return "";

	    ProductServiceImpl prodSvc = new ProductServiceImpl();
	    StringBuilder sb = new StringBuilder();

	    for (CartBean item : cartItems) {
	        int qty = item.getQuantity() > 0 ? item.getQuantity() : 1;
	        // product unit price (from DB)
	        double unitPrice = prodSvc.getProductPrice(item.getProdId());
	        String prodName = item.getProdId();
	        try {
	            com.shashi.beans.ProductBean pb = prodSvc.getProductDetails(item.getProdId());
	            if (pb != null && pb.getProdName() != null && !pb.getProdName().trim().isEmpty()) {
	                prodName = pb.getProdName();
	            }
	        } catch (Exception ignore) {}

	        sb.append(esc(prodName))
	          .append(" (x").append(qty).append(") - ")
	          .append(String.format("%.1f", unitPrice)).append(" MMK")
	          .append("<br/>");
	    }
	    return sb.toString();
	}
	
	public String paymentSuccessForSingleProduct(String userName,
            String prodId,
            int quantity,
            double paidAmount,
            double deliveryFee,
            String postalCode) {

		DeliveryResult deliveryResult = null;
		String deliveryAddress = null;
		int waitingDays = 0;
		
		if (postalCode != null && !postalCode.trim().isEmpty()) {
			postalCode = postalCode.trim();
			deliveryResult = new DeliveryServiceImpl().checkDelivery(postalCode);
			if (deliveryResult != null && deliveryResult.isAvailable()) {
				deliveryFee = deliveryResult.getFee();
				waitingDays = deliveryResult.getWaitingDays();
				deliveryAddress = (deliveryResult.getAreaName() != null ? deliveryResult.getAreaName() : "Delivery Area")
				+ " (" + postalCode + ")";
			} else {
				postalCode = null;
				deliveryFee = 0;
				waitingDays = 0;
			}
		} else {
			postalCode = null;
			deliveryFee = 0;
			waitingDays = 0;
		}
		
		ProductServiceImpl prodSvc = new ProductServiceImpl();
		com.shashi.beans.ProductBean pb = prodSvc.getProductDetails(prodId);
		
		if (pb == null) return "Product not found!";
		if (pb.getProdQuantity() < quantity) return "Insufficient stock for " + (pb.getProdName() != null ? pb.getProdName() : prodId);
		
			double unitPrice = prodSvc.getProductPrice(prodId);
			double itemAmount = unitPrice * quantity;
			double grandTotal = itemAmount + deliveryFee;
		
		if (paidAmount < grandTotal) {
			return "Payment Failed! Required: " + grandTotal + " MMK (including delivery).";
		}
		
		TransactionBean transaction = new TransactionBean(userName, paidAmount, deliveryFee);
		
		String transactionId = transaction.getTransactionId();
		
		OrderBean order = new OrderBean(transactionId, prodId, quantity, itemAmount, 0.0);
		order.setPostalCode(postalCode);
		order.setDeliveryAddress(deliveryAddress);
		
		boolean ok = addOrder(order);
		if (!ok) return "Order Placement Failed!";
		
		ok = new ProductServiceImpl().sellNProduct(prodId, quantity);
		if (!ok) {
			// Ideally rollback - minimal approach:
			return "Order Placement Failed while updating stock!";
		}
		
		try {
			new CartServiceImpl().removeAProduct(userName, prodId);
		} catch (Exception ignore) {}
		
		ok = addTransaction(transaction);
		if (!ok) {
			return "Order Placement Failed while saving transaction!";
		}
		
		String productLinesHtml = buildProductLineForSingleProduct(prodId, quantity);
		MailMessage.transactionSuccess(
			userName,
			new UserServiceImpl().getFName(userName),
					transactionId,
					itemAmount,
					deliveryFee,
					grandTotal,
					productLinesHtml
				);
		
		return "Order Placed Successfully!" + (waitingDays > 0 ? " Delivery in " + waitingDays + " days." : " (Self pickup / No delivery).");
		}
		
			private String buildProductLineForSingleProduct(String prodId, int qty) {
			ProductServiceImpl prodSvc = new ProductServiceImpl();
			com.shashi.beans.ProductBean pb = prodSvc.getProductDetails(prodId);
			String prodName = (pb != null && pb.getProdName() != null) ? pb.getProdName() : prodId;
			double unitPrice = prodSvc.getProductPrice(prodId);
			return esc(prodName) + " (x" + qty + ") - " + String.format("%.1f", unitPrice) + " MMK<br/>";
		}
			
	public int getUnshippedCount() {
	    int count = 0;
	    try (Connection con = DBUtil.provideConnection();
	         PreparedStatement ps = con.prepareStatement("SELECT COUNT(DISTINCT orderid) FROM orders WHERE shipped = 0");
	         ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return count;
	}

}
