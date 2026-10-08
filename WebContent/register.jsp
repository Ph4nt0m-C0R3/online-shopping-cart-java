<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Register</title>
<link rel="icon" type="image/png" href="images/SC.png">
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
    .register-card {
        background: #fff;
        border-radius: 15px;
        padding: 30px 25px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        transition: transform 0.3s ease;
        margin-top: 100px;
    }
    .register-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(0,0,0,0.2);
    }
    .register-card h2 {
        font-weight: bold;
        color: #b07fb5;
        margin-bottom: 20px;
    }
    .form-control {
        border-radius: 8px;
        border: 1px solid #ddd;
        box-shadow: none;
        transition: border-color 0.3s, box-shadow 0.3s;
    }
    .form-control:focus {
        border-color: #ff66b2;
        box-shadow: 0 0 6px rgba(255, 102, 178, 0.4);
    }
    .input-group-addon {
        background: #f9f1f6;
        border: 1px solid #ddd;
        border-left: none;
        cursor: pointer;
    }
    .btn-register {
        width: 100%;
        border-radius: 25px;
        padding: 12px;
        font-size: 16px;
        font-weight: bold;
        background: linear-gradient(135deg, #ff66b2, #ff3385) !important;
        border: none;
        color: #fff;
        transition: all 0.3s ease;
        margin-top: 10px;
    }
    .btn-register:hover {
        background: linear-gradient(135deg, #ff3385, #e60073);
        box-shadow: 0 4px 12px rgba(230, 0, 115, 0.3);
        color: #fff;
    }
    .message-text {
        font-size: 14px;
        margin-bottom: 10px;
        font-weight: 500;
        color: #ff3385;
    }
    .login-link {
        margin-top: 15px;
        font-size: 14px;
        text-align: center;
    }
    .login-link a {
        color: #ff3385;
        font-weight: bold;
        text-decoration: none;
    }
    .login-link a:hover {
        text-decoration: underline;
        color: #e60073;
    }
</style>
</head>
<body>

    <%@ include file="header.jsp"%>
    <%
    String message = request.getParameter("message");
    %>
    <div class="page-wrapper">
	    <div class="container">
	        <div class="row">
	            <form action="./RegisterSrv" method="post"
	                class="col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2 register-card">
	                
	                <div class="text-center">
	                    <h2>Register</h2>
	                    <%
	                    if (message != null) {
	                    %>
	                    <p class="message-text"><%=message%></p>
	                    <%
	                    }
	                    %>
	                </div>
	
	                <div class="row">
	                    <div class="col-md-6 form-group">
	                        <label for="first_name">Name</label>
	                        <input type="text" name="username" class="form-control"
	                        	placeholder="Enter your full name"
	                            value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
	                            required>
	                    </div>
	                    <div class="col-md-6 form-group">
	                        <label for="email">Email</label>
	                        <input type="email" name="email" class="form-control"
	                        	placeholder="demo@example.test"
	                            pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
	                            title="Enter a valid email address"
	                            value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
	                            required>
	                    </div>
	                </div>
	
	                <div class="form-group">
	                    <label for="address">Address</label>
	                    <textarea name="address" class="form-control" placeholder="Street, City, State, ZIP" required><%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %></textarea>
	                </div>
	
	                <div class="row">
	                    <div class="col-md-6 form-group">
	                        <label for="mobile">Mobile</label>
	                        <input type="number" name="mobile" class="form-control"
	                        	placeholder="09xxxxxxxxx"
	                            min="0"
	                            oninput="this.value = this.value.replace(/[^0-9]/g, '')"
	                            value="<%= request.getAttribute("mobile") != null ? request.getAttribute("mobile") : "" %>"
	                            required>
	                    </div>
	                    <div class="col-md-6 form-group">
						    <label for="postal_code">Postal Code</label>
						    <input type="text" name="postal_code" class="form-control"
						    	placeholder="Enter 5-digit postal code"
						        oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0,5)"
						        title="Postal code must be exactly 5 digits"
						        pattern="^\d{5}$"
						        value="<%= request.getAttribute("postal_code") != null ? request.getAttribute("postal_code") : "" %>"
						        required>
						</div>
	                </div>
	
	                <div class="row">
	                    <div class="col-md-6 form-group">
	                        <label for="password">Password</label>
	                        <div class="input-group">
	                            <input type="password" name="password"
	                                class="form-control" id="password"
	                                placeholder="Enter a strong password"
	                                pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
	                                title="Password must include uppercase, lowercase, number, and special character"
	                                required>
	                            <span class="input-group-addon" id="togglePassword">
	                                <span class="glyphicon glyphicon-eye-open"></span>
	                            </span>
	                        </div>
	                    </div>
	                    <div class="col-md-6 form-group">
	                        <label for="confirmPassword">Confirm Password</label>
	                        <div class="input-group">
	                            <input type="password" name="confirmPassword"
	                            	placeholder="Re-enter password"
	                                class="form-control" id="confirmPassword" required>
	                            <span class="input-group-addon" id="toggleConfirmPassword">
	                                <span class="glyphicon glyphicon-eye-open"></span>
	                            </span>
	                        </div>
	                    </div>
	                </div>
	
	                <button type="submit" class="btn btn-register">Register</button>
	
	                <div class="login-link">
	                    Already have an account? <a href="login.jsp">Login here</a>
	                </div>
	            </form>
	        </div>
	    </div>
    </div>

    <%@ include file="footer.html"%>
    
    <script>
        // Password toggle
        $("#togglePassword").click(function () {
            let passwordInput = $("#password");
            let icon = $(this).find("span");
            if (passwordInput.attr("type") === "password") {
                passwordInput.attr("type", "text");
                icon.removeClass("glyphicon-eye-open").addClass("glyphicon-eye-close");
            } else {
                passwordInput.attr("type", "password");
                icon.removeClass("glyphicon-eye-close").addClass("glyphicon-eye-open");
            }
        });
        $("#toggleConfirmPassword").click(function () {
            let passwordInput = $("#confirmPassword");
            let icon = $(this).find("span");
            if (passwordInput.attr("type") === "password") {
                passwordInput.attr("type", "text");
                icon.removeClass("glyphicon-eye-open").addClass("glyphicon-eye-close");
            } else {
                passwordInput.attr("type", "password");
                icon.removeClass("glyphicon-eye-close").addClass("glyphicon-eye-open");
            }
        });

        // Password match validation
        document.querySelector("form").addEventListener("submit", function(e) {
            let password = document.getElementById("password").value;
            let confirmPassword = document.getElementById("confirmPassword").value;
            if (password !== confirmPassword) {
                e.preventDefault();
                alert("Passwords do not match!");
            }
        });
        
    	// Auto scroll to form
        $(document).ready(function () {
		    $('html, body').animate({
		        scrollTop: $(".register-card").offset().top - ($(window).height() - $(".register-card").outerHeight())/2
		    }, 400);
		});
    </script>
</body>
</html>