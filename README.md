# The DNS

Run a public AdGuardHome DNS-sinkhole on AWS infrastructure.

Based on articles (but automated for deployment on AWS with Terraform):

- <https://adguard-dns.io/kb/adguard-home/getting-started/>
- <https://adguard.com/en/blog/in-depth-review-adguard-home.html>
- <https://adguard.com/en/blog/adguard-home-on-public-server.html>
- <https://go-acme.github.io/lego/usage/cli/obtain-a-certificate/index.html>
- <https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html>

## AdGuardHome Commands - Reminder

Go to installation directory:

```sh
cd /opt/adguard
```

Start or stop `AdGuardHome` service:

```sh
./AdGuardHome -s start
./AdGuardHome -s stop
./AdGuardHome -s status
```

## Encryption

Make sure port 80 is available before running `lego`. Either move the `AdGuardHome` HTTP server to a different port or temporarily disable it.

Download and install `lego`:

```sh
mkdir /opt/lego
cd /opt/lego

wget "https://github.com/go-acme/lego/releases/download/v4.27.0/lego_v4.27.0_linux_amd64.tar.gz" # update version
tar -xzf lego_v4.27.0_linux_amd64.tar.gz
```

Obtain certificate:

```sh
./lego --email="dns@sskender.com" --domains="dns.sskender.com" --http run
```

Renew certificate:

```sh
./lego --email="dns@sskender.com" --domains="dns.sskender.com" --http renew
```

## TODO

- [ ] Automate `lego` certificate renewal
- [ ] Automate installation on server
- [ ] Add secondary server for high availability
