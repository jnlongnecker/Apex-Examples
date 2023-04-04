public abstract class Food implements FlavorProfile {

    public List<String> flavors { get; private set; }

    public String name { get; private set; }

    public Food() {
      // We can chain constructors with "this()"
      this(null, 'Gloop');
    }

    public Food(String name) {
        this(null, name);
    }

    public Food(List<String> startingFlavors, String name) {
      flavors = new List<String>(startingFlavors);
      this.name = name;
    }

    /* Classes and methods are final by default. Virtual makes them overwritable */
    public virtual void addFlavor(String flavor) {
      flavors.add(flavor);
    }

    // public abstract Boolean hasFlavor(String flavor);

    public String flavorProfile() {

      if (flavors == null || flavors.size() == 0) { return 'tasteless'; }

      String flavorProfile = flavors[0];
      if (flavors.size() == 1) { return flavorProfile; }

      for (Integer i = 1; i < flavors.size() - 1; i++) {
        String flavor = flavors[i];
        flavorProfile += ', ' + flavor;
      }

      flavorProfile = ' and ' + flavors[flavors.size() - 1];

      return flavorProfile;
    }

}