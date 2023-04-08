/**
 * @author Rafael Araújo (leon3cs)
 * @date 2023
 * 
 * @group Interfaces
 * 
 * @description QueryBuilder interface
 */
public interface IQueryBuilder {
    /**
     * @description Adds a SObjectType to select FROM
     * @param sObject object type to select FROM
     * @return the current QueryBuilder instance with the added sObject
     */
	QueryBuilder selectFrom(Schema.SObjectType obj);
    /**
     * @description Adds a list of fields to be selected
     * @param fields the fields list
     * @return the current QueryBuilder instance with the added fields
     */
    QueryBuilder addFields(List<Schema.SObjectField> fields);
    /**
     * @description Adds a single field with aggregation function to the query
     * @param field the SObjectField to be aggregated
     * @param type the type of aggregation to be used
     * @return the current QueryBuilder instance with the added field aggregation
     */
    QueryBuilder addFieldAggregator(Schema.SObjectField field, AgreggatorType.types type);
    /**
     * @description Adds a single field to be grouped by
     * @param field the SObjectField to be grouped by
     * @return the current QueryBuilder instance with the added grouping
     */
    QueryBuilder groupBy(Schema.SObjectField field);
    /**
     * @description Adds a list of fields to be added in the order by clause
     * @param fields the list of fields to be added
     * @param type the type of ordering to be used 
     * @return the current QueryBuilder instance with the added ordering
     */
    QueryBuilder orderBy(List<Schema.SObjectField> fields, OrderByType.types type);
    /**
     * @description Adds a limit to the query
     * @param numRecords the amount of records allowed to return by the query
     * @return the current QueryBuilder instance with the added limit
     */
    QueryBuilder limitBy(Integer numRecords);
    /**
     * @description Adds a single where clause to the query. 
     * If added clause is not the first, it will be linked to the other clauses
     * by an AND operator
     * @param clause the QueryBuilderClause object to be added
     * @return the current QueryBuilder isntance with the added clause
     */
    QueryBuilder addWhere(QueryBuilderClause clause);
    /**
     * @description Adds two clauses to the where expression with an AND operator
     * if this expression is not the first in the clauses list, it will be linked
     * to the other clauses by an AND operator
     * @param clause1 the first QueryBuilderClause
     * @param clause2 the second QueryBuilderClause
     * @return the current QueryBuilder instance with the added clauses
     */
    QueryBuilder addWhereAnd(QueryBuilderClause clause1, QueryBuilderClause clause2);
    /**
     * @description Adds two clauses to the where expression with an OR operator
     * if this expression is not the first in the clauses list, it will be linked
     * to the other clauses by an AND operator
     * @param clause1 the first QueryBuilderClause
     * @param clause2 the second QueryBuilderClause
     * @return the current QueryBuilder instance with the added clauses
     */
    QueryBuilder addWhereOr(QueryBuilderClause clause1, QueryBuilderClause clause2);
    /**
     * @description Adds a single clause to the where expression with an NOT operator
     * if this expression is not the first in the clauses list, it will be linked
     * to the other clauses by an AND operator
     * @param clause1 the first QueryBuilderClause
     * @return the current QueryBuilder instance with the added clauses
     */
    QueryBuilder addWhereNot(QueryBuilderClause clause);
    /**
     * @description Adds a list of clauses with an especified expression to follow. The custom expression 
     * must be use numbers to represent the clauses as placeholders, and the query will be mounted in the order they 
     * came in the list, from 0 to n.
     * @param clauses the list of all clauses used in the expression
     * @param expression the where expression the be followed
     * @return the current QueryBuilder instance with the added clauses
     */
    QueryBuilder addWhereCustom(List<QueryBuilderClause> clauses, String expression);
    /**
     * @description Adds a subquery to the main query (not yet implemented)
     * @param relatedObject the related object to be selected
     * @param subquery a QueryBuilder instance with the subquery configuration
     * @return the current instance of QueryBuilder with the added subquery
     */
    QueryBuilder addSubquery(Schema.SObjectType relatedObject, QueryBuilder subQuery);
    /**
     * @description After making all the necessary validations, the basic query 
     * is built and optional parameters like WHERE clauses, limits, order and groups
     * are inserted into the query if they are present in the builder configuration
     * @return a string representing the query
     */
    String build();
}