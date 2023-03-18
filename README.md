# Mortomuitolouco
[![License](https://img.shields.io/badge/license-MIT-red.svg)](https://github.com/bruzistico/mortomuitolouco/blob/main/LICENSE.md) [![Version](https://img.shields.io/badge/Release-1.0-red.svg?maxAge=259200)]() [![Build](https://img.shields.io/badge/Supported_OS-Linux-yellow.svg)]()  [![Build](https://img.shields.io/badge/Supported_WSL-Windows-blue.svg)]() [![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/bruzistico/mortomuitolouco/issues) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/donate/?hosted_button_id=E79FWLM24RKTW)

### What to do with domains/subdomains that don't resolve anywhere?

This tool was developed with the main purpose of finding the IP of "dead" domains/subdomains that:

- Doesn't resolve anywhere [no publicly linked IPs]
- Resolve for private block IPS, but share public virtual host
- Among others misconfiguration

<p align="center">
<img width="780" align="center" alt="mortomuitolouco" class="center" src="https://user-images.githubusercontent.com/90929569/226084576-a9f16084-555a-4e9e-a408-8a5d5b57c359.png">
</p>

To better understand what a virtual host is, access [here](https://httpd.apache.org/docs/2.4/vhosts/examples.html)

## Usage modes
<p align="center">
<img align="center" alt="mortomuitolouco" class="center" src="https://user-images.githubusercontent.com/90929569/226084915-cfe5454f-d0a6-4ea4-902e-7804c3e79c9b.png">
</p>

```
Options:
  -s,  --subdomain	 Scan only one target subdomain/domain (e.g subdomain.example.com)
  -sL, --subdomain-list	 Scan multiple targets in a text file 
  -i,  --ip		 Scan only one virtual host IP (e.g 192.168.0.10)
  -iL, --ip-list	 Scan multiple virtual host IP in a text file
  -o,  --output		 Output (eg. output.txt)
  -v,  --verbose	 Verbose
  -h,  --help		 Help [Usage]

 Basic usage:

  ./mortomuitolouco.sh -s subdomain.example.com -i 192.168.0.10
  ./mortomuitolouco.sh -s subdomain.example.com -iL listips.txt
  ./mortomuitolouco.sh -sL subdomainlist.txt -i 192.168.0.10
  ./mortomuitolouco.sh -sL subdomainlist.txt -iL listip.txt
  ./mortomuitolouco.sh -sL subdomainlist.txt -iL listip.txt -o result.txt
  ./mortomuitolouco.sh -sL subdomainlist.txt -iL listip.txt -o result.txt -v

 [INFO] It is mandatory to inform Dead targets [-s or -sL] and IP targets [-i or -iL]

```
Example usage


https://user-images.githubusercontent.com/90929569/226085115-9f1bc4ad-a2f5-4c01-b2aa-e06eee647d7f.mp4



## Tips

- Search for IP [ASN] targets related to the company that owns the domain
 - Avoid using WAF and Load Balance IPs (These targets can generate a lot of false positives due to their behavior)
 - Still undergoing improvements in shared cloud environments


## What to do after finding the correct IPS?

You can change your local host file to force dns resolution in:

- Linux: /etc/hosts
- Windows: C:\Windows\System32\Drivers\etc\hosts 

example:

```
44.201.229.201 dead.bruzistico.com
```

### Change in Burp Suite

Settings >> Network >> Connections >> Hostname resolution overrides

![mml_2](https://user-images.githubusercontent.com/90929569/226085282-8359ab26-d972-4778-a0b3-e5a72ea7d1f1.png)

## To Do [Implementation]:

- Add port options other than the defaults 80,443 [list via command and via file]
- [CIDR] IP ranges and blocks via command line [Eg. 200.54.20.0/24, 200.54.20.10-15]
- Direct queries from ASN
- More file output options [output]


## Thanks

- [Leandro Carvalho](https://github.com/skateforever) - Skateforever
