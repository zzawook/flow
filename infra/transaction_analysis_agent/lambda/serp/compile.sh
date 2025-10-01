#!/bin/bash

npx esbuild index.ts   --bundle --platform=node --target=node22 --format=cjs   --outfile=index.js;
zip -9 brand-tools.zip index.js;