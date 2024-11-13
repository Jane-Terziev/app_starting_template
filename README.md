# Instructions

Replace AppName and app_name with your app name.

## Starting the app

```
docker compose build
docker compose run --rm app bundle exec rake db:create db:migrate
docker compose run --rm app bundle exec rake assets:precompile
docker compose up
```

## Setting up Kamal with AWS EC2
Setting up deployment with Kamal to AWS EC2 comes with a couple of steps:
1. Creating the AWS EC2 instance with a SSH Key Pair and installing docker
2. Setting the github actions secrets
3. Creating an account on dockerhub for pushing and pulling the docker images

### Creating an EC2 Instance
When you create the EC2 instance on AWS, make sure you select "Generate a new key pair".
This will automatically download a .pem file. If you want to deploy locally, you can store the file
at ssh/ec2-ssh-key.pem. This will allow you to just write <code>kamal deploy</code> in the terminal.

Then, you will need to modify the inbound and outbound traffic to the EC2 instance, set **SSH**, **HTTP** and **HTTPS** rules.
After that, you can connect to it locally with <code>ssh -i ssh/ec2-ssh-key.pem ec2-user@your-ec2-public-ip</code>, 
or through the AWS console EC2 page.

Next, install docker:
```shell
sudo su
yum update -y && yum install docker -y && service docker start && usermod -a -G docker ec2-user
```

Copy <code>your-ec2-public-ip</code> and replace <code>54.93.63.162</code> inside the config/deploy.yml file with it.

### Dockerhub
Create a Dockerhub account and create a private repository.
Replace janeterziev2 inside of config/deploy with your dockerhub username.

### Github Secrets
Go to your Github repository and add all the secrets mentioned in the ***.env_sample*** file. Additionally, you will need to 
add the <code>ec2-ssh-key.pem</code> content to a secret called ***EC2_SSH_KEY*** in order for us to be able to connect 
to the EC2 instance through github actions.

### Deploy
Now, you should be able to deploy either from locally with <code>kamal deploy</code> or with github actions on push on 
main branch.

## Generating new engine

```ruby
rails g engine engine_name
```