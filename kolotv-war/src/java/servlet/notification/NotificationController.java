package servlet.notification;

import bean.CGenUtil;
import com.google.gson.Gson;
import historique.MapUtilisateur;
import notification.Notification;
import station.export.ExportCsv;
import user.UserEJB;
import utilitaire.UtilDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/NotificationServlet"})
public class NotificationController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String action = request.getParameter("action");
        if (action != null) {
            if (action.equals("send_notif")) {sendNotif(request, response);}
            if (action.equals("find_notif")) {findNotification(request, response);}
        }
    }

    public void findNotification(HttpServletRequest request, HttpServletResponse response){
        try {
            // Convertir en JSON
            user.UserEJB u= (user.UserEJB) request.getSession().getValue("u");
            Notification [] notifications = Notification.getNotificationNonLu(String.valueOf(u.getUser().getRefuser()),null);
            List<Map<String,Object>> notificationList= new ArrayList<>();
            for (int i = 0; i < notifications.length; i++) {
                if (i>=5){
                    break;
                }
                Map<String,Object> attr = new HashMap<>();
                attr.put("id",notifications[i].getId());
                attr.put("objet",notifications[i].getObjet());
                attr.put("message",notifications[i].getMessage());
                attr.put("lien",notifications[i].getLien());
                attr.put("daty",notifications[i].getDaty());
                attr.put("heure",notifications[i].getHeure());
                notificationList.add(attr);
            }
            String json = new Gson().toJson(notificationList);

            // Envoyer la réponse
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void sendNotif(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (request.getParameterValues("ids")!=null && request.getParameter("description")!=null) {
            Connection c = new UtilDB().GetConn();
            user.UserEJB u= (user.UserEJB) request.getSession().getValue("u");
            MapUtilisateur[] allUsers = (MapUtilisateur[]) CGenUtil.rechercher(new MapUtilisateur(),null,null,c," AND REFUSER!="+u.getUser().getRefuser()+"");
            String [] id = request.getParameterValues("ids");
            String description = request.getParameter("description");
            LocalDateTime dateTime = LocalDateTime.now();
            List<Notification> notifications = new ArrayList<>();
            for(String i:id){
                Notification notif = new Notification();
                notif.setIdUser(String.valueOf(u.getUser().getRefuser()));
                notif.setObjet(u.getUser().getNomuser());
                notif.setDaty(Date.valueOf(dateTime.toLocalDate()));
                notif.setHeure(dateTime.toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm")));
                notif.setMessage(description);
                notif.setIdObjet(i);
                notif.setPriorite(1);
                notif.setLien("reservation/reservation-details-fiche.jsp&id="+i);
                notifications.addAll(Arrays.asList(notif.dupliquerNotification(allUsers)));
            }
            Notification.saveAll(notifications.toArray(new Notification[]{}), String.valueOf(u.getUser().getRefuser()),c);
            c.close();
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ExportCsv.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ExportCsv.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
