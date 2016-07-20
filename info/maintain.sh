work=~/.tmp/maintaining/h3control-bin/work
rm -rf $work
mkdir -p $work
wget -O $work/bfg-1.12.12.jar http://repo1.maven.org/maven2/com/madgag/bfg/1.12.12/bfg-1.12.12.jar
cd $work
git clone --mirror https://github.com/devizer/h3control-bin.git
du -h -d 2

# STEP 2
work=~/.tmp/maintaining/h3control-bin/work
cd $work
java -jar bfg-1.12.12.jar --strip-blobs-bigger-than 3M h3control-bin
# java -jar bfg-1.12.12.jar --strip-blobs-bigger-than 3M h3control-bin
