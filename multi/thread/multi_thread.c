/* multi_thread.c */
/* read number of thread N and range of count M from the file input.txt */

#include "multi_thread.h"

int N;
unsigned long int M;
pthread_t thread[20];
pthread_mutex_t mut;
int cnt = 1;
unsigned long long sum = 0;

void thread_fun(void)
{
    while (1)
    {
        pthread_mutex_lock(&mut);
        if (cnt > M)
        {
            pthread_mutex_unlock(&mut);
            break;
        }
        sum = sum + cnt;
        cnt++;
        pthread_mutex_unlock(&mut);
    }
    pthread_exit(NULL);
}

void thread_create(int i_create)
{
    if (pthread_create(&thread[i_create], NULL, (void *)thread_fun, NULL) != 0)
    {
        printf("Thread %d create fail!\n", i_create);
        exit(0);
    }
}

void thread_wait(void)
{
    int i;
    for (i = 0; i < N; i++)
    {
        if (thread[i] != 0)
        {
            pthread_join(thread[i], NULL);
        }
    }
}

int main(void)
{
    int i_create;
    struct timeval start, end;
    double time;
    pthread_mutex_init(&mut, NULL);

    FILE *fp_in, *fp_out;

    if ((fp_in = fopen("./input.txt", "rb")) == NULL)
    {
        printf("file open error!\n");
        exit(0);
    }

    if ((fp_out = fopen("./output.txt", "wb")) == NULL)
    {
        printf("file open error!\n");
        exit(0);
    }

    fscanf(fp_in, "N=%d\nM=%ld\n", &N, &M);
    fclose(fp_in);
    printf("MAIN: multi_thread is creating!\n");
    memset(&thread, 0, sizeof(thread));
    for (i_create = 0; i_create < N; i_create++)
    {
	thread_create(i_create);
    }
    printf("MAIN: Waiting!\n");

    gettimeofday(&start, NULL);
    thread_wait();
    gettimeofday(&end, NULL);    

    time = 1000000 * (end.tv_sec - start.tv_sec) + end.tv_usec - start.tv_usec;
    time = (double)time / 1000000;

    printf("sum = %lld\n", sum);
    printf("time: %lf\n", time);

    fprintf(fp_out, "%lld", sum);
    fclose(fp_out);
    return 0;
}
