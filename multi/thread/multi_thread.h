#ifndef _MULTI_THREAD_H_
#define _MULTI_THREAD_H_

#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>

void thread_fun(void);
void thread_create(int i_create);
void thread_wait(void);


#endif
