/**
 * @author Rafael Araújo (leon3cs)
 * @date 2023
 * 
 * @group Classes
 * 
 * @description The IQueryBuilder implementation of QueryBuilder API. This is the main object to interact with to create a query using QueryBuilder API
 */
public class QueryBuilder implements IQueryBuilder {
    /**
     * @description Type of SObject that is being selected fields from.
     * Will be used to generate the <object> in the query as follows
     * SELECT ... FROM <object> ...
     */
    @TestVisible
    private Schema.SObjectType fromObject {get;set;}
    /**
     * @description A list of SObjectFields to select in the query
     * Will be used to generate the <fields> in the query as follows
     * SELECT <fields> FROM ...
     */
    @TestVisible
    private List<Schema.SObjectField> fields {get;set;}
    /**
     * @description Map of SObjectFields to AgreggatorType for generating the list of fields with aggregations
     * will be used to generate the <aggregated_field> in the query as follows
     * SELECT <fields>,COUNT(<aggregated_field>) FROM ...
     */
    @TestVisible
    private Map<Schema.SObjectField, AgreggatorType.types> aggregatedFields {get;set;}
    /**
     * @description List of fields ordering the result set
     * Will be used to generate <order_field> in the query as follows
     * SELECT ... FROM ... ORDER BY <order_field>,<order_field> ASC|DESC
     */
    @TestVisible
    private List<Schema.SObjectField> orderedFields {get;set;}
    /**
     * @description A list of SObjectFields of all fields the query will be grouped by
     * Will be used to generate <group_field> in the query as follows
     * SELECT ... FROM ... WHERE ... GROUP BY <group_field>,<group_field>,..
     */
    @TestVisible
    private List<Schema.SObjectField> groupedFields {get;set;}
    /**
     * @description The map contains a order number as a key and a QueryBuilderClause object as value
     * that will be used to generate the <clause> in the query as follows
     * SELECT ... FROM ... WHERE <clause>...
     */
    @TestVisible
    private Map<Integer, QueryBuilderClause> clauses {get;set;}
    /**
     * @description Map of related SObjectType to QueryBuilder to generato subqueries
     * Will generate subqueries as follows
     * SELECT fields, (SELECT fields FROM relatedObject ...) FROM object ...
     */
    @TestVisible
    private Map<Schema.SObjectType, QueryBuilder> subQueries {get;set;}
    /**
     * @description Formula that represents the where clause.
     * example 1 AND 2 OR (3 AND NOT 4) where each number will be matched to a 
     * QueryBuilderClause object in the clauses property
     */
    @TestVisible
    private String whereExpression {get;set;}
    /**
     * @description Type of ordering the query will be using
     * can be ASCENDING_NULLS_FIRST|ASCENDING_NULLS_LAST|DESCENDING_NULLS_FIRST|DESCENDING_NULLS_LAST
     */
    @TestVisible
    private OrderByType.types orderBy {get;set;}
    /**
     * @description Number of records to limit the result
     * will generate the <limit> in the query as follows
     * SELECT ... FROM ... LIMIT BY <limit>
     */
    @TestVisible
    private Integer limitBy {get;set;}
    /**
     * @description Indicates if the QueryBuilder instance has added ordering
     */
    @TestVisible
    private Boolean hasOrder {get;set;}
    /**
     * @description Indicates if the QueryBuilder instance has added limit
     */
    @TestVisible
    private Boolean hasLimit {get;set;}
    /**
     * @description Indicates if the QueryBuilder instance has WHERE clauses
     */
    @TestVisible
    private Boolean hasWhere {get;set;}
    /**
     * @description Indicates if the QueryBuilder instance has added grouping
     */
    @TestVisible
    private Boolean hasGroup {get;set;}
    
    /**
     * @group Exceptions
     * 
     * @description It's thrown when there's validation errors related to subqueries generation
     */
    public class SubqueryException extends Exception {}
    /**
     * @group Exceptions 
     * 
     * @description It's thrown when there's a field or object in the QueryBuilder instance that the running user doesn't have
     * access to
     */
    public class AccessException extends Exception {}
    /**
     * @group Exceptions 
     * 
     * @description It's thrown when there's validation errors when generating field aggregations
     */
    public class AggregationException extends Exception {}
    /**
     * @group  Exceptions 
     * 
     * @description It's thrown when there's validation errors when generating field groups
     */
    public class GroupException extends Exception {}
    /**
     * @group Exceptions
     * 
     * @description It's thrown when there's validation errors with the formula described in the whereExpression property
     */
    public class ExpressionException extends Exception {}
    /**
     * @group Exceptions
     * 
     * @description It's thrown when there's no fields to select in the query
     */
    public class SelectionException extends Exception {}
    
    /**
     * @description Initializes all objects required variables
     */
    public QueryBuilder(){
        this.fields = new List<Schema.SObjectField>();
        this.aggregatedFields = new Map<Schema.SObjectField, AgreggatorType.types>();
        this.orderedFields = new List<Schema.SObjectField>();
        this.groupedFields = new List<Schema.SObjectField>();
        this.clauses = new Map<Integer, QueryBuilderClause>();
        this.limitBy = 0;
        this.whereExpression = '';
        this.hasOrder = false;
        this.hasLimit = false;
        this.hasWhere = false;
        this.hasGroup = false;
    }
    
    /**
     * @description Adds a SObjectType to select FROM
     * @param objType object type to select FROM
     * @return the current QueryBuilder instance with the added sObject
     * @example 
     * QueryBuilder builder = new QueryBuilder().selectFrom(Opportunity.getSObjectType());
     */
    public QueryBuilder selectFrom(Schema.SObjectType objType){
        this.fromObject = objType;
        return this;
    }
    
    /**
     * @description Adds a list of fields to be selected
     * @param fields the fields list
     * @return the current QueryBuilder instance with the added fields
     * @example
     * QueryBuilder builder = new QueryBuilder()
     * .addFields(new List<Schema.SObjectField>{
     *      Opportunity.Id,
     *      Opportunity.Name         
     * });
     */
    public QueryBuilder addFields(List<Schema.SObjectField> fields){
        this.fields.addAll(fields);
        return this;
    }
    
    /**
     * @description Adds a single field with aggregation function to the query
     * @param field the SObjectField to be aggregated
     * @param type the type of aggregation to be used
     * @return the current QueryBuilder instance with the added field aggregation
     * @example
     * QueryBuilder builder = new QueryBuilder()
     * .addFieldAggregator(Opportunity.Amount, AgreggatorType.SUM);
     */
    public QueryBuilder addFieldAggregator(Schema.SObjectField field, AgreggatorType.types type){
        this.aggregatedFields.put(field,type);
        return this;
    }
    
    /**
     * @description Adds a single field to be grouped by
     * @param field the SObjectField to be grouped by
     * @return the current QueryBuilder instance with the added grouping
     * @example
     * QueryBuilder builder = new QueryBuilder()
     * .groupBy(Opportunity.Name);
     */
    public QueryBuilder groupBy(Schema.SObjectField field){
        this.hasGroup = true;
        this.groupedFields.add(field);
        return this;
    }
    
    /**
     * @description Adds a list of fields to be added in the order by clause
     * @param fields the list of fields to be added
     * @param type the type of ordering to be used 
     * @return the current QueryBuilder instance with the added ordering
     * @example
     * QueryBuilder builder = QueryBuilder()
     * .orderBy(
     *      new List<Schema.SobjectField>{
     *          Opportunity.Name,
     *          Opportunity.StageName
     *      },
     *      OrderByType.ASCENDING_NULLS_FIRST
     * );
     */
    public QueryBuilder orderBy(List<Schema.SObjectField> fields, OrderByType.types type){
        this.hasOrder = true;
        this.orderedFields.addAll(fields);
        this.orderBy = type;
        return this;
    }
    
    /**
     * @description Adds a limit to the query
     * @param numRecords the amount of records allowed to return by the query
     * @return the current QueryBuilder instance with the added limit
     * @example
     * QueryBuilder builder = new QueryBuilder().limitBy(10);
     */
    public QueryBuilder limitBy(Integer numRecords){
        this.hasLimit = true;
     	this.limitBy = numRecords;
        return this;
    }
    
    /**
     * @description Adds a single where clause to the query. 
     * If added clause is not the first, it will be linked to the other clauses
     * by an AND operator
     * @param clause the QueryBuilderClause object to be added
     * @return the current QueryBuilder isntance with the added clause
     * @example
     * QueryBuilder builder = new QueryBuilder()
     * .addWhere(
     *      new QueryBuilderClause()
     *      .field(Opportunity.StageName)
     *      .isEqual('Closed Won')
     * );
     */
    public QueryBuilder addWhere(QueryBuilderClause clause){
        this.hasWhere = true;
        Integer size = this.clauses.size();
        
        if(size > 0){
            this.clauses.put(size+1,clause);
            this.whereExpression += ' AND '+size;
        }else{
            this.clauses.put(size,clause);
            this.whereExpression += String.valueOf(size);
        }
        
        return this;
    }
    
    /**
     * @description Adds two clauses to the where expression with an AND operator
     * if this expression is not the first in the clauses list, it will be linked
     * to the other clauses by an AND operator
     * @param clause1 the first QueryBuilderClause
     * @param clause2 the second QueryBuilderClause
     * @return the current QueryBuilder instance with the added clauses
     * @example
     * QueryBuilder builder = new QueryBuilder()
     * .addWhereAnd(
     *      new QueryBuilderClause()
     *      .field(Opportunity.StageName)
     *      .isEqual('Closed Won'),
     *      new QueryBuilderClause()
     *      .field(Opportunity.Amount)
     *      .isLessThan(10000)
     * );
     */
    public QueryBuilder addWhereAnd(QueryBuilderClause clause1, QueryBuilderClause clause2){
        this.hasWhere = true;
        Integer size = this.clauses.size();
        
        if(size > 0){
            Integer clause1Index = size;
            Integer clause2Index = size+1;
            this.clauses.put(clause1Index,clause1);
            this.clauses.put(clause2Index,clause2);
            this.whereExpression += ' AND ('+clause1Index+' AND '+clause2Index+')';
        }else{
            Integer clause1Index = 0;
            Integer clause2Index = 1;
            this.clauses.put(clause1Index,clause1);
            this.clauses.put(clause2Index,clause2);
            this.whereExpression += ' ('+clause1Index+' AND '+clause2Index+')';
        }
        
        return this;
    }
    
    /**
     * @description Adds two clauses to the where expression with an OR operator
     * if this expression is not the first in the clauses list, it will be linked
     * to the other clauses by an AND operator
     * @param clause1 the first QueryBuilderClause
     * @param clause2 the second QueryBuilderClause
     * @return the current QueryBuilder instance with the added clauses
     * @example
     * QueryBuilder builder = new QueryBuilder()
     * .addWhereOr(
     *      new QueryBuilderClause()
     *      .field(Opportunity.StageName)
     *      .isEqual('Closed Won'),
     *      new QueryBuilderClause()
     *      .field(Opportunity.Amount)
     *      .isLessThan(10000)
     * );
     */
    public QueryBuilder addWhereOr(QueryBuilderClause clause1, QueryBuilderClause clause2){
        this.hasWhere = true;
        Integer size = this.clauses.size();
        
        if(size > 0){
            Integer clause1Index = size;
            Integer clause2Index = size+1;
            this.clauses.put(clause1Index,clause1);
            this.clauses.put(clause2Index,clause2);
            this.whereExpression += ' AND ('+clause1Index+' OR '+clause2Index+')';
        }else{
            Integer clause1Index = 0;
            Integer clause2Index = 1;
            this.clauses.put(clause1Index,clause1);
            this.clauses.put(clause2Index,clause2);
            this.whereExpression += ' ('+clause1Index+' OR '+clause2Index+')';
        }
        
        return this;
    }
    
    /**
     * @description Adds a single clause to the where expression with an NOT operator
     * if this expression is not the first in the clauses list, it will be linked
     * to the other clauses by an AND operator
     * @param clause1 the first QueryBuilderClause
     * @return the current QueryBuilder instance with the added clauses
     * @example
     * QueryBuilder builder = new QueryBuilder()
     * .addWhereNot(
     *      new QueryBuilderClause()
     *      .field(Opportunity.StageName)
     *      .isEqual('Closed Won')
     * );
     */
    public QueryBuilder addWhereNot(QueryBuilderClause clause){
        this.hasWhere = true;
        Integer size = this.clauses.size();
        
        if(size > 0){
            Integer clauseIndex = size + 1;
            this.clauses.put(clauseIndex,clause);
            this.whereExpression += ' AND NOT '+size;
        }else{
            Integer clauseIndex = 0;
            this.clauses.put(clauseIndex,clause);
            this.whereExpression += ' NOT '+clauseIndex;
        }
        
        return this;
    }
    
    /**
     * @description Adds a list of clauses with an especified expression to follow. The custom expression 
     * must be use numbers to represent the clauses as placeholders, and the query will be mounted in the order they 
     * came in the list, from 0 to n.
     * @param clauses the list of all clauses used in the expression
     * @param expression the where expression the be followed
     * @return the current QueryBuilder instance with the added clauses
     * @example
     * QueryBuilder builder = new QueryBuilder()
     * .addWhereCustom(
     *      new List<QueryBuilderClause>{
     *          new QueryBuilderClause()
     *          .field(Opportunity.Amount)
     *          .isLessThan(10000),
     *          new QueryBuilderClause()
     *          .field(Opportunity.StageName)
     *          .isEqual('Closed Won'),
     *          new QueryBuilderClause()
     *          .field(Opportunity.StageName)
     *          .isEqual('Closed Lost'),
     *      },
     *      '0 AND (1 OR 2)'
     * )
     */
    public QueryBuilder addWhereCustom(List<QueryBuilderClause> clauses, String expression){
        this.hasWhere = true;
        Integer clauseIndex = 0;
        
        for(QueryBuilderClause clause : clauses){
            this.clauses.put(clauseIndex,clause);
            clauseIndex++;
        }
        
        this.whereExpression = expression;
        
        return this;
    }
    
    /**
     * @description Adds a subquery to the main query (not yet implemented)
     * @param relatedObject the related object to be selected
     * @param subquery a QueryBuilder instance with the subquery configuration
     * @return the current instance of QueryBuilder with the added subquery
     * @example
     * !--- examples unavailable ---!
     * (method not yet implemented properly)
     */
    public QueryBuilder addSubquery(Schema.SObjectType relatedObject, QueryBuilder subquery){
        if(!this.subQueries.containsKey(relatedObject)){
            this.subQueries.put(relatedObject,subquery);
        }else{
            throw new SubqueryException('Duplicate subquery for object: '+relatedObject.getDescribe().getName());
        }
        
        return this;
    }
    
    /**
     * @description Verify if the object to be selected from is accessible by the running user
     */
    @TestVisible
    private void validateObjectAccessibility(){
        if(!this.fromObject.getDescribe().isAccessible()){
			throw new AccessException('Object is not accessible: '+this.fromObject.getDescribe().getName());
        }
    }
    
    /**
     * @description Verify if the fields to be selected are accessible by the running user
     */
    @TestVisible
    private void validateFieldsAccessibility(){
        if(this.fields.isEmpty()){
            throw new SelectionException('Cannot make query without selecting fields');
        }
        
        for(Schema.SObjectField field : this.fields){
            if(!field.getDescribe().isAccessible()){
                throw new AccessException('Field is not accessible: ' + field.getDescribe().getName());
            }
        }
    }
    
    /**
     * @description Validates if the aggregated fields doesn't also are being selected instead of being grouped
     */
    @TestVisible
    private void validateAggregatedFields(){
        for(Schema.SObjectField field : this.fields){
            if(this.aggregatedFields.containsKey(field)){
                throw new AggregationException('Grouped field should not be aggregated: '+ field.getDescribe().getName());
            }
        }
    }
    
    /**
     * @description Validates there are fields to select that needs to be grouped or aggregated
     */
    @TestVisible
    private void validateGroupedFields(){
        if(!this.aggregatedFields.isEmpty()){
            for(Schema.SObjectField field : fields){
                if(!this.groupedFields.contains(field)){
                    throw new GroupException('Field should be grouped or aggregated: '+ field.getDescribe().getName());
                }
            }
        }
    }
    
    /**
     * @description Validates if the where expression contains all the indices tha match a where clause 
     */
    @TestVisible
    private void validateWhereExpression(){
        Boolean isValid = true;
        if(!this.clauses.isEmpty()){
            Integer size = this.clauses.size();
            for(Integer i=0;i<size;i++){
                if(!this.whereExpression.contains(String.valueOf(i))){
                 	isValid = false;   
                }
            }
        }
        if(!isValid){
            throw new ExpressionException('Invalid where expression: '+this.whereExpression);
        }
    }
    
    /**
     * @description builds a string with the names of all the fields to select
     * @return a string with comma separated field names
     */
    @TestVisible
    private String getFieldNames(){
        String fieldNames = '';
        
        for(Schema.SObjectField field : this.fields){
            fieldNames += field.getDescribe().getName() + ',';
        }
        
        return fieldNames.substringBeforeLast(',');
    }
    
    /**
     * @description Builds a string with all fields with aggregation functions
     * @return a string with comma separated values
     */
    @TestVisible
    private String getAggregatedFieldNames(){
        String aggregatedNames = ',';
        
        if(!this.aggregatedFields.isEmpty()){
            for(Schema.SObjectField field : this.aggregatedFields.keySet()){
                AgreggatorType.types type = this.aggregatedFields.get(field);
                switch on type {
                    when AVG {
                        aggregatedNames += 'AVG('+field.getDescribe().getName()+'),';
                    }
                    when COUNT {
                        aggregatedNames += 'COUNT('+field.getDescribe().getName()+'),';
                    }
                    when COUNT_DISTINCT {
                        aggregatedNames += 'COUNT_DISTINCT('+field.getDescribe().getName()+'),';
                    }
                    when MAX {
                        aggregatedNames += 'MAX('+field.getDescribe().getName()+'),';
                    }
                    when MIN {
                        aggregatedNames += 'MIN('+field.getDescribe().getName()+'),';
                    }
                    when SUM {
                        aggregatedNames += 'SUM('+field.getDescribe().getName()+'),';
                    }
                }
            }
        }
        
        return aggregatedNames.substringBeforeLast(',');
    }

    /**
     * @description Builds the where expression to filter the selection
     * @return a string with expressions
     */
    public String getWhereClause(){
        String whereClause = this.whereExpression;
        
        Integer size = this.clauses.size();
        
        for(Integer i=0; i<size; i++){
            whereClause = whereClause.replace(String.valueOf(i), this.clauses.get(i).getClause());
        }
        
        return whereClause;
    }
    
    /**
     * @description Builds the list of field names to the query be ordered with
     * @return a string with fields names and the type of ordering
     */
    public String getOrder(){
        String orderByFields = '';
        String order = '';
        
        if(!this.orderedFields.isEmpty()){
            for(Schema.SObjectField field : this.orderedFields){
                orderByFields += field.getDescribe().getName() + ',';
            }
        
            switch on this.orderBy {
                when ASCENDING_NULLS_LAST {
                    order = 'ASC NULLS LAST';
                }
                when ASCENDING_NULLS_FIRST {
                    order = 'ASC';
                }
                when DESCENDING_NULLS_LAST {
                    order = 'DESC NULLS LAST';
                }
                when DESCENDING_NULLS_FIRST {
                    order = 'DESC';
                }
            }            
            
        	orderByFields = orderByFields.substringBeforeLast(',') + ' ' + order;
        }
        
        return orderByFields;
    }
    
    /**
     * @description Builds a string of field names to group by
     * @return a string of comma separated field names
     */
    public String getGroups(){
        String groups = '';
        
        if(!this.groupedFields.isEmpty()){
            for(Schema.SObjectField field : this.groupedFields){
                groups += field.getDescribe().getName() + ',';
            }
        }
        
        return groups.substringBeforeLast(',');
    }
    
    /**
     * @description After making all the necessary validations, the basic query 
     * is built and optional parameters like WHERE clauses, limits, order and groups
     * are inserted into the query if they are present in the builder configuration
     * @return a string representing the query
     * @example
     * QueryBuilder builder = new QueryBuilder()
     *      .selectFrom(Opportunity.getSObjectType())
     *      .addFields(new List<Schema.SObjectField>{
     *          Opportunity.Id,
     *          Opportunity.Name
     *      })
     *      .addFieldAggregator(Opportunity.Amount, AgreggatorType.COUNT)
     *      .groupBy(Opportunity.Id)
     *      .groupBy(Opportunity.Name)
     *      .addWhere(new QueryBuilderClause()
     *          .field(Opportunity.StageName)
     *          .isEqual('Closed Won'))
     *      .orderBy(new List<Schema.SObjectField>{Opportunity.Name}, OrderByType.ASCENDING_NULLS_LAST)
     *      .limitBy(10);
     * 
     *  String query = builder.build();
     * 
     *  System.debug(query) // output: 'SELECT Id,Name,COUNT(Amount) FROM Opportunity WHERE StageName = \'Closed Won\' GROUP BY Id,Name ORDER BY Name ASC NULLS LAST LIMIT 10';
     */
    public String build(){
        validateObjectAccessibility();
        validateFieldsAccessibility();
        validateAggregatedFields();
        validateGroupedFields();
        validateWhereExpression();
        
        String query = 'SELECT ';
        
        query += getFieldNames();
        
        query += getAggregatedFieldNames();
        
        query += ' FROM ';
        
        query += this.fromObject.getDescribe().getName();
        
        if(this.hasWhere){
            query += ' WHERE ' + getWhereClause();
        }
        
        if(this.hasGroup){
            query += ' GROUP BY ' + getGroups();
        }

        if(this.hasOrder){
            query += ' ORDER BY ' + getOrder();
        }
        
        if(this.hasLimit){
            query += ' LIMIT ' + String.valueOf(this.limitBy);
        }
        
        return query;
    }
}