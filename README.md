# Heroku Minecraft

#### Minecraft finds a way.

This is a very alpha-quality Heroku app that runs a Minecraft server on a single dyno.

#### Limitations

Since Heroku is a bit of a weird platform, there are a couple of caveats to running a Minecraft server on it.

* Since Heroku no longer supports TCP routing, we're proxying the connection through WebSockets. This means each client will have to run a little tool to turn the WebSocket connection back into a regular TCP Minecraft connection. This is detailed below in the "Client" section.

* Heroku has no persistant storage, so you will have to have an [Amazon AWS](http://aws.amazon.com) account and an Amazon S3 bucket ready to store your world data. Your world data will be automatically synced to and from S3 in the background.

## Server Setup

1. Clone this repository using git (or, if it's easier, [GitHub for Mac](http://mac.github.com), or [GitHub for Windows](http://windows.github.com)).

2. Create a new Heroku app with a custom buildpack.

   ```bash
   $ heroku create my-app-name --buildpack https://github.com/ddollar/heroku-buildpack-multi.git
   ```

3. Choose your Minecraft server version (default 1.8.3).

   ```bash
   $ heroku config:add MC_VERSION=1.8.3
   ```

4. Add your Amazon AWS credentials and S3 bucket name to the Heroku configuration. This enables data persistence. Otherwise, your server will be wiped each time it is restarted.

   ```bash
   $ heroku config:add AWS_KEY=xxxxxxx AWS_SECRET=yyyyyyyyyyyyyyyyy S3_BUCKET=my-bucket-name
   ```

5. Push the app to Heroku.

   ```bash
   $ git push heroku master
   ```

## Client Setup

Install https://github.com/leonardosantos/hmwtc, then:

   ```bash
   $ hmwtc my-app-name.herokuapp.com
   ```

## Credits

Original implementation by [Jacob Gillespie](https://github.com/jacobwgillespie).

See the [contributors list](https://github.com/jacobwgillespie/heroku-minecraft/graphs/contributors) - many awesome people have contributed to make heroku-minecraft what it is today.
