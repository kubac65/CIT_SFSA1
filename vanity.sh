#!/bin/bash

username=$(whoami)
grep $username $1
