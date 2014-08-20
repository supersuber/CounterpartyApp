

#ifdef DEBUG
#define Log(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define Log(format, ...)
#endif
