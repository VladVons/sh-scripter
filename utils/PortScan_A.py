#!/usr/bin/env python3

'''
python async example
VladVons@gmail.com
2021.04.09
https://steemit.com/python/@gunhanoral/python-asyncio-port-scanner
'''


import asyncio
import time
import random
import ipaddress


class TPortScan():
    MaxPorts = 1015
    TimeOut = 3

    def GetIpRange(self, aCidr: str) -> list:
        return [str(IP) for IP in ipaddress.IPv4Network(aCidr)]

    def FilterOpened(self, aList: list, aValue: bool) -> list:
        return [Item for Item in aList if Item[2] == aValue]

    async def CheckPort(self, aIp: str, aPort: int) -> bool:
        #print('CheckPort', aIp, aPort)
        Conn = asyncio.open_connection(aIp, aPort)
        try:
            Reader, Writer = await asyncio.wait_for(Conn, timeout=self.TimeOut)
            return True
        except:
            return False
        finally:
            if ('Writer' in locals()):
                Writer.close()

    async def CheckPortSem(self, aSem, aIp: str, aPort: int) -> tuple:
        #print('CheckPortSem', aIp, aPort)
        async with aSem:
            Opened = await self.CheckPort(aIp, aPort)
            return (aIp, aPort, Opened)

    async def Main(self, aHosts: list, aPorts: list):
        print('Main. create tasks')
        Sem = asyncio.Semaphore(self.MaxPorts)
        Tasks = []
        for Host in aHosts:
            for Port in aPorts:
                Task = asyncio.create_task(self.CheckPortSem(Sem, Host, Port))
                Tasks.append(Task)

        print('Main. launch tasks', len(Tasks))
        Res = await asyncio.gather(*Tasks)
        return Res


PortScan = TPortScan()
Ports = [21, 22, 23, 25, 53, 69, 80, 139, 443, 1194, 1433, 1723, 2049, 3306, 3389, 5060, 5900, 8006, 8080, 8291]
#Ports = [22, 53, 80, 139, 443, 3389, 8006, 8080]
#Ports = [80, 139, 443, 3389]
#Ports=[80, 4550, 5150, 5160, 5511, 5550, 5554, 6550, 7000, 8080, 8866, 56000, 10000]
#Hosts = ['steemit.com', 'steem.io', 'www.raiblocks.net', 'bitcoin.org']
Hosts = PortScan.GetIpRange('192.168.2.0/24')

StartT = time.time()
#random.shuffle(Ports)
Task = PortScan.Main(Hosts, Ports)
Res = asyncio.run(Task)
Res = PortScan.FilterOpened(Res, True)
for Item in Res:
    print(Item)
print('Opened', len(Res))

print('async duration (s)', round(time.time() - StartT, 2))
