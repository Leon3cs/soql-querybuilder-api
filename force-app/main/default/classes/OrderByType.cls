/**
 * @author Rafael Araújo (leon3cs)
 * @date 2023
 * 
 * @group Enums
 * 
 * @description Types of possible ordering to be used in QueryBuilder
 * The available Order operations are:
 * ASCENDING_NULLS_LAST: appends to orderBy the ASC NULLS LAST clause
 * ASCENDING_NULLS_FIRST: appends to orderBy the ASC clause
 * DESCENDING_NULLS_LAST: appends to orderBy the DESC NULLS LAST clause
 * DESCENDING_NULLS_FIRST: appends to orderBy the DESC clause
 */
public class OrderByType {
    public enum types {
        ASCENDING_NULLS_LAST,
        ASCENDING_NULLS_FIRST,
        DESCENDING_NULLS_LAST,
        DESCENDING_NULLS_FIRST
    }
} 