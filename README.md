# docker-based-labs
Ability to give out lab-env to users(docker-containers) as personal-machines

### Goal:
Distribute/Hand-out independent virtual envs to different users out of a single machine(on-prem, VM or cloud)  
 - Each users' env is a docker container
 - Users share resources of same host VM (CPU, Memory, Network)
 - Users able to access env from SSH
 - Users completely own their env, root access inside container
 - Container is based on SSH login user name

### STEPS:
[PreReq]: SSH access to host, Docker installed on host, list of candidates/users needing envs/labs.
 1. [Optional] Move HOST SSH PORT from 22 to 2222
 2. Setup a top level directory to store users' files.  
    I have done this on /users/home  
    I have 3 folders created under /users/home > joe, john, jony
 4. Clone this repo
 5. [Optional] Change Dockerfile as per needs of base image  
    These would be the things that the env will come pre-built with.
 6. Run `./install_all.sh`  
    I have used LDAP based mechanism to authicate my users, you can change that in last line (docker run env vars) of install.sh  
    Refer [this](https://github.com/maxivak/docker-ssh#quick-start) or[this](https://github.com/jeroenpeeters/docker-ssh#user-authentication) for details.
 7. Now you should see each users container created (`docker ps`) and one additional for SSH.
 8. Each user may now login to thier env with ssh: `ssh john@host`  
    Change `john` with that user's name, Change `host` to your host VM fqdn/ip.  
 9. Feel free to access SSH over Browser at `http://host:8022`
### Credits:
This is adapted from [Docker-SSH](https://github.com/jeroenpeeters/docker-ssh) and [fork](https://github.com/maxivak/docker-ssh).
