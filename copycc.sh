#!/bin/bash
rm -rf chaincode/github.com/ctrack/*
cp -r $GOPATH/src/github.com/blockchain/* chaincode/github.com/ctrack/
ls -l chaincode/github.com/ctrack/
