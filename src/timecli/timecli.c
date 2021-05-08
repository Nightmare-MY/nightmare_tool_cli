#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
void sleep_ms(unsigned int secs)

{
    struct timeval tval;

    tval.tv_sec = secs / 1000;

    tval.tv_usec = (secs * 1000) % 1000000;

    select(0, NULL, NULL, NULL, &tval);
}

int thread(void)
{

    pthread_t newthid;
    newthid = pthread_self();
    // printf("this is a new thread, thread ID = %d\n", newthid);
    printf("    0.0");
    // exit(0);
    fflush(stdout);
    //…calculating…
    int m = 0;
    int i = 1;
    // 满10
    int x = 0;
    // 满100
    int h = 0;
    // 满1000
    int t = 0;
    while (1)
    {
        if (t)
        {
            printf("\010\010\010\010");
        }
        else if (h)
        {
            printf("\010\010\010");
        }
        else if (x)
        {
            printf("\010\010");
        }
        else
        {
            printf("\010");
        }
        if (m > 999)
        {
            t = 1;
        }
        else if (m > 99)
        {
            h = 1;
        }
        else if (m > 9)
        {
            x = 1;
        }
        printf("\010\010\010%d.%ds", m, i);
        fflush(stdout);
        i++;
        if (i == 10)
        {
            i = 0;
            m += 1;
        }
        sleep_ms(100);
    }
    return 0;
}

void post_thread()
{
    pthread_t thid;
    // printf("main thread ,ID is %d\n", pthread_self());
    if (pthread_create(&thid, NULL, (void *)thread, NULL) != 0)
    {
        printf("thread creation failed\n");
        exit(1);
    }
    // pthread_join(thid, NULL);
}

int main(int argc, char *argv[], char *envp[])
{
    post_thread();
    int len = 0;
    // i 为1是因为第一个参数是执行文件的路径
    for (int i = 1; i < argc; i++)
    {
        int cur_len = strlen(argv[i]);
        len += cur_len;
        if (i != argc - 1)
        {
            len += 1;
        }
        len += 2;
        // if (argv[i][0] != "-")
        // {
        //     printf("---> %c\n", argv[i][0]);
        //     len += 2;
        // }
        // if ()
    }
    // 末尾指针，因为上面的算法多了一个空格
    // len += 1;
    // printf("len -> %d\n", len);
    char buf[len];
    int is_first = 1;
    for (int i = 1; i < argc; i++)
    {
        // printf("长度 %d\n", strlen(buf));
        if (is_first)
        {
            sprintf(buf, "%s", argv[i]);
            is_first = 0;
        }
        else
        {
            sprintf(buf, "%s \"%s\"", buf, argv[i]);
        }
    }
    buf[len] = 0;
    // printf("->%s<-\n", buf);
    int status = system(buf);
    printf("\n");
    if (-1 == status)
    {
        printf("system error!");
    }
    else
    {
        // printf("exit status value = [0x%x]\n", status);

        if (WIFEXITED(status))
        {
            if (0 == WEXITSTATUS(status))
            {
                return 0;
                // printf("run shell script successfully.\n");
            }
            else
            {
                return WEXITSTATUS(status);
                // printf("run shell script fail, script exit code: %d\n", WEXITSTATUS(status));
            }
        }
        else
        {
            printf("exit status = [%d]\n", WEXITSTATUS(status));
        }
    }
    return 0;
}
