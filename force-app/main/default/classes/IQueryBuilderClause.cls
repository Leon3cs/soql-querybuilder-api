/**
 * @author Rafael Araújo (leon3cs)
 * @date 2023
 * 
 * @group Interfaces
 * 
 * @description QueryBuilderClause interface
 */
public interface IQueryBuilderClause {
    /**
     * @description Adds a SObjectField to be compared with
     * @param field the SObjectField to compare
     * @return the current QueryBuilderClause instance with the added field
     */
	QueryBuilderClause field(Schema.SObjectField field);
    /**
     * @description Creates a clause using the equal operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isEqual(Object value);
    /**
     * @description Creates a clause using the not equal operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isNotEqual(Object value);
    /**
     * @description Creates a clause using the less than operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isLessThan(Object value);
    /**
     * @description Creates a clause using the less or equal operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isLessOrEqual(Object value);
    /**
     * @description Creates a clause using the greater than operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isGreaterThan(Object value);
    /**
     * @description Creates a clause using the greater than or equal operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isGreaterOrEqual(Object value);
    /**
     * @description Creates a clause using the like operator
     * @param type a LikeType which describe the type of like operator
     * @param value the Object to compare with the field as a String
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isLike(LikeType.types type, Object value);
    /**
     * @description Creates a clause using the in operator
     * @param values the list of occurrences to compare with the field
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isIn(List<Object> values);
    /**
     * @description Creates a clause using the not in operator
     * @param values the list of occurrences to compare with the field
     * @return the current QueryBuilderClause instance with the clause 
     */
    QueryBuilderClause isNotIn(List<Object> values);
    /**
     * @description Generates the string representation of a QueryBuilderClause instance
     * @return A string that represent the operator configured in the builder
     */
    String getClause();
}