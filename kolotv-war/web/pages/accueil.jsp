<%@ page import="user.UserEJB" %><%--
    Document   : acceuil.jsp
    Created on : 30 mars 2023, 17:23:45
    Author     : Ny Anjara Mamisoa
--%>
<%
    UserEJB u = (user.UserEJB) session.getValue("u");
    String url = "reservation/reservation-details-calendrier.jsp";
    if (u.getUser().getIdrole().equals("diffuseur")){
        url = "reservation/planning-diffuseur.jsp";
    }
%>
<jsp:include page="<%=url%>">
    <jsp:param name="section" value="dashboard"/>
</jsp:include>
