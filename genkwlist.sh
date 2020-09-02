#!/bin/bash


echo '<kwlist ecf_filename="ecf.xml" language="english" encoding="UTF-8" compareNormalize="" version="Example keywords">' > data/kwlist.xml
n=1
while IFS='' read -r line || [[ -n "$line" ]]; do
  echo '  <kw kwid="'$n'">' >> data/kwlist.xml
  echo '    <kwtext>'$line'</kwtext>' >> data/kwlist.xml
  echo '  </kw>' >> data/kwlist.xml
  n=`expr $n + 1` 
done < data/keywords.txt
echo '</kwlist>' >> data/kwlist.xml





