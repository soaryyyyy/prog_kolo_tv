<%-- 
    Document   : file-liste-2
    Created on : 8 avr. 2025, 11:42:14
    Author     : bruel
--%>

<%@page import="filemanager.MyFileFilter"%>
<%@page import="filemanager.Util"%>
<%@page import="java.util.List"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="java.io.File"%>
<%
    String parent_dir = request.getParameter("parent");
    System.out.println(Util.BASE_DIR + (parent_dir == null || parent_dir.isEmpty()  ? Util.base : parent_dir));
    File parent = new File(Util.BASE_DIR + (parent_dir == null || parent_dir.isEmpty()  ? Util.base : parent_dir));
    String apres = "filemanager/file-liste-2.jsp";
    String lien = (String)session.getAttribute("lien");
    String lienapres = lien + "?but=" + apres;
    if(parent.isDirectory()){
        MyFileFilter fileFilter = new MyFileFilter();
        fileFilter.setName(request.getParameter("name"));
        fileFilter.setSort(request.getParameter("sort"));
        List<File> files = fileFilter.applyTo(parent);
        String prevpath = MyFileFilter.getPreviousPath(parent_dir);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des fichiers</h1>
    </section>
    <section class="content">
        <div class="box-body table-responsive no-padding">
            <form action="<%= lien %>" method="get" name="search" id="search">
                <input type="hidden" name="but" value="<%= apres %>" id="but">
                <div class="row">
                    <div class="row col-md-12">
                        <div class="box box-solid collapsed">
                            <div style="background:#806000; color:white;" class="box-header with-border"><h3 class="box-title" color="#edb031"><span color="#edb031">Recherche avancée</span></h3><div class="box-tools pull-right"><button data-original-title="Collapse" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title=""><i class="fa fa-plus"></i></button> </div></div>
                            <div class="box-body" id="pagerecherche">
                                <div class="form-group"><div class="col-md-4"><label for="name">Nom</label><input name="name" type="textbox" class="form-control" id="name" value="<%= Utilitaire.champNull(request.getParameter("name")) %>" ></div></div>
                                <input type="hidden" id="sort" name="sort" value="<%= Utilitaire.champNull(request.getParameter("sort")) %>">
                                <input type="hidden" id="parent" name="parent" value="<%= Utilitaire.champNull(parent_dir) %>">
                            </div>
                            <div class="box-footer">
                                <div class="row col-md-12">
                                   <div class="col-xs-4" align="center"><input name="afficher" value="Afficher" type="submit" class="btn" style="background:#806000; color:white" id="btnAfficher"></div>
                                </div>
                             </div>
                        </div>  
                    </div>    
                </div>
            </form>
            <br />
            <div style="display: flex; align-items: center;">
                <p style="margin-right: 20px;"><%= Utilitaire.champNull(parent_dir) %></p>
                <% if(prevpath != null){ %>
                <a class="btn btn-secondary" href="<%= lienapres %>&parent=<%= prevpath %>" role="button"><i class="fa fa-arrow-circle-left fa-2x" aria-hidden="true"></i></a>
                <% } %>
            </div>
            
            <table class="table table-hover table-bordered" id="recapitulation" border="0">
                <thead>
                    <tr class="head">
                        <th class="text-left" style="background-color:#806000; color: white;">
                            <span>Nom</span>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <i class="fa fa-long-arrow-up" style="cursor:pointer;" onclick="sort(0)" aria-hidden="true"></i>
                            &nbsp;
                            <i class="fa fa-long-arrow-down" style="cursor:pointer;" onclick="sort(1)" aria-hidden="true"></i>
                        </th>
                    </tr>
                </thead>
                <% for(File f: files){ 
                String href = "/" + f.getName();
                if(parent_dir != null && !parent_dir.isEmpty()){ 
                    href = parent_dir + href;
                }else{
                    href=Util.base+ "/" + f.getName();
                }
                %>
               
                <tr class="body">
                    <td class="text-left">
                        <a href="<%= f.isDirectory() ? lienapres + "&parent=" + href : "../FileManager2?parent=" + href %>" >
                            <i class='<%= f.isDirectory() ? "fa fa-folder-o":"fa fa-file-o"  %>' aria-hidden="true"></i>&nbsp;&nbsp;<%= f.getName() %>
                        </a>
                    </td>
                </tr>                
                <% } %>
            </table>
        </div>
    </section>
</div>
<script>
    function sort(order){
        $('#sort').val(order);
        $('#search').submit();
    }
</script>  
<% } else { %>
    <script>alert("Dossier invalide"); history.back(); </script>
<% } %>
