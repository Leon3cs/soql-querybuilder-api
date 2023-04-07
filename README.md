# QueryBuilder API

This is a collection of helper classes that allows developers to create dynamic SOQL queries.

## Here's a sneak peak

The Querybuilder API makes an Apex dynamic SOQL like this:

![soql-string](/images/soql-string.png)

Into something like this:

![soql-querybuilder](/images/soql-querybuilder.png)

## Some key benefits

* Ensures field and object accessibility when creating the string output
* Translates the math symbols and logical operators into methods
* Fully chainable operations that mounts the query piece by piece
* Customizable WHERE operation that works like custom formulas in SF 

## A lot more to improve

This first version of QueryBuilder API comes with experimental features and some unstable behaviors, but fixes and more features are coming in the near future.

## Project timeline

- First release
    Initial commit of QueryBuilder API