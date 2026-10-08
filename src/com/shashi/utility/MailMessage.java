package com.shashi.utility;

import jakarta.mail.MessagingException;
import java.security.SecureRandom;

public class MailMessage {
	private static String generatePromoCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder promoCode = new StringBuilder("SMART"); // Brand prefix

        for (int i = 0; i < 5; i++) { // 5 random characters
            int index = random.nextInt(chars.length());
            promoCode.append(chars.charAt(index));
        }
        return promoCode.toString();
    }
	
	public static void registrationSuccess(String emailId, String name) {
		String recipient = emailId;
		String subject = "Registration Successfull";
		String promoCode = generatePromoCode();
		String htmlTextMessage = "" + "<html>"
			    + "<body style='font-family: Arial, sans-serif; line-height: 1.6;'>"
			    + "<h2 style='color:#D63384;'>Welcome to Smart Care Cosmetics!</h2>"
			    + "Hi " + name + ",<br><br>"
			    + "Thank you for joining <b>Smart Care Cosmetics</b>. your one-stop destination for premium beauty and skincare products."
			    + "<br><br>"
			    + "We are excited to have you with us! Explore our exclusive collection of cosmetics and enjoy up to "
			    + "<b style='color:#E74C3C;'>60% OFF</b> on selected items."
			    + "<br><br>"
			    + "As a special <b>Welcome Gift</b>, we are offering you an additional "
			    + "<b style='color:#27AE60;'>10% OFF</b> (up to 5000 MMK) on your very first purchase."
			    + "<br><br>"
			    + "Simply use the promo code below during checkout:"
			    + "<br><br>"
			    + "<div style='background-color:#F8F9FA; padding:10px; border:1px dashed #D63384; display:inline-block;'>"
			    + "<b>PROMO CODE: " + promoCode + "</b>"
			    + "</div>"
			    + "<br><br>"
			    + "Hurry! This exclusive offer won't last forever!<br>"
			    + "We offer <b>FREE home delivery</b> on all orders and carry only the best, most trusted brands."
			    + "<br><br>"
			    + "Happy Shopping!<br>"
			    + "<b>Team Smart Care Cosmetics</b>"
			    + "</body>"
			    + "</html>";
		try {
			JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void transactionSuccess(
	        String recipientEmail, String name, String transId,
	        double subtotal, double deliveryFee, double totalAmount,
	        String productLinesHtml
	) {
	    String recipient = recipientEmail;
	    String subject = "Order Placed at Smart Care Cosmetics";

	    String htmlTextMessage = ""
	        + "<html><body style='font-family: Arial, sans-serif; line-height: 1.6;'>"
	        + "  <p>"
	        + "    <span style='color:#2c3e50;'>Hey </span><span style='color:white;font-weight:bold;'>" + name + "</span>,<br/><br/>"
	        + "    <span style='color:#2c3e50;'>Thank you for shopping with </span><b style='color:#ff3385;'>Smart Care Cosmetics</b>!<br/><br/>"
	        + "    <b style='color:#0d6efd;'>Transaction Details:</b><br/><br/>"
	        + "    <font style='color:#b30000;font-weight:bold;'>Transaction ID:</font> "
	        + "    <font style='color:green;font-weight:bold;'>" + transId + "</font><br/><br/>"

	        + (productLinesHtml == null ? "" : "<div style='color:#2c3e50;'>" + productLinesHtml + "</div>")
	        + "<br/>"

	        + "    <b style='color:#0d6efd;'>Subtotal</b> - <span style='color:#27ae60;'>" + String.format("%.1f", subtotal) + " MMK</span><br>"
	        + "    <b style='color:#0d6efd;'>Delivery fee</b> - <span style='color:#27ae60;'>" + String.format("%.1f", deliveryFee) + " MMK</span><br/>"
	        + "    <b style='color:#0d6efd;'>Total amount</b> - <span style='color:green;font-weight:bold;'>" + String.format("%.1f", totalAmount) + " MMK</span><br/><br/>"
	        + "    <span style='color:#2c3e50;'>We truly appreciate your trust in us.</span><br/><br/>"
	        + "    <font style='color:#ff3385;font-weight:bold;'>Smart Care Cosmetics</font><br/>"
	        + "    <small style='color:gray;'>This is an automated confirmation. You don't need to reply to this email.</small>"
	        + "  </p>"
	        + "</body></html>";

	    try { JavaMailUtil.sendMail(recipient, subject, htmlTextMessage); }
	    catch (MessagingException e) { e.printStackTrace(); }
	}

	public static void orderShipped(
	        String recipientEmail, String name, String transId,
	        double subtotal, double deliveryFee, double totalAmount,
	        String productLinesHtml
	) {
	    String recipient = recipientEmail;
	    String subject = "Hurray!! Your Order has been Shipped from Smart Care Cosmetics";

	    String htmlTextMessage = ""
	        + "<html><body style='font-family: Arial, sans-serif; line-height: 1.6;'>"
	        + "  <p>"
	        + "    <span style='color:#2c3e50;'>Hey </span><span style='color:white;font-weight:bold;'>" + name + "</span>,<br/><br/>"
	        + "    <span style='color:#2c3e50;'>Your order has been shipped and is on its way!</span><br/><br/>"
	        + "    <b style='color:#0d6efd;'>Transaction Details:</b><br/><br/>"
	        + "    <font style='color:#b30000;font-weight:bold;'>Order ID:</font> "
	        + "    <font style='color:green;font-weight:bold;'>" + transId + "</font><br/><br/>"

	        + (productLinesHtml == null ? "" : "<div style='color:#2c3e50;'>" + productLinesHtml + "</div>")
	        + "<br/>"

	        + "    <b style='color:#0d6efd;'>Subtotal</b> - <span style='color:#27ae60;'>" + String.format("%.1f", subtotal) + " MMK</span><br>"
	        + "    <b style='color:#0d6efd;'>Delivery fee</b> - <span style='color:#27ae60;'>" + String.format("%.1f", deliveryFee) + " MMK</span><br/>"
	        + "    <b style='color:#0d6efd;'>Total amount</b> - <span style='color:green;font-weight:bold;'>" + String.format("%.1f", totalAmount) + " MMK</span><br/><br/>"
	        + "    <span style='color:#2c3e50;'>Thank you for shopping with us!</span><br/><br/>"
	        + "    <font style='color:#ff3385;font-weight:bold;'>Smart Care Cosmetics</font><br/>"
	        + "    <small style='color:gray;'>This is an automated confirmation. You don't need to reply to this email.</small>"
	        + "  </p>"
	        + "</body></html>";

	    try { JavaMailUtil.sendMail(recipient, subject, htmlTextMessage); }
	    catch (MessagingException e) { e.printStackTrace(); }
	}

	public static void productAvailableNow(String recipientEmail, String name, String prodName, String prodId) {
		String recipient = recipientEmail;
		String subject = "Product " + prodName + " is Now Available at Smart Care Cosmetics";
		String htmlTextMessage = ""
			    + "<html>"
			    + "  <body style='font-family: Arial, sans-serif; line-height: 1.6;'>"
			    + "    <p>"
			    + "      Hey " + name + ",<br/><br/>"
			    + "      We noticed that during your recent visit to <b>Smart Care Cosmetics</b>, "
			    + "      you were looking for a product that was out of stock at the time."
			    + "      <br/><br/>"
			    + "      Good news! The product you wanted — "
			    + "      <font style=\"color:green;font-weight:bold;\">" + prodName + "</font> "
			    + "      (Product ID: <font style=\"color:green;font-weight:bold;\">" + prodId + "</font>) — "
			    + "      is now back in stock and available for purchase!"
			    + "      <br/><br/>"
			    + "      <b>Product Details:</b><br/><br/>"
			    + "      <font style=\"color:#b30000;font-weight:bold;\">Product ID:</font> "
			    + "      <font style=\"color:green;font-weight:bold;\">" + prodId + "</font><br/><br/>"
			    + "      <font style=\"color:#b30000;font-weight:bold;\">Product Name:</font> "
			    + "      <font style=\"color:green;font-weight:bold;\">" + prodName + "</font>"
			    + "      <br/><br/>"
			    + "      Hurry — popular items sell out fast!<br/><br/>"
			    + "      <font style=\"color:green;font-weight:bold;\">Smart Care Cosmetics</font><br/>"
			    + "      <small style='color:gray;'>This is an automated notification. You don't need to reply to this email.</small>"
			    + "    </p>"
			    + "  </body>"
			    + "</html>";


		try {
			JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}

	public static String sendMessage(String toEmailId, String subject, String htmlTextMessage) {
		try {
			JavaMailUtil.sendMail(toEmailId, subject, htmlTextMessage);
		} catch (MessagingException e) {
			e.printStackTrace();
			return "FAILURE";
		}
		return "SUCCESS";
	}
}
