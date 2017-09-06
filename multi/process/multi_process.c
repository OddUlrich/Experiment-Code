/* multi_process.c */
/* read number of thread N and range of count M from the file input.txt */

#include "multi_process.h"

unsigned long long str2long(char* str) {
    int i = 0;
    unsigned long long ret = 0;
    for (; str[i] != '\0'; i++) 
    {
	ret = ret * 10 + str[i] - '0';
    }
	return ret;
}

int main(void)
{
    int N;
    long int msgtype = 0;
    unsigned long int M;
    unsigned long int length;
    unsigned long long sum = 0;
    int i, msgid;
    struct stMsg msg;
    pid_t pid;
    struct timeval start, end;
    double time;
    
    FILE *fp_in, *fp_out;

    if (NULL == (fp_in = fopen("./input.txt", "rb")))
    {
        printf("file open error!\n");
        exit(0);
    }
    if (NULL == (fp_out = fopen("./output.txt", "wb")))
    {
        printf("file open error!\n");
        exit(0);
    }

    fscanf(fp_in, "N=%d\nM=%ld\n", &N, &M);
    fclose(fp_in);

    gettimeofday(&start,NULL);

    msgid = msgget((key_t)1234, 0666|IPC_CREAT);
    if (msgid == -1)
    {
        printf("msgget failed!\n");
        exit(0);
    }
 
    length = M/N;
    for (i = 0; i < N; i++)
    {
        pid = fork();
        if (0 == pid)
        {
            unsigned long long tmp = 0;
            unsigned long int head, foot; 
            msg.msg_type = 1;
            head = i*length + 1;

            if (i == N-1)
            {
                foot = M;
            }
            else 
            {
                foot = (i+1) * length;
            }
            
            for ( ; head <= foot; head++)
            { 
                tmp = tmp + head;
            }
            sprintf(msg.text, "%lld", tmp);
            if (msgsnd(msgid, (void*) &msg, MAX_SIZE, 0) == -1)
            {
                printf("msgsnd failed!\n");
            }
            exit(0);
        } 
    }

    for (i = 0; i < N; i++)
    {
        if (msgrcv(msgid, (void*) &msg, BUFSIZ, msgtype, 0) == -1)
        {
            printf("msgrcv failed!\n");
        }
        unsigned long long tmp = str2long(msg.text);
        sum = sum + tmp;
    }

    gettimeofday(&end, NULL);

    time = 1000000 * (end.tv_sec - start.tv_sec) + end.tv_usec - start.tv_usec;
    time = (double) time / 1000000;
    printf("sum = %lld\n", sum);
    printf("time: %lf\n", time);
    fprintf(fp_out, "%lld", sum);

    if (msgctl(msgid, IPC_RMID, 0) == -1)
    {
        printf("msgctl(IPC_RMID) failed!\n");
        exit(0);
    }
    return 0;
}
