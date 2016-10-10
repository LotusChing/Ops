#!/bin/bash
set -e
project="project_name"
workspace="/var/lib/jenkins/workspace/$project"
build_point="${workspace}/WEB-INF/classes"
libs="${workspace}/WEB-INF/lib"
cp=''
### Generate classpath
echo "Starting Generate classpath..."
for i in `find $libs -name *.jar`
do
    cp=$cp$i:
done
echo "Generate Successful."
cd $build_point

### Compile
echo "Starting Compile java source code..."
find . -name *.java | xargs -i javac -cp $cp -encoding utf8 {}
echo "Compile Done."
echo "Clean source code *.java"
find . -name *.java | xargs -i rm -f {}

echo "Work Done."

### Generate war file for tomcat
cd $workspace
echo "Starting Generate war file..."
jar -cvf $project.war WEB-INF
echo "Generate Successful."

### Undeploy old release project from tomcat
echo "Starging Undeploy old release project..."
wget http://user:passwd@ip/manager/text/undeploy?path=/$project -O -
echo "Undeploy Successful."

### Deploy new release project to tomcat
echo "Starging deploy new release project..."
# use tomcat provider web mangeent interface
#wget http://user:pass@ip:port/manager/text/deploy?path=/$project\&war=file:$project.war -O -
# use put method
#curl -T $project.war http://ip:port/dir/
echo "Deploy Successful."
