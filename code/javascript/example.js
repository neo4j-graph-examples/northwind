// npm install --save neo4j-driver
// node example.js
const neo4j = require('neo4j-driver');
const driver = neo4j.driver('bolt://<HOST>:<BOLTPORT>', 
                  neo4j.auth.basic('<USERNAME>', '<PASSWORD>'), 
                  {/* encrypted: 'ENCRYPTION_OFF' */});

const query =
  `
  MATCH (p:Product)-[:PART_OF]->(:Category)-[:PARENT*0..]-> 
  (:Category {categoryName:$category}) 
  RETURN p.productName as product 
  `;

const params = {"category": "Dairy Products"};

const session = driver.session({database:"neo4j"});

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
