package servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import org.apache.commons.codec.binary.Base64;

@WebServlet("/SaveSignatureServlet")
public class SaveSignatureServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Récupération des paramètres
        String signature = request.getParameter("signature");
        String from = request.getParameter("from");
        String id = request.getParameter("id");
        String fromreel = from + "&id=" + id;
        System.out.println("FROM = " + fromreel );

        // Vérification
        if (signature == null || signature.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Signature manquante");
            return;
        }

        try {
            // Décodage base64
            String base64Data = signature.split(",")[1];
            byte[] imageBytes = Base64.decodeBase64(base64Data);

            // Chemin réel de l'application
            String currentAppPath = request.getServletContext().getRealPath("/");
            System.out.println("Current App Path: " + currentAppPath);

            File currentAppDir = new File(currentAppPath);
            File deploymentsDir = currentAppDir.getParentFile();    // remonte 1 niveau
            String deploymentsPath = deploymentsDir.getAbsolutePath();

            // WAR cible (à adapter si besoin)
            String targetWar = "dossier.war";
            String appRelativePath = "/report";

            // Dossier final
            String physicalPath = deploymentsPath + File.separator + targetWar + appRelativePath;

            // Création du WAR si absent
            File warDir = new File(deploymentsPath + File.separator + targetWar);
            if (!warDir.exists()) {
                warDir.mkdirs();
                System.out.println("WAR directory created: " + warDir.getAbsolutePath());
            }

            // Création dossier /report
            File dir = new File(physicalPath);
            if (!dir.exists()) {
                dir.mkdirs();
                System.out.println("Report directory created: " + physicalPath);
            }

            // Sauvegarde du fichier
            String filename = "signature.png";
            String filePath = physicalPath + File.separator + filename;

            try (FileOutputStream fos = new FileOutputStream(filePath)) {
                fos.write(imageBytes);
                System.out.println("Signature saved: " + filePath);
            }

            if (from != null && !from.isEmpty()) {
                System.out.println("Redirecting to: module.jsp?" + from);
                response.sendRedirect("pages/module.jsp?" + fromreel);
            } else {
                // fallback si from est absent
                System.out.println("FROM parameter missing – redirecting to home");
                response.sendRedirect("module.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur serveur: " + e.getMessage());
        }
    }
}
