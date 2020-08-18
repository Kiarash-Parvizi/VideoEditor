#ifndef CMDEXECUTION_H
#define CMDEXECUTION_H

#include<cstdlib>

void exec(const char* cmd) {
    system(cmd);
}

#endif // CMDEXECUTION_H
