# ivacy-ovpn
OpenVPN client for Ivacy VPN for Linux

## Install

* Download Ivacy OpenVPN archive file from Ivacy VPN [download page](https://support.ivacy.com/vpnusecases/openvpn-files-windows-routers-ios-linux-and-mac/)

```shell
wget https://ivacy.s3.amazonaws.com/support/OpenVPN-Configs.rar
```

* Extract the files from `rar` archive

```shell
unrar x https://ivacy.s3.amazonaws.com/support/OpenVPN-Configs.rar
cd OpenVPN-Configs
```

* Download this shell (bash) script

```shell
wget https://github.com/eduard-haritonov/ivacy-ovpn/raw/main/ivacy-ovpn.sh
chmod +x ivacy-ovpn.sh
```

* Get `sudo` permission to run `openvpn` utility as `root` user


## Usage

* Run the script and select a country (enter country number from provided prompt)

```shell
./ivacy-ovpn.sh
Q -- quit

== Protocol (UDP) ==
U -- protocol: UDP
T -- protocol: TCP
R -- protocol: random TCP or UDP

1) Australia		   8) Czech Republic	    15) Japan		      22) Norway		29) South Korea		  36) United Arab Emirates
2) Austria		   9) Denmark		    16) Luxembourg	      23) Panama		30) Spain		  37) United Kingdom
3) Belgium		  10) France		    17) Malaysia	      24) Philippines		31) Sweden		  38) United States
4) Brazil		  11) Germany		    18) Mexico		      25) Poland		32) Switzerland
5) Brunei		  12) Hong Kong		    19) Netherlands	      26) Russia		33) Taiwan
6) Bulgaria		  13) India 		    20) New Zealand	      27) Singapore		34) Turkey
7) Canada		  14) Italy		    21) Nigeria		      28) South Africa		35) Ukraine
#? 38
-- Country: United States
-- [Press Ctrl+C to interrupt VPN] --
-- File used: United States-WashingtonDC-UDP.ovpn ...
........
2022-02-15 16:48:18 Initialization Sequence Completed
```

* Use Ctrl+C key to quit from OpenVPN. Choose TCP protocol if UDP is not available for your ISP.

* Have a fun with Ivacy OpenVPN!
