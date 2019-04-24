MATCH (bacon:Person {name: "Kevin Bacon"})-[*1..4]-(person)
RETURN DISTINCT person