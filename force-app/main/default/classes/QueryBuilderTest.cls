@IsTest
public class QueryBuilderTest {
    
    @IsTest
    static void shouldInitializeQueryBuilder(){
        QueryBuilder builder = new QueryBuilder();

        Assert.isInstanceOfType(builder.fields, List<Schema.SObjectField>.class, 'it should match types');
        Assert.isInstanceOfType(builder.orderedFields, List<Schema.SObjectField>.class, 'it should match types');
        Assert.isInstanceOfType(builder.groupedFields, List<Schema.SObjectField>.class, 'it should match types');
        Assert.isInstanceOfType(builder.aggregatedFields, Map<Schema.SObjectField, AgreggatorType.types>.class, 'it should match types');
        Assert.isInstanceOfType(builder.clauses, Map<Integer, QueryBuilderClause>.class, 'it should match types');
        Assert.isInstanceOfType(builder.limitBy, Integer.class, 'it should match types');
        Assert.isInstanceOfType(builder.whereExpression, String.class, 'it should match types');
        Assert.isInstanceOfType(builder.hasOrder, Boolean.class, 'it should match types');
        Assert.isInstanceOfType(builder.hasGroup, Boolean.class, 'it should match types');
        Assert.isInstanceOfType(builder.hasLimit, Boolean.class, 'it should match types');
        Assert.isInstanceOfType(builder.hasWhere, Boolean.class, 'it should match types');
    }

    @IsTest
    static void shouldInitializeFromObject(){
        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType());

        Assert.isInstanceOfType(builder.fromObject, Schema.SObjectType.class, 'it should match types');
        Assert.areEqual(Account.getSObjectType(), builder.fromObject, 'it should match values');
    }

    @IsTest
    static void shouldInitializeFields(){
        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .addFields(
                new List<Schema.SObjectField>{
                    Account.Id,
                    Account.Name,
                    Account.CreatedDate
                }
            );

        Assert.areEqual(3, builder.fields.size(), 'it should have 3 added fields');
    }

    @IsTest
    static void shouldAddFieldAggregator(){
        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Opportunity.getSObjectType())
            .addFieldAggregator(Opportunity.Amount, AgreggatorType.types.MAX);

        Assert.isFalse(builder.aggregatedFields.isEmpty(), 'it should have added the aggregation');
    }

    @IsTest
    static void shouldAddFieldGroup(){
        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .groupBy(Account.Name);

        Assert.areEqual(1, builder.groupedFields.size(), 'it should have added the group');
        Assert.isTrue(builder.hasGroup, 'it should have changed hasGroup variable to true');
    }
    
    @IsTest
    static void shouldAddOrderBy(){
        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .orderBy(new List<Schema.SObjectField>{
                Account.Name
            }, OrderByType.types.ASCENDING_NULLS_LAST);

        Assert.areEqual(1, builder.orderedFields.size(), 'it should have added the ordering');
        Assert.isTrue(builder.hasOrder, 'it should have changed hasOrder variable to true');
    }

    @IsTest
    static void shouldLimitBy(){
        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .limitBy(10);

        Assert.areEqual(10, builder.limitBy, 'it should have added the limit');
        Assert.isTrue(builder.hasLimit, 'it should have changed hasLimit variable to true');
    }

    @IsTest
    static void shouldAddWhere(){
        QueryBuilderClause clause = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual('John Smith');

        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .addWhere(clause);
        
        Assert.isTrue(builder.hasWhere, 'it should have changed hasWhere variable to true');
        Assert.areEqual('0', builder.whereExpression, 'it should have matched the where expresison');

        QueryBuilderClause clause2 = new QueryBuilderClause()
            .field(Account.Phone)
            .isEqual('99999999');

        builder.addWhere(clause2);

        Assert.areEqual('0 AND 1', builder.whereExpression, 'it should have matched the where expression with AND');
    }

    @IsTest
    static void shouldAddWhereAnd(){
        QueryBuilderClause clause1 = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual('John Smith');
        
        QueryBuilderClause clause2 = new QueryBuilderClause()
            .field(Account.Phone)
            .isEqual('99999999');

        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .addWhereAnd(clause1, clause2);
        
        Assert.areEqual(' (0 AND 1)', builder.whereExpression, 'it should have matched the where expression with AND');
        
        QueryBuilderClause clause3 = new QueryBuilderClause()
        .field(Account.Name)
        .isEqual('William Clover');
        
        QueryBuilderClause clause4 = new QueryBuilderClause()
        .field(Account.Phone)
        .isEqual('3939393939');
        
        builder.addWhereAnd(clause3, clause4);
        
        Assert.areEqual(' (0 AND 1) AND (2 AND 3)', builder.whereExpression, 'it should have matched the where expression with AND');
    }

    @IsTest
    static void shouldAddWhereOr(){
        QueryBuilderClause clause1 = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual('John Smith');
        
        QueryBuilderClause clause2 = new QueryBuilderClause()
            .field(Account.Phone)
            .isEqual('99999999');

        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .addWhereOr(clause1, clause2);
        
        Assert.areEqual(' (0 OR 1)', builder.whereExpression, 'it should have matched the where expression with OR');
        
        QueryBuilderClause clause3 = new QueryBuilderClause()
        .field(Account.Name)
        .isEqual('William Clover');
        
        QueryBuilderClause clause4 = new QueryBuilderClause()
        .field(Account.Phone)
        .isEqual('3939393939');
        
        builder.addWhereOr(clause3, clause4);
        
        Assert.areEqual(' (0 OR 1) AND (2 OR 3)', builder.whereExpression, 'it should have matched the where expression with OR');
    }

    @IsTest
    static void shouldAddWhereCustom(){
        QueryBuilderClause clause1 = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual('John Smith');
        
        QueryBuilderClause clause2 = new QueryBuilderClause()
            .field(Account.Phone)
            .isEqual('99999999');

        QueryBuilderClause clause3 = new QueryBuilderClause()
        .field(Account.Name)
        .isEqual('William Clover');
        
        QueryBuilderClause clause4 = new QueryBuilderClause()
        .field(Account.Phone)
        .isEqual('3939393939');

        List<QueryBuilderClause> clauses = new List<QueryBuilderClause>{clause1,clause2,clause3,clause4};

        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .addWhereCustom(clauses, '0 AND (1 OR (2 AND NOT 3))');
    
        Assert.isTrue(builder.clauses.size() == 4, 'it should match clause list size');
        Assert.areEqual('0 AND (1 OR (2 AND NOT 3))',builder.whereExpression, 'it should have matched the custom expression');
    }

    @IsTest
    static void shouldAddWhereNot(){
        QueryBuilderClause clause = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual('John Smith');

        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .addWhereNot(clause);
        
        Assert.isTrue(builder.hasWhere, 'it should have changed hasWhere variable to true');
        Assert.areEqual(' NOT 0', builder.whereExpression, 'it should have matched the where expresison');

        QueryBuilderClause clause2 = new QueryBuilderClause()
            .field(Account.Phone)
            .isEqual('99999999');

        builder.addWhereNot(clause2);

        Assert.areEqual(' NOT 0 AND NOT 1', builder.whereExpression, 'it should have matched the where expression with AND');
    }

    @IsTest
    static void shouldValidateObjectAccessibility(){
        String username = 'test@user'+Datetime.now().getTime()+'.com';

        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Minimum Access - Salesforce'];

        User usr = new User(
            FirstName='test',
            LastName='user',
            Username=username,
            ProfileId=prof.Id,
            Email='email@email.com',
            Alias='tstu',
            TimeZoneSidKey='America/Los_Angeles',
            LocaleSidKey='en_US',
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US'
        );

        System.runAs(usr){

            QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType());

            Exception resultException = null;

            try{
                builder.validateObjectAccessibility();
            }catch(Exception ex){
                resultException = ex;
            }

            Assert.isNotNull(resultException, 'Should throw exception');
            Assert.areEqual('Object is not accessible: '+Account.getSObjectType().getDescribe().getName(), resultException.getMessage(), 'Should say that object is not accessible');
        }
    }

    @IsTest
    static void shouldValidateFieldAccessibility(){
        String username = 'test@user'+Datetime.now().getTime()+'.com';

        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Minimum Access - Salesforce'];

        User usr = new User(
            FirstName='test',
            LastName='user',
            Username=username,
            ProfileId=prof.Id,
            Email='email@email.com',
            Alias='tstu',
            TimeZoneSidKey='America/Los_Angeles',
            LocaleSidKey='en_US',
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US'
        );

        System.runAs(usr){

            QueryBuilder builder = new QueryBuilder();

            Exception resultException = null;

            try{
                builder.validateFieldsAccessibility();
            }catch(Exception ex){
                resultException = ex;
            }

            Assert.isNotNull(resultException, 'Should throw exception');
            Assert.areEqual('Cannot make query without selecting fields', resultException.getMessage(), 'Should return the specified message for empty fields');

            QueryBuilder builder2 = new QueryBuilder()
                .addFields(new List<Schema.SObjectField>{
                    Account.Id
                });

            Exception resultException2 = null;

            try{
                builder2.validateFieldsAccessibility();
            }catch(Exception ex){
                resultException2 = ex;
            }

            Assert.isNotNull(resultException, 'Should throw exception');
            Assert.areEqual('Field is not accessible: ' + Account.Id.getDescribe().getName(), resultException2.getMessage(), 'Should return specified message for unavailable fields');
        }
    }

    @IsTest
    static void shouldValidateAggregatedFields(){
        QueryBuilder builder = new QueryBuilder()
            .addFields(new List<Schema.SObjectField>{Account.Id})
            .addFieldAggregator(Account.Id, AgreggatorType.types.AVG)
            .groupBy(Account.Id);

        Exception resultException = null;

        try{
            builder.validateAggregatedFields();
        }catch(Exception ex){
            resultException = ex;
        }

        Assert.isNotNull(resultException, 'Should throw exception');
        Assert.areEqual('Grouped field should not be aggregated: '+ Account.Id.getDescribe().getName(), resultException.getMessage(), 'Should return specified message for grouped field');
    }

    @IsTest
    static void shouldValidateGroupedFields(){
        QueryBuilder builder = new QueryBuilder()
            .addFields(new List<Schema.SObjectField>{Account.Id})
            .addFieldAggregator(Account.Id, AgreggatorType.types.AVG);

        Exception resultException = null;

        try{
            builder.validateGroupedFields();
        }catch(Exception ex){
            resultException = ex;
        }

        Assert.isNotNull(resultException, 'Should throw exception');
        Assert.areEqual('Field should be grouped or aggregated: '+ Account.Id.getDescribe().getName(), resultException.getMessage(), 'Should return specified message for grouped field');
    }

    @IsTest
    static void shouldValidadeWhereExpression(){
        QueryBuilderClause clause1 = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual('John Smith');
        
        QueryBuilderClause clause2 = new QueryBuilderClause()
            .field(Account.Phone)
            .isEqual('99999999');

        QueryBuilderClause clause3 = new QueryBuilderClause()
        .field(Account.Name)
        .isEqual('William Clover');
        
        QueryBuilderClause clause4 = new QueryBuilderClause()
        .field(Account.Phone)
        .isEqual('3939393939');

        List<QueryBuilderClause> clauses = new List<QueryBuilderClause>{clause1,clause2,clause3,clause4};

        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .addWhereCustom(clauses, '0 AND (1 OR (2 AND NOT 4))');

        Exception resultException = null;

        try{
            builder.validateWhereExpression();
        }catch(Exception ex){
            resultException = ex;
        }

        Assert.isNotNull(resultException, 'Should throw exception');
        Assert.areEqual('Invalid where expression: '+builder.whereExpression, resultException.getMessage(), 'Should return specified message for invalid expression');
    }

    @IsTest
    static void shouldGetFieldNames(){
        QueryBuilder builder = new QueryBuilder()
            .addFields(
                new List<Schema.SObjectField>{
                    Account.Id,
                    Account.Name,
                    Account.Phone
                }
            );
        
        String fieldNames = builder.getFieldNames();

        Assert.isNotNull(fieldNames, 'Should return fieldNames');
        Assert.isTrue(fieldNames.contains(Account.Id.getDescribe().getName()), 'Should contain field name');
        Assert.isTrue(fieldNames.contains(Account.Name.getDescribe().getName()), 'Should contain field name');
        Assert.isTrue(fieldNames.contains(Account.Phone.getDescribe().getName()), 'Should contain field name');
    }

    @IsTest
    static void shouldGetAggregatedFieldNames(){
        QueryBuilder builder = new QueryBuilder()
            .addFieldAggregator(Opportunity.Amount, AgreggatorType.types.AVG)
            .addFieldAggregator(Opportunity.StageName, AgreggatorType.types.COUNT)
            .addFieldAggregator(Opportunity.Id, AgreggatorType.types.COUNT_DISTINCT)
            .addFieldAggregator(Opportunity.CreatedDate, AgreggatorType.types.MAX)
            .addFieldAggregator(Opportunity.LastModifiedDate, AgreggatorType.types.MIN)
            .addFieldAggregator(Opportunity.ExpectedRevenue, AgreggatorType.types.SUM);

        String fieldNames = builder.getAggregatedFieldNames();

        Assert.isNotNull(fieldNames, 'Should return fieldNames');
        Assert.isTrue(fieldNames.contains('AVG'), 'Should contain AVG aggregation');
        Assert.isTrue(fieldNames.contains('COUNT'), 'Should contain COUNT aggregation');
        Assert.isTrue(fieldNames.contains('COUNT_DISTINCT'), 'Should contain COUNT_DISTINCT aggregation');
        Assert.isTrue(fieldNames.contains('MAX'), 'Should contain MAX aggregation');
        Assert.isTrue(fieldNames.contains('MIN'), 'Should contain MIN aggregation');
        Assert.isTrue(fieldNames.contains('SUM'), 'Should contain SUM aggregation');
    }

    @IsTest
    static void shouldGetWhereClause(){
        QueryBuilderClause clause1 = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual('John Smith');
        
        QueryBuilderClause clause2 = new QueryBuilderClause()
            .field(Account.Phone)
            .isEqual('99999999');

        QueryBuilderClause clause3 = new QueryBuilderClause()
        .field(Account.Name)
        .isEqual('William Clover');
        
        QueryBuilderClause clause4 = new QueryBuilderClause()
        .field(Account.Phone)
        .isEqual('3939393939');

        List<QueryBuilderClause> clauses = new List<QueryBuilderClause>{clause1,clause2,clause3,clause4};

        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Account.getSObjectType())
            .addWhereCustom(clauses, '0 AND (1 OR (2 AND NOT 3))');

        String expectedClause = 'Name = \'John Smith\' AND (Phone = \'99999999\' OR (Name = \'William Clover\' AND NOT Phone = \'3939393939\'))';

        Assert.areEqual(expectedClause, builder.getWhereClause(), 'Should match the where clause');
    }

    @IsTest
    static void shouldGetOrder(){
        QueryBuilder builder1 = new QueryBuilder()
            .orderBy(new List<Schema.SObjectField>{
                Account.Name,Account.Phone
            }, OrderByType.types.ASCENDING_NULLS_FIRST);
        QueryBuilder builder2 = new QueryBuilder()
            .orderBy(new List<Schema.SObjectField>{
                Account.Name,Account.Phone
            }, OrderByType.types.ASCENDING_NULLS_LAST);
        QueryBuilder builder3 = new QueryBuilder()
            .orderBy(new List<Schema.SObjectField>{
                Account.Name,Account.Phone
            }, OrderByType.types.DESCENDING_NULLS_FIRST);
        QueryBuilder builder4 = new QueryBuilder()
            .orderBy(new List<Schema.SObjectField>{
                Account.Name,Account.Phone
            }, OrderByType.types.DESCENDING_NULLS_LAST);

        String order1 = builder1.getOrder();
        String order2 = builder2.getOrder();
        String order3 = builder3.getOrder();
        String order4 = builder4.getOrder();

        Assert.isTrue(order1.contains('ASC'), 'Should contain order by clause');
        Assert.isTrue(order2.contains('ASC NULLS LAST'), 'Should contain order by clause');
        Assert.isTrue(order3.contains('DESC'), 'Should contain order by clause');
        Assert.isTrue(order4.contains('DESC NULLS LAST'), 'Should contain order by clause');
    }

    @IsTest
    static void shouldGetGroups(){
        QueryBuilder builder = new QueryBuilder()
            .groupBy(Account.Name)
            .groupBy(Account.Phone);
        
        String fieldNames = builder.getGroups();

        Assert.isNotNull(fieldNames, 'Should return fieldNames');
        Assert.isTrue(fieldNames.contains(Account.Name.getDescribe().getName()), 'Should contain field name');
        Assert.isTrue(fieldNames.contains(Account.Phone.getDescribe().getName()), 'Should contain field name');
    }

    @IsTest
    static void shouldBuildQuery(){
        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Opportunity.getSObjectType())
            .addFields(new List<Schema.SObjectField>{
                Opportunity.Id,
                Opportunity.Name
            })
            .addFieldAggregator(Opportunity.Amount, AgreggatorType.types.COUNT)
            .groupBy(Opportunity.Id)
            .groupBy(Opportunity.Name)
            .addWhere(new QueryBuilderClause()
                .field(Opportunity.StageName)
                .isEqual('Closed Won'))
            .orderBy(new List<Schema.SObjectField>{Opportunity.Name}, OrderByType.types.ASCENDING_NULLS_LAST)
            .limitBy(10);

        String expectedQuery = 'SELECT Id,Name,COUNT(Amount) FROM Opportunity WHERE StageName = \'Closed Won\' GROUP BY Id,Name ORDER BY Name ASC NULLS LAST LIMIT 10';

        String resultQuery = builder.build();

        Assert.areEqual(expectedQuery, resultQuery, 'Should return the specified');
    }

    @IsTest
    static void shouldBuildSubquery(){
        QueryBuilder builder = new QueryBuilder()
            .selectFrom(Opportunity.getSObjectType())
            .addFields(new List<Schema.SObjectField>{
                Opportunity.Id,
                Opportunity.Name
            })
            .addFieldAggregator(Opportunity.Amount, AgreggatorType.types.COUNT)
            .groupBy(Opportunity.Id)
            .groupBy(Opportunity.Name)
            .addWhere(new QueryBuilderClause()
                .field(Opportunity.StageName)
                .isEqual('Closed Won'))
            .orderBy(new List<Schema.SObjectField>{Opportunity.Name}, OrderByType.types.ASCENDING_NULLS_LAST)
            .limitBy(10);
            
        
        List<Schema.ChildRelationship> relations = Account.getSObjectType().getDescribe().getChildRelationships();
        
        Schema.ChildRelationship opportunityRelationShip = null;
        
        for(Schema.ChildRelationship childRelation : relations){
            if(childRelation.getChildSObject().getDescribe().getName() == Opportunity.getSObjectType().getDescribe().getName()){
                opportunityRelationShip = childRelation;
                break;
            }
        }

        builder.relatedFromObject = opportunityRelationShip;

        String expectedQuery = 'SELECT Id,Name,COUNT(Amount) FROM '+opportunityRelationShip.getRelationshipName()+' WHERE StageName = \'Closed Won\' GROUP BY Id,Name ORDER BY Name ASC NULLS LAST LIMIT 10';

        String resultQuery = builder.buildSubquery();

        Assert.areEqual(expectedQuery, resultQuery, 'Should return the specified');
    }

    @IsTest
    static void shouldBuildSubQueries(){
        QueryBuilder builder = new QueryBuilder()
        .selectFrom(Account.getSObjectType())
        .addFields(
            new List<Schema.SObjectField>{
                Account.Id,
                Account.Name
            }
        )
        .addSubquery(
            Opportunity.getSObjectType(),
            new QueryBuilder()
            .selectFrom(Opportunity.getSObjectType())
            .addFields(
                new List<Schema.SObjectField>{
                    Opportunity.Id,
                    Opportunity.Name
                }
            )
        )
        .addSubquery(
            Contact.getSObjectType(),
            new QueryBuilder()
            .selectFrom(Contact.getSObjectType())
            .addFields(
                new List<Schema.SObjectField>{
                    Contact.Id,
                    Contact.Name
                }
            )
        );

        String expectedQuery = ',(SELECT Id,Name FROM Opportunities),(SELECT Id,Name FROM Contacts)';

        Assert.areEqual(expectedQuery, builder.getSubqueries());
    }

    @IsTest
    static void shouldAddSubqueries(){
        QueryBuilder builder = new QueryBuilder()
        .selectFrom(Account.getSObjectType())
        .addFields(
            new List<Schema.SObjectField>{
                Account.Id,
                Account.Name
            }
        )
        .addSubquery(
            Opportunity.getSObjectType(),
            new QueryBuilder()
            .selectFrom(Opportunity.getSObjectType())
            .addFields(
                new List<Schema.SObjectField>{
                    Opportunity.Id,
                    Opportunity.Name
                }
            )
        )
        .addSubquery(
            Contact.getSObjectType(),
            new QueryBuilder()
            .selectFrom(Contact.getSObjectType())
            .addFields(
                new List<Schema.SObjectField>{
                    Contact.Id,
                    Contact.Name
                }
            )
        );

        Assert.isFalse(builder.subQueries.isEmpty(), 'Should add multiple subqueries');

        QueryBuilder builderDuplicate = new QueryBuilder()
        .selectFrom(Account.getSObjectType())
        .addFields(
            new List<Schema.SObjectField>{
                Account.Id,
                Account.Name
            }
        )
        .addSubquery(
            Opportunity.getSObjectType(),
            new QueryBuilder()
            .selectFrom(Opportunity.getSObjectType())
            .addFields(
                new List<Schema.SObjectField>{
                    Opportunity.Id,
                    Opportunity.Name
                }
            )
        );

        Exception duplicateException = null;

        try{
            builderDuplicate
            .addSubquery(
                Opportunity.getSObjectType(),
                new QueryBuilder()
                .selectFrom(Opportunity.getSObjectType())
                .addFields(
                    new List<Schema.SObjectField>{
                        Opportunity.Id,
                        Opportunity.Name
                    }
                )
            );
        }catch(Exception ex){
            duplicateException = ex;
        }

        String expectedDuplicateMessage = 'Duplicate subquery for object: '+Opportunity.getSObjectType().getDescribe().getName();

        Assert.isNotNull(duplicateException, 'Should catch exception');
        Assert.areEqual(expectedDuplicateMessage, duplicateException.getMessage(), 'Should match the exception message');

        QueryBuilder builderInvalid = new QueryBuilder()
        .selectFrom(Account.getSObjectType())
        .addFields(
            new List<Schema.SObjectField>{
                Account.Id,
                Account.Name
            }
        );

        Exception invalidException = null;

        try{
            builderInvalid
            .addSubquery(
                Contact.getSObjectType(),
                new QueryBuilder()
                .selectFrom(Opportunity.getSObjectType())
                .addFields(
                    new List<Schema.SObjectField>{
                        Opportunity.Id,
                        Opportunity.Name
                    }
                )
            );
        }catch(Exception ex){
            invalidException = ex;
        }

        String expectedInvalidMessage = 'Invalid subquery: the object to make the subquery must match the related object. Expected: ' +
        Contact.getSObjectType().getDescribe().getName() +
        ' Actual: ' + Opportunity.getSObjectType().getDescribe().getName();

        Assert.isNotNull(invalidException, 'Should catch exception');
        Assert.areEqual(expectedInvalidMessage, invalidException.getMessage(), 'Should match the exception message');

        QueryBuilder builderNoRelation = new QueryBuilder()
        .selectFrom(Account.getSObjectType())
        .addFields(
            new List<Schema.SObjectField>{
                Account.Id,
                Account.Name
            }
        );

        Exception noRelationException = null;
            
        try{
            builderNoRelation
            .addSubquery(
                AssetAction.getSObjectType(),
                new QueryBuilder()
                .selectFrom(AssetAction.getSObjectType())
                .addFields(
                    new List<Schema.SObjectField>{
                        AssetAction.Id
                    }
                )
            );
        }catch(Exception ex){
            noRelationException = ex;
        }

        String expectedNoRelationMessage = 'Invalid subquery for related object ' + AssetAction.getSObjectType().getDescribe().getName();

        Assert.isNotNull(noRelationException, 'Should catch exception');
        Assert.areEqual(expectedNoRelationMessage, noRelationException.getMessage(), 'Should match the exception message');
    }
}