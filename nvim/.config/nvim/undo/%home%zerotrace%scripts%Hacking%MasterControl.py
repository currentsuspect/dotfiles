Vim�UnDo� Qh	�k�F���]:����*�(p�"1+��   X                                  f�`t    _�                             ����                                                                                                                                                                                                                                                                                                                                                             f�]s    �                   �               5��                    L                       N
      5�_�                            ����                                                                                                                                                                                                                                                                                                                                       M           V        f�^�     �              M   
import cv2   import socket   import threading   import argparse   import logging   import numpy as np   from pathlib import Path       # Set up logging   [logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')   $logger = logging.getLogger(__name__)       def parse_arguments():   D    """Parse command-line arguments for the server configuration."""   G    parser = argparse.ArgumentParser(description="Video Stream Server")   \    parser.add_argument('--ip', type=str, default="192.168.0.100", help="Server IP address")   N    parser.add_argument('--port', type=int, default=12345, help="Server port")   `    parser.add_argument('--video', type=str, default="video.mp4", help="Path to the video file")       return parser.parse_args()       !def handle_client(client_socket):   :    """Handle client connections, sending video frames."""       try:           while True:   .            # Read a frame from the video file   #            ret, frame = cap.read()               if not ret:   3                logger.info("End of video stream.")                   break       8            # Encode the frame and send it to the client   3            _, buffer = cv2.imencode('.jpg', frame)   3            client_socket.sendall(buffer.tobytes())       except Exception as e:   3        logger.error(f"Error handling client: {e}")       finally:           client_socket.close()   0        logger.info("Client connection closed.")       'def start_server(ip, port, video_file):   I    """Start the server to accept client connections and stream video."""       global cap   &    cap = cv2.VideoCapture(video_file)       $    # Check if the video file exists       if not cap.isOpened():   @        logger.error(f"Could not open video file: {video_file}")           return           # Create a socket server   E    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)       try:   &        server_socket.bind((ip, port))           server_socket.listen(1)   ;        logger.info(f"Server is running on {ip}:{port}...")       except Exception as e:   6        logger.error(f"Failed to bind or listen: {e}")           return       ?    # Accept client connections and start a new thread for each       while True:           try:   8            client_socket, addr = server_socket.accept()   8            logger.info(f"Client connected from {addr}")   Z            client_handler = threading.Thread(target=handle_client, args=(client_socket,))   "            client_handler.start()           except Exception as e:   C            logger.error(f"Error accepting client connection: {e}")           cap.release()       server_socket.close()   $    logger.info("Server shut down.")       if __name__ == "__main__":       args = parse_arguments()   0    start_server(args.ip, args.port, args.video)    5��            M                      O
             5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        f�^�    �                   �               5��                    S                       �
      5�_�                    R                                                                                                                                                                                                                                                                                                                                                                       f�`i     �   Q   U   T       �   R   S   T    5��    Q                      r
                     �    Q                    v
              ]       5�_�                    R       ����                                                                                                                                                                                                                                                                                                                                                             f�`n     �   Q   T   V            if port < 1024:5��    Q                     v
                     �    Q                    v
                     5�_�                     V       ����                                                                                                                                                                                                                                                                                                                                                             f�`s    �   U   X   W      &    start_server(ip, port, video_file)5��    U                    �
                     5��