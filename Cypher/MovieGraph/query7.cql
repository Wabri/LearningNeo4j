MATCH (dir:Person)-[:DIRECTED]->(movie)
WHERE movie.title = "Cloud Atlas"
RETURN dir