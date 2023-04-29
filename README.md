# QueryBuilder API

This is a collection of helper classes that allows developers to create dynamic SOQL queries.

## Here's a sneak peak

The Querybuilder API makes an Apex dynamic SOQL that looks like this:

![soql-string](/docs/soql-string.png)

Into something like this:

![soql-querybuilder](/docs/soql-querybuilder.png)

## Some key benefits

* Ensures field and object accessibility when creating the string output
* Translates the math symbols and logical operators into methods
* Fully chainable operations that mounts the query piece by piece
* Customizable WHERE operation that works like custom formulas in SF 

## A lot more to improve

This first version of QueryBuilder API comes with experimental features and some unstable behaviors, but fixes and more features are coming in the near future.

## Project timeline

- First release
    - Initial commit of QueryBuilder API
    - April '23 UPDATE: Introducing subquery support
        Now it's possible to add subqueries to an QueryBuilder instance. the method 'addSubquery' that was previously not implemented is fully functional.
        **Here's an example of how to use it**:
        
        ![soql-querybuilder-subquery](/docs/soql-querybuilder-subquery.png)
        
        Check out the QueryBuilder class documentation to learn more about this feature.
