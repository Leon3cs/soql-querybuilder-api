@IsTest
public class QueryBuilderClauseTest {

    @IsTest
    static void shouldInitializeClause(){
        QueryBuilderClause builder = new QueryBuilderClause();
        
        Assert.isNotNull(builder.clause, 'it should be initialized by constructor');
        Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');
        Assert.isTrue(String.isEmpty(builder.clause) == true, 'it should be empty');
    }
    
    @IsTest
    static void shouldPopulateField(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.Name);
        
        Assert.isNotNull(builder.field, 'it should initialize field property');
        Assert.isInstanceOfType(builder.field, Schema.SOBjectField.class, 'it should be a Schema.SObjectField');
    }
    
    @IsTest
    static void shouldPopulateFieldType(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.Name);
        
        Assert.isNotNull(builder.fieldType, 'it should initialize field property');
        Assert.isInstanceOfType(builder.fieldType, Schema.DisplayType.class, 'it should be a Schema.DisplayType');
        Assert.areEqual(Account.Name.getDescribe().getType(), builder.fieldType, 'it should match the Account.Name DisplayType');
    }
    
    @IsTest
    static void shouldParseNumberValueAccordingly(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.AnnualRevenue);

        String num = String.valueOf(1000);
        String parsedNumber = builder.getParsedValue(1000);
        
        Assert.areEqual(num, parsedNumber, 'it should generate the same output');
        Assert.isFalse(parsedNumber.contains('\''), 'it should not contain single quotes');
    }

    @IsTest
    static void shouldParseStringValueAccordingly(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.Name);

        String name = 'Test';
        String parsedName = builder.getParsedValue('Test');

        Assert.areNotEqual(name, parsedName, 'it should generate different output');
        Assert.isTrue(parsedName.contains(name), 'it should have the same text');
        Assert.isTrue(parsedName.contains('\''), 'it should contain single quotes');
    }

    @IsTest
    static void shouldGerenateIsEqualExpression(){
        String testData = 'John Smith';
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual(testData);

        Assert.isNotNull(builder.clause, 'it should generate a clause');
        Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');

        String expression = Account.Name.getDescribe().getName() + ' = \'' + testData + '\'';

        Assert.areEqual(expression, builder.clause, 'it should match the expression of equal');
    }

    @IsTest
    static void shouldGerenateIsNotEqualExpression(){
        String testData = 'John Smith';
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.Name)
            .isNotEqual(testData);

        Assert.isNotNull(builder.clause, 'it should generate a clause');
        Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');

        String expression = Account.Name.getDescribe().getName() + ' != \'' + testData + '\'';

        Assert.areEqual(expression, builder.clause, 'it should match the expression of not equal');
    }

    @IsTest
    static void shouldGenerateIsLessThanExpression(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Opportunity.Amount)
            .isLessThan(1000);

            Assert.isNotNull(builder.clause, 'it should generate a clause');
            Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');

            String expression = Opportunity.Amount.getDescribe().getName() + ' < ' + '1000';

            Assert.areEqual(expression, builder.clause, 'it should match the expression of less than');
    }

    @IsTest
    static void shouldGenerateIsLessThanOrEqualExpression(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Opportunity.Amount)
            .isLessOrEqual(1000);

            Assert.isNotNull(builder.clause, 'it should generate a clause');
            Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');

            String expression = Opportunity.Amount.getDescribe().getName() + ' <= ' + '1000';

            Assert.areEqual(expression, builder.clause, 'it should match the expression of less than or equal');
    }

    @IsTest
    static void shouldGenerateIsGreaterThanExpression(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Opportunity.Amount)
            .isGreaterThan(1000);

            Assert.isNotNull(builder.clause, 'it should generate a clause');
            Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');

            String expression = Opportunity.Amount.getDescribe().getName() + ' > ' + '1000';

            Assert.areEqual(expression, builder.clause, 'it should match the expression of greater than');
    }

    @IsTest
    static void shouldGenerateIsGreaterOrEqualExpression(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Opportunity.Amount)
            .isGreaterOrEqual(1000);

            Assert.isNotNull(builder.clause, 'it should generate a clause');
            Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');

            String expression = Opportunity.Amount.getDescribe().getName() + ' >= ' + '1000';

            Assert.areEqual(expression, builder.clause, 'it should match the expression of greater or equal');
    }

    @IsTest
    static void shouldGenerateIsLikeExpression(){
        QueryBuilderClause builderStart = new QueryBuilderClause()
            .field(Account.Name)
            .isLike(LikeType.STARTS_WITH, 'Smith');

        Assert.isNotNull(builderStart.clause, 'it should generate a clause');
        Assert.isInstanceOfType(builderStart.clause, String.class, 'it should be a String');

        String expressionStart = Account.Name.getDescribe().getName() + ' LIKE \'Smith%\'';

        Assert.areEqual(expressionStart, builderStart.clause, 'it should match the expression of like starting with the sentence');

        QueryBuilderClause builderEnd = new QueryBuilderClause()
            .field(Account.Name)
            .isLike(LikeType.ENDS_WITH, 'Smith');

        Assert.isNotNull(builderEnd.clause, 'it should generate a clause');
        Assert.isInstanceOfType(builderEnd.clause, String.class, 'it should be a String');

        String expressionEnd = Account.Name.getDescribe().getName() + ' LIKE \'%Smith\'';

        Assert.areEqual(expressionEnd, builderEnd.clause, 'it should match the expression of like end with the sentence');    
        
        QueryBuilderClause builderEquals = new QueryBuilderClause()
            .field(Account.Name)
            .isLike(LikeType.EQUALS, 'Smith');

        Assert.isNotNull(builderEquals.clause, 'it should generate a clause');
        Assert.isInstanceOfType(builderEquals.clause, String.class, 'it should be a String');

        String expressionEquals = Account.Name.getDescribe().getName() + ' LIKE \'%Smith%\'';

        Assert.areEqual(expressionEquals, builderEquals.clause, 'it should match the expression of like that is equal to the sentence');    
    }

    @IsTest
    static void shouldGenerateIsInExpression(){
        List<String> names = new List<String>{'John', 'David', 'Michael'};
        List<String> expectedNames = new List<String>{'\'John\'', '\'David\'', '\'Michael\''};

        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.Name)
            .isIn(names);

        
        Assert.isNotNull(builder.clause, 'it should generate a clause');
        Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');

        String expressionEquals = Account.Name.getDescribe().getName() + ' IN ' + expectedNames.toString();

        Assert.areEqual(expressionEquals, builder.clause, 'it should match the expression of like that is equal to the sentence');   
        
    }

    @IsTest
    static void shouldGenerateIsNotInExpression(){
        List<String> names = new List<String>{'John', 'David', 'Michael'};
        List<String> expectedNames = new List<String>{'\'John\'', '\'David\'', '\'Michael\''};

        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.Name)
            .isNotIn(names);

        
        Assert.isNotNull(builder.clause, 'it should generate a clause');
        Assert.isInstanceOfType(builder.clause, String.class, 'it should be a String');

        String expressionEquals = Account.Name.getDescribe().getName() + ' NOT IN ' + expectedNames.toString();

        Assert.areEqual(expressionEquals, builder.clause, 'it should match the expression of like that is equal to the sentence');   
        
    }

    @IsTest
    static void shouldReturnClauseAsString(){
        QueryBuilderClause builder = new QueryBuilderClause()
            .field(Account.Name)
            .isEqual('John Smith');

        String expectedClause = Account.Name.getDescribe().getName() + ' = \'John Smith\'';

        Assert.isInstanceOfType(builder.getClause(), String.class, 'it should return a String');
        Assert.isFalse(String.isBlank(builder.getClause()), 'it should not be empty');
        Assert.areEqual(expectedClause, builder.getClause(), 'it should match the expression');
    }
}