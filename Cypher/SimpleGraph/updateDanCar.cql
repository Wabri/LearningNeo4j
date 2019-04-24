MATCH 
    (ann:Person {name: "Dan"})-[:OWNS]-(car:Car)
WHERE 
    car.brand="Volvo"
SET
    car.wheels=4
RETURN
    car.wheels