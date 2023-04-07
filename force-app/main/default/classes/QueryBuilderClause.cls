/**
 * @author Rafael Araújo (leon3cs)
 * @date 2023
 * 
 * @group Classes
 * 
 * @description This is the IQueryBuilderClause implementation that allows where statements to be written as 
 * configuration objects to be added in the QueryBuilder object
 */
public class QueryBuilderClause implements IQueryBuilderClause {
    /**
     * @description the SObjectField to make the logical operation
     */
    @TestVisible
    private Schema.SObjectField field {get;set;}
    /**
     * @description the internal salesforce field type of the SObjectField to treat the value to compare properly
     */
    @TestVisible
    private Schema.DisplayType fieldType {get;set;}
    /**
     * @description the string representation of the logical operation configured
     */
    @TestVisible
    private String clause {get;set;}
    
    /**
     * @description Initializes required propreties
     */
    public QueryBuilderClause(){
        this.clause = '';
    }
    
    /**
     * @description Adds a SObjectField to be compared with
     * @param field the SObjectField to compare
     * @return the current QueryBuilderClause instance with the added field
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.Amount);
     */
    public QueryBuilderClause field(Schema.SObjectField field){
		this.field = field;
        this.fieldType = field.getDescribe().getType();
        return this;
    }
    
    /**
     * @description Receives a value and return the string representation of it
     * @param value the Object to return as string
     * @return the string representation of the value
     */
    @TestVisible
    private String getParsedValue(Object value){
        switch on this.fieldType {
            when DATE, DATETIME, INTEGER, DOUBLE, LONG, TIME, PERCENT, CURRENCY {
            	return String.valueOf(value);
        	}
            when else {
                return '\''+String.valueOf(value)+'\'';
            }
        }
    }
    
    /**
     * @description Creates a clause using the equal operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.Amount)
     * .isEqual(1000);
     */
    public QueryBuilderClause isEqual(Object value){
        String fieldName = this.field.getDescribe().getName();
        String compareValue = getParsedValue(value);
        this.clause = fieldName+' = '+compareValue;
        return this;
    }
    
    /**
     * @description Creates a clause using the not equal operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.Amount)
     * .isNotEqual(1000);
     */
    public QueryBuilderClause isNotEqual(Object value){
        String fieldName = this.field.getDescribe().getName();
        String compareValue = getParsedValue(value);
        this.clause = fieldName+' != '+compareValue;
        return this;
    }
    
    /**
     * @description Creates a clause using the less than operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.Amount)
     * .isLessThan(1000);
     */
    public QueryBuilderClause isLessThan(Object value){
        String fieldName = this.field.getDescribe().getName();
        String compareValue = getParsedValue(value);
        this.clause = fieldName+' < '+compareValue;
        return this;
    }
    
    /**
     * @description Creates a clause using the less or equal operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.Amount)
     * .isLessOrEqual(1000);
     */
    public QueryBuilderClause isLessOrEqual(Object value){
        String fieldName = this.field.getDescribe().getName();
        String compareValue = getParsedValue(value);
        this.clause = fieldName+' <= '+compareValue;
        return this;
    }
    
    /**
     * @description Creates a clause using the greater than operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.Amount)
     * .isGreaterThan(1000);
     */
    public QueryBuilderClause isGreaterThan(Object value){
        String fieldName = this.field.getDescribe().getName();
        String compareValue = getParsedValue(value);
        this.clause = fieldName+' > '+compareValue;
        return this;
    }
    
    /**
     * @description Creates a clause using the greater than or equal operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.Amount)
     * .isGreaterOrEqual(1000);
     */
    public QueryBuilderClause isGreaterOrEqual(Object value){
        String fieldName = this.field.getDescribe().getName();
        String compareValue = getParsedValue(value);
        this.clause = fieldName+' >= '+compareValue;
        return this;
    }
    
    /**
     * @description Creates a clause using the like operator
     * @param type a LikeType which describe the type of like operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     * @example 
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.StageName)
     * .isLike(LikeType.STARTS_WITH, 'Closed');
     */
    public QueryBuilderClause isLike(LikeType type, Object value){
        String fieldName = this.field.getDescribe().getName();
        
        if(type == LikeType.STARTS_WITH){
            this.clause = fieldName + ' LIKE \'' + String.valueOf(value) + '%\'';
        }
        
        if(type == LikeType.ENDS_WITH){
            this.clause = fieldName + ' LIKE \'%' + String.valueOf(value) + '\'';
        }
        
        if(type == LikeType.EQUALS){
            this.clause = fieldName + ' LIKE \'%' + String.valueOf(value) + '%\'';
        }
        
        return this;
    }
    
    /**
     * @description Creates a clause using the in operator
     * @param values the list of occurrences to compare with the field
     * @return the current QueryBuilderClause instance with the clause 
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.StageName)
     * .isIn(new List<Object>{
     *      'Closed Won',
     *      'Closed Lost'
     * });
     */
    public QueryBuilderClause isIn(List<Object> values){
        String fieldName = this.field.getDescribe().getName();
        List<String> stringValues = new List<String>();
        
        for(Object obj : values){
            stringValues.add(getParsedValue(obj));
        }
        
        this.clause = fieldName + ' IN ' + stringValues.toString();
        
        return this;
    }
    
    /**
     * @description Creates a clause using the not in operator
     * @param values the list of occurrences to compare with the field
     * @return the current QueryBuilderClause instance with the clause 
     * @example
     * QueryBuilderClause clause = new QueryBuilderClause()
     * .field(Opportunity.StageName)
     * .isNotIn(new List<Object>{
     *      'Closed Won',
     *      'Closed Lost'
     * });
     */
    public QueryBuilderClause isNotIn(List<Object> values){
        String fieldName = this.field.getDescribe().getName();
        List<String> stringValues = new List<String>();
        
        for(Object obj : values){
            stringValues.add(getParsedValue(obj));
        }
        
        this.clause = fieldName + ' NOT IN ' + stringValues.toString();
        
        return this;
    }
    
    /**
     * @description Generates the string representation of a QueryBuilderClause instance
     * @return A string that represent the operator configured in the builder
     * @example
     * QueryBuilderClause builder = new QueryBuilderClause()
     * .field(Account.Name)
     * .isEqual('John Smith');
     * 
     * String clause = builder.getClause();
     * 
     * System.debug(clause); // output: Name = 'John Smith'
     */
    public String getClause(){
        return this.clause;
    }
}