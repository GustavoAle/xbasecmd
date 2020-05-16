#include <stdio.h>
#include "hbvm.h"

#define XBCMD_VER "2.0.137" //<ten of the year>.<unit of the year>.<day since 1st january>

extern char * xbs_parse(const char *input);
extern void xbs_call_proc(const char *input);

void print_credits(){

    printf( "           ______                      ________  ______   | Author: Gustavo Ale\n"
            " ___  ___ /  ___ \\                    / ____/  \\/  / _ \\  | License: GPL\n"
            " \\  \\/  //  /__/ /_____ __________   / /   / /\\_/ / / \\ \\ | \n"
            "  \\  \\ //  ___ _/  ___ `/ ____/ __ \\/ /   / /  / / /  / / | \n"
            "  / \\  \\  /__/  / /__/ (___  )  ___/ /___/ /  / / /__/ /  | \n"
            " /__/\\__\\______/\\___,_/_____/\\____/\\____/_/  /_/______/   | Version: " XBCMD_VER "\n");

}


int main(){
    char msg[] = "echo('hi')";

    print_credits();

    hb_vmInit(0);
    xbs_call_proc("_INIT");

    xbs_parse(msg);

    hb_vmQuit();
}