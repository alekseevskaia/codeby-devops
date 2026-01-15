# Task 1

1. What is the decimal equivalent of 01001010?
Your answer: 74

2. How many subnets and how many hosts in subnet are there for the network address 80.160.0.0/20?
Your answer: 4096, 20

3. What is the last isable host address of prefix 182.144.10/29?
Your answer:8

4. IP address 10.145.100.6/27 is a part of which host range?
Your answer:100.1 to 10.145.

5. How many IP addresses can be assigned to hosts, for Subnet Mask 255.255.255.0?
Your answer:254

6. If you need to have 5 subnets, which subnet mask do you use?
Your answer:255.255.255.224

7. What is the broadcast address of the prefix 172.18.16.0/21?
Your answer:172.18.255.255

# Task 2

## 1

sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

## 2

sudo nano /etc/ssh/sshd_config

DenyUsers *

Match Address 192.168.56.10
    AllowUsers *

# Task 3

In folder server

