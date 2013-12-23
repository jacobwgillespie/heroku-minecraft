# Heroku Minecraft

**You can't run a Minecraft server on Heroku**. This is because Heroku has removed TCP routing from their platform. [Here's the old heroku-routing labs feature that no longer works.](https://github.com/JacobVorreuter/heroku-routing)

This app currently works in every way except actually being able to connect to the server. It runs the Minecraft server, syncs data to S3, and everything, but you can't get the server packets through Heroku's routing mesh.

**If you have any idea how to get TCP routing to work through Heroku, open an issue!** (I've tried using the websockets labs feature but I didn't get that far.)

Here's how this would work if that feature was re-enabled:

## Setup

1. Clone this repository.
2. Create a new Heroku app with a custom buildpack.

   ```
   heroku create my-app-name --buildpack https://github.com/ddollar/heroku-buildpack-multi.git
   ```
   
3. Add your Amazon AWS credentials so that the server data can be synced to S3.

   ```
   heroku config:add AWS_KEY=xxxxxxx AWS_SECRET=yyyyyyyyyyyyyyyyy S3_BUCKET=my-bucket-name
   ```
   
   
4. Push the app to Heroku.

   ```
   git push heroku master
   ```
   
5. Scale the app.

   ```
   heroku scale server=1
   ```

6. Access the server in minecraft with at the address `my-app-name.herokuapp.com`.

## Contributing

Please figure out how to get TCP connections through Heroku's routing mesh and tell me how, or submit a pull request!
