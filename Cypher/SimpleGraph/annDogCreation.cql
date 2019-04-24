MERGE (a:Person {name:"Ann"})
ON CREATE SET
    a.facebook = "@annie"
MERGE (a)-[:HAS_PET]->(:Dog {name:"Sam"})