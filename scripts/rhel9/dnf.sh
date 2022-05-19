#!/bin/bash

# Check whether the install media is mounted, and if necessary mount it.
if [ ! -d /media/BaseOS/ ] || [ ! -d /media/AppStream/ ]; then
  mount /dev/cdrom /media || (printf "\nFailed mount RHEL cdrom.\n"; exit 1)
fi

# Setup the install DVD as the dnf repo location.
cat <<-EOF > /etc/yum.repos.d/media.repo
[rhel9-base-media]
name=rhel9-base
baseurl=file:///media/BaseOS/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-beta

[rhel9-appstream-media]
name=rhel9-appstream
baseurl=file:///media/AppStream/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF

# Import the Red Hat signing key.
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-beta
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

# Setup the EPEL repo.
base64 --decode > epel-release-9-2.el9.noarch.rpm <<-EOF
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
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+AAAAB////3AAAAAQAAAA
AI6t6AEAAAAAAAAAQQAAC4UAAAA/AAAABwAAC3UAAAAQAAAAZAAAAAgAAAAAAAAAAQAAA+gAAAAG
AAAAAgAAAAEAAAPpAAAABgAAAA8AAAABAAAD6gAAAAYAAAARAAAAAQAAA+wAAAAJAAAAFwAAAAEA
AAPtAAAACQAAAFQAAAABAAAD7gAAAAQAAADQAAAAAQAAA+8AAAAGAAAA1AAAAAEAAAPxAAAABAAA
AQAAAAABAAAD8gAAAAYAAAEEAAAAAQAAA/MAAAAGAAABEwAAAAEAAAP2AAAABgAAASIAAAABAAAD
9wAAAAYAAAEoAAAAAQAAA/gAAAAJAAABNwAAAAEAAAP8AAAABgAAAUMAAAABAAAD/QAAAAYAAAFu
AAAAAQAAA/4AAAAGAAABdAAAAAEAAAQEAAAABAAAAXwAAAAGAAAEBgAAAAMAAAGUAAAABgAABAkA
AAADAAABoAAAAAYAAAQKAAAABAAAAawAAAAGAAAECwAAAAgAAAHEAAAABgAABAwAAAAIAAADCgAA
AAYAAAQNAAAABAAAAxAAAAAGAAAEDwAAAAgAAAMoAAAABgAABBAAAAAIAAADRgAAAAYAAAQUAAAA
BgAAA2QAAAABAAAEFQAAAAQAAAOEAAAABgAABBcAAAAIAAADnAAAAAIAAAQYAAAABAAAA8AAAAAH
AAAEGQAAAAgAAAPcAAAABwAABBoAAAAIAAAEfgAAAAcAAAQdAAAABAAABLAAAAABAAAEHgAAAAgA
AAS0AAAAAQAABB8AAAAIAAAEwwAAAAEAAAQoAAAABgAABMQAAAABAAAEOAAAAAQAAATQAAAACAAA
BDkAAAAIAAAE8AAAAAgAAAQ6AAAACAAABi0AAAAIAAAERwAAAAQAAAd4AAAABgAABEgAAAAEAAAH
kAAAAAYAAARJAAAACAAAB6gAAAAGAAAEWAAAAAQAAAewAAAAAgAABFkAAAAIAAAHuAAAAAIAAARc
AAAABAAAB8gAAAAGAAAEXQAAAAgAAAfgAAAABgAABF4AAAAIAAAILwAAAAUAAARiAAAABgAACKoA
AAABAAAEZAAAAAYAAAoUAAAAAQAABGUAAAAGAAAKGQAAAAEAAARmAAAABgAACh4AAAABAAAEbAAA
AAYAAAohAAAAAQAABHQAAAAEAAAKPAAAAAYAAAR1AAAABAAAClQAAAAGAAAEdgAAAAgAAApsAAAA
AwAAE5MAAAAEAAAKhAAAAAEAABOUAAAABgAACogAAAABAAATtgAAAAgAAAq0AAAAAQAAE7cAAAAI
AAAK4QAAAAEAABO4AAAABAAACuQAAAABAAATxgAAAAYAAAroAAAAAQAAE+QAAAAIAAAK7gAAAAEA
ABPlAAAABAAACzAAAAABAAAT6QAAAAgAAAs0AAAAAUMAZXBlbC1yZWxlYXNlADkAMi5lbDkARXh0
cmEgUGFja2FnZXMgZm9yIEVudGVycHJpc2UgTGludXggcmVwb3NpdG9yeSBjb25maWd1cmF0aW9u
AFRoaXMgcGFja2FnZSBjb250YWlucyB0aGUgRXh0cmEgUGFja2FnZXMgZm9yIEVudGVycHJpc2Ug
TGludXggKEVQRUwpIHJlcG9zaXRvcnkKR1BHIGtleSBhcyB3ZWxsIGFzIGNvbmZpZ3VyYXRpb24g
Zm9yIHl1bS4AAABhp/1+YnVpbGR2bS1wcGM2NGxlLTA1LmlhZDIuZmVkb3JhcHJvamVjdC5vcmcA
AAAAAFtiRmVkb3JhIFByb2plY3QARmVkb3JhIFByb2plY3QAR1BMdjIARmVkb3JhIFByb2plY3QA
VW5zcGVjaWZpZWQAaHR0cDovL2Rvd25sb2FkLmZlZG9yYXByb2plY3Qub3JnL3B1Yi9lcGVsAGxp
bnV4AG5vYXJjaAAAAAAGeAAABhAAAAWtAAAA7gAAAAAAAEg/gaSBpIGkgaRB7YGkAAAAAAAAAAAA
AAAAYaf9SGGn/Uhhp/1IYaf9SGGn/X5hp/1IZmNmMGVhYjRmMDVhMWMwZGU2MzYzYWM0YjcwNzYw
MGEyN2E5ZDc3NGU5YjQ5MTA1OWU1OWU2OTIxYjI1NWE4NABkMGVmM2U4MGRmZmRlNmU1MjFhMWQw
NTIxNjE1MWE4ODYzOTI5ZjNlNDBhMGMzNDU5MTQ1Y2Y5Nzg2MjUzYzVhADllOWUwYzBhYTczY2Zl
OWMxYmVkN2QxYmVlMDA2MWJkODY3OTIyYWMwNDNiZmZjMmEyMDZlZjg5Mjk1NzUzNzgAN2Q5ODAz
YTM4ZjI1YWZkYjcxNjVhMDc2Y2NmOWZlNTA4Mzk2OGNhMTNhMTBkNjkzOTRjMmU2MjY4YWQ4NjQy
OQAAOTMxY2NmMzRlODUxN2ZjYWEwOWEzYWM1NDIzOTUyNmVkZDgxOWNhZWU4NGRiZTI4NDc2ZTg0
NDFkYjQzMGZiNgAAAAAAAAAAAAAAAAAAEQAAABEAAAAAAAAAAAAAAIByb290AHJvb3QAcm9vdABy
b290AHJvb3QAcm9vdAByb290AHJvb3QAcm9vdAByb290AHJvb3QAcm9vdABlcGVsLXJlbGVhc2Ut
OS0yLmVsOS5zcmMucnBtAAAAAP///////////////////////////////2NvbmZpZyhlcGVsLXJl
bGVhc2UpAGVwZWwtcmVsZWFzZQAAABAAAAgAAAAMAQAACgEAAAoBAAAKAQAACgEAAApjb25maWco
ZXBlbC1yZWxlYXNlKQByZWRoYXQtcmVsZWFzZQBycG1saWIoQ29tcHJlc3NlZEZpbGVOYW1lcykA
cnBtbGliKEZpbGVEaWdlc3RzKQBycG1saWIoUGF5bG9hZEZpbGVzSGF2ZVByZWZpeCkAcnBtbGli
KFBheWxvYWRJc1pzdGQpAHJwbWxpYihSaWNoRGVwZW5kZW5jaWVzKQA5LTIuZWw5ADkAMy4wLjQt
MQA0LjYuMC0xADQuMC0xADUuNC4xOC0xADQuMTIuMC0xAAAAAABmZWRvcmEtcmVsZWFzZQAANC4x
Ni4xLjMAAAAAYadjwGFgMsBhMg5AYQPpwGC4xEBfy3ZAX51RwF3zfUBDYXJsIEdlb3JnZSA8Y2Fy
bEBnZW9yZ2UuY29tcHV0ZXI+IC0gOS0yAENhcmwgR2VvcmdlIDxjYXJsQHJlZGhhdC5jb20+IC0g
OS0xAE1vaGFuIEJvZGR1IDxtYm9kZHVAYmh1amppLmNvbT4gLSA4LTEzAEtldmluIEZlbnppIDxr
ZXZpbkBzY3J5ZS5jb20+IC0gOC0xMgBDYXJsIEdlb3JnZSA8Y2FybEBnZW9yZ2UuY29tcHV0ZXI+
IC0gOC0xMQBLZXZpbiBGZW56aSA8a2V2aW5Ac2NyeWUuY29tPiAtIDgtMTAAS2V2aW4gRmVuemkg
PGtldmluQHNjcnllLmNvbT4gLSA4LTkATWVybGluIE1hdGhlc2l1cyA8bW1hdGhlc2lAcmVkaGF0
LmNvbT4gLSA4LTguZWw5AC0gRW5hYmxlIGVwZWw5IHJlcG8gZmlsZXMALSBJbml0aWFsIHBhY2th
Z2UgZm9yIGVwZWw5LW5leHQALSBDaGFuZ2UgdGhlIGJhc2V1cmwgdG8gcG9pbnQgdG8gc291cmNl
L3RyZWUgZm9yIHNycG1zAC0gRW5hYmxlIGNlcnRib3QtcmVuZXcudGltZXIgKCByaGJ6IzE5ODYy
MDUgKQAtIEFkZCBlcGVsLW5leHQtcmVsZWFzZSBzdWJwYWNrYWdlAC0gQWRkIHg1MDl3YXRjaC50
aW1lciBlbmFibGVkIGJ5IGRlZmF1bHQuIEZpeGVzIGJ1ZyAjMTkwMTcyMQAtIEFkZCBjb3VudG1l
IGZlYXR1cmUgZm9yIGVwZWwuIEZpeGVzIGJ1ZyAjMTgyNTk4NAAtIEFkZCBtb2R1bGFyIHJlcG9z
LgAAAAAAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAgAAAAMAAAAEAAAABQAAAAYAAAAA
AAAAABAAAAgAAAAIOS0yLmVsOQA5LTIuZWw5AAAAAAAAAAABAAAAAQAAAAIAAAADAAAABFJQTS1H
UEctS0VZLUVQRUwtOQBlcGVsLXRlc3RpbmcucmVwbwBlcGVsLnJlcG8AOTAtZXBlbC5wcmVzZXQA
ZXBlbC1yZWxlYXNlAEdQTAAvZXRjL3BraS9ycG0tZ3BnLwAvZXRjL3l1bS5yZXBvcy5kLwAvdXNy
L2xpYi9zeXN0ZW1kL3N5c3RlbS1wcmVzZXQvAC91c3Ivc2hhcmUvbGljZW5zZXMvAC91c3Ivc2hh
cmUvbGljZW5zZXMvZXBlbC1yZWxlYXNlLwAtTzIgLWZsdG89YXV0byAtZmZhdC1sdG8tb2JqZWN0
cyAtZmV4Y2VwdGlvbnMgLWcgLWdyZWNvcmQtZ2NjLXN3aXRjaGVzIC1waXBlIC1XYWxsIC1XZXJy
b3I9Zm9ybWF0LXNlY3VyaXR5IC1XcCwtRF9GT1JUSUZZX1NPVVJDRT0yIC1XcCwtRF9HTElCQ1hY
X0FTU0VSVElPTlMgLXNwZWNzPS91c3IvbGliL3JwbS9yZWRoYXQvcmVkaGF0LWhhcmRlbmVkLWNj
MSAtZnN0YWNrLXByb3RlY3Rvci1zdHJvbmcgLXNwZWNzPS91c3IvbGliL3JwbS9yZWRoYXQvcmVk
aGF0LWFubm9iaW4tY2MxICAtbTY0IC1tY3B1PXBvd2VyOSAtbXR1bmU9cG93ZXI5IC1mYXN5bmNo
cm9ub3VzLXVud2luZC10YWJsZXMgLWZzdGFjay1jbGFzaC1wcm90ZWN0aW9uAGNwaW8AenN0ZAAx
OQBub2FyY2gtcmVkaGF0LWxpbnV4LWdudQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAQAAAAEAAAABAAAAAgAAAAEAQVNDSUkgdGV4dABkaXJlY3RvcnkAAAAAAAAIaHR0cHM6Ly9i
dWd6LmZlZG9yYXByb2plY3Qub3JnL2VwZWwtcmVsZWFzZQAoZXBlbC1uZXh0LXJlbGVhc2UgaWYg
Y2VudG9zLXN0cmVhbS1yZWxlYXNlKQAAAAAAAAAAdXRmLTgAZWU3NjZkZDA4N2VhYmIzMjhjZjY4
NTlhNTRiMjQxNDM2ZGRmZGNiZTliNzM4NjhjMjEzOWYyNTRmMGU2YWM5ZQAAAAAACDUzNmZmMTNl
ZWQzZjBlOGQ4MjM4ZjZiZGUxNjgzNjkzNGE2YzE1M2RiMjlmMjUwYmMyMmRiZWYyMGY3Njk4ZjIA
AAAAPwAAAAf///vwAAAAECi1L/0AaOUQAQr8TDAtgIpQmgcYWyH70Zf4N1jQGOPOsTCTWSsEOAvJ
Ze6mhS72Omthus9hmHrDMKd6LQMHA8YC1tpgvJN9IogBPhogINbYwm283WjMSt6H4Qk/yejZHhqT
Ujo+igaOfOhcLNwUelSLPuL8QMEwhToSK7MwVfWJHvNUE+yjzAsjLaz0WaDRV1k+j5X5kBMOIyGj
30bWp/Iq4NUkMBYOpvLgSCCb81hSprj4TWweLPRNqold5HU5StUF8kAqI2JGsQmRHCKiJSmi5OJC
iYikUGmYBxkikaAK5rtEa8pCpEpn8SmpPFVWeSwJ56FzkoA1YULBGFrsNG55x8ZGfk44+3wgNUF5
PC4KWCeJHglYuS7TtSmR7qRPh4xFA1oOPhg0jjaNRPMNjlLFMJMGkJJVEj3DwQ2Y7oN1F43k8FFE
xaZgEjMHb4GwpuJ8oMm0mLATTkgUlUODRIsPjT9pPH92ZUVQQum8DjpYB6BSpWJVHcSWLFKjnBzV
5gdOeQHJzUem5vCZNBcQQ2edQbkwUwOzIR8USTVWQpYEcWeeyErgXAeb/SAFZ/Jh3hLdw2OrHnKJ
nI/DMTG6UTkQkqijsKOtgjdPDD0cWFAvRR4H1UFzsO+Zto2i65yVcejSQ0GClwv3sZa+jGiWmPto
YNgP5ZLBzgaDJCNLA6OBXOk0ahhHkUedPEQHW+cKi+cwipmCgWWV/y4ijAM70GykMUmJRSNUuXxC
yNYPVaXG+ZcTlyrskRDJ8ckXC+naFUaxp3LTIMfICXMiqPmwijBKiZWAZ//riIzsY8NdJu5JXGSp
cRTZaTFicPDEEX6O0uSg40lOjCq8hCwiS6QjOvC2h32ym5AhskxmaHM8UZKEHTIpJXA6EuJpSqO9
7OaFD9dBybNIODQPpISIYkkUeENG1hqGCtrC8Jy8jnbAMSbk6hYkkviHSxgv0SfvQS9AHNsobuTg
cjBZzMNnClXWZIGkhkvp0PnIBsYDhFS5lwWMhC7WHEcJLrI0rCgpKTKoZ66u1oSDzxGuhGEiUPT1
KuFYCXSZhC6k6OCzreqSbI7YuCqSDeYR58RYnIyEUgvLSD4d2ql06AarXBKEAwciCJmrcyGMLgxC
pVNB0HSyxDd+COKoE7c0Jiz/BOLBSIAoODovoS4gC4WjLhQUiwRF16R/M6Ar1y5pwOcdVjSAAwiK
SIL/iNCJz3e5E9wNE3p3j/GvcCAs7KKrj8a/5gntre55T/LXue8Q5vzwegzll17kuGc7Fwwl+6Cd
CobuQ67in/p2AjBwnO0AAjBU7eE7AMMACAwJJD6dEdx+Q9Zj1bl7D7FnAuTllUgkuD4mPhzFenpE
V3OIydwlEgbskXOQIdQ9gIl4/SDd+3XXVbr5pW9rOOqs9RVpGNIK7kvSnkvqdY5SJXzDyl+kD+5O
M+/2N32dRQraLtJ9KcdoABO0unICbBSB6jf9rh++FoCeOr4Z+vvqUT/HF9XZo/u/WrK1Q6vmp4vh
xYrnAgocOHDgw5fv5wjhj5/oEDuPrxFiLx2Myeaaid2gYZgMDCRkayzERwMmAnFkQPPUNbszNi5i
HGBG9QOVpkbC6DogDQUnUTml9TQNpIYGqXy+Hj5H47lCmNw68xCNLiBdOfS8+NWNoO0zdSTp4SHR
6Ll4JGNdhBwwzmGGZmuQhEwFcmXDBV0O62SBLEJKdgI5gBeyL9Cb3SX+W55q7D4zaVJDhPswfRKq
hD4HCMhQnCYNIt6cS0TDKO1XmShsTiOQBXkowf1J5KtMzM1kHcRF+Z1JhNInHswxGg02fAcDc6x/
ikKIwzLGKrzMxAFPNg6Jkz7MQyNui04+yJnwIcfJo36jBtJqdFPCpzIyLsmJO4mfCMeaLwFkWXg0
CnhhFCBLpaxKBc3nGV1L9GBd2yhFZuZL0JotM2WSAzfZOBRMF4vjobFKFoGASiTGg5gROdFXdTwV
8PkkI70tY3ymzkGom0Qi7VnzN2AGc0SZ4jGJkaNDUpAsOFCZrdiNF/xKXsihkBEhHUeCpjvTrQ9H
Z3Oh7YHTwXDYMSugBFYosg8MkaTeNwkYkzwaIQVFTHS+URm6CpbubUmGII+DgoPWppk4DzUSqzEh
RbKJHyLPxPQRBUxoq0sGqTCYhkUnFO0Iw972dfxJrEpX4AnSrnw41ygJn4VDJluYEVr4iISnlbE4
mGrE0DDKZ8kY0l1VYFykRPtuJO10/fR8vufcV5y8ZwqL+zfOu3KTsr/v3NMAcbuD9sK/1IC3p6uA
/GuimYbhG1AFlfaMw1F3mmr8VXfYwHb61urlzTWJr87cttUaVAN+f95cnQuNin1qxmksw12CH85h
nZXOt/g3N8f/El2ooZ3gHsPdc7d37J4Su7gJQCw2/a4nwgD/c/jHWzAp93CeYqa6x11PW+9e4JRi
WxEQ0H0RENCJe+6hpTzLf7WHs9vzGkDW0HTv18oRTIoi6BAg+uy+imXdYQbr3CWdSZ0RisrCKNiE
o/lIsGzTsAmlKhts1Mk4FKptONiGTTYci042FdU02bUh7KTyiKgEdM/Z70yPKB+0z2XddTeb6liG
PKy8jwTMMAxt77IWqbDim8k9cR13+C9eDyvp5rv/BG19SucEtcP6fbhBe98zYBRMg0UBfU6+2OFq
UuVobo7v/fp79PL5YN0UxbsdNS+/4eXuWPemc2njx3V2l7OvH2+et92RGZcWKLa4Tv6f7u5bykAX
UFMF5+4cPU5K6/deU6X6I0kztSmulvY8otQA0VV8M7PkXsxawe5z6wzynkGSilV/VGe8CZhPt4iA
MOlXXfvX3czkekfvUkIpQnztTV1WslQ5/u7+blNRrK87tPv74Qpajl/slk6Ro38137frnvMr6h8z
nZX2oQtFY4GgWCwYClpp+M4SSumcQ4p3KZTiGi3h+qCTQliMUaqjVJJ7FEpFqIFVYC0ikQV93C+U
Ymz9oEvbXJkquzZXhX42FTrnRJTU7N013Q7fcuMHQxQBcu5hnnHuKL9eplvncdKyw5XifHkN78ir
he6/4ThWysHv6nLMlsxh+OA2CziQ6VQSEK+h4IDs3/jt68pI6H7xIB+/RuCZ4/rtQ8GAKOgXL0eA
llcyonic6IKRsFBEbgL3swgGyAzuhJgtglewuw8BTB726n3HQMkxsN8GBw4cOAAAAABkV7Zxk5qa
u5rre4Juh1JhRReUQgDnctP9AP0lWy30YrD3LqAENLD/cblgeTwJKsXhngb6xYIy/3+a374REHrJ
IjxnuelxxpIAuxA+ggCygZLTUSbD0SSVpVQEYsKVvyHXlfrRXpz1W+/1azdcoMYMIgwKMnsBAQQO
QIBX6nFixQdQAgJwv0nM3Kub891rpWMOu03+ZrRVFg7WmRhoUmmVxWJRMEoZaJzsk8EqCp1k2Nxg
H22rso9lbapN42QKKqptMph1dTRKTUq7KpWmmmCSajTijCgsNK+sUn08V5bZfEDXhrHhZBnNsKpz
ZdPCQNml0VFWWdeGZjKbdmk+GnWBsM26KNeEXnOS+XBG1NpUmurjmVpFMRqWXRqnk32qzMeqNhtG
oVgGk1QWK7s0k7Ntk0/G2mCXBpvalXWwi1KTDYaho+3DsWxYiBJoFcEEA03twras6tBEdk0yHAvd
LBUsq2ywDctCdINVm4aFOHNzWUJ061wWRYSqDL0ykqrTqehIsm2YJrs6dNtcm+jiXBl1VbLKYlEK
h15XRqETDaOaKqtwsg69LBu9tE9lXZLRtqmyrApRzmb311nMXYc1f93cT9KF+VtRTgIdEnj6ObHj
Hn733h331jLf14SIlF3mdt3Z1u53zyKe43+b2vd1V3jO9BxZhjeDD27QfofHvjBxnh+pH/83wzG/
htJxvPqr4ELZdR83nR9usVt9a9htfdzDB2/VHMdfI5Rl7sKeycrnh128e++8e9kZFEzKYH/PuID+
/LreQBEJdiJA3b3b90RAZrYGJZ4Uv9wFdeV32/qwuN7u3Tov7zWTk497cn07RhH8ep670zq9OnHP
02CHXyrAWeeGKhpMjvof9zRZ6hyvxtf7em3ePbx9UkSO61oNK84Yh9Xqz1jXL/kNq6lSC/3qKmZL
IYjaVrmjjIU2ebfcbWjuqy/2MJsMJq7fV8WLsbdh1vpPP6mq6QLlV08eihColPQqJS1zYEAAAAAA
AgEAY0AgGBweMhzQCBViD+RHBk+zYh0KRzDJAQgUmAGBkQggEgBQEEYMcYyA+p9AS6M9YJxr5N0h
VOx/gMyR4fmlN+WLISrNQ0KJomIeyF8q+kCdhedbKxDM+hWhIbo3sRb4c1zsVHL3iA5dLWkHpv3B
v93ynKhHZT4j0B4oBKnxcwgNRGSWacdcy18gFdhSkbQbbPeWiTlWGoSaeHlGzNv6e/pMdSIhQIh/
JASrhsDBnRmoka5QAhciu3IJYuvQDEcDaBvtkqEI8igRfZYW5hU48e3f9oXHocyMrqrt1YYrpVz+
BmGfdsii58tGGOrdrSF29HjWucJnP0x3gvvO5kWK8n6s5BtMF2DJZXI27pY19Aq45iQcH3PZC4eq
oCoPnLx3/Jw0EaM0lbQaF0TGgm7Nu2lUgPFIeD3VK08Zk2o5wqFugf63jfceuQ06URs3g3Kys2FG
UKlWOzr/PJT6YTewGGuwH4gjzH+44MRqqXBaN6gacxCjG8jwvzUS0cEEvbA0CcS35dpKKC7QBiqo
bHDsR6+tmJNSaEW0n1o/P6WVcOppUT0aFBBndAatQ6ojzS2qQPjI5Zqv8JFCqLG1y4GMQlvnSpLV
t/YCSvGqOyEEZa8lWWJZMR1OMSnzJKAL+jEJO8Q23K7FPwQhAupqJZqYjRJtKXh0xg53ifl3AN+j
1DSAn/sy3t+5cEP+VBjP/UdrZ+QwrLc+2d+t5LZH/Ug5npmyooS+jtVc0WuFD+r7oIzi992whoM1
dMAqWLWKdVqNefjXnBD6hWL+QKRLrdHQ/K6dYwXNlo4YZkkCZ45t5/Op8Qkz4uwK+hjpkcrFX1SV
iRE5mVwgAd+T2empBFARZKCZsoqYhnTcmrbntd5RO+xh9qOQYCvXIJaI0wKZLnu0Z0w/rpZyKG3s
A/2odPkeXS9NCWy4QB9unhrDHLWAerMxzoUVgh5t/lhrR3WpLAVuB7xw9sk7+OF3wgBBgWyji+k4
OuvJvyVb7puXvhBdP00Q6EIVXDkT00Ii7nPM244cVZqApIUUHyzDy2R9FwuEfTTDGkxxIAi8dAXf
6od0r9VIwj7EQDpZhFo4Ks4YF4GZ6agL+PVL7zAZKfx+QHn9X3jwRNLORwy8h9XcpIa9UpKOGAYJ
y1qF66a2uBPikg6gk2fhdaOLPUJIzNFZQoRhAWRjHXLdslDFkhqI5K8QPPEwjEe/JFwh8+IeRbNW
rG9RqRmjiPduZcE8uoUdYKHxnZJ/81oTRkCf38CZcO1mp6rRN+b6MevAjZFkJVPhWYTymLHynug/
VdpWh0XxDye6Yc5Be0rFtxn/WyfKgXy+wyG26KLJq0O6jrSArDmx759Rv1c/yeEYSFwXcwg/ZDMI
NFOIAjIENICJ/44dYThU/SdkkO65kaq1RQDu2nJvYpwSbvIe91nqALjSLgFg9tGGkjty0UCvqYLj
aBxwmuJ9fqPjYxI5zWmr3gXWz0CQTOO5XR3MbSeWEgsQUfa8w0ko3535razn6ITNQEYo4np0D4Ix
alBHo5E49u51zDDMg7uK9sSS7jgg1KR44R7g1ruilaagwWCxpAezAkFqPF+DA7rLFY6BkQr8a1Ig
9zqyCAtlLiB4cIAXMrxmnktQkdroNHbCeBcr/ZHsQRQ7qtZA0pv4lrPQexIXa6xXHb+VFRttrEMM
ezlDdSb1pMDC+71e7Ni3BhQn5qCoUYVoTrlPMUt7AGKnEGGkHYUMRLRolr9wDz8GcgT6EPbe3Wn6
pknpsZK0MZlk+mlqM9oh4UFrMVvZb86eKIeMPq+LOWQOeWp7h+JMD3CRZdTjKxFZswSJJ7WxfbX2
xSMXvPUmVSHYk+G4GlBQLkiGjEyG5tmEa5c0ZKCRaBHR0yTtoD6BGg5+Qs+Z7Pw2sCN8Ko0g+x8i
awmGiYqIfFRXQRzfJbfFXyNRYrBkanoLs8/hizQgrixBKZkqNKXPfqOynVbU8ZYkXWLbP93Xpz2H
KLu/o7PbpYQ24Ot5aqwT6bBKXekQ9bUIROqMsujo2FMypgQAHizvsxk6KNDTV5IDRUXdUpDumTx8
SKbTD79LCTVu4p9mOETfSIwltpHlhcgfgbr9P5GdYk5ciDNa+5opeNFPEu9b8NOlsxTZZlOzbX+M
LUZLMUWbRNO1kKR94hDCMaSBDUYfZMtVvHckpQdJwOCAOoAxdBSCgQV5a5XZ75F3viymgXGZiLhe
zIMxiJ2tUap43AN1eZDfWKNOqQS2EhYeXxOjZGcili0SK6lf1laFiAJcGKULtxQaxaOiSEBI7Cf0
ezsJKJlqoq1uHZ1utukR3vZh7d1YH5yglQLvidnyO3GpxEIvoXJoK/gCOi4kYGxSHEyFdi1OKV2U
MiTlkVaomxcA4msIdXcD5V9u+mUkAhGWN1QtqcEjoMJRgR1TPp0w0knsgkJUFuCb6cScKGpJ0xfm
423cEZbSDleXMfEH3HiIyog7WTvvMnSYW/bRfFMefFT2eedqPm9C1N+f+9EtivtNbm68utQj+lUL
eDbWmHq+/KURThs1ew1w3aK7kJAHuyCs3w5wuI7+9iTEzkKg+biCy5jCMM4qoyDOjw6FsrCd27cb
+Yrxr25Cvi9BzyeBbZ1iUpOsXqlC76zykrp+qWiIL21cAwgaLyG3idsKGWvM+x1BT1EwY/788N1m
2sq2YVJu7XO3ceJCOECv/hHCmfrLENEDs9P+phpkEuUj5jOA7nqG1rZ4+hBmrksKC8ckYw8y7vUp
7KkCHWWl2xZwxTyamwag+zSHqMDRMDAhhQiio1ZBOqZVM8LrU1SiXgDg7i+Zk9s3ApGTpkWhPgd4
YI5uVB64qeb5eV/lkbCEce+ib6j6UcznpmHI0am+STjuUEJ0UTb/swTAraWMpZ6HMdaf7GSuXOe/
A/zTqbpza/H4FPOLEhB/oswQixeH4X4cBsUSlm6rV12yt1U+E+D0BtcoG9MgPFcahQKd+IxiE/Qg
oAY5BXw2D2FcIIoNrE3rqIje3qVpuKRsYVlRZKeOTeGTZyvZuW1HST2sQGRN+chVdWjb9Akov8q+
uYjuC87BxaA/YUys6ncpxqFIouwYyr3Rzrq3djqC8cbzMLdsCTnfZtpaXfniasy/2mgDwAlEuxsH
ztn6XLlonCzfQVxS9s0HfMqZ90i9EkI10KzzDdMRkYGqqdj8D2FvfB/KoFCO9cep4/9xNzuK+1p4
2mCcPOinmGSpGvGlvCVr03TFZd22INK8WG/U7L5gtp/ehbTt966jb4nGIudT5FBUC7IbIiur8Rki
zWGIz7hmifz6Qt0jlagJ/SVwISQyyyLfbCaYQjT0DflM0ZCRDSThB4JxTDKaU2vP2zgo96oo2tck
iOMCtnZIA7wnnKHuGwhDrUC/akfULxr/GKLismmsMGgQyxTJFT+LlaAUHV0Mhc3ULlRGwotNsBFC
5prjYRiJiY2b562Ijc5vP+TUWeCHPfgpnBUgOeEi2K3QqQkzIMcoiOkk54ANsiCujBGADM9Ws5tm
ndPvIFbfCfRHi09TIiK1dGh9D9aCQpB6KANihyDkB56py845b7M1TLUhQnhNt0JWBm14vkBYjw47
SpUJEuQWTAHD0I4YVPRFNYjge1x669zFds/bw10oJsIsVTqw8/XhAfSW/lsHQ8IgSZVTxxPWyrJr
8ZQNhyoNsoNvqHwVSsgQiKSzyVINk9zpDa+l2x4hC3N0r7rkdI56+WWTmclTEZ5lZb3zHQueJX+Z
hq86zoMcGAYb9toH2bAS8rQQzAmL/Z6SWgMWqYTfZfDbJqbBves4WXG39rjs6tIa5dpjNwsTmuzx
u4GrIFbKkcOtb9gGaWbKBGeBc+vFuTTyWQNA8jfhJg9PMQgsTJWzuNOLSAOvDvGjeJP5BpJ5qXl2
GpUyX3bgWrklHa1DN3lc110cD4iW9MCojucaAoJ2U5Nx4DSZHg7QCKZALLt+L7UmLymfcyIqvLYO
W/ANWrSA0BkHxpO8fZBiPywr2H6iLj4HijUdyroY4f5HGYE6+eEh1m0kwFMSXsNr4UY+smHp7XAa
FkSZdaIEQME9EnWyODJuqtneeRz124+bkEcSQbW6JZga9646ypiNnEDGvdOChtyGImwZGBUZgCny
5qXQzdXAIEddAZ9b/P3SISVEEoX2/ESUR8d94TaMWXTXcF+mQue1zIdX6qlCSTDru9W6APNnPUiZ
OZRTF0bBAcqUfo4x2N+JoznopSwU/uEiIEN9KTKMwauNT6vWpY9ujsqmIJ4TkpAAAj1HpOyvN+Po
i8ajyzxkexGIgdwhgIz4gHWkDMEt9Z/h7G6iOkY7TsoSduTUnh12cd3HfAPeBo2KkxdcQNftUNtM
4ORTNhsiTcFw+PRw7uNqEoxb5DBAL9gAFiLwRiqNlQRflckDDRtREe8VOqgvQPUUA7Y8z/lGLLM7
dSPGB0j8oOOraxujAYhvxxeWC9MjY2r13rK1hPWmKQ/zHMCQtugR1g+2xII6ImczQOK3wx5fsTn9
1DTMS1z56qToaAn8/3UAYYYZJjWAqFFt0GDg7wIAMt1JCpqyhYXdAq3XSoCuLI3T43AbsuEUwRwG
yDSjlI+JvNUMA25PV3ogGTZ2JGbXzUX8FtST9iY+3Xn7kJD1kvydC1kX1Q/+DrA4XRYSafPJouGM
jg4oDJwSjwIYobHS2DKESAkk8sCFHP4QO5wL8EKAiDWg51vQmD+MDp9nR3CTwFmUKUtQeSqSnJmL
APs9JQUY9lM6AppnhbbsIe6st3A+XV9vm5AKhvajmItwQgg9msLcoPlq9DE0CroR5y5treexmYi/
UihnGNbJIay/sgoTQmlJDZ0U14shf9ujOel/7WTVFCB0P9xbDompK7RbMXCeCnDCJMYyWTaAXAOG
imZ1FRrlwdWA5rLQVLUFYr9tP7TlYQkU0FRCGA6xb5JA5ITyTHtN6E07PBuIJZ2KjsPtNn50wD1g
um+p3c19uKM9Fhmu0IC+t6K7bkRd82Zw1wwB1xDO4sEFYVPCZ7eBYCGWwrqjYu4NAK9/tuIOsx2z
+OMMc81+rfdVP69UIk0MRuVeQTyY/hf2nmQ9inW6ggc3NvVvt2VgNzopRR5zDJF3QnlqYtX9qJKO
yU5WRFksq5Chm6Mm4UvDMutU8PAxzpweUUVLSL1c+B8y6s3dPWEZjAcsEKHENT4mLf+3iaCrbKsK
0nFriw2nWTZ9OlJ316bI0thefZVlBec7H4UMsHhxj0nRJ0IPNwUGZfYc1drICvP2BmIQAq893YMK
oG6LGwVAcVMyNUzItY+naNt+SYsi0eAMKZw9QOVfC3f7HYVoQOJRPgrY7ys14CELtaTrorjloW2E
eOLFBkUl8WVmtQeGL1eDojFvgCK2EEVXqrtPCRojUunTI1Cteo03mRyQJMzHoYMMKzwCeg/Pxiry
8qN+cAd3Fugjf3ufd34Edl/AYOVHVhPOTx8updV7fmAcEMpFDk2paw+AetPknetPutiImUzUokQU
ytlQvpyzkz0GmGd64uRjsrxZk5yM70FlfDt4FTXGA/PvNCO8uIDgd5rtyjMPSw9KxcwoAwyVIgtU
zqzzWtdADWla1qkGU/GQO3zyYaDRZkJ9EknQXbOTGww6xvPpu8/6oLLIq+kqEJ0sOKOEs6vZWgcX
fdy+g9zbBy3SfQ15r+JUUhRCS9DrmE58KbwiRp70LyFrhJ9Dlr2BjGkNqviBtOd29t/wyb98aVND
LnvALpTBh2+vcI+LHJapMKJrGH2zjg/opGhSnGzCQrqYXbWulh8BGOZpiIdUv9ocR/COzsKEi50l
/0oGPWV41I17Txuw3TCRsBH2Mnu8qqUnKEaWF+mK0W63gm0qYA2Uan0IsYjfLtUhQJN6ziG+OLXi
myr6eE6tXIsW4g5+2l9L4HdQAvXKBNGO4SpDbuk2vBFVbENtCeReW88QEsMHeosv9sQ+mgjjx2cH
IJ5A/I43vdMqpMbdciCKGmVN0RABm1LObQ1JkHTRR1LwZxzPjhKJ8Poji69Qcbrs3jCYM2drnZ6Q
lr5uWJ8QERDECJG2PRkARczEIMYoKDlPptoPkk2tLlcxDNCJzXwZ998swkG2GlFkvK4azryzIzQa
Gl4ynTvT2XRqREd+9GJq1BRiziSXvgbF8Hguz8wlcV6hMvSKrbxC4UbpIiVhhEC1k+BIPtZltSIe
4pouzCutNSDXVMu1TgX0khTo46DnBkAirNDgZcMQuE3WIQTwVJHgXKyl4n04gydmATc9siZWmrSZ
/UQ9fmVXNNsCJqSoBTAnhhDxIFqB6BokU9jQXE95dMg7fkFuJ/KJOiKJL26qQxRnhzSF1aJ7QeUK
bdN/t/rN8XRAuYoQB4fSoT+/UABV9QLVZ6eRruW4kuyg0d1IM9eQXtXmPL9BijZvT6Gmli3NEFbs
iFNTy8A/lWT2fMZ6zrCBRv4ilLvJmMxbxsJutBLiIxF7BzM45jfEOPWd6I2CwpuQLFbQw8SvaAKH
XyzToXHkNPFqYWYZZ88w4tLsi9r4g7MIgGrCDR8BjVSlyaeOgJiUHPDomzS1xis/vO6dTk59gG2V
aZiUqz1K8hjrHcaDpWYQK7YGOXq9qKyUaVUflo/GHeDl9mwduKUA64yywG1C5ci5hADmoKrmXw2C
TuX61RwIjPMAVtqd0/n+PmyjRsVQVAEbt4/MiYygKyd+3j0ln7zBC74i0MvPvhw25qOYk97CNxjI
aLW78bup/HCZEeqVms7deVWTiTgFTvugOBKsYRoIxIOr+AOYhQanp01TJeYOvqsBqcdS7TJ4dHR7
YLQS6NCayVFRyUuQXjYIHlQEAxYLoXAeeFq7HPmXbUWYLVlPrVQ0OOoNYj5mryupuviQRJQjwjKr
d6KEVDDn/sx9KbySA/xY7voZtdSwg/JHJi/7bFZSL43pr9HDmD6RP5KF/pAaGZcHFqDDBtDoHoGy
BQtEgPe+ASAfI9q2rdwFRA/oYRShoH8arw5vhqbSNVF8+/Lp+gDCySl9gpHeSDmr2oGrYdfEDs4j
iQusTtFkGjYJdiPU9X3YvxHjmrg0qB12liXzu5h8kF8wLrLuM9cwTU5+mGKAFC3ZYmsFJAQ+r5VI
9WJzl+sT0fF1IaQb+Lr1OwPLUjfXN6d9kiqMG/jl30D5SlcRDvO2BMHQ8f60+3HMhr7FejSoVbBD
dn61pPVWldIH0iV0q+DzZHb+xKb1gJ3SU/mJ+egCSkdKWWjnRY1WryEq/hTh44z+1Lg/cacG7oMB
6giXJyygc8G07UFlTO8HO9A9AseVvt6AY+mG5rIUqDCOJAX4oOotvPvpPJBZDAX3Nztg/D9oJFAP
j6utzf+MLOj086zMsvxPvlWjqVDmjptxW5/1OCeFimIbRCzFqKWBGR6ME9wLQYEzv72lv0jr9U8j
EnpBXX40t7WTvlIvHR3+LNk8ESQNGsvCau2Fz33YcMHKAFohx+j9z9HgJ3E4Pmk+IRupmeQFKHGD
HEf8rT/vH0vLW5SlFqrx3/uzfoZ0fniPxqbfK5unSPPtwZAW
EOF

# Install the EPEL release RPM.
dnf --assumeyes install epel-release-9-2.el9.noarch.rpm

# Setup the EPEL release signing key.
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-9

# Delete the RPM file.
rm --force epel-release-9-2.el9.noarch.rpm

# Update the EPEL repo to use HTTPS.
sed -i -e "s/^#baseurl/baseurl/g" /etc/yum.repos.d/epel.repo
sed -i -e "s/^mirrorlist/#mirrorlist/g" /etc/yum.repos.d/epel.repo
sed -i -e "s/http:\/\/download.fedoraproject.org\/pub\/epel\//https:\/\/mirrors.kernel.org\/fedora-epel\//g" /etc/yum.repos.d/epel.repo

# Disable the testing repo.
sed --in-place "s/^/# /g" /etc/yum.repos.d/epel-testing.repo
sed --in-place "s/# #/##/g" /etc/yum.repos.d/epel-testing.repo

# Disable the playground repo.
sed --in-place "s/^/# /g" /etc/yum.repos.d/epel-playground.repo
sed --in-place "s/# #/##/g" /etc/yum.repos.d/epel-playground.repo

# Disable the subscription manager plugin.
if [ -f /etc/yum/pluginconf.d/subscription-manager.conf ]; then
  sed --in-place "s/^enabled=.*/enabled=0/g" /etc/yum/pluginconf.d/subscription-manager.conf
fi

# And disable the subscription maangber via the alternate dnf config file.
if [ -f /etc/dnf/plugins/subscription-manager.conf ]; then
  sed --in-place "s/^enabled=.*/enabled=0/g" /etc/dnf/plugins/subscription-manager.conf
fi

# Install the basic packages we'd expect to find.
dnf --assumeyes install sudo dmidecode dnf-utils bash-completion man man-pages vim-enhanced sysstat bind-utils wget dos2unix unix2dos lsof tar telnet net-tools coreutils grep gawk sed curl patch sysstat make cmake libarchive info autoconf automake libtool gcc-c++ libstdc++-devel gcc cpp ncurses-devel glibc-devel glibc-headers kernel-headers psmisc whois python36

# For some reason the beta thinks this package is installed, when in fact it's missing.
dnf --assumeyes reinstall libunistring
