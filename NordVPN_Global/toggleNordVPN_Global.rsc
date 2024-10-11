:local isDisabled [/interface/wireguard/get [find comment="NordVPN_Global"] disabled]

:if ($isDisabled = true) do={
    /interface/wireguard/peers/enable [find comment="NordVPN_Global"]
    /interface/wireguard/ enable [find comment="NordVPN_Global"]
    /ip/firewall/nat/ enable [find comment="NordVPN_Global"]
    /ip/firewall/filter enable [find comment="NordVPN_Global"]
    /ip/address/ enable [find comment="NordVPN_Global"]
    /ip/route/ enable [find comment="NordVPN_Global"]
} else={
    /interface/wireguard/ peers disable [find comment="NordVPN_Global"]
    /interface/wireguard/ disable [find comment="NordVPN_Global"]
    /ip/firewall/nat/ disable [find comment="NordVPN_Global"]
    /ip/firewall/filter disable [find comment="NordVPN_Global"]
    /ip/address/ disable [find comment="NordVPN_Global"]
    /ip/route/ disable [find comment="NordVPN_Global"]
}
