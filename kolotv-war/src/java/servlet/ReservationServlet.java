package servlet;

import com.google.gson.Gson;
import notification.Notification;
import reservation.Reservation;
import station.export.ExportCsv;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ReservationServlet", urlPatterns = {"/ReservationServlet"})
public class ReservationServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String action = request.getParameter("action");
        if (action != null) {
            if (action.equals("find_donnee_modif")) {findDonneeModif(request, response);}
            if (action.equals("find_details_planning")) {findDetailsPlanning(request, response);}
        }
    }

    public void findDonneeModif(HttpServletRequest request, HttpServletResponse response){
        try {
            // Convertir en JSON
            user.UserEJB u= (user.UserEJB) request.getSession().getValue("u");
            String dtDebut = request.getParameter("dtDebut");
            String dtFin = request.getParameter("dtFin");
            String idReservation = request.getParameter("idReservation");
            Reservation reservation = new Reservation();
            reservation.setId(idReservation);
            List<Map<String,Object>> list= reservation.prepareDataModif(dtDebut,dtFin,null);
            String json = new Gson().toJson(list);

            // Envoyer la réponse
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void findDetailsPlanning(HttpServletRequest request, HttpServletResponse response){
        try {
            // Convertir en JSON
            user.UserEJB u= (user.UserEJB) request.getSession().getValue("u");
            String dtDebut = request.getParameter("dtDebut");
            String dtFin = request.getParameter("dtFin");
            String idReservation = request.getParameter("idReservation");
            Reservation reservation = new Reservation();
            reservation.setId(idReservation);
            List<Map<String,Object>> list= reservation.getPlanningDetails(dtDebut,dtFin,null);
            String json = new Gson().toJson(list);

            // Envoyer la réponse
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);
        } catch (Exception e) {
            throw new RuntimeException(e);
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
