# examples/playground

```graphql
# OPERATIONS

type Query {
  app(id: ID!): App
  person(id: ID!): Person
}

type Mutation {
  personCreate(input: PersonCreateInput!): PersonCreateResult!
  personUpdate(input: PersonUpdateInput!): PersonUpdateResult!
}

# OBJECTS

type App {
  id: ID!
  slug: String!
  name: String!
}

type Person {
  id: ID!
  name: Name!
  role: Role!
  email: String
  friends(limit: Int): [Person!]!
}

type Name {
  first: String!
  middle: String
  last: String!
}

type NameAlreadyExistsError implements Error {
  message: String!
}

type NotFoundError implements Error {
  id: ID!
  message: String!
}

# ENUMS

enum Role {
  ADMIN
  GUEST
}

# SCALARS

scalar Timestamp

# INTERFACES

interface Error {
  message: String!
}

# UNIONS

union PersonCreateResult = Person | NameAlreadyExistsError

union PersonUpdateResult = Person | NotFoundError

# INPUTS

input PersonCreateInput {
  name: String!
  email: String
}

input PersonUpdateInput {
  id: ID!
  name: SetRequiredString
  email: SetOptionalString
}

input SetRequiredString {
  value: String!
}

input SetOptionalString {
  value: String
}
```