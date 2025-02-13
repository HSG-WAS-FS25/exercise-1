// leader agent

/*
 * Based on implementation developed by Joao Leite which extends the work of
 * Rafael Bordini, Jomi Hubner and Maicon Zatelli
 */

/* Initial beliefs */
depot(0,0). // the agent believes that the depot is located at (0,0)

/* Initial goals */
!start. // the agent has an initial goal to start

/*
* Plan for reacting to the creation of goal !start
* The plan is required for starting to manage the depot
* Triggering event: creation of goal !start
* Context: true (the plan is always applicable)
* Body: creates the goal to manage the depot
*/
@start_plan
+!start
   :  true
   <- !manage_depot; // creation of goal !manage_depot
   .

/********* START OF YOUR IMPLEMENTATION FOR TASKS 5 & 6 *********/
/*
* Plan for reacting to the creation of goal !manage_depot
* The plan is required for managing the depot
* Triggering event: creation of goal !manage_depot
* Context: the agent has a belief about the size of the map
* Body: 1) computes a random location (X,Y), 2) moves the depot to (X,Y),
* 3) informs the miner, and 4) creates the goal to manage the depot again
*/
@manage_depot_plan
+!manage_depot
   :  map_size(W,H)
   <- .wait(10000); // waits 10000ms
      jia.random(X,W) ; // action that unifies X with a random number in [0, W]
      jia.random(Y,H) ; // action that unifies Y with a random number in [0, H]
      move_depot(X,Y); // action that moves the depot at (X,Y)
      -+depot(X,Y); // deletes the old belief depot(_,_) and adds a new belief depot(X,Y) 
      !manage_depot; // creates goal !manage_depot
   .
/********* START OF YOUR IMPLEMENTATION FOR TASKS 5 & 6 *********/

/*
* Plan for reacting to the creation of goal !manage_depot
* The plan is required for managing the depot in case the agent does not have a belief about the size of the map
* Triggering event: creation of goal !manage_depot
* Context: true (the plan is always applicable)
* Body: waits and creates the goal to manage the depot
*/
@manage_depot_unkown_map_plan
+!manage_depot
   :  true
   <- .wait(100); // waits 100ms
      !manage_depot; // creates goal !manage_depot
   .

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }