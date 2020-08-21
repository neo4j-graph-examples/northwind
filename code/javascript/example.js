// npm install --save neo4j-driver
// node example.js
var neo4j = require('neo4j-driver');
var driver = neo4j.driver('bolt://<HOST>:<BOLTPORT>', 
                  neo4j.auth.basic('<USERNAME>', '<PASSWORD>'), 
                  {/* encrypted: 'ENCRYPTION_OFF' */});

var query = 
  `
  MATCH (p:Product)-[:PART_OF]->(:Category)-[:PARENT*0..]-> 
  (:Category {categoryName:$category}) 
  RETURN p.productName as product 
  `;

var params = {"category": "Dairy Products"};

var session = driver.session({database:"neo4j"});

session.run(query, params)
  .then(function(result) {
    result.records.forEach(function(record) {
        console.log(record.get('product'));
    })
	session.close();
    driver.close();
  })
  .catch(function(error) {
    console.log(error);
  });
