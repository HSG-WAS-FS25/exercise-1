// miner agent

/*
 * Based on implementation developed by Joao Leite which extends the work of
 * Rafael Bordini, Jomi Hubner and Maicon Zatelli
 */

/* Initial beliefs */
ready_to_explore. // the agent believes that it is ready to explore the woods for gold
depot(0,0). // the agent believes that the depot is located at (0,0)

/* Initial goals */
!start. // the agent has an initial goal to start


/********* START OF YOUR IMPLEMENTATION FOR TASK 1 *********/
// You can add your solution here
/********* END OF YOUR IMPLEMENTATION FOR TASK 1 *********/

/* 
 * Plan for reacting to the deletion of the goal !start
 * The plan is required for handling failures until you implement Task 1 
 * Triggering event: failure of goal !start
 * Context: true (the plan is always applicable)
 * Body: waits and creates the goal !start 
*/
@handle_missing_start_plan 
-!start
   :  true
   <- .wait(2000); // waits 2000ms
      !start; // creates goal !start (the agent re-tries to !start)
   . 


/********* START OF YOUR IMPLEMENTATION FOR TASK 2 *********/
/* 
 * Plan for reacting to the addition of the belief ready_to_explore 
 * The plan is required for exploring the woods for gold
 * Triggering event: addition of belief ready_to_explore
 * Context (before Task 2): true (the plan is always applicable)
 * Context (after Task 2): the agent has a belief about the size of the map
 * Body: computes a random location and creates the goal to explore the route to it 
*/
@ready_to_explore_plan
+ready_to_explore
   :  true
   <- jia.random(X,20) ; // action that unifies X with a random number in [0, 20]
      jia.random(Y,20) ; // action that unifies Y with a random number in [0, 20]
      .print("I will create the goal to explore (",X,",", Y,")");
      !explore(X,Y); // creates goal explore(X,Y)
   .
/********* END OF YOUR IMPLEMENTATION FOR TASK 2 *********/

/* 
 * Plan for reacting to the addition of the belief ready_to_explore 
 * The plan is required in case the agent does not have a belief about the size of the map after you implement Task 2 
 * Triggering event: addition of belief ready_to_explore
 * Context : true (the plan is always applicable)
 * Body: waits and deletes the old belief ready_to_explore and adds a new belief ready_to_explore
*/
@ready_to_explore_unknown_map_plan
+ready_to_explore
   :  true
   <- .wait(100); // waits 100ms
      -+ready_to_explore; // deletes the old belief ready_to_explore and adds a new belief ready_to_explore
   .
/********* START OF YOUR IMPLEMENTATION FOR TASK 3 *********/
// You can add your solution here
/********* END OF YOUR IMPLEMENTATION FOR TASK 3 *********/

/* 
 * Plan for reacting to the creation of the goal !init_handle(gold(X,Y))
 * The plan is required for initializing the process of handling gold 
 * when the agent had a goal of going near an irrelevant location
 * Triggering event: creation of goal !init_handle(Gold)
 * Context: the agent believes that it has the goal to go near a location
 * Body: deletes any goals for going near any location, and creates the goal to handle the gold
 */
@init_handle_plan[atomic]
+!init_handle(gold(X,Y))
   :  .desire(go_near(_,_))
   <- .print("I will stop moving to handle ", gold(X,Y));
      .drop_desire(go_near(_,_)); // action that deletes the goal of going near a location
      !!handle(gold(X,Y)); // creates goal !handle(gold(X,Y))
   .

/* 
 * Plan for reacting to the creation of the goal !init_handle(gold(X,Y))
 * The plan is required for initializing the process of handling gold 
 * Triggering event: creation of goal !init_handle(Gold)
 * Context: true (the plan is always applicable)
 * Body: creates the goal to handle the gold 
 */
@init_handle_not_moving_plan[atomic]
+!init_handle(gold(X,Y))
   :  true
   <- !!handle(Gold); // creates goal !handle(gold(X,Y))
   .

/* 
 * Plan for reacting to creation of goal !handle(gold(X,Y))
 * The plan is required for collecting a gold nugget and droppping it at the depot
 * Triggering event: creation of goal !handle(Gold)
 * Context: the agent does not believe it is ready to explore, and 
 * it believes that the depot is located at (DepotX,DepotY)
 * Body: 1) moves to the location of a gold nugget, 2) picks the nugget,
 * 3) confirms that picking was successful, 4) moves to the location of the depot,
 * 5) confirms that reaching the depot was successfully, 6) drops the nugget at the depot, 
 * and 7) chooses another perceived gold to handle
 */
+!handle(gold(X,Y))
   :  not ready_to_explore
      & depot(DepotX,DepotY)
   <- .print("Handling ", gold(X,Y), "now");
      /********* START OF YOUR IMPLEMENTATION FOR TASK 4 *********/
      // You can add your solution here
      /********* END OF YOUR IMPLEMENTATION FOR TASK 4 *********/
      .print("Finish handling ",gold(X,Y));
      !!choose_gold; // creates goal !choose_gold
   .

/* 
 * Plan for reacting to the creation of goal !move_to(X,Y)
 * The plan is required for moving to the location (X,Y)
 * Triggering event: creation of goal !move_to(X,Y)
 * Context: the agent believes it is located at (X,Y)
 * Body: announces that it has reached the location (X,Y)
 */
 @move_to_plan
+!move_to(X,Y)
   :  current_position(X,Y)
   <- .print("I've reached (",X,",",Y,")");
   .
/* 
 * Plan for reacting to the creation of goal !move_to(X,Y)
 * The plan is required for confirming that it is in the position of a gold nugget and it is carrying the gold nugget
 * Triggering event: creation of goal !move_to(X,Y)
 * Context: the agent does not believe that it is located at (X,Y)
 * Body: creates the goal to make 1 more step towards (X,Y), and creates goal !move_to(X,Y)
 */
@move_to_different_location_plan
+!move_to(X,Y)
   :  not current_position(X,Y)
   <- !next_step(X,Y); // creates goal !next_step(X,Y)
      !move_to(X,Y); // creates a goal !move_to(X,Y)
   .
/* 
 * Plan for reacting to the creation of goal !confirm_pick
 * The plan is required for confirming that the agent is at the location of a gold nugget and 
 * it is carrying a nugget
 * Triggering event: creation of goal !confirm_pick
 * Context: the agent believes it is located at the location (X,Y) of a gold nugget
 * Body: checks if the agent is carrying gold, and deletes the belief that gold is located at (X,Y)
 */
 @confirm_pick_plan
+!confirm_pick
   :  current_position(X,Y)
      & gold(X,Y)
   <- ?carrying_gold; // tests if the agent is carrying gold
      .abolish(gold(X,Y)); // deletes the belief that gold is located at (X,Y)
      .print("Successfully picked gold");
   .

/* 
 * Plan for reacting to the creation of goal !confirm_depot
 * The plan is required for confirming that the agent is at the location of the depot
 * Triggering event: creation of goal !confirm_depot
 * Context: the agent believes it is at the location (X,Y) 
 * Body: checks if the agent is at the location of the depot, and creates goal !confirm_depot(State) 
 */
@confirm_depot_plan
+!confirm_depot
   :  current_position(X,Y)
   <- depot_at(X,Y,State);
      !confirm_depot(State);
   .

/* 
 * Plan for reacting to the creation of goal !confirm_depot(State)
 * The plan is required for confirming that the agent is at the location of the depot
 * Triggering event: creation of goal !confirm_depot(State)
 * Context: the agent believes it is at the location (X,Y) of the depot
 * Body: announces that is has successfully reached the depot
 */
@confirm_depot_right_location_plan
+!confirm_depot(State)
   :  State
   <- .print("Successfully reached depot");
   .

/* 
 * Plan for reacting to the deletion of goal !confirm_depot(State)
 * The plan is required for confirming that the agent is at the location of the depot,
 * if previously it failed to confirm this
 * Triggering event: deletion of goal !confirm_depot(State)
 * Context: the agent believes that the depot is located at (DepotX,DepotY)
 * Body: tries to move again to the location of the depot and confirm 
 */
@confirm_depot_handle_failure_plan
-!confirm_depot(State)
   :  depot(DepotX, DepotY)
   <- .print("Confirming depot failed. Retrying to move to depot.");
      .wait(1500); // waits 1500ms
      !move_to(DepotX,DepotY); // creates goal !move_to(DepotX,DepotY)
      !confirm_depot; // creates goal !confirm_depot
   .

/* 
 * Plan for reacting to the deletion of goal !handle(gold(X,Y))
 * The plan is required in case the agent fails to handle a gold nugget
 * Triggering event: deletion of goal !handle(gold(X,Y))
 * Context: the agent believes that the gold nugget is located at (X,Y)
 * Body: deletes the belief that gold is located at (X,Y), and 
 * chooses another gold nugget to handle
 */
 @handle_gold_handle_failure_plan
-!handle(gold(X,Y))
   :  gold(X,Y)
   <- .print("Handling ",gold(X,Y), " failed.");
      .abolish(gold(X,Y)); // deletes the belief gold(X,Y)
      !!choose_gold; // creates goal !choose_gold
   .

/* 
 * Plan for reacting to the deletion of goal !handle(gold(X,Y))
 * The plan is required in case the agent fails to handle a gold nugget
 * Triggering event: deletion of goal !handle(gold(X,Y))
 * Context: true (the plan is always applicable)
 * Body: chooses another gold nugget to handle
 */
@handle_gold_missing_gold_plan
-!handle(gold(X,Y))
   :  true
   <- .print("Handling ",gold(X,Y), " failed.");
      !!choose_gold; // creates goal !choose_gold
   .

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }

/* Import behavior of agents that explore the mine environment */
{ include("inc/exploration.asl") }

/* Import behavior of agents that choose to handle gold nuggets perceived in the past */
{ include("inc/gold_selection.asl") }