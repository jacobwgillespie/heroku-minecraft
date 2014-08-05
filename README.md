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

3. Add your Amazon AWS credentials and S3 bucket name to the Heroku configuration. This enables data persistence. Otherwise, your server will be wiped each time it is restarted.

   ```bash
   $ heroku config:add AWS_KEY=xxxxxxx AWS_SECRET=yyyyyyyyyyyyyyyyy S3_BUCKET=my-bucket-name
   ```

4. Push the app to Heroku.

   ```bash
   $ git push heroku master
   ```

## Client Setup

Hopefully, this process can be streamlined in the future, but for now it's a little squirrely if you aren't a developer.

These instructions are for OS X, or some other Linux-like operating system maybe.

1. Clone this repository using git (or, if it's easier, [GitHub for Mac](http://mac.github.com), or [GitHub for Windows](http://windows.github.com)).

2. Install [NodeJS](http://nodejs.org) and [NPM](https://npmjs.org). On the Mac, I suggest doing this via [Homebrew](http://brew.sh). If you have Homebrew installed, just do `brew install node`.

3. Change to the repository you cloned.

   ```bash
   $ cd ~/Downloads-Or-Wherever/heroku-minecraft
   ```

4. Install the NPM dependencies.

   ```bash
   $ npm install
   ```

5. Run the proxy service. This will proxy the Minecraft server on Heroku to your local machine. The server will appear to be a Minecraft server running on your local machine.

   ```bash
   $ coffee proxy/connect.coffee my-app-name.herokuapp.com
   ```

6. **Leave the terminal window open** and launch Minecraft. Add a new server with the address `localhost`. Hit connect and play! When you're done playing, close the terminal window.

## Credits

Much of the original Heroku setup by [Jacob Gillespie](https://github.com/jacobwgillespie).

Updates, refactoring, and the WebSockets proxying by [Wil Gieseler](https://github.com/wilg).
