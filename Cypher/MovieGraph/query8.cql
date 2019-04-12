MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->(movie)
WHERE film.title = "Cloud Atlas"
RETURN dir