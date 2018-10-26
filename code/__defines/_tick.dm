#define TICK_LIMIT_RUNNING 80
#define TICK_LIMIT_TO_RUN 70
#define TICK_LIMIT_MC 70
#define TICK_LIMIT_MC_INIT_DEFAULT 98

#define TICK_CHECK ( TICK_USAGE > Master.current_ticklimit )
#define CHECK_TICK if TICK_CHECK stoplag()

#define TICK_USAGE world.tick_usage
#define TICK_USAGE_REAL world.tick_usage    //to be used where the result isn't checked
