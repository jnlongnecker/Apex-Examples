public class ScheduledApex implements Schedulable {
	// Use case
	// - Running apex at a specific point in time
	// 
	// A very simple use case, but one that actually is quite handy
	// We're only allowed 100 scheduled jobs at a time
	// We must implement a single method: Execute

    // Execute contains simply the code that we wish to run at a schedule
    public void Execute(SchedulableContext context) {
        
        // We are allowed to schedule callouts, but only asynchronous callouts
        FutureApex.FutureAndCallouts();
    }
    
    // From there, we give the job a name, a cron expression and the class we want to schedule
    public static id ScheduleAt(String cronExpression) {
        return System.Schedule('My Scheduled Job', cronExpression, new ScheduledApex());
    }
    
    /* -- CRON EXPRESSIONS --
     * CRON expressions are a way to denote a complex time for our apex to be scheduled at
     * Each CRON expression follows the following syntax:
     * Seconds Minutes Hours Day_of_Month Month Day_of_Week Year(optional)
     * 
     * Seconds and Minutes accept values 0-59
     * Hours accepts values 0-23
     * Day_of_Month accepts values 1-31
     * Month accepts values 1-12 or the 3 letter abbreviation (JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC)
     * Day_of_Week accepts values 1-7 or the 3 letter abbreviation (SUN, MON, TUE, WED, THU, FRI, SAT)
     * Year accepts values 1970-2099, or it can be left unspecified
     * 
     * EXAMPLE: String cron = '0 0 12 1 12 1'; 
     * 			This expression fires on December 1st at 12:00pm if it happens to fall on a Sunday
     * 
     * Obviously, we need to be able to generalize a bit more, so we have special CRON syntax characters:
     * , : Used to specify multiple values
     * - : Used to specify a range
     * * : Used to select all possible values
     * ? : Used to select no value (only for Day_of_Month and Day_of_Week)
     * / : Used to create an interval. For instance, 1/4 for Month will run every 4 months, starting at January
     * L : Used to specify the final value of a range. If used with a value, specifies the last value of that type
     * W : Used to specify the nearest weekday. Only usable for Day_of_Month. 
     * # : Used to specify the nth day of the month. Only available for Day_of_Week. For example, 6#2 is used to specify the second Friday
     * 
     * Some more examples:
     * 			String ex1 = '0 0 9 1 * ?';
     * 			String ex2 = '0 7 * ? 8 2-6';
     * 			String ex3 = '0 20 16 ? * 2L;
     * 			String ex4 = '0 10 12 12W 1/2 ?';
     * 			String ex5 = '0 0 9-17 ? * 2,4,6';
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * Answers:
     * 			ex1 : The first of every month at 9:00am.
     * 			ex2 : Weekdays in August, every hour at 7 past the hour.
     * 			ex3 : The last Monday of every month at 4:20pm.
     * 			ex4 : Every other month starting from January, occuring at 12:10pm on the nearest weekday to the 12th.
     * 			ex5 : Every hour during work hours (9:00am - 5:00pm) on Monday, Wednesday and Friday.
     * 
     */ 
}