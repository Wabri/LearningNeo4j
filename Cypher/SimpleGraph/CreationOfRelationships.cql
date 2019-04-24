MATCH 
    (dan:Person {name: "Dan"}),
    (ann:Person {name: "Ann"}),
    (car:Car {model:"V70"})
CREATE 
    (dan)-[:LOVES]->(ann), 
    (ann)-[:LOVES]->(dan),
    (ann)-[:LIVES_WITH]->(dan),
    (dan)-[:OWNS]->(car),
    (dan)-[:DRIVES]->(car),
    (ann)-[:DRIVES]->(car)