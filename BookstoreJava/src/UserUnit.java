public class UserUnit {

    private int id;
    private String name;
    private Boolean registeredYN;

    public UserUnit(int id, String name, Boolean registeredYN) {
        this.id = id;
        this.name = name;
        this.registeredYN = registeredYN;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String toString(){
        return this.name;
    }
    
    public void setRegisterFlag(Boolean pReg) {
        this.registeredYN = pReg;
    }

    public Boolean getRegisterFlag(){
        return this.registeredYN;
    }
}