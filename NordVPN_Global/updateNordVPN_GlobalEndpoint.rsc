/system script run "JParseFunctions"; global JSONLoad; global JSONLoads; global JSONUnload
:local apiurl "https://api.nordvpn.com/v1/servers/recommendations?filters[servers_technologies][identifier]=wireguard_udp&limit=1"
:local data [/tool fetch url=$apiurl mode=https as-value output=user]
:local parsedData [ $JSONLoads ($data->"data") ]
:local hostname ($parsedData->0->"hostname")
:local publickey ""
:foreach item in=($parsedData->0->"technologies") do={
  :local id ($item->"identifier");
  :if ($id = "wireguard_udp") do={
    :set publickey ($item->"metadata"->0->"value");
  }
}
/interface/wireguard/peers set [find comment="NordVPN_Global"] public-key=$publickey endpoint-address=$hostname