#ifndef XBASECMD_BASICIO_H
#define XBASECMD_BASICIO_H

/** Initialize customized termios*/
void init_termios(int __echo);

/** Restore to old termios configuration*/
void reset_termios(void);

#endif