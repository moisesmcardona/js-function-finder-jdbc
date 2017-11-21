<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title>Welcome</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <%
            String errorMessage = "Welcome! Please enter your details below. If you don't have an account, click the Register button.";
            int errorCode = 0;
            if (request.getParameter("error") != null)
                errorCode = Integer.parseInt(request.getParameter("error"));
            if (errorCode == 2)
                errorMessage = "Username does not exist";
            else if (errorCode == 3)
                errorMessage = "Username not validated. Check your email";
            else if (errorCode == 4)
                errorMessage = "Password is invalid";
            out.print(errorMessage);
        %>
        
        <form method="post" action="checkUsernameRegister.jsp">
            Username: <input name="username" type="text" /></br>
            Password: <input name="password" type="password" /></br>
        <input type="submit" name="login"  value="Log In"/> <input type="submit" name="login" value="Register"/>
        
       </form>
    </body>
</html>
