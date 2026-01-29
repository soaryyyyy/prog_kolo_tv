package utils;

import annexe.Produit;
import annexe.ProduitLib;
import bean.Champ;
import bean.ListeColonneTable;
import chatbot.AiColDesc;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import chatbot.UtilChatbot;
import duree.DureeMaxSpot;
import fabrication.FabricationFilleCpl2;
import faturefournisseur.FactureFournisseurDetailsCpl;
import prevision.PrevisionComplet;
import produits.Acte;
import produits.CategorieIngredient;
import produits.DisponibiliteChambre;
import produits.Ingredients;
import reservation.Reservation;
import reservation.ReservationDetailsLib;
import reservation.ReservationSimple;
import support.Support;
import utilitaire.UtilDB;
import vente.BonDeCommande;
import vente.Vente;
import vente.VenteDetailsLib;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.util.Vector;

public class ConstanteAsync {
    public static Class<? extends ClassIA>[] iaClasses = new Class[]{VenteDetailsLib.class, FactureFournisseurDetailsCpl.class, PrevisionComplet.class, ProduitLib.class, Reservation.class, BonDeCommande.class};
    public static final String API_KEY = "AIzaSyBp79rk0qe1FEPYeKPx6TuORYABQrV2c4I";
    public static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=" + API_KEY;
    public static final String heureCheckout="12:00:00";
    public static final double propAvance=0.33;
    public static final String categService="CAT002";
    public static final String categorieChambre="CAT001";

}
