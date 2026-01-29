package station.export;

import bean.CGenUtil;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import reservation.Mattraquage;
import reservation.Reservation;
import support.Support;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ExportCSV", urlPatterns = {"/ExportCSV"})
public class ExportCsv extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String action = request.getParameter("action");
        if (action != null) {
            if (action.equals("exp_reservation")) {exportReservationToExcel(request,response);}
            if (action.equals("exp_reservation_journalier")) {exportReservationToExcelJournalier(request,response);}
            if (action.equals("exp_reservation_mattraquage")) {exportMattraquage(request,response);}
        }
    }
    public void exportReservationToExcel(HttpServletRequest req, HttpServletResponse response) throws Exception {
        String idSupport = req.getParameter("idSupport");
        String fileName = "PLM-";
        if (idSupport != null && idSupport.isEmpty()==false) {
            Support support = new Support();
            support.setId(idSupport);
            support = (Support) CGenUtil.rechercher(support,null,null,null,"")[0];
            fileName += support.getVal();
        }
        fileName += "-"+Utilitaire.dateDuJour()+"-"+Utilitaire.heureCouranteHMS()+".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\""+fileName+"\"");
        try (OutputStream out = response.getOutputStream()) {
            XSSFWorkbook workbook = new XSSFWorkbook();
            Connection c = new UtilDB().GetConn();
            String idResa = req.getParameter("idReservation");
            String etat = req.getParameter("etat");
            Date dtDebut = null;
            Date dtFin = null;
            if (req.getParameter("dtDebut") != null && req.getParameter("dtDebut").isEmpty()==false) {
                dtDebut = Date.valueOf(req.getParameter("dtDebut"));
            }
            if (req.getParameter("dtFin") != null && req.getParameter("dtFin").isEmpty()==false) {
                dtFin = Date.valueOf(req.getParameter("dtFin"));
            }

            Reservation.imprimerExcel(workbook,idSupport,idResa,dtDebut,dtFin,etat,c);
            workbook.write(out);
            out.flush();
            workbook.close();
            if (c != null) c.close();
        }
    }

    public void exportReservationToExcelJournalier(HttpServletRequest req, HttpServletResponse response) throws Exception {
        String idSupport = req.getParameter("idSupport");
        String [] idTypeService = req.getParameterValues("idTypeService");
        String fileName = "PLM-";
        if (idSupport != null && idSupport.isEmpty()==false) {
            Support support = new Support();
            support.setId(idSupport);
            support = (Support) CGenUtil.rechercher(support,null,null,null,"")[0];
            fileName += support.getVal();
        }
        fileName += "-"+Utilitaire.dateDuJour()+"-"+Utilitaire.heureCouranteHMS()+".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\""+fileName+"\"");
        try (OutputStream out = response.getOutputStream()) {
            XSSFWorkbook workbook = new XSSFWorkbook();
            Connection c = new UtilDB().GetConn();
            String etat = req.getParameter("etat");
            String dtDebut = Utilitaire.dateDuJour();
            String dtFin = Utilitaire.dateDuJour();
            if (req.getParameter("dtDebut") != null && req.getParameter("dtDebut").isEmpty()==false) {
                dtDebut = Utilitaire.formatterDaty(Date.valueOf(req.getParameter("dtDebut")));
            }
            if (req.getParameter("dtFin") != null && req.getParameter("dtFin").isEmpty()==false) {
                dtFin = Utilitaire.formatterDaty(Date.valueOf(req.getParameter("dtFin")));
            }
            Reservation.imprimerExcelJournalier(workbook,idTypeService,idSupport,dtDebut,dtFin,etat,c);
            workbook.write(out);
            out.flush();
            workbook.close();
            if (c != null) c.close();
        }
    }

    public void exportMattraquage(HttpServletRequest req, HttpServletResponse response) throws Exception {
        String idSupport = req.getParameter("idSupport");
        String fileName = "PLM-";
        if (idSupport != null && idSupport.isEmpty()==false) {
            Support support = new Support();
            support.setId(idSupport);
            support = (Support) CGenUtil.rechercher(support,null,null,null,"")[0];
            fileName += support.getVal();
        }
        fileName += "-"+Utilitaire.dateDuJour()+"-"+Utilitaire.heureCouranteHMS()+".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\""+fileName+"\"");
        try (OutputStream out = response.getOutputStream()) {
            XSSFWorkbook workbook = new XSSFWorkbook();
            Connection c = new UtilDB().GetConn();
            String idResa = req.getParameter("idReservation");
            new Mattraquage().imprimerExcel(workbook,idResa,c);
            workbook.write(out);
            out.flush();
            workbook.close();
            if (c != null) c.close();
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
