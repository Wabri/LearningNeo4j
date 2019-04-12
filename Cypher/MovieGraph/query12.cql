MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->()<-[:ACTED_IN]-(coactor:Person),
    (coactor)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoactor:Person)
WHERE NOT (tom)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoactor) AND tom <> cocoactor
RETURN cocoactor.name AS Racommended, count(*) AS Strength ORDER BY Strength DESC