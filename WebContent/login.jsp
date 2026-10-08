<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Login</title>
<link rel="icon" type="image/png" href="images/SC.png">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
    .login-card {
        background: #fff;
        border-radius: 15px;
        padding: 30px 25px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        transition: transform 0.3s ease;
        margin-top: 100px;
    }
    .login-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(0,0,0,0.2);
    }
    .login-card h2 {
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
    .btn-login {
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
    .btn-login:hover {
        background: linear-gradient(135deg, #ff3385, #e60073);
        box-shadow: 0 4px 12px rgba(230, 0, 115, 0.3);
        color: #fff;
    }
    .message-text {
        font-size: 14px;
        margin-bottom: 10px;
        font-weight: 500;
    }
    .register-link {
        margin-top: 15px;
        font-size: 14px;
        text-align: center;
    }
    .register-link a {
        color: #ff3385;
        font-weight: bold;
        text-decoration: none;
    }
    .register-link a:hover {
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
				<form action="./LoginSrv" method="post"
					class="col-md-4 col-md-offset-4 col-sm-8 col-sm-offset-2 login-card">
					
					<div class="text-center">
						<h2>Login</h2>
						<%
						if (message != null) {
						%>
						<p class="message-text" style="color: #ff3385;">
							<%=message%>
						</p>
						<%
						}
						%>
					</div>
					
					<div class="form-group">
						<label for="last_name">Email</label>
						<input type="email"
							placeholder="Enter Email"
							name="username"
							class="form-control"
							id="last_name" required>
					</div>
	
					<div class="form-group">
					    <label for="password">Password</label>
					    <div class="input-group">
					        <input type="password"
					               placeholder="Enter Password"
					               name="password"
					               class="form-control"
					               id="password"
					               required>
					        <span class="input-group-addon" id="togglePassword">
					            <span class="glyphicon glyphicon-eye-open"></span>
					        </span>
					    </div>
					</div>
	
					<div class="form-group">
						<label for="userrole">Login As</label>
						<select name="usertype"
							id="userrole"
							class="form-control" required>
							<option value="customer" selected>CUSTOMER</option>
							<option value="admin">ADMIN</option>
						</select>
					</div>
	
					<button type="submit" class="btn btn-login">Login</button>
	
					<div class="register-link">
					    Not registered yet? <a href="register.jsp">Create an account</a>
					</div>
				</form>
			</div>
		</div>
	</div>

	<%@ include file="footer.html"%>
	
	<script>
	    $(document).ready(function () {
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
	        
	     	// Auto scroll to form
	        $(document).ready(function () {
	            $('html, body').animate({
	                scrollTop: $(".login-card").offset().top - ($(window).height() - $(".login-card").outerHeight())/2
	            }, 400);
	        });
	    });
	</script>

</body>
</html>