package model.entity;

public enum Role {
    MANAGER("Manager"),
    MARKETING("Marketing"),
    SALE("Sale"),
    SUPPORT("Support");
    
    private final String value;
    
    Role(String value) {
        this.value = value;
    }
    
    public String getValue() {
        return value;
    }
    
    public static Role fromString(String value) {
        if (value == null) {
            return null;
        }
        
        for (Role role : Role.values()) {
            if (role.value.equalsIgnoreCase(value)) {
                return role;
            }
        }
        return null;
    }
}
