# LearningDataAnalysis

## Summary

1. [Graph Fundamentals](#graph-fundamentals)
2. [Neo4J](#neo4j)
    * [Query Language Cypher](#cypher)
    * [Application - Movie Graph](#application---movie-graph)
3. [References](#references)

## Graph Fundamentals

###### ***This notes below can be read on neo4J browser sandbox by type the command: :play concepts***

A graph database can store any kind of data using a few simple concepts:
1. **Nodes** - graph data records
2. **Relationships** - connect nodes
3. **Properties** - named data values

The simplest graph has just a single **node** with some named values called **Properties**:

![simpleGraph](resources/simpleGraph.PNG)

Nodes are the name for data records in a graph and the data is stored as Properties that can be simple name/value pairs.

Nodes can be grouped together by applying a Label to each member. In the example above we can set to that node the label **Person**.  Is important to know that a label is not a object and can't have any properties, is used only to categorize the nodes in a graph. A node can have zero or more labels based on the definition of that node.

To add more records we can simply add more nodes.

![moreNodes](/resources/moreNodes.PNG)

Similar nodes can have different properties with different type: string, number or even boolean.
The dimension of a graph like this can be infinite because there is no limit to the number of nodes that can be added.

One of the properties of a database is to connect data, in a graph database the link is made by **Relationships**. To associate two nodes we can add **Relationship** between them wich describe how the records are related.

![relationships](/resources/relationships.PNG)

A relationship are data records that need to have two properties: **direction** and **type**, and can also contains properties like nodes.

![relationshipProperties](/resources/relationshipProperties.PNG)

## Neo4J

### Cypher

###### ***This notes below can be read on neo4J browser sandbox by type the command: :play cypher***
###### ***All of the query are run in the [Neo4J browser sandbox](https://neo4j.com/sandbox-v2)***

Neo4J's Cypher language is purpose built for working with graph data. It uses patterns to describe graph data and is familiar to sql-like clauses, this language follow this rule: ***describing what to find and not how to find it***.

Let's create a small social graph using this query language.
To create a new data we use the **CREATE** clause:

```Cypher
CREATE (ee:Person {name: "Emil", from: "Sweden", klout:99})
```
***klout = influence based on the ability to drive action across the social web***

With this query we create a node **ee** of type Person that have 3 properties: name, from and klout.

The output of this query will be:
```
Added 1 label, created 1 node, set 3 properties, completed after 134 ms.
```

To find a node we can use the **MATCH** clause follow by a filters and conditions of nodes and relationships:
```Cypher
MATCH (ee:Person) WHERE ee.name = "Emil" RETURN ee;
```
Take the nodes label Person and return only the nodes that have a property name with the value **Emil**. To explain step by step:
- **MATCH** -> clause to specify a pattern of nodes and relationships
- **(ee:Person)** -> a single node pattern with label Person which will assign matches to the variable **ee**
- **WHERE** -> clause to filter the results
- **ee.name = "Emil"** -> compare name property to the value "Emil"
- **RETURN** -> clause used to request particular results

The output of this query can be different:
- by **graph**:

![matchEmilReturnG](/resources/matchEmilReturnG.PNG)
- by **table**:
```Json
{
    "name": "Emil",
    "from": "Sweden",
    "klout": 99
} 
```
- by **text**:
```
╒══════════════════════════════════════════╕
│"ee"                                      │
╞══════════════════════════════════════════╡
│{"name":"Emil","from":"Sweden","klout":99}│
└──────────────────────────────────────────┘ 
```

**Create** clauses can create many nodes and relationships at once:
```Cypher
MATCH (ee:Person) WHERE ee.name = "Emil"
CREATE 
(js:Person {name:"Johan", from:"Sweden", learn:"surfing"}),
(ir:Person {name:"Ian", from:"England", title:"author"}),
(rvb:Person {name:"Rik", from:"Belgium", pet:"Orval"}),
(ally:Person {name:"Allison", from: "California", hobby: "surfing" }),
(ee)-[:KNOWS {since: 2001}]->(js),
(ee)-[:KNOWS {rating:5}]->(ir),
(js)-[:KNOWS]->(ir), (js)-[:KNOWS]->(rvb),
(ir)-[:KNOWS]->(js), (ir)-[:KNOWS]->(ally),
(rvb)-[:KNOWS]->(ally)
```
If exits in the database a node with **name** property with value **Emil** then create 4 new nodes and 7 relationship between them.
The relationships are created by defined the left node and the right node:
```Cypher
(left_node)-[:NAME_OF_RELATIONSHIP {name_of_property: value_of_property}]->(right_node)
```
The output of the query above is:
```Text
Added 4 labels, created 4 nodes, set 14 properties, created 7 relationships, completed after 33 ms.
```

To see what we created we need to run a new query that take all of the nodes in relationship with **Emil**:
```Cypher
MATCH (ee:Person)-[:KNOWS]-(friends) 
WHERE ee.name="Emil"
RETURN ee.name, friends
```
Analyze this clause `MATCH (ee:Person)-[:KNOWS]-(friends)`, the meaning of `()-[:KNOWS]-()` is to maches **KNOWS** relationship in either direction and takes all nodes with label Person that have a relationship with other nodes.
The output will be all the relationships between node **ee** with property name set as Emil and nodes **friends**, the query graph result will be:

![matchEmilFriendsG](/resources/matchEmilFriendsG.PNG)

Pattern matching can be used to make recommendations, to suggest a new friend or a new film to watch. For example we can make recomandation to johan that is learning to surf, he may want to find a new frend who already does:
```Cypher
MATCH (js:Person)-[:KNOWS]-()-[:KNOWS]-(surfer)
WHERE js.name = "Johan" AND surfer.hobby = "surfing"
RETURN DISTINCT surfer
```
The clause **DISTINCT** is use to avoid an output of the same nodes because more than one Person can be friend to the same Person at the same time more than one nodes can be related to the same node.
The pattern put on the **MATCH** clause contains 2 relations and the nodes in the center `()` is not important in our recommendation so is ignored and not referred with a name.
This query return all of the Person who have the hobby "surfing" that are connected to a friend of a friend of Johan. In our database only one node correspond to this filter: "Allison".

![matchsurfingrecommendation](/resources/matchSurfingRecommendations.PNG)

To understand how the query works you can use the **EXPLAIN** or **PROFILE** clause put at the beginning of the query, like this:
```Cypher
PROFILE MATCH (js:Person)-[:KNOWS]-()-[:KNOWS]-(surfer)
WHERE js.name = "Johan" AND surfer.hobby = "surfing"
RETURN DISTINCT surfer
```
The outcome will be a cause effect of how the engine find the result.

### Application - Movie Graph

Let's create a more complex example with a mini application containing actors and directors that are related through the movies they've collaborated on.

We can create more than one nodes and relationships with a single block query statement composed of multiple **CREATE** clauses:
```Cypher
CREATE (TheMatrix:Movie {title:'The Matrix', released:1999, tagline:'Welcome to the Real World'})
CREATE (Keanu:Person {name:'Keanu Reeves', born:1964})
CREATE (Carrie:Person {name:'Carrie-Anne Moss', born:1967})
CREATE (Laurence:Person {name:'Laurence Fishburne', born:1961})
CREATE (Hugo:Person {name:'Hugo Weaving', born:1960})
CREATE (LillyW:Person {name:'Lilly Wachowski', born:1967})
CREATE (LanaW:Person {name:'Lana Wachowski', born:1965})
CREATE (JoelS:Person {name:'Joel Silver', born:1952})
CREATE
  (Keanu)-[:ACTED_IN {roles:['Neo']}]->(TheMatrix),
  (Carrie)-[:ACTED_IN {roles:['Trinity']}]->(TheMatrix),
  (Laurence)-[:ACTED_IN {roles:['Morpheus']}]->(TheMatrix),
  (Hugo)-[:ACTED_IN {roles:['Agent Smith']}]->(TheMatrix),
  (LillyW)-[:DIRECTED]->(TheMatrix),
  (LanaW)-[:DIRECTED]->(TheMatrix),
  (JoelS)-[:PRODUCED]->(TheMatrix)
```
***You can find all the query block here: [Cypher/MovieGraph/createGraph.cql](Cypher/MovieGraph/createGraph.cql)***

The script add lot of nodes with relative relationships and properties, with this we can test some query:
1. Find the actor named "TOM Hanks"
    ```Cypher
    MATCH (tom {name: "Tom Hanks"})
    RETURN tom
    ```
    or 
    ```Cypher
    MATCH (tom:Person)
    WHERE tom.name="Tom Hanks"
    RETURN tom
    ```
2. Find the movie with title "Cloud Atlas"
    ```Cypher
    MATCH (cloud:Movie)
    WHERE cloud.title="Cloud Atlas"
    RETURN cloud
    ```
    or
    ```Cypher
    MATCH (cloud:Movie {title: "Cloud Atlas"})
    RETURN cloud
    ```
3. Find 10 people
    ```Cypher
    MATCH (people:Person)
    RETURN people.name
    LIMIT 10
    ```
    The ***LIMIT*** clause is use to limitate the number of nodes in output.
3. Find movies released in the 1990s
    ```Cypher
    MATCH (movie:Movie)
    WHERE movie.released >= 1990 AND movie.released < 2000
    RETURN movie.title
    ```
3. Find the films where "Tom Hanks" acted and show the director of the film
    ```Cypher
    MATCH (tom:Person)-[:ACTED_IN]->(movie)<-[:DIRECTED]-(dir)
    WHERE tom.name = "Tom Hanks"
    RETURN tom,movie,dir
    ```
    graph result:

    ![Tom Hanks](/resources/movieGraphTomHanks.PNG)
3. List of Tom Hanks movies
    ```Cypher
    MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->(movie)
    RETURN tom,movie
    ```
    graph result:

    ![Tom Hanks Acted](/resources/movieGraphTomHanksActed.PNG)
3. Who directed "Cloud Atlas"
    ```Cypher
    MATCH (dir:Person)-[:DIRECTED]->(movie)
    WHERE movie.title = "Cloud Atlas"
    RETURN dir
    ```
3.  Tom Hanks co-actor (actor in the same film)
    ```Cypher
    MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->(movie)
    WHERE film.title = "Cloud Atlas"
    RETURN dir
    ```
3. How people are related to "Cloud Atlas"
    ```Cypher
    MATCH (people:Person)-[relatedTo]-(:Movie {title: "Cloud Atlas"})
    RETURN people.name,Type(relatedTo),relatedTo
    ```
    The *Type()* is use to get the type of nodes or relationships.

### References 
- [neo4j browser sandbox](https://neo4j.com/sandbox-v2)
    * :play concepts
    * :play intro
    * :play cypher
    * :play movie-graph
- [neo4j developer manual](https://neo4j.com/docs/developer-manual/3.2/)