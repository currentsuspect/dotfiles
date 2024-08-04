Vim�UnDo� |�MϚw_ ���>� 	��T e��)ˇ��p�/   !                                  f�DX    _�                             ����                                                                                                                                                                                                                                                                                                                                                             f�;�    �                   �               5��                    C                       �      5�_�                            ����                                                                                                                                                                                                                                                                                                                                      D          V       f�<t     �              D   #!/usr/bin/env python3       import subprocess   import tempfile   
import sys   	import os       def check_command(command):       """   2    Check if a command is available on the system.           Parameters:   ,        command (str): The command to check.           Returns:   @        bool: True if the command is available, False otherwise.       """   c    return subprocess.call(["which", command], stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0       def scan_networks(interface):       """   2    Scan for available networks using airodump-ng.           Parameters:   C        interface (str): The network interface to use for scanning.           Returns:   )        str: The path to the output file.       """   (    if not check_command("airodump-ng"):   7        print("[ERROR] airodump-ng command not found.")           sys.exit(1)       ,    print("[INFO] Scanning for networks...")       ,    # Create a temporary file for the output   #    output_file = tempfile.mktemp()       try:   *        # Run airodump-ng to scan networks   �        subprocess.run(["sudo", "airodump-ng", interface, "--output-format", "csv", "--write", output_file], timeout=30, check=True)   *        csv_file = f"{output_file}-01.csv"   (        if not os.path.exists(csv_file):   3            print("[ERROR] No scan results found.")               sys.exit(1)   9        print(f"[INFO] Scan results saved to {csv_file}")           return csv_file   .    except subprocess.CalledProcessError as e:   6        print(f"[ERROR] Failed to scan networks: {e}")           sys.exit(1)       except Exception as e:   /        print(f"[ERROR] Unexpected error: {e}")           sys.exit(1)       def get_interface():       """   <    Prompt the user for a network interface and validate it.           Returns:   8        str: The network interface provided by the user.       """       while True:   P        interface = input("Enter the network interface (e.g., wlan0): ").strip()           if not interface:   7            print("[ERROR] Interface cannot be empty.")               continue   =        if not os.path.exists(f"/sys/class/net/{interface}"):   '            print(f"[ERROR] Interface {    5��            D                      �             5�_�                            ����                                                                                                                                                                                                                                                                                                                                                V       f�<x    �                   �               5��                    O                       �      5�_�                            ����                                                                                                                                                                                                                                                                                                                                       P           V        f�DT     �              P   #!/usr/bin/env python3       import subprocess   import tempfile   
import sys   	import os       def check_command(command):       """   2    Check if a command is available on the system.           Parameters:   ,        command (str): The command to check.           Returns:   @        bool: True if the command is available, False otherwise.       """   c    return subprocess.call(["which", command], stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0       def scan_networks(interface):       """   2    Scan for available networks using airodump-ng.           Parameters:   C        interface (str): The network interface to use for scanning.           Returns:   )        str: The path to the output file.       """   (    if not check_command("airodump-ng"):   7        print("[ERROR] airodump-ng command not found.")           sys.exit(1)       ,    print("[INFO] Scanning for networks...")       ,    # Create a temporary file for the output   #    output_file = tempfile.mktemp()       try:   *        # Run airodump-ng to scan networks   �        subprocess.run(["sudo", "airodump-ng", interface, "--output-format", "csv", "--write", output_file], timeout=30, check=True)   *        csv_file = f"{output_file}-01.csv"   (        if not os.path.exists(csv_file):   3            print("[ERROR] No scan results found.")               sys.exit(1)   9        print(f"[INFO] Scan results saved to {csv_file}")           return csv_file   .    except subprocess.CalledProcessError as e:   6        print(f"[ERROR] Failed to scan networks: {e}")           sys.exit(1)       except Exception as e:   /        print(f"[ERROR] Unexpected error: {e}")           sys.exit(1)       def get_interface():       """   <    Prompt the user for a network interface and validate it.           Returns:   8        str: The network interface provided by the user.       """       while True:   P        interface = input("Enter the network interface (e.g., wlan0): ").strip()           if not interface:   7            print("[ERROR] Interface cannot be empty.")               continue   =        if not os.path.exists(f"/sys/class/net/{interface}"):   C            print(f"[ERROR] Interface {interface} does not exist.")               continue           return interface       def main():   "    # Prompt for network interface       interface = get_interface()           # Scan for networks       scan_networks(interface)       if __name__ == "__main__":   
    main()    5��            P                      �             5�_�                             ����                                                                                                                                                                                                                                                                                                                                                  V        f�DW    �                   �               5��                                            ,      5��