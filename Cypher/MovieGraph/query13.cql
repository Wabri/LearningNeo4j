MATCH (tomh:Person {name: "Tom Hanks"})-[]->(movie)<-[]-(someone:Person),
    (someone)-[]->(movie2)<-[]-(tomc:Person {name: "Tom Cruise"})
RETURN tomh,movie, someone,movie2, tomc