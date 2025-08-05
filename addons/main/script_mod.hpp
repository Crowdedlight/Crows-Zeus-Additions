#define MAINPREFIX z
#define PREFIX crowsza

#include "script_version.hpp"

#define VERSION     MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCH
#define VERSION_AR  MAJOR,MINOR,PATCH

// Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game.
#define REQUIRED_VERSION 2.10

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(Crow's ZA - COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(Crow's ZA - COMPONENT)
#endif
