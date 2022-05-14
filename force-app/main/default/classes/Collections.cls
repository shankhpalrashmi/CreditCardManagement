public class Collections {
    /* Listed below are primitive DataTypes used as a collection of list,set or map.
     * You can also use customised apex classes as list,set or map.
     * Additionally you can use custom object apex classes like Customer__c as list,set or map.
     */
    
	public List<String> names;
    public Set<Integer> rollNumbers;
    public Map<Integer, String> studentMap;
    public Set<String> orderedNames;
    
    /*List is just like any other list.
     * Values in a list are taken in ordered manner, the order in which they are added.
     * The values can be duplicate
     */
    
    public void understandList(){
        //Not a primitive datatype so need to allocate space.
        names = new List<String>();
        names.add('Rashmi'); //0
        names.add('Prashant'); //1
        names.add('Mangala'); //2
        names.add('Subhash'); //3
        names.add('Kid'); //4
        
        System.debug('I am printing list elements: '+names);
        
        // Element on the 4th place is Kid so it will be printed
        System.debug('I am printing value against index 4: '+names[4]);
    }
    
    /*Set can be integers or strings.
     * Values in a list are taken in ordered manner, the order in which they are added.
     * The values can be duplicate
     */
    
        public void understandSet(){
        rollNumbers = new Set<Integer>();
        rollNumbers.add(22);
        rollNumbers.add(25);
        rollNumbers.add(29);
        rollNumbers.add(26);
        rollNumbers.add(15);
        
        System.debug('I am printing set of elements: '+rollNumbers);
    }
    
    public void understandMap(){
        studentMap = new Map<Integer, String>();
        studentMaP.put(22, 'A');
        studentMap.put(25, 'B');
        studentMap.put(29, 'J');
        studentMap.put(26, 'U');
        studentMap.put(15, 'O');
        //key act as set and value act as list
     
        System.debug('I am printing set elements: '+studentMap);
        
        // this is how you print all the keys in a map
        
        System.debug('I am printing set elements: '+studentMap.keySet());
        
        //this is how you print values in a map
        System.debug('I am printing set elements: '+studentMap.values());

        //this how you print a particular value against a key
        System.debug('I am printing set elements: '+studentMap.get(25));
    }
    
    //If you use strings in a set it prints list in an alphabetical order
    
    public void setAsStrings(){
        orderedNames = new Set<String>();
        orderedNames.add('Rashmi'); //0
        orderedNames.add('Prashant'); //1
        orderedNames.add('Mangala'); //2
        orderedNames.add('Subhash'); //3
        orderedNames.add('Kid'); //4
        
        System.debug('I am printing list elements: '+orderedNames);
        
    }
}