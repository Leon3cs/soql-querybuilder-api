/**
 * @author Rafael Araújo (leon3cs)
 * @date 2023
 * 
 * @group Enums
 * 
 * @description Types of possible like expressions to be used in QueryBuilderClause
 * The available LIKE operations are:
 * STARTS_WITH: matches values starting with the sequence (LIKE ...%)
 * ENDS_WITH: matches values ending with the sequence (LIKE %...)
 * EQUALS: mateches values that are exact match or match part of the sequence (LIKE %...%)
 */
public class LikeType {
	public enum types {
		STARTS_WITH,
		ENDS_WITH,
		EQUALS
	}
}