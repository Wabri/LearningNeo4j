MATCH (s:Supplier)-[*]->(c:Category)
RETURN 
    s.companyName as Company,
    collect(distinct c.categoryName) as Categories
ORDER BY Company DESC
