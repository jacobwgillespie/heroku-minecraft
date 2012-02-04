echo "`cat server.properties1`\nserver-port=$PORT\n`cat server.properties2`" > server.properties 
java -jar bin/minecraft_server.jar nogui
