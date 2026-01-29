package mg.cnaps.compta;

public class ComptaLettrageLib extends ComptaLettrage {
    String compte,journal;

    public ComptaLettrageLib() {
        super.setNomTable("COMPTA_LETTRAGE_LIB");
    }   

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public String getJournal() {
        return journal;
    }

    public void setJournal(String journal) {
        this.journal = journal;
    }

    
}
