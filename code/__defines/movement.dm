// Defines used for movement state evaluation.
#define MOVEMENT_INTENT_WALKING 1
#define MOVEMENT_INTENT_RUNNING 2

#define IS_WALKING(X) (X?.move_intent?.flags & MOVEMENT_INTENT_WALKING)
#define IS_RUNNING(X) (X?.move_intent?.flags & MOVEMENT_INTENT_RUNNING)

// Causes AStar paths to be blocked by windows that can't be passed through; usually, they go straight through.
#define ASTAR_BLOCKED_BY_WINDOWS 1
