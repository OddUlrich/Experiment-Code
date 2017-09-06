#ifndef _MULTI_PROCESS_H_
#define _MULTI_PROCESS_H_

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/msg.h>
#include <sys/wait.h>

#define MAX_SIZE 100

struct stMsg
{
    long int msg_type;
    char text[BUFSIZ];
};

#endif
