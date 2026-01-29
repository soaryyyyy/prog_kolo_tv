<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire"%>

<%@ page import="java.io.*" %>

<%
    String but = "";
    String queryString = "";
    try{
        queryString = request.getQueryString();
        but = "pages/testLogin.jsp";
        if(queryString != null && !queryString.equals("")){
            but += "?" + queryString;
        }
    }
    catch(Exception ex){ %>
        <script language="JavaScript">
        alert(<%=ex.getMessage()%>);
        document.location.replace("../index.jsp");
        </script>
   <% }
%>
<!DOCTYPE html>
  <html lang="FR" style="display: flex;align-items: center;justify-content: center;">
    <head>
      <meta charset="UTF-8">
      <title>Identification</title>
      <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
      <link href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css" rel="stylesheet">
      <link href="${pageContext.request.contextPath}/assets/css/refontlogin.css" rel="stylesheet">
      <link href="${pageContext.request.contextPath}/dist/css/stylecustom.css" rel="stylesheet">
    </head>

    <body class="login-page">
      <div class="login-box">
        <div class="login-logo">
              <a href="index.jsp">
                  <img src="${pageContext.request.contextPath}/assets/img/logo.jpeg" alt="Logo">
              </a>
        </div>
        <form action="<%=but%>" method="post" style="width: 100%;">
            <div class="form-group">
                <label class="fontinter labelinput" for="username">Utilisateur</label>
                <input type="text" id="username" name="identifiant" class="form-control" placeholder="" value="admin" required>
            </div>
            <div class="form-group">
                <label class="fontinter labelinput" for="password">Mot de passe</label>
                <input type="password" id="password" name="passe" class="form-control" placeholder="" value="test" required>
            </div>
            <button type="submit" class="btn btn-login">Se connecter</button>
        </form>
      </div>
      <script src="${pageContext.request.contextPath}/plugins/jQuery/jQuery-2.1.4.min.js" type="text/javascript"></script>
      <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    </body>
  </html>
