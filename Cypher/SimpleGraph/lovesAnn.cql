MATCH 
    (ann:Person {name: "Ann"})<-[:LOVES]-(op)
RETURN
    op