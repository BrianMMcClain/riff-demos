#!/bin/bash

riff build -n greeting -v 0.0.1 -f greeting
riff apply -f greeting
riff build -n timestamp -v 0.0.1 -f timestamp
riff apply -f timestamp