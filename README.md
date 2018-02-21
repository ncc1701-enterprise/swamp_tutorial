## introduction

If you follow this howto you will be able to host an own live stream that can be added to the Cinema gamemode. I want this to be possible for everyone, even if you don't have a clue about linux or servers. However you can still go the Exstor way and use www.ustream.tv or other services that basically do the same but charge you more or display ads.

## prerequisites

For this to work you need a small cloud server with decent connectivity and probably a second computer as source for your stream.

```
VPS specs
* operating system: Debian 9 x64
* CPU: 1-2 core
* RAM: 128MB or more
* Network: 1Gbit shared
```

### where to rent a cloud server?

[DigitalOcean](https://www.digitalocean.com/) - First choice, add your paypal or CC and deploy a 5$/month instance. Free 50$ credit if you're a student via [GitHub](https://education.github.com/pack). There are other vouchers that give you free credit too, just google for them.  
[BuyVM](https://buyvm.net/kvm-dedicated-server-slices) - 3.50$/month, no promotions but quality hosting  
[Hetzner](https://www.hetzner.com/cloud) - 2.49€/month (if you're located outside EU), however they want you to send a copy of your ID to verify your account  
[OVH/kimsufi](https://www.kimsufi.com/us/en/) - 4.47$/month



## getting your computer ready to manage a server

I guess that you're using Windows as operating system on your local computer. To be able to connect to a server via SSH we need two handy tools that don't require any installation. Just download the executables and place them anywhere on your harddisk.

[download putty](https://the.earth.li/~sgtatham/putty/latest/w32/putty.exe)  
[download puttygen](https://the.earth.li/~sgtatham/putty/latest/w32/puttygen.exe)

_putty quick start quide: use right mouse to paste your clipboard, use the tab key to auto-complete filenames_  
TODO

## setting up your server

Now that you are connected to your server we are ready to set things up. You can copy paste all commands. First we need to update our package lists and upgrade all preinstalled software.

`apt-get update && apt-get upgrade -y`

Here is what it should look like
![](https://i.imgur.com/gKk8P5E.jpg)

Now we install nano: a simple commandline text editor that works well with putty and htop: a commandline task manager

`apt-get install nano htop unzip -y`

Again we will install software, now the gcc compiler and some libraries that are needed to compile nginx.

```apt-get install gcc make build-essential libpcre3 libpcre3-dev libc6 libssl-dev zlib1g zlib1g-dev lsb-base openssl -y```

We're now ready to download nginx and the rtmp module, which is the piece of software that we're actually interested in. Before that we create a new directory called "nginx_temp" and move into it.

```
mkdir nginx_temp
cd nginx_temp
wget http://nginx.org/download/nginx-1.13.9.tar.gz
wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
tar xfv nginx-1.13.9.tar.gz
unzip master.zip
rm nginx-1.13.9.tar.gz
rm master.zip
```

Now that we've downloaded anything, we need to compile nginx. Luckily developers include a script that does most of the work for us by default.

```cd nginx-1.13.9
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
make
make install
/usr/local/nginx/sbin/nginx
```

Nginx is now up and running, verify by typing the IP adress of your server into a browser. It should look like here:
![](https://i.imgur.com/3CJ0ZnM.jpg)  
As nginx says we need to edit the configuration to fit our needs. This will be done with the text editor nano.   
_nano quick start guide: use CTRL+C then y then RETURN to close and save changes. Change y to n if you don't want to save._

`nano /usr/local/nginx/conf/nginx.conf`

Now use CTRL+V to scroll to the bottom and paste the following at the end of file, close and save like described above.

```
rtmp {
        server {
                listen 1935;
                chunk_size 4096;

                application live {
                        live on;
                        record off;
                }
        }
}
```

Now restart nginx to load your new configuration

```
/usr/local/nginx/sbin/nginx -s stop
/usr/local/nginx/sbin/nginx
```

We're finished with the server now. You can type htop and press enter to watch the cpu load while you test the stream.
You need to edit the following link to fit your servers IP adress, then you can paste it in the chat while standing in a cinema to add your stream to the queue.

`rtmp://<server ip>:1935/live/test`

## setting up your source with Open Broadcaster

In your OBS paste the following under 'stream' in settings

```
URL: rtmp://<server ip>:1935/live
key: test
```
