MATCH 
    (ann:Person {name: "Ann"})-[:DRIVES]-(car:Car)
RETURN
    car