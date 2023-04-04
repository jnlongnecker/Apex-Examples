/*
    Pillars of OOP
        - Encapsulation : Only give access to others what is explicitly necessary (protect your state)
            - Access modifiers (global, public, protected, private)
            - Properties
        - Abstraction : Hide away complexity except where necessary to implement it
            - Abstract methods
            - Abstract classes
            - Interfaces
        - Inheritance : Use the functionality of the parent or interface
            - Extending a class
            - Implementing an interface
        - Polymorphism : Allow functions to adjust from context (parameters or object it is attached to)
            - Method overloading
            - Method overriding
            - Constructor chaining
            - Virtual keyword
*/

/* Top-Level class must have public or global visibility */
public class Fruit extends Food {

    public enum Color { RED, BLUE, GREEN, PURPLE, YELLOW }

    /* Property access modifer is as or more restrictive */
    public Color skinColor { get; private set; }
    public Color fleshColor { get; private set; }

    public Double rating {
      get {
        Integer avg = 0;
        Integer cnt;
        for (cnt = 0; cnt < ratings.size(); cnt++) {
          avg += ratings[cnt];
        }
        return avg / cnt;
      }
    }

    /* methods and variables are private by default */
    List<Integer> ratings;

    /* Methods or variables can be static. This means they are accessible without an instance of the class. */
    public static Integer numFruits { get; private set; }

    /* Can also be static, where it will only run once the first time the class is accessed. */
    {
      numFruits++;
    }

    public Fruit(String name, Color skinColor, Color fleshColor) {
        super(name);
        this.skinColor = skinColor;
        this.fleshColor = fleshColor;
        ratings = new List<Integer>();
    }

    public void addRating(Integer rating) {
      ratings.add(rating);
    }

    override
    public void addFlavor(String flavor) {
      if (flavors.size() > 2) { return; }
      super.addFlavor(flavor);
    }

    
}