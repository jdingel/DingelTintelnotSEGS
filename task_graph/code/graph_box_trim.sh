#!/bin/bash
#Script to generate graph of tasks based on specified terminal nodes denoted by [shape=box]
#This script simply starts at the terminal nodes and takes one step upstream repeatedly until it encounters no upstream pre-requisites.
#Input path is $1; output path is $2

#if [ acyclic -n $1 ]
#then

grep -v '^#' $1 | sed 's/^[[:space:]]*//' | sed 's/ \-> /\->/' > temp_graph.txt #Remove comments from graph.

ENDPOINTS="$(grep '\[shape=box\]' temp_graph.txt | sed 's/ \[shape=box\]/$|/' | sed 's/^/\->/' | tr -d '\n' | sed 's/|$//')"
echo $ENDPOINTS

while [ -n "$ENDPOINTS" ]
do
awk /${ENDPOINTS}/{print} temp_graph.txt >> temp.txt
ENDPOINTS=$(awk /${ENDPOINTS}/{print} temp_graph.txt | awk -F'->' '{print "->" $1 "$|"}' | sort | uniq | tr -d '\n' | sed s'/|$//')
done
cat <(echo -e 'digraph G {') <(sort temp.txt | uniq | grep -v 'setup_environment' | sed 's/\-\>/ \-\> /') <(grep '\[shape=box\]' temp_graph.txt) <(echo '}') > $2
rm temp.txt temp_graph.txt

#fi
