public class BestPractices {
    private static Map< String, Schema.SObjectType > objectMap;
    static {
        objectMap = Schema.getGlobalDescribe();
    }
    
    /*
        As a best practice, you want to keep your code commented, but not overly commented.
        Throughout this course, these code files have been failing this best practice. They are
        extremely over-commented. This is on purpose, as they are meant to serve as a reference
        at a later point for the topics they cover. However, let us take a look at an example of
        a properly commented method
    */

    // Returns the smallest Integer in the list. Throws an error on a null or empty list
    public static Integer CommentCode(List<Integer> variousInts) {

        // Check valid input
        if (variousInts == null || variousInts.size() == 0) {
            throw new IllegalArgumentException('List cannot be null or empty.');
        }

        // Find smallest value
        Integer minValue = variousInts[0];
        for (Integer index = 1; index < variousInts.size(); index++) {
            Boolean smallerIntFound = minValue > variousInts[index];
            if (smallerIntFound)  {
                minValue = variousInts[index];
            }
        }

        return minValue;
    }

    /*
        As you can see, comments are minimal. In fact, this method can probably get away without the use
        of comments at all. But comments describing proper usage of a method are always important,
        especially for future developers that will be expanding the code base or using your methods.

        The reason we can get away with such a small amount of comments is because of the use of
        self-documenting code. Except for the name of the method (which describes the best practice),
        it is obvious by the names of the variables what each line of code is doing, and thus does 
        not require comments to explain the line-by-line functionality. Your code should incorporate
        these concepts.
    */

    /*
        We should also be concious of readability and modularity when creating a method. Whenever
        we write code that is either:
            - Not in the context of the method functionality
            - Repeatable
        we should consolidate such code in helper methods. An example is shown below for a method
        that will map together parent records to child records. Two helper methods are used to
        enable seperation of concerns and the use of repeated functionality
    */

    // Maps parent records to child records using the parent as a key
    public static Map< SObject, List< SObject > > MapToChildren ( List<SObject> parents, List<SObject> children ) {

        // Ensure inputs are valid
        if ( parents.size() == 0 ) {
            throw new IllegalArgumentException( 'ERROR: Parents list cannot be empty' );
        }
        if ( children.size() == 0 ) {
            throw new IllegalArgumentException( 'ERROR: Children list cannot be empty' );
        }

        /* Note here the use of modularity: reused functionality is consolidated to a new method */
        Schema.DescribeSObjectResult entityFromParents = GetSObjectResultFromSObject( parents[0] );
        Schema.DescribeSObjectResult entityFromChildren = GetSObjectResultFromSObject( children[0] );

        /* 
            Note here the use of seperation of concerns: This method only maps the two lists, so
            retrieval of the mapping field is left to another method 
        */
        String mappingFieldName = GetMappingField( entityFromParents, entityFromChildren );

        // Ensure parents have a relationship to children to map to
        if ( mappingFieldName == null ) {
            throw new IllegalArgumentException( 'ERROR: Parents have no relationship to the input children.' );
        }

        // Map parents to child objects
        Map< SObject, List< SObject > > childMap = new Map< SObject, List< SObject > >();
        for ( SObject key : parents ) {
            List< SObject > valueList = new List< SObject >();
            for ( SObject value : children ) {
                if ( key.id == value.get( mappingFieldName ) ) {
                    valueList.add( value );
                }
            }
            if ( valueList.size() > 0 ) {
                childMap.put( key, valueList );
            }
        }

        return childMap;
    }

    // Retrieves the name of the field in a child object that references the parent object
    private static String GetMappingField ( Schema.DescribeSObjectResult parent, Schema.DescribeSObjectResult child ) {
        List< Schema.ChildRelationship > parentRelationships = parent.getChildRelationships();
        for ( Schema.ChildRelationship relationship : parentRelationships ) {
            if ( relationship.getChildSObject().getDescribe().getName() == child.getName() ) {
                return relationship.getField().getDescribe().getName();
            }
        }
        return null;
    }

    // Retrieves the SObjectResult from an input SObject; matching off of ID prefix
    private static Schema.DescribeSObjectResult GetSObjectResultFromSObject( SObject sObj ) {
        String currPrefix;
        String objPrefix = null;

        // For valid ID's, store the object ID prefix
        if ( sObj != null && sObj.Id != null)
            objPrefix = String.valueOf( sObj.Id ).substring( 0, 3 );

        // Find ID prefix in the global describe
        for( Schema.SObjectType objType : objectMap.values() ) {
            Schema.DescribeSObjectResult result = objType.getDescribe();
            currPrefix = result.getKeyPrefix();

            if ( currPrefix != null && currPrefix == objPrefix ) {
                return result;
            }
        }

        return null;
    }

    /*
        This method is additionally an extreme example of dynamicism in action. We learned about
        these powerful, advanced Apex methods in order to enhance the effectiveness of our code.
        We should make use of them to allow us to not hardcode our values. The more information we
        can retrieve on the fly (at runtime) instead of ahead of time and hard-code in, the more
        flexible and powerful our programs will be
    */

    /*
        Let's go ahead and list out our best practices:
        - Keep your code stupid simple and READABLE
        - Modularize your code by extracting repeatable functionality
        - Comment your code
        - Have self-documenting code
        - Use dynamically retrieved values wherever possible
        - Robustly test your code
        
        Apex Specific:
        - Follow governor limits
          - No SOQL/SOSL/DML in loops
          - Use the Limits class to stay within governor limits
          - Use SOQL For Loops
          - Use asynchronous apex for more governor limits if needed
        - Follow trigger best practices
          - Bulkify your trigger
          - 1 trigger per object
          - Keep triggers logicless
          - Avoid trigger recursion
        
    */
}
