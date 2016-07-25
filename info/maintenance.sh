git pull
git commit -am "commit before maintenance"
wget -O /tmp/bfg.jar http://repo1.maven.org/maven2/com/madgag/bfg/1.12.12/bfg-1.12.12.jar
java -jar /tmp/bfg.jar --strip-blobs-bigger-than 3100K ..

rm /tmp/bfg.jar
git push

