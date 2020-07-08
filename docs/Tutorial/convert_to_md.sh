#!/bin/sh


for file in *.html; do
    pandoc --from html --to commonmark "$file" > "$(basename "$file" .html).md"
done
