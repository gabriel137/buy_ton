#!/bin/sh

bin/simple_ms_blocklist eval "BuyTon.Release.migrate" && \
bin/simple_ms_blocklist eval "BuyTon.Release.seed" && \
bin/simple_ms_blocklist start