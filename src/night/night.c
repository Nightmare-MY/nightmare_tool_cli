#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
void sleep_ms(unsigned int secs)

{
    struct timeval tval;

    tval.tv_sec = secs / 1000;

    tval.tv_usec = (secs * 1000) % 1000000;

    select(0, NULL, NULL, NULL, &tval);
}
int main(int argc, char *argv[], char *envp[])
{
    pid_t curpid = getpid();
    // printf("--->%d", curpid);
    int i = 0;
    for (i = 0; i < argc; i++)
    {
        // printf("%s\n", argv[i]);
    }
    int pid = fork();
    int tmp = 0;
    int *down = &tmp;
    if (pid < 0)
    {
        // return throw_runtime_exception(env, "Fork failed");
    }
    else if (pid == 0)
    {
        sleep_ms(100);
        // time_t start, end;
        // start = time(NULL); //or time(&start);
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
        while (!*down)
        {
            // printf("down ->%d\n", *down);
            //  difftime(end, start)
            // end = time(NULL);
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
    }
    else
    {
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
        system(buf);
        // printf("done\n");
        // int tmp = 1;
        // printf("parent ->%d\n", down);
        // down = &tmp;
        // printf("parent ->%d\n", down);
        // printf("parent ->%d\n", down);
        printf("\n");
        kill(pid, SIGINT);

        return 0;
    }
    return 0;
}
