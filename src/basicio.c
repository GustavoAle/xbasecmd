#include <termios.h>
#include <stdio.h>

static struct termios __old_termios_cfg, __current_termios_cfg;

/** Initialize customized termios*/
void init_termios(int __echo) 
{
    tcgetattr(0, &__old_termios_cfg); /** get old termios cfg*/
    __current_termios_cfg = __old_termios_cfg; /** copy old config*/
    __current_termios_cfg.c_lflag &= ~ICANON; /** disable io buffer*/
    if (__echo) { /** set echo*/
        __current_termios_cfg.c_lflag |= ECHO; 
    } else {
        __current_termios_cfg.c_lflag &= ~ECHO;
    }
    tcsetattr(0, TCSANOW, &__current_termios_cfg); /** apply current config*/
}


/** Restore to old termios configuration*/
void reset_termios(void) 
{
    tcsetattr(0, TCSANOW, &__old_termios_cfg);
}