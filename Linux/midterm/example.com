; Start of Authority (SOA) record

$TTL    604800
@       IN      SOA     ns1.example.com. admin.example.com. (
                              4         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

; name servers - NS records


    IN      NS      ns1.example.com.
    IN      NS      ns2.example.com.

; name servers - A records


ns1.example.com.          IN      A      10.10.10.2
ns2.example.com.          IN      A      10.10.10.3

; Hosts - A records


windows2016.example.com.    IN      A      10.162.0.2
ubuntu1804.example.com.		IN      A      10.162.0.3