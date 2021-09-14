module Operations exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import GraphQL.Operations.AST as AST
import GraphQL.Operations.Parse as Parse
import Test exposing (..)





suite : Test
suite =
    describe "Operational GQL"
        [ test "Parse a query" <|
            \_ ->
                let
                    parsed =
                        Parse.parse queries.simple
                            
                in
                Expect.true
                    "Expected the simple query to parse"
                    (case parsed of
                        Ok _ ->
                            True
                        Err _ ->
                            False

                    )
        ,  test "Parse the blissfully dashboard query" <|
                \_ ->
                    let
                        parsed =
                            Parse.parse queries.dashboard
                                |> Debug.log "DASH"
                                
                    in
                    Expect.true
                        "Expected the blissfully dashboard to parse"
                        (case parsed of
                            Ok _ ->
                                True
                            Err _ ->
                                False

                        )
        ]



queries =
    { simple =
        """query {
  organization {
    isActive
    domain
    teams {
      name
    }
  }
}

        """
    , dashboard = """query Dashboard($filter:PersonAppRelationshipFilter, $filter1:PersonAppRelationshipFilter, $filter10:TicketFilter, $filter11:TicketFilter, $filter12:WorkflowFilter, $filter13:WorkflowFilter, $filter14:WorkflowFilter, $filter15:WorkflowFilter, $filter16:PeopleFilter, $filter2:AuditLogEventsFilter, $filter3:ServiceEntityRelationshipFilter, $filter4:ServiceEntityRelationshipFilter, $filter5:ServiceEntityRelationshipFilter, $filter6:AuditLogEventsFilter, $filter7:AuditLogEventsFilter, $filter8:TransactionFilter, $filter9:TransactionFilter, $first:Int, $first1:Int, $first2:Int, $first3:Int, $first4:Int, $orderBy:EntityPropertySortInput, $orderBy1:EntityPropertySortInput, $orderBy2:EntityPropertySortInput, $orderBy3:EntityPropertySortInput){personAppRelationships(filter: $filter){totalEdges}
personAppRelationships1:personAppRelationships(filter: $filter1){totalEdges}
auditLogEvents(first: $first, filter: $filter2){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{details{__typename
... on EventAppAccessRevokedDetected{__typename}
... on EventAppAccessAffirmedDetected{__typename}
... on EventPersonWorkflowCreated{__typename}
... on EventPersonTeamRemoved{__typename}
... on EventPersonTeamCreated{__typename}
... on EventDevicePersonRemoved{__typename}
... on EventDevicePersonCreated{__typename}
... on EventAppTeamRemoved{__typename}
... on EventAppTeamCreated{__typename}
... on EventAppPersonRemoved{__typename}
... on EventAppPersonCreated{__typename}
... on EventTeamRemoved{__typename}
... on EventTeamPropertyUpdated{__typename}
... on EventTeamCreated{__typename}
... on EventPersonRemoved{__typename}
... on EventPersonPropertyUpdated{__typename}
... on EventPersonCreated{__typename}
... on EventDeviceRemoved{__typename}
... on EventDevicePropertyUpdated{__typename}
... on EventDeviceCreated{__typename}
... on EventAppRoleUnassigned{__typename}
... on EventAppRoleReassigned{__typename}
... on EventAppRoleAssigned{__typename}
... on EventAppRoleRemoved{__typename}
... on EventAppRoleUpdated{__typename}
... on EventAppRoleCreated{__typename}
... on EventAppRenewalDateUpdated{__typename}
... on EventAppSubscriptionDetected{__typename}
... on EventAppSubscriptionRemoved{__typename}
... on EventAppSubscriptionCreated{__typename}
... on EventAppRelationshipDetected{app{id}
sources}
... on EventAppLicenseDetected{__typename}
... on EventAppLicenseUnassigned{__typename}
... on EventAppLicenseAssigned{__typename}
... on EventAppLicenseUpdated{__typename}
... on EventAppLicenseRemoved{__typename}
... on EventAppLicenseCreated{__typename}
... on EventAppFileRemoved{__typename}
... on EventAppFileUploaded{__typename}
... on EventAppRemoved{__typename}
... on EventAppPropertyUpdated{__typename}
... on EventAppCreated{__typename}}
createdAt
id}}}
serviceEntityRelationships2(first: $first1, orderBy: $orderBy, filter: $filter3){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{serviceEntity{categories}
directlyAttributableLastMonthSpend
serviceEntity1:serviceEntity{slug
logo
name
id}}}}
workflowPlans{__typename
... on PermissionDeniedError{__typename}
... on WorkflowPlansSuccess{plans{type
id}}}
serviceEntityRelationships21:serviceEntityRelationships2(first: $first2, orderBy: $orderBy1, filter: $filter4){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{last12MonthSpend
renewalOptions{renewalDate}
serviceEntity{slug
logo
name
id}}}}
teams(first: $first3, orderBy: $orderBy2){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{spendOverTime{amount
from}
averageSpendPerMemberLastMonth
id
name}}}
serviceEntityRelationships22:serviceEntityRelationships2(first: $first4, orderBy: $orderBy3, filter: $filter5){totalEdges
pageInfo{endCursor
startCursor
hasNextPage
hasPreviousPage}
edges{node{directlyAttributableLastMonthSpend
serviceEntity{slug
logo
name
id}}}}
auditLogEvents1:auditLogEvents(filter: $filter6){totalEdges}
auditLogEvents2:auditLogEvents(filter: $filter7){totalEdges}
transactions(filter: $filter8){totalEdges}
transactions1:transactions(filter: $filter9){totalEdges}
organization{spendDelta
lastMonthSpend
aggregateSpendOverTimeReports{amount
from}}
tickets(filter: $filter10){totalEdges}
tickets1:tickets(filter: $filter11){totalEdges}
workflows2(filter: $filter12){totalEdges}
workflows21:workflows2(filter: $filter13){totalEdges}
workflows22:workflows2(filter: $filter14){totalEdges}
workflows23:workflows2(filter: $filter15){totalEdges}
devices{totalEdges}
teams1:teams{totalEdges}
persons(filter: $filter16){totalEdges}
serviceEntityRelationships23:serviceEntityRelationships2{totalEdges}}"""
    }