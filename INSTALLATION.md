# Installation of Managetech Dashboard

## Prerequisites
- Ruby version 3.1.2
- Rails version 7.0.2.4
- Vue 3.0
- Redis
- PostgreSQL Database

## Local setup

### Rails Application

Move to `/managetech` directory and set up Rails application.

Create a `.env` file and edit the variables in the `.env` file.

```bash
cp .env.example .env
```

Install gems by running the command below.

```bash
bundle install
```

Configure the database setting at `/managetech/config/database.yml` and then migrate the tables into the database.

```bash
rails db:migrate
```

We're using the `foreman` tool to run the app. Run the Rails API backend using the `foreman` tool.

```bash
foreman start -f Procfile.dev
```

The Rails application will be running at http://localhost:8020

### Vue Application

Move to `/frontend` directory and set up Vue.JS frontend.

Create a `.env` file and edit the variables in the `.env` file.

```bash
cp .env.example .env
```

Install NPM packages using Yarn package manager.

```bash
yarn install
```

Run the Vue.js Dashboard frontend.

```bash
yarn run serve
```

The Vue application will be running at http://localhost:8080

## Production Set up

### Creating a Deploy user

To run software on our server, we're going to create a deploy user. The deploy user has limited permissions in production to help prevent anyone from getting full control of our server if a hacker broke into our server.

While logged in as `root` on the server, we can run the following commands to create the deploy user and add them to the sudo group.

```bash
adduser deploy
adduser deploy sudo
exit
```

Next let's add our SSH key to the server to make it faster to login. We're using a tool called `ssh-copy-id` for this.

If you're on a Mac, you may need to install ssh-copy-id with homebrew first: `brew install ssh-copy-id`

```bash
ssh-copy-id root@1.2.3.4
ssh-copy-id deploy@1.2.3.4
```

Now you can login as either `root` or `deploy` without having to type in a password!

For the rest of this tutorial, we want to be logged in as `deploy` to set up everything. Let's SSH in as deploy now and we shouldn't be prompted for a password this time.

```bash
ssh deploy@1.2.3.4
```

### Installing Ruby

We're going to be installing Ruby using a ruby version manager. You're probably using one in development, but this is also handy in production so it allows you to upgrade the Ruby version in production quickly.

The first step is to install some dependencies for compiling Ruby as well as some Rails dependencies.

To make sure we have everything necessary for Webpacker support in Rails, we're first going to start by adding the Node.js and Yarn repositories to our system before installing them.

We're also going to install Redis so we can use ActionCable for websockets in production as well. You might also want to configure Redis as your production store for caching.

Make sure you're logged in as the `deploy` user on the server, and run the following commands:

```bash
# Adding Node.js repository
curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# Adding Yarn repository
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo add-apt-repository ppa:chris-lea/redis-server

# Refresh our packages list with the new repositories
sudo apt-get update

# Install our dependencies for compiling Ruby along with Node.js and Yarn
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg apt-transport-https ca-certificates redis-server redis-tools nodejs yarn
```

Yay! Now that we have our dependencies installed, we can begin installing Ruby.
Choose the version of Ruby you want to install: In our project we used Ruby 3.1.2.

Next we're going to install Ruby using a Ruby version manager called `rbenv`. It is the easiest and simplest option, plus it comes with some handy plugins to let us easily manage environment variables in production.

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

echo 'eval "$(rbenv init -)"' >> ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars

exec $SHELL

rbenv install 3.2.2

rbenv global 3.2.2

ruby -v
# ruby 3.2.2
```

The last step is to install Bundler:
```bash
# This installs the latest Bundler, currently 2.x.
gem install bundler

# For older apps that require Bundler 1.x, you can install it as well.
gem install bundler -v 1.17.3

# Test and make sure bundler is installed correctly, you should see a version number.
bundle -v
# Bundler version 2.0
```

If it tells you bundle not found, run `rbenv rehash` and try again.

### Installing NGINX & Passenger

For production, we'll be using NGINX as our webserver to receive HTTP requests. Those requests will then be handed over to Passenger which will run our Ruby app.

Installing Passenger is pretty straightforward. We'll add their repository and then install and configure their packages.

```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger $(lsb_release -cs) main > /etc/apt/sources.list.d/passenger.list'

sudo apt-get update

sudo apt-get install -y nginx-extras libnginx-mod-http-passenger
if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

sudo ls /etc/nginx/conf.d/mod-http-passenger.conf
```
Now that we have NGINX and Passenger installed, we need to point Passenger to the correct version of Ruby.

We'll start by opening up the Passenger config file in your favorite editor, `nano` or `vim`

```bash
# If you want to use the Nano for editing
sudo nano /etc/nginx/conf.d/mod-http-passenger.conf

# If you want to use the Vim for editing
sudo vim /etc/nginx/conf.d/mod-http-passenger.conf
```
We simply want to change the `passenger_ruby` line to match the following:

```bash
passenger_ruby /home/deploy/.rbenv/shims/ruby;
```
Save this file and we'll start NGINX.

```bash
sudo service nginx start
```
You can check and make sure NGINX is running by visiting your server's public IP address in your browser and you should be greeted with the "Welcome to NGINX" message.

Next we're going to remove this default NGINX server and add one for our application instead.

```bash
sudo rm /etc/nginx/sites-enabled/default

# If you want to use the Nano for editing
sudo nano /etc/nginx/sites-enabled/myapp

# If you want to use the Vim for editing
sudo vim /etc/nginx/sites-enabled/myapp
```
We want the contents of our NGINX site to look like the following.

Change `myapp` to the name of your app. We'll use this same folder later on when we define our Capistrano `deploy_to` folder.

```bash
server {
  listen 80;
  listen [::]:80;

  server_name _;
  root /home/deploy/myapp/current/public;

  passenger_enabled on;
  passenger_app_env production;

  location /cable {
    passenger_app_group_name myapp_websocket;
    passenger_force_max_concurrent_requests_per_process 0;
  }

  # Allow uploads up to 100MB in size
  client_max_body_size 100m;

  location ~ ^/(assets|packs) {
    expires max;
    gzip_static on;
  }
}
```
Save the file and then we'll reload NGINX to load the new server files.
```bash
sudo service nginx reload
```

### Creating a PostgreSQL Database

For Postgres, we're going to start by installing the Postgres server and libpq which will allow us to compile the pg rubygem.

Then, we're going to become the `postgres` linux user who has full access to the database and use that account to create a new database user for our apps. We'll call that user `deploy`.

And finally, the last command will create a database called `myapp` and make the `deploy` user owner.

Make sure to change `myapp` to the name of your application.

```bash
sudo apt-get install postgresql postgresql-contrib libpq-dev

sudo su - postgres

createuser --pwprompt deploy

createdb -O deploy myapp

exit
```
You can manually connect to your database anytime by running `psql -U deploy -W -h 127.0.0.1 -d myapp`. Make sure to use `127.0.0.1` when connecting to the database instead of localhost.

