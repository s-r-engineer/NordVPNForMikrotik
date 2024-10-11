This block is to deploy NordVPN wireguard client with general VPN access.

### How to get private key
1. You need wireguard-tools to be installed in linux or wireguard client to be installed on mac or windows.
2. You need official NordVPN cliennt authenticated
3. Connect to nordvpn
4. in console/terminal/cmd/powershell run command `wg show nordlynx private-key` **NB!** interface name can be capitalized a little like NordLynx. If in doubt run `wg show`to see intrface name. **NB!** in linux/mac add sudo in the beginning of the command and follow instructions
5. The result of the kommand is your private key.


### VPN deployment
Run this in mikrotik's console after pasting your private key into wireguard interface.
* Do not worry about peer's address and public key. It will be updated with correct ones later.
* You would like to update addresses for the firewall rules if you are not using default Mikrotik network which is 192.168.88.0/24

```
#interface
/interface wireguard add comment="NordVPN_Global" disabled=yes name=NordVPN_Global private-key="your private key here"
#peer
/interface wireguard peers add allowed-address=0.0.0.0/0 disabled=yes comment="NordVPN_Global" endpoint-address=someunknown.nordvpn.com endpoint-port=51820 interface=NordVPN_Global name=NordVPN_Global public-key="K53l2wOIHU3262sX5N/5kAvCvt4r55lNui30EbvaDlE="
#ip address
/ip address add address=10.5.0.2 comment="NordVPN_Global" disabled=yes interface=NordVPN_Global network=10.5.0.2
#firewall forward
/ip firewall filter add action=accept chain=forward comment="NordVPN_Global" disabled=yes out-interface=NordVPN_Global src-address=192.168.88.0/24 place-before=0
/ip firewall filter add action=accept chain=forward comment="NordVPN_Global" connection-state=established,related disabled=yes dst-address=192.168.88.0/24 in-interface=NordVPN_Global place-before=0
/ip firewall filter add action=drop chain=forward comment="NordVPN_Global" disabled=yes in-interface=NordVPN_Global place-before=0
#firewall nat
/ip firewall nat add action=masquerade chain=srcnat comment="NordVPN_Global" disabled=yes out-interface=NordVPN_Global
#ip route
/ip route add comment="NordVPN_Global" disabled=yes distance=1 dst-address=0.0.0.0/0 gateway=NordVPN_Global pref-src=""
```

Next you need to create scripts.

First is **JParseFunctions** (taken from https://github.com/Winand/mikrotik-json-parser/). Find it in file `JParseFunctions.rsc`. You will need it to read response from NordVPN API

Second is **toggleNordVPN_Global**. It will switch VPN on and off when you'll need it. Find it in file `toggleNordVPN_Global.rsc`

Third is **updateNordVPN_GlobalEndpoint**. It will query NordVPN API in order to find recommended server and update peer accordingly.

### Notes
* **updateNordVPN_GlobalEndpoint** script exist because I am often having issues with speed and connection stability which this script will fix.
* I find it convinient to use aliases like `alias updateEndpoint='ssh user@192.168.88.1 /system script run updateNordVPN_GlobalEndpoint'`
* From time to time you'll need to update own private key in WireGuard interface. Sequence is the same as for deployemnt (described in **How to get private key**). Do it in Winbox/Web/Console with command `/interface/wireguard/ set private-key=YourPrivateKeyHere [find comment="NordVPN_Global"]`