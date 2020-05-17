:history

LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/order-details.csv" AS row
MATCH (p:Product), (o:Order)
WHERE p.productID = row.productID AND o.orderID = row.orderID
CREATE (o)-[details:ORDERS]->(p)
SET details = row,
details.quantity = toInteger(row.quantity);

MATCH (c:Customer),(o:Order)
WHERE c.customerID = o.customerID
CREATE (c)-[:PURCHASED]->(o);

CREATE INDEX ON :Order(orderID);

CREATE INDEX ON :Customer(customerID);

LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/orders.csv" AS row
CREATE (n:Order)
SET n = row;

LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/customers.csv" AS row
CREATE (n:Customer)
SET n = row;

MATCH (p:Product),(s:Supplier)
WHERE p.supplierID = s.supplierID
CREATE (s)-[:SUPPLIES]->(p);

MATCH (p:Product),(c:Category)
WHERE p.categoryID = c.categoryID
CREATE (p)-[:PART_OF]->(c);

CREATE INDEX ON :Supplier(supplierID);

CREATE INDEX ON :Category(categoryID);

CREATE INDEX ON :Product(productID);

LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/suppliers.csv" AS row
CREATE (n:Supplier)
SET n = row;

LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/categories.csv" AS row
CREATE (n:Category)
SET n = row;

LOAD CSV WITH HEADERS FROM "http://data.neo4j.com/northwind/products.csv" AS row
CREATE (n:Product)
SET n = row,
n.unitPrice = toFloat(row.unitPrice),
n.unitsInStock = toInteger(row.unitsInStock), n.unitsOnOrder = toInteger(row.unitsOnOrder),
n.reorderLevel = toInteger(row.reorderLevel), n.discontinued = (row.discontinued <> "0");

:use northwind

create database northwind;

:use system

:play northwind graph

unwind range(1,50000) as id create (:Person {id:id, name:"Andreas "+id, age:id %100});

unwind range(1,50000) as id call apoc.merge.node(["Foo"],{id:id}) yield node return count(*);

create constraint on (f:Foo) assert f.id is unique;
explain unwind range(1,50000) as id call apoc.merge.node(["Foo"],{id:id}) yield node return count(*);

CALL db.stats.retrieve('GRAPH COUNTS') yield data
unwind data.relationships as r
with r where r.relationshipType = $type and (exists(r.startLabel) or exists (r.endLabel))
return r;

CALL db.stats.retrieve('GRAPH COUNTS') yield data
unwind data.relationships as r
with r where r.relationshipType = $type 
return r;

:param type => "KNOWS"

CALL db.stats.retrieve('GRAPH COUNTS') yield data
unwind data.relationships as r
with r where r.relationshipType = $type 
return r;

CALL db.stats.retrieve('GRAPH COUNTS');

CALL db.stats.retrieve(‘GRAPH COUNTS’);

CALL db.index.fulltext.queryRelationships('KNOWS','context:(id1 id2 id3)') 
YIELD relationship as r RETURN r limit $limit;

:param limit => 12