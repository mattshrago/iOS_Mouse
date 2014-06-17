from Tkinter import *
from twisted.internet.protocol import Factory, Protocol
from twisted.internet.error import CannotListenError
from twisted.internet import reactor, tksupport
import win32api, win32con, socket, sys, os

class wireless_mouse(Protocol):
        def connectionMade(self):
                print "Client connected"
        def connectionLost(self, reason):
                print "Client disconnected"

        def message(self, message):
                x = 65535/win32api.GetSystemMetrics(0)
                y = 65535/win32api.GetSystemMetrics(1)
                self.transport.write(x +" "+ y);

        def mouseClick(self, data):
                b = data.split('[click]')
                l = b[0]
                if l == "Left_Click":
                    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN, 0, 0)
                    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP, 0, 0)
                if l == "Right_Click":
                    win32api.mouse_event(win32con.MOUSEEVENTF_RIGHTDOWN, 0, 0)
                    win32api.mouse_event(win32con.MOUSEEVENTF_RIGHTUP, 0, 0)

        def changePosition(self, data):
                a = data.split('[pos]')
                x = a[0]
                y = a[1]
                nx = int(x) * 65535/win32api.GetSystemMetrics(0)
                ny = int(y) * 65535/win32api.GetSystemMetrics(1)
                win32api.mouse_event(win32con.MOUSEEVENTF_ABSOLUTE|win32con.MOUSEEVENTF_MOVE,nx,ny)
                
        def dataReceived(self, data):            #when the client sends data
                instance = wireless_mouse()
                if "[pos]" in data:                                                             
                        instance.changePosition(data)
                elif "[click]" in data:
                        instance.mouseClick(data)
                elif "[char]" in data:
                        print "test"
                else:
                        print "Failure."
