/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mg.cnaps.compta.ecriture;

import mg.cnaps.compta.ComptaEcriture;

/**
 *
 * @author Kanto
 */
public class ComptaEcritureLib extends ComptaEcriture{
    private double montant;
    private String journalLib;

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getJournalLib() {
        return journalLib;
    }

    public void setJournalLib(String journalLib) {
        this.journalLib = journalLib;
    }

    public ComptaEcritureLib() throws Exception
    {
        this.setNomTable("compta_exercice_lib");
    }
}
