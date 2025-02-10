# Programming Your First Agent(s)!

Recently, rumours about the discovery of gold scattered around deep Carpathian woods made their way into the public. Consequently, hordes of gold miners are pouring into the area in the hope to collect as many gold nuggets as possible. In this introductory tutorial, your task is to program a team of miner agents that will collect the gold and deliver it to a depot for safe storage.

The project template we prepared for this tutorial already includes most of the code required by your team of miners, but it leaves out a few parts — just enough to give you a guided tour of some of the features of autonomous agents discussed in the first lecture.

This tutorial is a simplified version of the [Gold Miners Tutorial](https://jacamo-lang.github.io/jacamo/tutorials/gold-miners/readme.html) which extends the winning implementation developed in the context of the 2nd [Multi-Agent Programming Contest](https://multiagentcontest.org/). No submission is required, but feel free to send your questions to [Danai](mailto:danai.vachtsevanou@unisg.ch).

The tutorial project is developed with [JaCaMo](https://jacamo-lang.github.io/), a platform for programming multi-agent systems, and uses [Gradle](https://gradle.org/). We recommend you to use [Visual Studio Code](https://code.visualstudio.com/) with the following extensions:
- For JaCaMo syntax highlighting: [JaCaMo4Code](https://marketplace.visualstudio.com/items?itemName=tabajara-krausburg.jacamo4code)
- For Gradle view: [Gradle for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-gradle)
- For Java-Gradle support: [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)

Optional reading material for a brief introduction to agent-oriented programming: [<u>Chapter 4.1</u> of Boissier, O., Bordini, R. H., Hubner, J., & Ricci, A. (2020). Multi-agent oriented programming: programming multi-agent systems using JaCaMo. Mit Press.](https://mitpress.mit.edu/books/multi-agent-oriented-programming)

## Table of Contents
-   [Project structure](#project-structure)
-   [How to run the project](#how-to-run-the-project)
-   [Gold Miners Tutorial](#gold-miners-tutorial)
    -  [Task 1 - Hello World](#task-1---hello-world)
    -  [Task 2 - Beliefs about the world](#task-2---beliefs-about-the-world)
    -  [Task 3 - Reactive behavior](#task-3---reactive-behavior)
    -  [Task 4 - Proactive behavior](#task-4---proactive-behavior)
    -  [Task 5 - Social behavior](#task-5---social-behavior)
    -  [Task 6 - Towards Multi-Agent Systems](#task-6---towards-multi-agent-systems)
-   [Concluding remarks](#concluding-remarks)

## Project structure
```
├── src
│   ├── agt
│   │   ├── miner.asl // agent program of miner agents
│   │   ├── leader.asl // agent program of the leader agent
│   │   └── inc
│   │       ├── exploration.asl // program that supports miner agents in exploring the grid environment
│   │       └── gold_selection.asl // program that supports miner agents in choosing gold nuggets to handle
│   └── env
├── mas_1_4.jcm // the configuration file of the JaCaMo application for tasks 1-4
├── mas_5.jcm // the configuration file of the JaCaMo application for task 5
└── mas_6.jcm // the configuration file of the JaCaMo application for task 6
```
 
## How to run the project

You can run the project directly in Visual Studio Code or from the command line with [Gradle 7.4](https://gradle.org/). The available Gradle tasks are:

- For Tasks 1-4: `task_1_4`
- For Task 5: `task5`
- For Task 6: `task6`

### How to run in Visual Studio Code

In Visual Studio Code, click the Gradle Side Bar elephant icon, and navigate through the Gradle Tasks to run one of the `jacamo` tasks:

<img src="doc/vscode-gradle-view-annotated.png?raw=true" width="200">

### Command Line (MacOS/Linux/Windows)

- MacOS and Linux: Use the command `./gradlew` to run one of the Gradle tasks, e.g.:
```shell
./gradlew task_1_4
```
- Windows: Use the command `gradlew.bat` to run one of the Gradle tasks, e.g.:
```shell
gradle.bat task_1_4
```

## Gold Miners Tutorial

Your team of miners is situated on a grid map that represents the Carpathian woods. Each agent in your team of miners is implemented by the _agent program_ given in [miner.asl](src/agt/miner.asl). This program is written in [Jason/AgentSpeak](https://github.com/jason-lang/jason), a programming language for _Belief-Desire-Intention (BDI) agents_.

We will discuss more about BDI agents in Week 5. For the purpose of this tutorial, it is sufficient to know that a BDI agent has:
- _beliefs_:  information the agent holds about the world; beliefs are not necessarily true, they may be out of date or inaccurate;
- _desires_ or _goals_: states of affairs the agent wishes to bring to the world;
- _intentions_: desires that the agent is committed to achieve.

In [miner.asl](src/agt/miner.asl), lines 8-13 define the _initial beliefs and goals_ of a miner agent:
- `ready_to_explore`: the agent believes that it is ready to explore the woods for gold;
- `depot(0,0)`: the agent believes that the depot is located at (0,0);
- `!start`: the agent has an initial goal to start, which is similar to the `main` method of a Java program; goals are expressed similarly to beliefs except they are preceded by an exclamation point (`!`).

A BDI agent achieves its goals by executing _plans_ programmed by a developer. A plan has the following form:

```
@<plan annotation>
<trigerring_event> : <application_context> <-
   <action_1>;
   <action_2>;
   <action_3>.
```

In this tutorial, we will only use plan annotations to refer to plans easily. Then:
- the _triggering event_ states which event can trigger the execution of the plan;
- the _application context_ states the context in which the plan is applicable and can be executed; if the context is `true`, the plan is applicable in any context;
- the _plan body_ is a recipe for action; note that the plan body is preceded by the sign `<-`, each action is followed by a semicolon (`;`), and the plan ends with a dot (`.`).

In this tutorial, we will use the following types of triggering events:
- `+!<goal>`: signals the creation of a goal, ex. `+!start`;
- `-!<goal>`: signals the deletion of a goal, ex. when the execution of an action in the plan body has failed;
- `+<belief>`: signals the creation of a belief to a belief, ex. `+ready_to_explore`;
- `-<belief>`: signals the deletion of a belief, ex. `-ready_to_explore`.

With this minimal information, you are now ready to program your first agent!

### Task 1 - Hello world

Your first task is to write a plan that prints "Hello world of miners!" when the miner agent starts.

To print a statement, you can use the following action — and note that this is a special action whose name starts with a dot (`.`):

```
.print("text to be printed")
```

<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for achieving the goal !start 
 * Triggering event: creation of goal !start
 * Context: true (the plan is always applicable)
 * Body: prints "Hello world of miners!"
*/
@start_plan 
+!start : true <-
   .print("Hello world of miners!").
```

</details>

### Task 2 - Beliefs about the world

An agent acquires beliefs throughout its lifetime, and you can inspect the beliefs of your agents by visiting http://localhost:3272/ while running the project:

<img src="doc/miner-beliefs.png?raw=true" width="400">

The creation of the initial belief `ready_to_explore` will trigger the plan `@ready_to_explore_plan` on lines 32-37. This plan achieves the following:
- it computes a random position (X,Y) within the grid environment;
- it creates the goal `!explore(X,Y)` for exploring the route to (X,Y); the agent will look for gold while exploring this route.

Currently, the width and height of the map are hard coded into the plan (Width = 20, Height = 20). If the agent has a belief about the size of the map, you can avoid hard coding these values: you can instead use variables to retrieve the values from the agent's beliefs. In AgentSpeak, a variable starts with a capital letter, and we can use the application context of a plan to match variables against the agent's beliefs. For example, given the beliefs shown in the above image, we can write the following plan to print the agent's current position when the agent starts:

```
+!start : current_position(X,Y) <-
   .print(X, " ", Y).
```

If the agent has a belief `current_position(12, 17)` when the agent starts, then the above plan would print `12 17`.

Your second task is to update the `@ready_to_explore_plan` to avoid hard coding the size of the map.

<!--
- the context of the `@ready_to_explore_plan` so that the plan is only executed when the agent has a belief `env_size(X,Y)`. Now, the plan will be applicable only if the variables X, Y become bound to specific values based on a _ground_ belief (e.g. `env_size(100, 100)`) of the miner's belief base at run time.
 - update the body of the plan such that the random position is computed based on variables X, Y instead of the hard coded values 20, 20.
 -->

<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for reacting to the addition of the belief ready_to_explore 
 * The plan is required for exploring the woods for gold
 * Triggering event: addition of belief ready_to_explore
 * Context: the agent has a belief about the size of the map
 * Body: computes a random location (X,Y) and creates the goal to explore the route to it 
*/
@ready_to_explore_plan
+ready_to_explore : map_size(W,H) <-  
   jia.random(X,W) ; // action that unifies X with a random number in [0, W]
   jia.random(Y,H) ; // action that unifies Y with a random number in [0, H]
   .print("I will create the goal to explore (",X,",", Y,")");
   !explore(X,Y) . // creates goal explore(X,Y)
```

</details>

### Task 3 - Reactive behavior

You can click on the cells of the Mining World GUI to add gold nuggets to the map. While exploring the map, the miner agent can perceive gold nuggets that are located in adjacent positions (i.e., the perception radius is 1 grid). 

When an agent receives a percept from the environment, the percept is reflected in the agent's beliefs. While your miner agent is exploring the map, you can again inspect its beliefs as shown above to see the addition of new `gold` beliefs.

Your third task is to create a `@gold_perceived_plan` in [miner.asl](src/agt/miner.asl) to enable the agent to react when it perceives a new gold nugget. For this task, it is sufficient if the plan correctly triggers when gold is perceived. Note that you can use variables in triggering events as well, ex. the triggering event `+gold(X,Y)` will match X and Y to the coordinates of the cell in which the gold nugget was perceived.

The `@gold_perceived_plan` should only be applicable if the agent is ready to explore (i.e., has the belief `ready_to_explore`) and the agent is not already carrying gold (i.e., does not have the belief `carrying_gold`). To implement such conditions in the plan's application context:
- you can use _logical and_ (`&`) and _logical or_ (`|`) to specify conjunctions or disjunctions of beliefs that need to hold;
- you can use the `not` keyword to specify that a belief should not hold (e.g., `not sunny`).

<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for reacting to the addition of the belief gold(X,Y) 
 * The plan is required for reacting to the perception of gold
 * Triggering event: addition of belief gold(X,Y)
 * Context: the agent believes it is ready to explore, and does not believe it is already carrying gold
 * Body: announces the perception of a gold nugget
*/
@gold_perceived_plan[atomic]          
+gold(X,Y) : ready_to_explore & not carrying_gold <- 
    .print("Gold perceived: ",gold(X,Y)).
```

</details>

### Task 4 - Proactive behavior 
    
Currently, the miner agent can perceive gold nuggets but it cannot handle them.

Your fourth task is to complete the `@handle_gold_plan` in [miner.asl](src/agt/miner.asl) to enable the agent to achieve its goal of collecting a perceived gold nugget and delivering it to the depot. The triggering event and the context of the plan are already provided, and there are two available operations that you can use in the plan body. Operations are actions that are implemented by the environment. For this task, the environment offers two operations:
    
- `pick` : collects a gold nugget. The action succeeds if the miner agent is in the position of a gold nugget, e.g. the agent in position (10,8) collects the gold nugget that is perceived in position (10,8);
- `drop` : drops a gold nugget in the depot. The action succeeds if the miner is carrying gold and is in the position of the depot.

For ensuring the success of the action execution, and therefore the achievement of the goal to handle the gold, the plan body should enable the agent not only to pick and drop, but also to move around the map (ex. to the position of a gold nugget or to the depot), to confirm that a gold nugget was picked up successfully, and to confirm that the agent is in the position of the depot.

In AgentSpeak, plans that achieve a more complex goal might require the agent to achieve specific sub-goals amid the actions to be taken. For example, we can write the following plan for creating the goal of moving to a specific position while the agent strives to achieve the goal of handling a gold nugget. This generates the triggering event `+!move_to(10,8)`, and the agent strives to achieve this _sub-goal_ of moving to location `(10,8)` by executing the `@move_to_plan` provided in lines 117-119.

```
@handle_gold_plan
+!handle(gold(X,Y)) : true <-
   !move_to(X,Y);
   .print("I moved to (",X,",",Y,")").
```

Your miner agent is already equipped with the following plans, which you can reuse for implementing the body of `@handle_gold_plan` by creating appropriate sub-goals to trigger the plans:
- `@move_to_plan` (lines 117-119): enables the agent to mvoe to a position (X,Y);
- `@confirm_pick_plan` (lines 141-145): enables the agent to confirm that it is in the position of a gold nugget and it is carrying the gold nugget (i.e., the gold nugget was picked up);
- `@confirm_depot_plan` (lines 154-157): enables the agent to confirm that it is at the depot; later in the tutorial, the depot will be mobile (meaning that the location known by the agent might be outdated), which is why the agent needs to check it arrived at the right location.

In [miner.asl](src/agt/miner.asl), the goal of handling gold is created in the body of the `@init_handle_plan` (lines 74-78) — a plan dedicated to the initialization of the gold handling process. Update your `@gold_perceived_plan` from Task 3 such that, instead of printing the position of the gold nugget, the plan: 
- deletes the belief that the agent is ready to explore. Note that for deleting a belief you need to use the `-` operator. For example, we can write `-sunny` to delete the belief `sunny`;
- creates a sub-goal that triggers `@init_handle_plan`. 

This will initiate the gold handling process and will eventually generate the triggering event `+!handle(gold(X,Y))`, which the agent will strive to achieve by executing your `@handle_gold_plan`.
                              
<details>
<summary>Solution</summary>

```
// miner.asl

/* 
 * Plan for reacting to the addition of the belief gold(X,Y) 
 * The plan is required for reacting to the perception of gold
 * Triggering event: addition of belief gold(X,Y)
 * Context: the agent believes it is ready to explore, and does not believe it is already carrying gold
 * Body: deletes the belief that the agent is ready to explore and creates the goal to initialize the gold handling
*/
@gold_perceived_plan[atomic]          
+gold(X,Y) : ready_to_explore & not carrying_gold <- 
    .print("Gold perceived: ",gold(X,Y));
    -ready_to_explore;
    !init_handle(gold(X,Y)).

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
+!handle(gold(X,Y)) : not ready_to_explore & depot(DepotX,DepotY) <- 
   .print("Handling ", gold(X,Y), "now");
   !move_to(X,Y); // creates goal !move(X,Y)
   pick; // action that picks a gold nugget when the agent is in the location of a gold nugget
   !confirm_pick; // creates goal !confirm_pick
   !move_to(DepotX,DepotY); // creates goal !move(DepotX,DepotY)
   !confirm_depot; // creates goal !confirm_depot
   drop; // action that drops a gold nugget when the agent is in the location of the depot
   .print("Finish handling ",gold(X,Y));
   !!choose_gold. // creates goal !choose_gold
```

</details>

### Task 5 - Social behavior

The team of miners has elected a leader agent, which is responsible for keeping track of the depot coordinates and periodically moving the depot in the grid environment for security reasons. In the Mining World GUI, observe that the depot is moved to a new position every few seconds. You miner agent remains stuck carrying gold in the initial position of the depot — similar to the stuck Roomba you saw in the first lecture. This is because the initial belief of the miner agent about the depot coordinates (`depot(0,0)`) is outdated, so the agent continues to try and confirm that the known location is indeed the location of the depot (lines 178-183).

Thankfully, agents can communicate with one other to share knowledge about the environment. In AgentSpeack, plan bodies can contain _communication actions_, which allow agents to send messages. For example, the miner agent can perform the action `.send(leader, tell, sunny)` to tell the leader that it is `sunny`. The leader will then acquire a new `sunny` belief — and will also keep note that the miner agent is the source of this new belief.

Your fifth task is to update the `@manage_depot_plan` in [leader.asl](src/agt/leader.asl) such that the leader agent tells the miner agent the new location of the depot every time the leader moves the depot.

<details>
<summary>Solution</summary>

```
// leader.asl

/*
* Plan for reacting to the creation of goal !manage_depot
* The plan is required for managing the depot
* Triggering event: creation of goal !manage_depot
* Context: the agent has a belief about the size of the map
* Body: 1) computes a random location (X,Y), 2) moves the depot to (X,Y),
* 3) informs the miner, and 4) creates the goal to manage the depot again
*/
@manage_depot_plan
+!manage_depot : map_size(W,H) <- 
   .wait(10000); // waits 10000ms
   jia.random(X,W) ; // action that unifies X with a random number in [0, W]
   jia.random(Y,H) ; // action that unifies Y with a random number in [0, H]
   move_depot(X,Y); // action that moves the depot at (X,Y)
   -+depot(X,Y); // deletes the old belief depot(_,_) and adds a new belief depot(X,Y) 
   .send(miner, tell, depot(X,Y)); // action that tells the miner that the depot is located at (X,Y)
   !manage_depot. // creates goal !manage_depot
```

</details>

### Task 6 - Towards Multi-Agent Systems

The gold mining business is lucrative and your hard work paid off, so now you can afford a team of four miner agents and one leader agent. All the miner agents explore the grid environment for gold nuggets and try to gather as many as possible. However, with the plan you implemented in Task 5, only one miner agent will be informed by the leader about the new depot location. As a result, the rest of the miners remain stuck carrying gold in the initial position of the depot.

Your sixth task is to update the `@manage_depot_plan` in [leader.asl](src/agt/leader.asl) such that the leader agent broadcasts to the whole team the new location of the depot every time the leader moves the depot. In AgentSpeak, an agent can broadcast a message to all other agents in the multi-agent system with the `.broadcast` action. For example, `.broadcast(tell, sunny)` will tell all the agents in the muli-agent system that it is `sunny`.

<details>
<summary>Solution</summary>

```
// leader.asl

/*
* Plan for reacting to the creation of goal !manage_depot
* The plan is required for managing the depot
* Triggering event: creation of goal !manage_depot
* Context: the agent has a belief about the size of the map
* Body: 1) computes a random location (X,Y), 2) moves the depot to (X,Y),
* 3) informs all agents, and 4) creates the goal to manage the depot again
*/
@manage_depot_plan
+!manage_depot : map_size(W,H) <- 
   .wait(10000); // waits 10000ms
   jia.random(X,W) ; // action that unifies X with a random number in [0, W]
   jia.random(Y,H) ; // action that unifies Y with a random number in [0, H]
   move_depot(X,Y); // action that moves the depot at (X,Y)
   -+depot(X,Y); // deletes the old belief depot(_,_) and adds a new belief depot(X,Y) 
   .broadcast(tell, depot(X,Y)); // action that tells the miner that the depot is located at (X,Y)
   !manage_depot. // creates goal !manage_depot
```

</details>

## Concluding remarks
Now with your team of miners working at full force, you lay back, relax, and enjoy the view of the Carpathian woods. But before you go off relaxing, it is worth to reflect on a question:

| :bulb: Your agents are able to achieve their goals in a flexible manner by interleaving proactive, reactive, and social behavior. If you reflect on your agents and their behavior, can you pinpoint concrete examples of such interleaving of behavior?   |
| :-- |


## Troubleshooting

The JaCaMo console sometimes freezes for MacOS users. A way-out is to disable
the MAS console (line 7), and enable the java.util.logging.ConsoleHandler
(line 10) in logging.properties (should be combined with running the 
application from a console):

```properties
# default Jason MAS Console
#handlers = jason.runtime.MASConsoleLogHandler, java.util.logging.FileHandler

# To use the ConsoleHandler, use the following line instead.
handlers= java.util.logging.ConsoleHandler
```