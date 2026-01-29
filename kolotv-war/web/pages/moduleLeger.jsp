<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="javax.ejb.ConcurrentAccessTimeoutException"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.*" %>

<%
    try {

        String but = "index.jsp";
        String lien = "module.jsp";
        String lienContenu = "index.jsp";
        String menu = "elements/menu/";
        String langue = "";
        if (request.getParameter("langue") != null) {
            session.setAttribute("langue", (String) request.getParameter("langue"));
        }
        langue = (String) session.getAttribute("langue");
%>
<%@include file="security-login.jsp"%>
<%    if (session.getAttribute("lien") != null) {
    lien = (String) session.getAttribute("lien");
}
    if (request.getParameter("idmenu") != null) {
        //session.setAttribute("lien", lien);
        session.setAttribute("menu", (String) request.getParameter("idmenu"));
    }
    if ((request.getParameter("but") != null) && session.getAttribute("u") != null) {
        but = request.getParameter("but");
    }
    else {%>
<script language="JavaScript">
    alert("Veuillez vous connecter pour acceder a ce contenu");
    document.location.replace("${pageContext.request.contextPath}/index.jsp");
</script>
<% }
%>

<!DOCTYPE html>
<html>
<%--<jsp:include page='elements/css.jsp'/>--%>


<body>
<!-- Site wrapper -->
    <% try {%>
     <jsp:include page="<%=but%>"/>

    <% } catch (Exception e) {%>
    <script language="JavaScript"> alert('<%=e.getMessage().toUpperCase()%>');
    history.back();</script>
    <%
        }
    %>



    <%
        UserEJB user = (UserEJB) request.getSession().getAttribute("u");
    %>


</body>

</html>
<%
    } catch (ConcurrentAccessTimeoutException e) {
        out.println("<script language='JavaScript'> document.location.replace('/cnaps-war/');</script>");
    }
%>
