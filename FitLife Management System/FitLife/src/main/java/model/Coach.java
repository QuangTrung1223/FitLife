package model;

public class Coach {
    private int coachId;
    private String coachName;
    private String specialization;
    private String experience;
    private String description;
    private String imageUrl;
    private double price;
    private double rating;
    private String certifications;
    private String location;

    public Coach() {}

    public Coach(int coachId, String coachName, String specialization, String experience, 
                 String description, String imageUrl, double price, double rating, 
                 String certifications, String location) {
        this.coachId = coachId;
        this.coachName = coachName;
        this.specialization = specialization;
        this.experience = experience;
        this.description = description;
        this.imageUrl = imageUrl;
        this.price = price;
        this.rating = rating;
        this.certifications = certifications;
        this.location = location;
    }

    public int getCoachId() { return coachId; }
    public void setCoachId(int coachId) { this.coachId = coachId; }

    public String getCoachName() { return coachName; }
    public void setCoachName(String coachName) { this.coachName = coachName; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getCertifications() { return certifications; }
    public void setCertifications(String certifications) { this.certifications = certifications; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}
