<%--
    Document   : reservation-report
    Author     : Toky20
--%>
<%@page import="support.Support"%>
<%@page import="bean.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="produits.CategorieIngredient" %>
<%
    try {

%>
<style type="text/css">
    /* div {
       margin-top: 1em;
       margin-bottom: 1em;
   }

   input {
       padding: .5em;
       margin: .5em;
   }

   select {
       padding: .5em;
       margin: .5em;
   } */

    #signatureparent {
        color: darkblue;
        background-color: darkgrey;
        padding: 20px;
    }

    /* This is the div within which the signature canvas is fitted */
    #signature {
        border: 2px dotted black;
        background-color: lightgrey;
        height: 500px;
    }

    /* Drawing the 'gripper' for touch-enabled devices */
    html.touch #content {
        float: left;
        width: 92%;
    }

    html.touch #scrollgrabber {
        float: right;
        width: 4%;
        margin-right: 2%;
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAFCAAAAACh79lDAAAAAXNSR0IArs4c6QAAABJJREFUCB1jmMmQxjCT4T/DfwAPLgOXlrt3IwAAAABJRU5ErkJggg==)
    } */

    html.borderradius #scrollgrabber {
        border-radius: 1em;
    }
</style>

<div class="content-wrapper">
    <div>
        <div class="row">
            <div class="col-md-12">

                <div id="content">
                    <div id="signatureparent">
                        <div>Signez ici</div>
                        <div id="signature"></div>
                    </div>
                    <div id="tools" style="display: flex;align-items: first baseline;gap: 12px;">
                        <form action="/univ/imprimerRecu" method="post">
                            <input type="hidden" name="action" value="imprimerRecu"/>
                            <input type="hidden" name="id" value="<%=request.getParameter("id")%>"/>
                            <input type="hidden" name="signature" id="impression1"/>
                            <button class="link btn btn-primary" type="submit" id="btnImprimer1">Imprimer</button>
                        </form>

                        <!-- Formulaire 2 -->
                        <form action="/univ/imprimerRecu" method="post">
                            <input type="hidden" name="action" value="imprimerRecuXprinter"/>
                            <input type="hidden" name="id" value="<%=request.getParameter("id")%>"/>
                            <input type="hidden" name="signature" id="impression2"/>
                            <button class="link btn btn-secondary" type="submit" id="btnImprimer2">Imprimer sur XPRINTER</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div id="scrollgrabber"></div>
    </div>

</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

