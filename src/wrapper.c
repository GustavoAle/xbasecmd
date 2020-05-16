#include <stdio.h>
#include <signal.h>
#include <hbvm.h>
#include <hbapi.h>

#define XBCMD_VER "2.0.137" //<ten of the year>.<unit of the year>.<day since 1st january>

extern char * xbs_parse(const char *input);
extern void xbs_call_proc(const char *input);

void print_credits(){

    printf( "           ______                      ________  ______   | Author: Gustavo Ale\n"
            " ___  ___ /  ___ \\                    / ____/  \\/  / _ \\  | License: MIT\n"
            " \\  \\/  //  /__/ /_____ __________   / /   / /\\_/ / / \\ \\ | \n"
            "  \\  \\ //  ___ _/  ___ `/ ____/ __ \\/ /   / /  / / /  / / | \n"
            "  / \\  \\  /__/  / /__/ (___  )  ___/ /___/ /  / / /__/ /  | \n"
            " /__/\\__\\______/\\___,_/_____/\\____/\\____/_/  /_/______/   | Version: " XBCMD_VER "\n\n");

}

static volatile int run_loop = 1;

void sig_handler(int sig_number) {
    if(sig_number == SIGINT){
        run_loop = 0;
    }
}

int main(){
    char buffer[1024];

    

    print_credits();

    hb_vmInit(0);
    hb_conRelease();
    xbs_call_proc("_INITVARS");
    signal(SIGINT,sig_handler);
    
    while(run_loop)
    {
        printf("--> ");
        scanf(" %s",buffer);
        
        xbs_parse(buffer);
        
    }
    hb_vmQuit();

}