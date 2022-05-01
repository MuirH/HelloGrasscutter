#!/bin/bash

config(){
    echo "$0: Generating configuration..."
    java -jar grasscutter.jar -handbook
    if [ -z "$MongoIP" ]; then
        cat config.json|jq '.DatabaseUrl="mongodb://mongo:27017"' > config.json
        cat config.json|jq '.GameServer.DispatchServerDatabaseUrl="mongodb://mongo:27017"' > config.json
    else
        cat config.json|jq ".DatabaseUrl=\"mongodb:/"$MongoIP":27017\"" > config.json
        cat config.json|jq ".GameServer.DispatchServerDatabaseUrl=\"mongodb:/"$MongoIP":27017\"" > config.json
    fi
    cat config.json|jq '.GameServer.Name="HelloGrasscutter"' > config.json
}

init(){
    echo "$0: Start initialization."
    cp -rf /keys /app/keys
    cp -rf /data /app/data
    cp -rf /keystore.p12 /app/keystore.p12
    cp -rf /grasscutter.jar /app/grasscutter.jar
    if [[ ! -d "/app/resources" ]]; then
        echo "$0: Downloading resources..."
        git clone --depth 1 https://github.com/HelloGrasscutter/Resources.git /tmp/Resources
        echo "$0: Copying resources..."
        mkdir -p /app/resources/
        mv -f /tmp/Resources/Resources/* /app/resources
    fi
    config
    echo "$0: Initialization complete!"
    echo "$0: Please run again and the server will start soon!"
}

if [[ ! -d "/app" ]]; then
    echo -e "$0: Please mount the data directory to /app.\n$0: Exiting..."
elif [[ ! -f "/app/grasscutter.jar" ]]; then
    init
elif [[ $1 = "reset" ]]; then
    echo "$0: [!!] All files except config.json will be reset, including the data folder."
    read -r -p "$0: Are You Sure? [y/N] " input
    case $input in
        [yY][eE][sS]|[yY])
            echo "$0: Deleting old resources..."
            rm -rf /app/resources
            init
            ;;
        *)
            echo "$0: Exiting..."
            exit 1
            ;;
    esac
elif [[ $1 = "resetconfig" ]]; then
    read -r -p "$0: [!!] Are you sure you want to reset the config.json? [y/N] " input
    case $input in
        [yY][eE][sS]|[yY])
            echo "$0: Deleting config.json..."
            rm -rf /app/config.json
            config
            ;;
        *)
            echo "$0: Exiting..."
            exit 1
            ;;
    esac
else
    echo -e "$0: Welcome to HelloGrasscutter, this is a docker open source project based on Grasscutter, you can check it out at https://github.com/HelloGrasscutter."
    cd /app
    exec "$@"
fi
