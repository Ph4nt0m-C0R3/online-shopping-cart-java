package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.shashi.beans.TransactionBean;
import com.shashi.service.TransService;
import com.shashi.utility.DBUtil;

public class TransServiceImpl implements TransService {

	@Override
	public String getUserId(String transId) {
		String userId = "";

		Connection con = DBUtil.provideConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement("select username from transactions where transid=?");

			ps.setString(1, transId);

			rs = ps.executeQuery();

			if (rs.next())
				userId = rs.getString(1);

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return userId;
	}
	
	public TransactionBean getTransactionById(String transId) {
	    TransactionBean trans = null;

	    try (Connection con = DBUtil.provideConnection();
	         PreparedStatement ps = con.prepareStatement(
	             "SELECT transid, username, time, amount, delivery_fee FROM transactions WHERE transid=?"
	         )) {
	        ps.setString(1, transId);

	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                trans = new TransactionBean(
	                    rs.getString("transid"),
	                    rs.getString("username"),
	                    rs.getTimestamp("time"),
	                    rs.getDouble("amount")
	                );
	                trans.setDeliveryFee(rs.getDouble("delivery_fee")); // NEW
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return trans;
	}

}
