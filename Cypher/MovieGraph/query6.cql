MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->(movie)
RETURN tom,movie