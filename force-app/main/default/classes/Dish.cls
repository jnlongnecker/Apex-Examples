public class Dish implements FlavorProfile {
    
    private List<Food> plate;
    private FlavorProfile drink;

    public Dish() {
        plate = new List<Food>();
    }

    public void addFood(Food newFood) {
        plate.add(newFood);
    }

    public String flavorProfile() {
        String profile = 'This dish has a ';
        for (Food item : plate) {
            profile += item.flavorProfile();
            profile += ' ' + item.name + ', a ';
        }

        profile = profile.substring(0, profile.length() - 2);
        profile += 'nd a ' + drink.flavorProfile() + ' drink.';

        return profile;
    }
}