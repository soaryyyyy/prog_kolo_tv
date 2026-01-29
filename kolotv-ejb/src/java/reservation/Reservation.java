package reservation;

import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import bean.ClassMere;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import client.Client;
import emission.ParrainageEmission;
import media.Media;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.bson.util.StringRangeSet;
import produits.Acte;
import produits.CategorieIngredient;
import produits.Ingredients;
import user.UserEJB;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.io.FileWriter;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Writer;
import java.sql.*;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

import caisse.MvtCaisse;
import prevision.Prevision;
import utils.CalendarUtil;
import utils.ConstanteKolo;
import utils.ConstanteStation;
import utils.ExcelUtil;
import vente.Vente;
import vente.VenteDetails;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@AiTabDesc("La table RESERVATION est conçue pour enregistrer les réservations effectuées par les clients, généralement dans un système de gestion de diffusion, de commande ou de prestation de service. Elle relie plusieurs entités clés comme les clients, les bons de commande, les supports de diffusion" +
        "Une reservation est facturer si la colonne etatFacturation est 1 \n"+
        "et elle est non facturer si la colonne etatFacturation est 0 \n")
public class Reservation extends ClassMere implements ClassIA
{
    String id;
    String idclient;
    Date daty;
    String remarque;
    private String idBc;
    String idSupport;
    String source;

    @Override
    public String getNomTableIA() {
        return "RESERVATIONLIB_ETAT_FACTURE";
    }
    @Override
    public String getUrlListe() {
        return "/pages/module.jsp?but=reservation/reservation-liste.jsp";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassAnalyse() {
        return this;
    }
    @Override
    public String getUrlAnalyse() {
        return "/pages/module.jsp?but=reservation/reservation-liste.jsp";
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public String getIdBc() {
        return idBc;
    }

    public void setIdBc(String idBc) {
        this.idBc = idBc;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdclient() {
        return idclient;
    }

    public void setIdclient(String idclient) {
        this.idclient = idclient;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public Reservation () throws Exception {
        setNomTable("reservation");
        setLiaisonFille("idmere");
        setNomClasseFille("reservation.ReservationDetails");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("RESA", "GETSEQRESERVATION");
        this.setId(makePK(c));
    }

    public void effectif(String u, Connection c) throws Exception
    {
        boolean isOuvert = false;
        try
        {
            if (c == null)
            {
                c = new UtilDB().GetConn();
                isOuvert = true;
            }
            ReservationDetails r = new ReservationDetails();
            r.setIdmere(this.getId());
            ReservationDetails[] res = (ReservationDetails[]) CGenUtil.rechercher(r, null, null, c, " ");
            for (int j = 0; j < res.length; j++)
            {
                Ingredients ing = new Ingredients();
                ing.setId(res[j].getIdproduit());
                Ingredients[] ings = (Ingredients[]) CGenUtil.rechercher(ing, null, null, c, " ");
                for (int i = 0; i < res[i].getQte(); i++)
                {
                    Acte acte = new Acte();
                    acte.setIdclient(this.getIdclient());
                    acte.setIdreservation(this.getId());
                    acte.setIdproduit(res[j].getIdproduit());
                    acte.setQte(res[i].getQte());
                    acte.setLibelle("Location de/du " + this.getId());
                    acte.setPu(ings[0].getPu());
                    LocalDate ld = this.getDaty().toLocalDate().plusDays(i);
                    Date dt = Date.valueOf(ld);
                    acte.setDaty(dt);
                    acte.createObject(u, c);
                }
            }
        }
        catch (Exception e) {
            c.rollback();
            e.printStackTrace();
            throw new Exception("Rendre effectif réservation non abouti");
        }
        finally {
            if (isOuvert) {
                c.close();
            }
        }
    }

    public Acte[] getActes(Connection c) throws Exception
    {
        Acte[] actes;
        boolean isOuvert = false;
        try
        {
            if (c == null)
            {
                c = new UtilDB().GetConn();
                isOuvert = true;
            }
            Acte acte = new Acte();
            acte.setIdreservation(this.getId());
            actes = (Acte[]) CGenUtil.rechercher(acte, null, null, c, " ");
        }
        catch (Exception e)
        {
            c.rollback();
            e.printStackTrace();
            throw new Exception("Erreur lors de la recuperation des actes dans la reservation");
        }
        finally {
            if (isOuvert) {
                c.close();
            }
        }
        return actes;
    }
    public List<reservation.ReservationDetails> decomposer(String nT,Connection c) throws Exception{
        List<reservation.ReservationDetails> res = new ArrayList<reservation.ReservationDetails>();
        reservation.ReservationDetails[] listeFille =(reservation.ReservationDetails[])this.getFille();
        if(listeFille==null)listeFille=(reservation.ReservationDetails[])this.getFille(nT,c,"");
        for(reservation.ReservationDetails fille : listeFille)
        {
            res.addAll(fille.decomposer());
        }
        return res;
    }
    public Acte[] getActeAvecSimulation(String nTActe,Connection c)throws Exception {
        List<Acte> retour=new ArrayList<>();
        Check[] listeCheckIn=this.getListeCheckIn(null,c);
        for (int i = 0; i < listeCheckIn.length; i++)
        {
            retour.addAll(Arrays.asList(listeCheckIn[i].getActeAvecSimulation(nTActe,c)));
        }
        return retour.toArray(new Acte[retour.size()]);
    }
    public vente.VenteDetails[] genereVenteDetails(String nTableChekIn,Connection c)throws Exception {
        List<vente.VenteDetails> retour=new ArrayList<>();
        Check[] listeCheckIn=this.getListeCheckIn(nTableChekIn,c);
        for (int i = 0; i < listeCheckIn.length; i++)
        {
            retour.addAll(Arrays.asList(listeCheckIn[i].genereVenteDetails("ACTE_LIB",c)));
        }
        return retour.toArray(new vente.VenteDetails[retour.size()]);
    }

    public CheckOut[] getListeCheckOut(String nTableChekOut,Connection c)throws Exception {
        CheckOut crt = new CheckOut();
        crt.setNomTable("CHECKOUTAVECRESERVATION");
        if (nTableChekOut != null && nTableChekOut.compareTo("") != 0) crt.setNomTable(nTableChekOut);
        crt.setReservation (this.getId());
        return (CheckOut[]) CGenUtil.rechercher(crt,null,null,c,"");
    }

    public Check[] getListeCheckIn(String nT, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            Check crt = new Check();
            if (nT != null && nT.compareTo("") != 0) crt.setNomTable(nT);
            crt.setReservation (this.getId());
            return (Check[]) CGenUtil.rechercher(crt,null,null,c,"");
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
    }

    public Prevision genererPrevision(String u, Connection c) throws Exception{
        Prevision mere = new Prevision();
        ReservationLibAvecDateMax reservationComplet = this.getReservationWithMontant(c);
        Date datyPrevu = reservationComplet.getDatyfinpotentiel();
        mere.setDaty(datyPrevu);
        mere.setCredit(reservationComplet.getResteAPayer());
        mere.setIdOrigine(this.id);
        mere.setIdCaisse(ConstanteStation.idCaisse);
        mere.setIdDevise("AR");
        mere.setDesignation("Prevision rattach&eacute;e au Reservation N : "+this.getId());
        mere.setIdTiers(this.getIdclient());
        return ( Prevision ) mere.createObject(u, c);
    }

    public ReservationLibAvecDateMax getReservationWithMontant(Connection c) throws Exception{
        return (ReservationLibAvecDateMax)new reservation.ReservationLibAvecDateMax().getById(this.getId(), "reservation_lib_avecmaxdate", c);
    }


    public Vente[] getFactureClient(String nT, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            Vente crt = new Vente();
            if (nT != null && nT.compareTo("") != 0) crt.setNomTable(nT);
            crt.setIdReservation(this.getId());
            System.out.println("ID RESA "+crt.getIdReservation());
            return (Vente[]) CGenUtil.rechercher(crt,null,null,c,"");
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
    }
    public reservation.ReservationDetails[] decomposerEnTableau(String nT,Connection c) throws Exception {
        List<reservation.ReservationDetails> res=decomposer(nT,c);
        return res.toArray (new reservation.ReservationDetails[res.size()]);
    }
    public MvtCaisse[] getAcompte(String nT,Connection c) throws Exception {
        MvtCaisse crt=new MvtCaisse();
        if(nT!=null&&nT.compareTo("") != 0) crt.setNomTable(nT);
        crt.setIdOp(this.getId());
        return (MvtCaisse[]) CGenUtil.rechercher(crt,null,null,c,"");
    }
    public ReservationDetailsCheck[] getListeSansCheckIn(String nT, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            ReservationDetailsCheck crt = new ReservationDetailsCheck();
            if (nT != null && nT.compareTo("") != 0) crt.setNomTable(nT);
            crt.setIdmere (this.getId());
            return (ReservationDetailsCheck[]) CGenUtil.rechercher(crt,null,null,c,"");
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
    }

    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        reservation.ReservationDetails[] fille=(reservation.ReservationDetails[])this.getFille();
        ArrayList<reservation.ReservationDetails> retour=new ArrayList<>();
        for(int i=0;i<fille.length;i++)
        {
            retour.addAll(fille[i].decomposer());
        }
        reservation.ReservationDetails[] filleVrai=retour.toArray (new reservation.ReservationDetails[retour.size()]);
        this.setFille(filleVrai);
        return super.createObject(u, c);
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
//            ReservationDetails [] filles = this.getReservationDetails(c);
//            for (ReservationDetails res : filles){
//                if (res.getIdMedia()==null){
//                    throw new Exception("Media manquant pour la reservation "+res.getId());
//                }
//            }
//            genererPrevision(u, c);
            super.validerObject(u, c);
            if(estOuvert) c.commit();
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    @Override
    public int annuler(String u, Connection c) throws Exception {
        return super.annuler(u, c);
    }

    public String getStringForException(ReservationDetailsLib [] res, Connection c) throws Exception{
        String  retour = "- "+res[0].getLibelleproduit() +" non disponible: ";
        String compare = res[0].getIdproduit();
        for (int i = 0; i < res.length; i++) {
            String tocompare = res[i].getIdproduit();
            if (!compare.equalsIgnoreCase(tocompare)) {
                retour +=  "- "+res[i].getLibelleproduit() +" non disponible: ";
            }
            retour += String.valueOf(Utilitaire.formatterDaty(res[i].getDaty())) + "\\n";
            compare = tocompare;
        }
        return retour;
    }

    public ReservationDetails [] getReservationDetails(Connection c) throws Exception{
        ReservationDetails rd = new ReservationDetails();
        rd.setIdmere(this.getId());
        ReservationDetails [] reservationDetails = (ReservationDetails[]) CGenUtil.rechercher(rd,null,null,c,"");
        return reservationDetails;
    }

    public ReservationDetailsAvecDiffusion [] getReservationDetailsAvecDiffusions(Connection c) throws Exception{
        ReservationDetailsAvecDiffusion rd = new ReservationDetailsAvecDiffusion();
        rd.setIdmere(this.getId());
        ReservationDetailsAvecDiffusion [] reservationDetails = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(rd,null,null,c,"");
        return reservationDetails;
    }

    public void diffuser(String user,Connection c) throws Exception {
        ReservationDetails [] reservationDetails = this.getReservationDetails(c);
        for (ReservationDetails reservationDetail : reservationDetails) {
            reservationDetail.diffuser(user,c);
        }
    }

    public Acte [] genererDiffusion(Connection c) throws Exception {
        ReservationDetails [] reservationDetails = this.getReservationDetails(c);
        List<Acte> actes = new ArrayList<>();
        for (ReservationDetails reservationDetail : reservationDetails) {
            actes.add(reservationDetail.genererDiffusionAvecControl(c));
        }
        return actes.toArray(new Acte[]{});
    }

    public Reservation dupliquer (String date, String idSupport, Connection c) throws Exception {
        Reservation r = new Reservation();
        r.setId(this.getId());
        Reservation [] reservations = (Reservation[]) CGenUtil.rechercher(r,null,null,c,"");
        if (reservations.length==0) {
            throw new Exception("Reservation inexistant");
        }
        Reservation old_resa = new Reservation();
        old_resa.setDaty(Date.valueOf(date));
        old_resa.setRemarque(reservations[0].getRemarque());
        old_resa.setIdclient(reservations[0].getIdclient());
        old_resa.setIdBc(reservations[0].getIdBc());
        old_resa.setIdSupport(idSupport);
        old_resa.setSource(reservations[0].getSource());
        ReservationDetails [] reservationDetails = reservations[0].getReservationDetails(c);
        List<ReservationDetails> listFille = new ArrayList<>();
        for (int i = 0; i < reservationDetails.length; i++) {
            ReservationDetails fille = new ReservationDetails();
            fille.setDaty(reservationDetails[i].getDaty());
            fille.setIdparrainage(reservationDetails[i].getIdparrainage());
            fille.setIdproduit(reservationDetails[i].getIdproduit());
            fille.setIdMedia(reservationDetails[i].getIdMedia());
            fille.setIsEntete(reservationDetails[i].getIsEntete());
            fille.setRemarque(reservationDetails[i].getRemarque());
            fille.setSource(reservationDetails[i].getSource());
            fille.setHeure(reservationDetails[i].getHeure());
            fille.setOrdre(reservationDetails[i].getOrdre());
            fille.setPu(reservationDetails[i].getPu());
            fille.setQte(reservationDetails[i].getQte());
            fille.setDuree(reservationDetails[i].getDuree());
            fille.setIsDependant(reservationDetails[i].getIsDependant());
            listFille.add(fille);
        }

        old_resa.setFille(listFille.toArray(new ReservationDetails[]{}));
        return old_resa;
    }

    public vente.VenteDetails[] genereVenteDetails(Connection c)throws Exception {
        List<vente.VenteDetails> retour=new ArrayList<>();
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String req = "SELECT IDPRODUIT,COUNT(QTE) AS QTES,PU FROM RESERVATIONDETAILS_LIB WHERE IDMERE = '"+this.getId()+"' GROUP BY IDPRODUIT, PU";
            PreparedStatement statement = c.prepareStatement(req);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                ReservationDetails reservationDetail = new ReservationDetails();
                reservationDetail.setIdproduit(rs.getString("IDPRODUIT"));
                reservationDetail.setQte(rs.getDouble("QTES"));
                reservationDetail.setPu(rs.getDouble("PU"));
                Ingredients serviceMedia = reservationDetail.getProduit(c);
                VenteDetails venteDetails = new VenteDetails();
                venteDetails.setIdProduit(serviceMedia.getId());
                venteDetails.setCompte(serviceMedia.getCompte_vente());
                venteDetails.setQte(reservationDetail.getQte());
                venteDetails.setPu(reservationDetail.getPu());
                venteDetails.setRemise(reservationDetail.getRemise());
                venteDetails.setTva(serviceMedia.getTva());
                venteDetails.setDesignation(serviceMedia.getLibelle());
                retour.add(venteDetails);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            c.rollback();
            throw ex;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return retour.toArray(new vente.VenteDetails[]{});
    }

    @Override
    public boolean getEstIndexable() {return true;}

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public static void imprimerExcel(XSSFWorkbook workbook,String idSupport, String idReservation, Date dt_debut, Date dt_fin,String etat, Connection c) throws Exception {
        Sheet sheet = workbook.createSheet("A traiter");
        Map<String, XSSFCellStyle> styleCache = new HashMap<>();
        Map<LocalDate,List<ReservationDetailsAvecDiffusion>> resaJournalier = new TreeMap<>();
        int rowIndex = 0;

        Reservation search = new Reservation();
        if (idReservation != null && !idReservation.isEmpty()) {
            search.setId(idReservation);
        }
        if (idSupport != null && !idSupport.isEmpty()) {
            search.setIdSupport(idSupport);
        }

        String aWhere = "";
        if (etat != null && !etat.isEmpty()) {
            aWhere += " and ETAT="+etat;
        }
        if (dt_debut!=null){
            aWhere += " and daty >= TO_DATE('"+dt_debut+"', 'YYYY-MM-DD')";
        }
        if (dt_fin!=null){
            aWhere += " and daty <= TO_DATE('"+dt_fin+"', 'YYYY-MM-DD')";
        }

        Reservation[] list = (Reservation[]) CGenUtil.rechercher(search, null,null, c, aWhere);

        for (Reservation reservation : list) {

                if (rowIndex > 0){
                    sheet.createRow(rowIndex++);
                }

                LocalDate[] dt = reservation.getDateInterval(c);
                List<LocalDate> periodes = CalendarUtil.getAllDate(dt[0], dt[1]);

                // Créer les headers dynamiques
                List<String> headers = new ArrayList<>();
                headers.addAll(Arrays.asList("Client", "Source", "Remarque", "Heure"));
                List<String> sous_headers = new ArrayList<>();
                sous_headers.addAll(Arrays.asList("", "", "", ""));

            for (LocalDate d : periodes) {
                    DateTimeFormatter jourFormatter = DateTimeFormatter.ofPattern("E", Locale.FRENCH); // pour L/M/M...
                    DateTimeFormatter jourDuMois = DateTimeFormatter.ofPattern("d");
                    headers.add(jourFormatter.format(d).substring(0, 1).toUpperCase());
                    sous_headers.add(jourDuMois.format(d));
                }

                // Écrire les en-têtes
                Row headerRow = sheet.createRow(rowIndex++);
                XSSFCellStyle headerStyle = ExcelUtil.getHeaderStyle(workbook);
                for (int i = 0; i < headers.size(); i++) {
                    Cell cell = headerRow.createCell(i);
                    cell.setCellStyle(headerStyle);
                    cell.setCellValue(headers.get(i));
                    sheet.autoSizeColumn(i);
                }
                headerRow = sheet.createRow(rowIndex++);
                for (int i = 0; i < sous_headers.size(); i++) {
                    Cell cell = headerRow.createCell(i);
                    if (sous_headers.get(i).isEmpty()==false) {
                        cell.setCellStyle(headerStyle);
                        cell.setCellValue(Double.parseDouble(sous_headers.get(i)));
                    }else {
                        cell.setCellValue(sous_headers.get(i));
                    }
                }

                ReservationDetailsAvecDiffusion resafille = new ReservationDetailsAvecDiffusion();
                resafille.setNomTable("RESERVATIONDETAILS_SANSETAT");
                resafille.setIdmere(reservation.getId());
                ReservationDetailsAvecDiffusion [] details = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(resafille,null,null,c, "");
                Map<Integer,List<ReservationDetailsAvecDiffusion>> filles = ReservationDetailsAvecDiffusion.groupByOrdre(details);

                for (Map.Entry<Integer, List<ReservationDetailsAvecDiffusion>> entry : filles.entrySet()) {
                    int ordre = entry.getKey();
                    List<ReservationDetailsAvecDiffusion> resadet = entry.getValue();
                    ReservationDetailsAvecDiffusion rf = resadet.get(0);

                    List<String> line = new ArrayList<>();
                    line.add(rf.getClient());
                    line.add(rf.getSource());
                    line.add(rf.getRemarque());
                    line.add(rf.getHeure().replace(':','H'));

                    String codeCouleur = rf.getBackGround();

                    for (LocalDate date : periodes) {
                        String value = "";
                        for (ReservationDetailsAvecDiffusion fille : resadet) {
                            LocalDate d = fille.getDaty().toLocalDate();
                            if (d.isEqual(date)) {
                                value = "1";
                                List<ReservationDetailsAvecDiffusion> resaJ = resaJournalier.get(d);
                                if (resaJ == null) {
                                    resaJ = new ArrayList<>();
                                }
                                resaJ.add(rf);
                                resaJournalier.put(d, resaJ);
                                break;
                            }
                        }
                        line.add(value);
                    }

                    // Créer la ligne Excel
                    Row row = sheet.createRow(rowIndex++);
                    ExcelUtil.createStyleForHexColor(workbook,codeCouleur,styleCache);
                    for (int i = 0; i < line.size(); i++) {
                        Cell colonne = row.createCell(i);
                        String value = line.get(i);
                        if (value != null && value.matches("-?\\d+(\\.\\d+)?")) {
                            // Nombre entier ou décimal
                            colonne.setCellValue(Double.parseDouble(value));
                        } else {
                            // Valeur texte
                            colonne.setCellValue(value);
                        }
                        if (!codeCouleur.equalsIgnoreCase("#FFFFFF")){
                            colonne.setCellStyle(styleCache.get(codeCouleur));
                        }
                    }
                }

        }
        String[] titre = new String[]{"Heure","Remarque","Client","Source","Remarque","Heure"};
        for (Map.Entry<LocalDate, List<ReservationDetailsAvecDiffusion>> entry : resaJournalier.entrySet()) {
            LocalDate key = entry.getKey();
            List<ReservationDetailsAvecDiffusion> value = Reservation.trierResa(entry.getValue(),c);
            rowIndex = 0;
            Sheet new_sheet = workbook.createSheet(CalendarUtil.getDayOfWeek(key).toUpperCase() +" "+ key);
            Row headRow = new_sheet.createRow(rowIndex++);
            for (int i = 0; i < titre.length; i++) {
                Cell cell = headRow.createCell(i);
                cell.setCellValue(titre[i]);
            }

            for (ReservationDetailsAvecDiffusion r: value) {
                String [] colonneValue = new String[titre.length];
                colonneValue[0] = r.getHeure().replace(':','H');
                colonneValue[1] = r.getRemarque();
                colonneValue[2] = r.getClient();
                colonneValue[3] = r.getSource();
                colonneValue[4] = r.getRemarque();
                colonneValue[5] = r.getHeure().replace(':','H');
                // Créer la ligne Excel
                Row row = new_sheet.createRow(rowIndex++);
                String codeCouleur = r.getBackGround();
                ExcelUtil.createStyleForHexColor(workbook,codeCouleur,styleCache);
                for (int i = 0; i < colonneValue.length; i++) {
                    Cell colonne = row.createCell(i);
                    colonne.setCellValue(colonneValue[i]);
                    if (!codeCouleur.equalsIgnoreCase("#FFFFFF")){
                        colonne.setCellStyle(styleCache.get(codeCouleur));
                    }
                }
            }

        }
    }

    public static void imprimerExcelJournalier(XSSFWorkbook workbook,String [] idTypeService,String idSupport, String dMin,String dMax,String etat, Connection c) throws Exception {
        Map<String, XSSFCellStyle> styleCache = new HashMap<>();
        int rowIndex = 0;

        ReservationDetailsAvecDiffusion search = new ReservationDetailsAvecDiffusion();
        search.setNomTable("RESERVATIONDETAILS_SANSETAT");
        String aWhere = "";
        if (idSupport != null && !idSupport.isEmpty()) {
            aWhere += " and idSupport='"+idSupport+"'";
        }
        if (idTypeService != null && idTypeService.length > 0) {
            aWhere += " and CATEGORIEPRODUIT IN (";
            for (int i = 0; i < idTypeService.length; i++) {
                if (i < idTypeService.length - 1) {
                    aWhere += "'"+idTypeService[i]+"',";
                }else {
                    aWhere += "'"+idTypeService[i]+"'";
                }
            }
            aWhere += ")";
        }
        if (etat != null && !etat.isEmpty()) {
            aWhere += " and ETAT="+etat;
        }

        if(dMin==null||dMin.compareToIgnoreCase("")==0)dMin=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
        String[] colInt={"daty"};
        String[] valInt={dMin,dMax};
        HashMap<String, Vector> reservations =CGenUtil.rechercher2D(search,colInt,valInt,"daty",c,aWhere);

        int day = Utilitaire.diffJourDaty(dMax, dMin)+1;
        String listeDate[]=new String[day];
        for (int i = 0; i < day; i++) {
            listeDate[i]=Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(dMin,i))  ;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String[] titre = new String[]{"Jour","Heure","Remarque","Client","Source","Remarque","Heure","Jour"};
        for (String date : listeDate) {
            LocalDate key = LocalDate.parse(date, formatter);
            titre[0] = CalendarUtil.getDayOfWeek(key);
            titre[titre.length-1] = titre[0];
            Vector v = reservations.get(date);
            if (v == null) continue;

            List<ReservationDetailsAvecDiffusion> value = new ArrayList<>((Vector<ReservationDetailsAvecDiffusion>) v);
            value = trierResaAvecBillboard(value,c);
            rowIndex = 0;
            Sheet new_sheet = workbook.createSheet(CalendarUtil.getDayOfWeek(key).toUpperCase() +" "+ key);
            Row headRow = new_sheet.createRow(rowIndex++);
            for (int i = 0; i < titre.length; i++) {
                Cell cell = headRow.createCell(i);
                cell.setCellValue(titre[i]);
            }
            for (ReservationDetailsAvecDiffusion r: value) {
                String [] colonneValue = new String[titre.length];
                colonneValue[0] = "1";
                colonneValue[1] = r.getHeure().replace(':','H');
                colonneValue[2] = r.getRemarque();
                colonneValue[3] = r.getClient();
                colonneValue[4] = r.getSource();
                colonneValue[5] = r.getRemarque();
                colonneValue[6] = r.getHeure().replace(':','H');
                colonneValue[7] = "1";
                // Créer la ligne Excel
                Row row = new_sheet.createRow(rowIndex++);
                String codeCouleur = r.getBackGround();
                ExcelUtil.createStyleForHexColor(workbook,codeCouleur,styleCache);
                for (int i = 0; i < colonneValue.length; i++) {
                    Cell colonne = row.createCell(i);
                    colonne.setCellValue(colonneValue[i]);
                    if (!codeCouleur.equalsIgnoreCase("#FFFFFF")){
                        colonne.setCellStyle(styleCache.get(codeCouleur));
                    }
                }
            }
            for (int i = 0; i <titre.length ; i++) {
                new_sheet.autoSizeColumn(i);
            }
        }

    }




    public LocalDate [] getDateInterval(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String request = "SELECT MIN(DATY) as dtMin,MAX(DATY) as dtMax FROM RESERVATIONDETAILS WHERE IDMERE = ?";
            PreparedStatement statement = c.prepareStatement(request);
            statement.setString(1, this.getId());
            ResultSet rs = statement.executeQuery();
            LocalDate[] result = new LocalDate[2];
            result[0] = LocalDate.now();
            result[1] = LocalDate.now();
            while (rs.next()) {
                if (rs.getDate("dtMin")!=null && rs.getDate("dtMax")!=null) {
                    result[0] = rs.getDate("dtMin").toLocalDate();
                    result[1] = rs.getDate("dtMax").toLocalDate();
                }
            }
            return result;
        }catch(Exception e){
                throw e;
            }
        finally {
                if(estOuvert==true && c!=null) c.close();
            }
    }

    public Client getClient(Connection c) throws Exception{
        Client rd = new Client();
        rd.setId(this.getIdclient());
        Client [] reservationDetails = (Client[]) CGenUtil.rechercher(rd,null,null,c,"");
        if (reservationDetails.length > 0) {
            return reservationDetails[0];
        }
        return null;
    }

    public static List<ReservationDetailsAvecDiffusion> trierResa(List<ReservationDetailsAvecDiffusion> resaJ,Connection c) throws Exception {
        List<ReservationDetailsAvecDiffusion> result = new ArrayList<>();
        CategorieIngredient [] categorieIngredients = (CategorieIngredient[]) CGenUtil.rechercher(new CategorieIngredient(),null,null,c," ORDER BY RANG ASC");
        List<String> idCategories = resaJ.stream()
                .map(ReservationDetailsAvecDiffusion::getCategorieproduit)
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());
        List<CategorieIngredient> categoriesFiltrees = Arrays.stream(categorieIngredients)
                .filter(cat -> idCategories.contains(cat.getId()))
                .collect(Collectors.toList());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        Map<String, List<ReservationDetailsAvecDiffusion>> listResaTrier = new TreeMap<>(
                Comparator.comparing(s -> LocalTime.parse(s, formatter))
        );
        resaJ.stream()
                .filter(r -> r.getHeure() != null)
                .forEach(r -> listResaTrier.computeIfAbsent(r.getHeure(), k -> new ArrayList<>()).add(r));

        for (Map.Entry<String, List<ReservationDetailsAvecDiffusion>> entry : listResaTrier.entrySet()) {
            List<ReservationDetailsAvecDiffusion> details = entry.getValue();

            for (CategorieIngredient cat : categoriesFiltrees) {
                List<ReservationDetailsAvecDiffusion> resaSimple = details.stream()
                    .filter(resa -> cat.getId().equals(resa.getCategorieproduit()) && resa.getIdparrainage() == null)
                    .sorted(Comparator.comparing(ReservationDetailsAvecDiffusion::getIsEntete).reversed())
                    .collect(Collectors.toList());
                result.addAll(resaSimple);
            }
            Set<String> idParrainagesSet = details.stream()
                    .map(ReservationDetailsAvecDiffusion::getIdparrainage)
                    .filter(Objects::nonNull)
                    .distinct().collect(Collectors.toSet());
            List<ReservationDetailsAvecDiffusion> resaParrainer = details.stream()
                    .filter(r -> idParrainagesSet.contains(r.getIdparrainage()))
                    .sorted(Comparator.comparing(ReservationDetailsAvecDiffusion::getId))
                    .collect(Collectors.toList());
            result.addAll(resaParrainer);
        }
        return result;
    }

    public static List<ReservationDetailsAvecDiffusion> trierResaAvecBillboard(List<ReservationDetailsAvecDiffusion> resaJ,Connection c) throws Exception {
        List<ReservationDetailsAvecDiffusion> resaTrier = trierResa(resaJ, c);

        List<ReservationDetailsAvecDiffusion> result = new ArrayList<>(resaTrier.size());
        List<ReservationDetailsAvecDiffusion> nonBillboards = new ArrayList<>();

        for (ReservationDetailsAvecDiffusion r : resaTrier) {
            if (ConstanteKolo.billiboards.containsKey(r.getIdproduit())) {
                result.add(r); // Les billboards d'abord
            } else {
                nonBillboards.add(r); // Les autres après
            }
        }
        result.addAll(nonBillboards);
        return result;
    }

    public static void main(String[] args) throws Exception {
        ReservationDetailsAvecDiffusion [] list = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(new ReservationDetailsAvecDiffusion(),null,null,null,"");
        trierResa(Arrays.asList(list),null);
    }
    public List<Map<String,Object>> prepareDataModif (String dtDebut,String dtFin,Connection c) throws Exception {
        boolean estOuvert = false;
        List<Map<String,Object>> result = new ArrayList<>();
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }

            LocalDate localDateDebut = LocalDate.parse(dtDebut);
            LocalDate localDateFin = LocalDate.parse(dtFin);
            Map<String,Object> plannings = new LinkedHashMap<>();
            while (localDateDebut.isAfter(localDateFin)==false) {
                plannings.put(localDateDebut.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),new String[]{"",""});
                localDateDebut = localDateDebut.plusDays(1);
            }

            ReservationDetailsAvecDiffusion search = new ReservationDetailsAvecDiffusion();
            search.setNomTable("RESERVATIONDETAILS_SANSETAT");
            search.setIdmere(this.getId());
            ReservationDetailsAvecDiffusion [] details = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(search,null,null,c, " and DATY >= TO_DATE('"+dtDebut+"','YYYY-MM-DD') and DATY <= TO_DATE('"+dtFin+"','YYYY-MM-DD')");
            Map<Integer,List<ReservationDetailsAvecDiffusion>> filles = ReservationDetailsAvecDiffusion.groupByOrdre(details);

            for (Map.Entry<Integer, List<ReservationDetailsAvecDiffusion>> entry : filles.entrySet()) {
                int ordre = entry.getKey();
                List<ReservationDetailsAvecDiffusion> resadet = entry.getValue();
                Map<String,Object> resa = new HashMap<>();
                resa.put("serviceLib",resadet.get(0).getLibelleproduit() !=null ? resadet.get(0).getLibelleproduit() : "");
                resa.put("service",resadet.get(0).getIdproduit()!=null ? resadet.get(0).getIdproduit() : "");
                resa.put("media",resadet.get(0).getIdMedia()!=null ? resadet.get(0).getIdMedia() : "");
                resa.put("mediaLib",resadet.get(0).getIdMediaLib()!=null ? resadet.get(0).getIdMediaLib() : "");
                resa.put("duree",resadet.get(0).getDuree());
                resa.put("pu",resadet.get(0).getPu());
                resa.put("ordre",ordre);
                resa.put("heure",resadet.get(0).getHeure());
                resa.put("remarque",resadet.get(0).getRemarque()!=null ? resadet.get(0).getRemarque() : "");
                resa.put("source",resadet.get(0).getSource()!=null ? resadet.get(0).getSource() : "");
                int isEntete = resadet.get(0).getIsEntete();
                if (isEntete==1){
                    resa.put("isEntete",new String[]{"","selected",""});
                }
                if (isEntete==-1){
                    resa.put("isEntete",new String[]{"","","selected"});
                }
                if (isEntete==0){
                    resa.put("isEntete",new String[]{"selected","",""});
                }
                List<String> dates = new ArrayList<>();
                for (ReservationDetailsAvecDiffusion detail : resadet) {
                    String keys = detail.getDaty().toLocalDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                    String isDisable = "";
                    if (detail.getIdDiffusion()!=null) {
                        isDisable = "disabled";
                    }else {
                        dates.add(keys);
                    }
                    plannings.put(keys,new String[]{"checked",isDisable});
                }
                resa.put("dates",dates);
                resa.put("planning",plannings.values().toArray(new String[0][]));
                result.add(resa);
                for (String dt : dates) {
                    plannings.put(dt,new String[]{"",""});
                }
            }

        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
        return result;
    }

    public ReservationDetailsGroupe [] genererReservationDetailsGroupe (Connection c) throws Exception {
        List<ReservationDetailsGroupe> result = new ArrayList<>();
        ReservationDetailsAvecDiffusion search = new ReservationDetailsAvecDiffusion();
        search.setNomTable("RESERVATIONDETAILS_SANSETAT");
        search.setIdmere(this.getId());
        ReservationDetailsAvecDiffusion [] details = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(search,null,null,c, "");
        Map<Integer,List<ReservationDetailsAvecDiffusion>> filles = ReservationDetailsAvecDiffusion.groupByOrdre(details);

        for (Map.Entry<Integer, List<ReservationDetailsAvecDiffusion>> entry : filles.entrySet()) {
            int ordre = entry.getKey();
            List<ReservationDetailsAvecDiffusion> resadet = entry.getValue();
            ReservationDetailsGroupe resadetGroupe = new ReservationDetailsGroupe();
            resadetGroupe.setIdmere(this.getId());
            resadetGroupe.setIdproduit(resadet.get(0).getIdproduit());
            resadetGroupe.setIdmedia(resadet.get(0).getIdMedia());
            resadetGroupe.setRemarque(resadet.get(0).getRemarque());
            resadetGroupe.setSource(resadet.get(0).getSource());
            resadetGroupe.setHeure(resadet.get(0).getHeure());
            resadetGroupe.setIsEntete(resadet.get(0).getIsEntete());
            resadetGroupe.setOrdre(ordre);
            resadetGroupe.setPu(resadet.get(0).getPu());
            resadetGroupe.setDuree(resadet.get(0).getDuree());

            List<String> dateDiffusions = new ArrayList<>();
            List<String> dateInvalides = new ArrayList<>();
            for (ReservationDetailsAvecDiffusion detail : resadet) {
                String keys = detail.getDaty().toLocalDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                if (detail.getIdDiffusion()!=null) {
                    dateInvalides.add(keys);
                }else {
                    dateDiffusions.add(keys);
                }
            }
            resadetGroupe.setDatedebut(resadet.get(0).getDaty());
            resadetGroupe.setDatefin(resadet.get(resadet.size()-1).getDaty());
            resadetGroupe.setDateDiffusion(String.join(";",dateDiffusions));
            resadetGroupe.setDateInvalide(String.join(";",dateInvalides));
            result.add(resadetGroupe);
        }
        return result.toArray(new ReservationDetailsGroupe[]{});
    }

    public Reservation updateResa(String u,String dtDebut,String dtFin,Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            String request = "DELETE FROM RESERVATIONDETAILS WHERE IDMERE=? AND ETAT!=? and DATY >= TO_DATE('"+dtDebut+"','YYYY-MM-DD') and DATY <= TO_DATE('"+dtFin+"','YYYY-MM-DD')";

            PreparedStatement statement = c.prepareStatement(request);
            statement.setString(1,this.getId());
            statement.setInt(2, ConstanteKolo.etatDiffuser);
            statement.executeUpdate();

            this.updateToTableWithHisto(u,c);
            ReservationDetails [] reservationDetails = (ReservationDetails[]) this.getFille();
            for (ReservationDetails reservationDetail : reservationDetails) {
                reservationDetail.createObject(u,c);
            }
            if (this.getSource()!=null){
                ParrainageEmission p = new ParrainageEmission();
                p.setId(this.getSource());
                ParrainageEmission [] list = (ParrainageEmission[]) CGenUtil.rechercher(p,null,null,c,"");
                if (list!=null && list.length>0) {
                    p = list[0];
                    ReservationDetails [] rd = this.getReservationDetails(c);
                    p.setQte(rd.length);
                    p.updateToTableWithHisto(u,c);
                }
            }
            return this;
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }

    }

    public Reservation updateResaV2(String u,ReservationDetailsGroupe [] reservationDetailsGroupes,int lastOrder,Connection c) throws Exception {
        boolean estOuvert = false;
        try {

            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            List<ReservationDetails> reservationDetails = new ArrayList<>();
            for (int i = 0; i < reservationDetailsGroupes.length; i++) {
                if (reservationDetailsGroupes[i].getOrdre()==0){
                    lastOrder += 1;
                    reservationDetailsGroupes[i].setOrdre(lastOrder);
                }
                reservationDetailsGroupes[i].setIdmere(this.getId());
                ReservationDetails [] rsdt = reservationDetailsGroupes[i].genererReservationDetailsPourModif(c);
                reservationDetails.addAll(Arrays.asList(rsdt));
            }

            String request = "DELETE FROM RESERVATIONDETAILS WHERE IDMERE=? AND ETAT!=?";

            PreparedStatement statement = c.prepareStatement(request);
            statement.setString(1,this.getId());
            statement.setInt(2, ConstanteKolo.etatDiffuser);
            statement.executeUpdate();

            this.updateToTableWithHisto(u,c);
            ParrainageEmission parrainageEmission = null;
            String idParrainage = null;
            if (this.getSource()!=null && this.getSource().isEmpty()==false){
                ParrainageEmission p = new ParrainageEmission();
                p.setId(this.getSource());
                ParrainageEmission [] list = (ParrainageEmission[]) CGenUtil.rechercher(p,null,null,c,"");
                if (list!=null && list.length>0) {
                    parrainageEmission = list[0];
                    idParrainage = parrainageEmission.getId();
                }
            }
            System.out.println("PARAIN"+idParrainage);
            for (ReservationDetails reservationDetail : reservationDetails) {
                reservationDetail.setIdparrainage(idParrainage);
                reservationDetail.createObject(u,c);
            }
            if (parrainageEmission!=null){
                ReservationDetails [] rd = this.getReservationDetails(c);
                parrainageEmission.setQte(rd.length);
                parrainageEmission.updateToTableWithHisto(u,c);
            }
            return this;
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }

    }

    public List<Map<String,Object>> getPlanningDetails (String dtDebut,String dtFin,Connection c) throws Exception {
        boolean estOuvert = false;
        List<Map<String,Object>> result = new ArrayList<>();
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }

            LocalDate localDateDebut = LocalDate.parse(dtDebut);
            LocalDate localDateFin = LocalDate.parse(dtFin);
            Map<String,Object> plannings = new LinkedHashMap<>();
            while (localDateDebut.isAfter(localDateFin)==false) {
                plannings.put(localDateDebut.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),new String[]{"",""});
                localDateDebut = localDateDebut.plusDays(1);
            }
            ReservationDetailsAvecDiffusion search = new ReservationDetailsAvecDiffusion();
            search.setNomTable("RESERVATIONDETAILS_SANSETAT");
            search.setIdmere(this.getId());
            ReservationDetailsAvecDiffusion [] details = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(search,null,null,c, " and DATY >= TO_DATE('"+dtDebut+"','YYYY-MM-DD') and DATY <= TO_DATE('"+dtFin+"','YYYY-MM-DD')");
            Map<Integer,List<ReservationDetailsAvecDiffusion>> filles = ReservationDetailsAvecDiffusion.groupByOrdre(details);

            for (Map.Entry<Integer, List<ReservationDetailsAvecDiffusion>> entry : filles.entrySet()) {
                int ordre = entry.getKey();
                List<ReservationDetailsAvecDiffusion> resadet = entry.getValue();
                Map<String,Object> resa = new HashMap<>();
                resa.put("serviceLib",resadet.get(0).getLibelleproduit() !=null ? resadet.get(0).getLibelleproduit() : "");
                resa.put("media",resadet.get(0).getIdMedia()!=null ? resadet.get(0).getIdMedia() : "");
                resa.put("mediaLib",resadet.get(0).getIdMediaLib()!=null ? resadet.get(0).getIdMediaLib() : "");
                resa.put("ordre",ordre);
                resa.put("heure",resadet.get(0).getHeure());
                resa.put("remarque",resadet.get(0).getRemarque()!=null ? resadet.get(0).getRemarque() : "");
                resa.put("source",resadet.get(0).getSource()!=null ? resadet.get(0).getSource() : "");
                int isEntete = resadet.get(0).getIsEntete();
                if (isEntete==1){
                    resa.put("isEntete","T&ecirc;te d'&eacute;cran");
                }
                if (isEntete==-1){
                    resa.put("isEntete","Fin d'&eacute;cran");
                }
                if (isEntete==0){
                    resa.put("isEntete","Aucun");
                }
                List<String> dates = new ArrayList<>();
                for (ReservationDetailsAvecDiffusion detail : resadet) {
                    String keys = detail.getDaty().toLocalDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                    dates.add(keys);
                    String color = "rgb(255, 201, 100)";
                    if (detail.getIdDiffusion()!=null || detail.getEtat() == ConstanteKolo.etatDiffuser) {
                        color = "rgb(3, 161, 3)";
                    }
                    if (detail.getEtat() == ConstanteKolo.etatSuspendu){
                        color = "rgb(255, 74, 74)";
                    }

                    plannings.put(keys,new String[]{detail.getId(),color});
                }
                resa.put("dates",dates);
                resa.put("planning",plannings.values().toArray(new String[0][]));
                result.add(resa);
                for (String dt : dates) {
                    plannings.put(dt,new String[]{"",""});
                }
            }
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
        return result;
    }

    public Reservation changeEtat(int etat,String u,Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            this.setEtat(etat);
            this.updateToTableWithHisto(u,c);
            ReservationDetails [] reservationDetails = this.getReservationDetails(c);
            for (ReservationDetails reservationDetail : reservationDetails) {
                reservationDetail.changeEtat(etat,u,c);
            }
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
        return this;
    }

}
