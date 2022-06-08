%{ for s in nameservers ~}
nameserver ${s}
%{ endfor ~}