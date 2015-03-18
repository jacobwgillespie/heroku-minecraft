#!/bin/bash

# Set Minecraft version
MC_VERSION="${MC_VERSION:-1.7.10}"


# Download Minecraft
curl -o "vendor/minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/${MC_VERSION}/minecraft_server.${MC_VERSION}.jar"
