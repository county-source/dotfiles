#!/bin/bash
asusctl profile -p | grep "Active" | grep -oE 'Quiet|Balanced|Performance'
