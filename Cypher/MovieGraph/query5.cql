MATCH (tom:Person)-[:ACTED_IN]->(movie)<-[:DIRECTED]-(dir)
WHERE tom.name = "Tom Hanks"
RETURN tom,movie,dir