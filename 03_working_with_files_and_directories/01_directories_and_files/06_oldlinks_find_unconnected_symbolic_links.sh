#!/usr/bin/env  bash

# Use find to track down all links and then uses perl to print the names of links that point to nonexistent files. 
find . -type l -print | perl -nle '-e || print'
