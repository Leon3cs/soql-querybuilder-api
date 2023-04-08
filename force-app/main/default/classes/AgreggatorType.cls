/**
 * @author Rafael Araújo (leon3cs)
 * @date 2023
 * 
 * @group Enums
 * 
 * @description Types of possible aggregator functions to be used in QueryBuilder
 * The available aggregation functions are:
 * AVG
 * COUNT
 * COUNT_DISTINCT
 * MIN
 * MAX
 * SUM
 */
public class AgreggatorType {
    public enum types {
        AVG,
        COUNT,
        COUNT_DISTINCT,
        MIN,
        MAX,
        SUM 
    }
}