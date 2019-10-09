#!/usr/bin/env bash

# After you compile and debug a program, there's a part of the executable binary that you can delete to save disk space. The strip command does the job. Note that once you strip a file, you can't use a symbolic debugger like dbx or gdb on it!
strip my_executable
