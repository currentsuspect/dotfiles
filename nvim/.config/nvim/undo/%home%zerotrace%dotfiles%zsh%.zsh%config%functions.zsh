Vim�UnDo� �z^?Q$)��A��dM�wVM�?��o`�9��   �   W    current_date=$(command date +"%A, %B %d, %Y")  # Use `command date` to bypass alias   �   3      ,       ,   ,   ,    f��v    _�                     �        ����                                                                                                                                                                                                                                                                                                                                                             f��    �   �               �   �            �   �               5��    �                      *                     �    �                      *                     �    �                      *                     �    �               !       +              �      5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                      �           V        f��     �   �   �       "   # Custom Greeting Message   print_greeting() {       local username=$(whoami)       local hostname=$(hostname)   0    local date=$(date +"%A, %B %d, %Y %H:%M:%S")              # Colors       local reset_color="%f"       local bold="%B"       local normal="%b"       local green="%F{green}"       local cyan="%F{cyan}"       local yellow="%F{yellow}"           # ASCII Art (optional)   !    local ascii_art=$(cat <<'EOF'   6 _______  __   __  _______  _______  _______  _______    6|       ||  |_|  ||       ||       ||       ||       |   6|    ___||       ||   _   ||   _   ||    ___||    ___|   6|   |___ |       ||  | |  ||  | |  ||   |___ |   |___    6|    ___| |     | |  |_|  ||  |_|  ||    ___||    ___|   6|   |___ |   _   ||       ||       ||   |___ |   |___    6|_______||__| |__||_______||_______||_______||_______|   EOF       )       &    echo "$cyan$ascii_art$reset_color"   H    echo "$bold$green Welcome, $username@$hostname! $reset_color$normal"   .    echo "$yellow Today is $date $reset_color"       echo ""   }       print_greeting    5��    �       "               +      �              5�_�                    �        ����                                                                                                                                                                                                                                                                                                                            �           �           V        f��    �   �               �   �            �   �               5��    �                      *                     �    �               !       +              �      5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                      �           V        f���     �   �   �       "   # Custom Greeting Message   print_greeting() {       local username=$(whoami)   5    local hostname=$(command -v hostname && hostname)   C    local date=$(command -v date && date +"%A, %B %d, %Y %H:%M:%S")              # Colors       local reset_color="%f"       local bold="%B"       local normal="%b"       local green="%F{green}"       local cyan="%F{cyan}"       local yellow="%F{yellow}"           # ASCII Art (optional)   !    local ascii_art=$(cat <<'EOF'   6 _______  __   __  _______  _______  _______  _______    6|       ||  |_|  ||       ||       ||       ||       |   6|    ___||       ||   _   ||   _   ||    ___||    ___|   6|   |___ |       ||  | |  ||  | |  ||   |___ |   |___    6|    ___| |     | |  |_|  ||  |_|  ||    ___||    ___|   6|   |___ |   _   ||       ||       ||   |___ |   |___    6|_______||__| |__||_______||_______||_______||_______|   EOF       )       &    echo "$cyan$ascii_art$reset_color"   H    echo "$bold$green Welcome, $username@$hostname! $reset_color$normal"   .    echo "$yellow Today is $date $reset_color"       echo ""   }       print_greeting    5��    �       "               +      �              5�_�                    �        ����                                                                                                                                                                                                                                                                                                                            �           �           V        f���    �   �               �   �            5��    �                      *                     �    �              !       +              �      5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                      �           v        f��~     �   �           "    # Custom Greeting Message   print_greeting() {       local username=$(whoami)   #    local hostname=$(/bin/hostname)   =    local current_date=$(/bin/date +"%A, %B %d, %Y %H:%M:%S")           # Colors       local reset_color="%f"       local bold="%B"       local normal="%b"       local green="%F{green}"       local cyan="%F{cyan}"       local yellow="%F{yellow}"           # ASCII Art (optional)   !    local ascii_art=$(cat <<'EOF'   6 _______  __   __  _______  _______  _______  _______    6|       ||  |_|  ||       ||       ||       ||       |   6|    ___||       ||   _   ||   _   ||    ___||    ___|   6|   |___ |       ||  | |  ||  | |  ||   |___ |   |___    6|    ___| |     | |  |_|  ||  |_|  ||    ___||    ___|   6|   |___ |   _   ||       ||       ||   |___ |   |___    6|_______||__| |__||_______||_______||_______||_______|   EOF       )       &    echo "$cyan$ascii_art$reset_color"   H    echo "$bold$green Welcome, $username@$hostname! $reset_color$normal"   6    echo "$yellow Today is $current_date $reset_color"       echo ""   }       print_greeting    5��    �       !              *      �              5�_�                    �        ����                                                                                                                                                                                                                                                                                                                            �           �           v        f��    �   �               �   �            �   �               5��    �                      *                     �    �                      +              �      5�_�      	              �        ����                                                                                                                                                                                                                                                                                                                           
           �           V        f���     �   �   �           # Custom Greeting Message   print_greeting() {       local username=$(whoami)   D    local current_date=$(/bin/date +"%A")  # Get the day of the week           # Colors       local reset_color="%f"       local bold="%B"       local normal="%b"       local green="%F{green}"       local yellow="%F{yellow}"           # ASCII Art (optional)   !    local ascii_art=$(cat <<'EOF'   6 _______  __   __  _______  _______  _______  _______    6|       ||  |_|  ||       ||       ||       ||       |   6|    ___||       ||   _   ||   _   ||    ___||    ___|   6|   |___ |       ||  | |  ||  | |  ||   |___ |   |___    6|    ___| |     | |  |_|  ||  |_|  ||    ___||    ___|   6|   |___ |   _   ||       ||       ||   |___ |   |___    6|_______||__| |__||_______||_______||_______||_______|   EOF       )       &    echo "$cyan$ascii_art$reset_color"   3    echo "$bold$green Welcome! $reset_color$normal"   6    echo "$yellow Today is $current_date $reset_color"       echo ""   }       print_greeting    5��    �                       +      �              5�_�      
           	   �        ����                                                                                                                                                                                                                                                                                                                            �           �           V        f���    �   �               �   �            �   �               5��    �                      *                     �    �               	       +              �       5�_�   	              
   �        ����                                                                                                                                                                                                                                                                                                                                                             f��     �   �               �   �            �   �               5��    �                      �                     �    �               	       �              �       5�_�   
                 �        ����                                                                                                                                                                                                                                                                                                                            �           �           v        f��$    �   �   �   �   	       # Custom Greeting Message   print_greeting() {   G    local current_date=$(date +"%A, %B %d, %Y")  # Get the current date       echo "Welcome!"   !    echo "Today is $current_date"       echo ""   }    5��    �                     *      �               5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             f��     �   �               �   �            �   �               5��    �                      	                     �    �                      
                    5�_�                    �        ����                                                                                                                                                                                                                                                                                                                            �           �           v        f��    �   �   �        print_greeting       # Custom Greeting Message   print_greeting() {   L    local current_date=$(date +"%A, %B %d, %Y")  # Correctly format the date       echo "Welcome!"   !    echo "Today is $current_date"       echo ""   }       print_greeting    5��    �                     +      �               5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f��     �   �   �   �      W    current_date=$(command date +"%A, %B %d, %Y")  # Use `command date` to bypass alias5��    �                    t                     5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f��     �   �   �   �          �   �   �   �    5��    �                     t                     5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f��g    �   �   �   �          echo "Welcome!"5��    �                     �                     �    �                    �                    �    �                 	   �             	       �    �                                          5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f���     �   �   �   �      W    current_date=$(command date +"%A, %B %d, %Y")  # Use `command date` to bypass alias5��    �                    �                     5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f���     �   �   �   �          �   �   �   �    5��    �                     �                     �    �                     �                     �    �                    �              �       5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f���     �   �   �   �          local yellow="%F{yellow}"5��    �                                         �    �                                           5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f���     �   �   �   �              # Colors5��    �                   �                    5�_�                    �   
    ����                                                                                                                                                                                                                                                                                                                                                             f��     �   �   �             echo "Welcome! $username"5��    �   
                  �                     �    �                    �                    �    �                    �                    5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f��,     �   �   �         #    echo "$bold Welcome! $username"5��    �                     �                     5�_�                    �   
    ����                                                                                                                                                                                                                                                                                                                                                             f��7     �   �   �         !    echo "Today is $current_date"5��    �   
                  �                     �    �                    �                    5�_�                    �       ����                                                                                                                                                                                                                                                                                                                                                             f��Y   	 �   �   �         )    echo "$yellow Today is $current_date"5��    �                     �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                       �           v        f���     �                 �              �   �               5��    �                                           �                                               �                                       �      5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                       �           v        f��	     �   �   �        # Custom Greeting Message   print_greeting() {       local current_date       local username=$(whoami)              # Colors       local reset_color="%f"       local bold="%B"       local normal="%b"       local green="%F{green}"       local yellow="%F{yellow}"       W    current_date=$(command date +"%A, %B %d, %Y")  # Use `command date` to bypass alias   *    echo "$bold Welcome! $green $username"   1    echo "$yellow Today is $normal $current_date"       echo ""   }       # Call the greeting function   print_greeting    5��    �                     ,      �              5�_�                    �        ����                                                                                                                                                                                                                                                                                                                            �           �           v        f��     �   �   �           5��    �                      *                     5�_�                    �        ����                                                                                                                                                                                                                                                                                                                            �           �           v        f��     �   �   �           5��    �                      *                     5�_�                    �        ����                                                                                                                                                                                                                                                                                                                            �           �           v        f��   
 �   �   �           5��    �                      *                     5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             f��R     �   �   �              local reset_color="%f"       local bold="%B"       local normal="%b"       local green="%F{green}"       local yellow="%F{yellow}"5��    �                      �                     5�_�      !               �   
    ����                                                                                                                                                                                                                                                                                                                                                             f��X     �   �   �   �      *    echo "$bold Welcome! $green $username"5��    �   
                                       5�_�       "           !   �   
    ����                                                                                                                                                                                                                                                                                                                                                             f��Y     �   �   �   �      )    echo "bold Welcome! $green $username"5��    �   
                                       5�_�   !   #           "   �       ����                                                                                                                                                                                                                                                                                                                                                             f��]     �   �   �   �      $    echo "Welcome! $green $username"5��    �                     
                     5�_�   "   $           #   �       ����                                                                                                                                                                                                                                                                                                                                                             f��^     �   �   �   �      #    echo "Welcome! green $username"5��    �                     
                     5�_�   #   %           $   �   
    ����                                                                                                                                                                                                                                                                                                                                                             f��c     �   �   �   �      1    echo "$yellow Today is $normal $current_date"5��    �   
                                       5�_�   $   &           %   �       ����                                                                                                                                                                                                                                                                                                                                                             f��h     �   �   �   �      )    echo "Today is $normal $current_date"5��    �                     (                     5�_�   %   '           &   �   3    ����                                                                                                                                                                                                                                                                                                                                                             f��p     �   �   �   �      W    current_date=$(command date +"%A, %B %d, %Y")  # Use `command date` to bypass alias5��    �   3                  �                     5�_�   &   (           '   �   3    ����                                                                                                                                                                                                                                                                                                                                                             f��r     �   �   �   �      R    current_date=$(command date +"%A, %B %d, %Y")   `command date` to bypass alias5��    �   3                  �                     5�_�   '   )           (   �   3    ����                                                                                                                                                                                                                                                                                                                                                             f��s     �   �   �   �      P    current_date=$(command date +"%A, %B %d, %Y")  command date` to bypass alias5��    �   3                  �                     5�_�   (   *           )   �   3    ����                                                                                                                                                                                                                                                                                                                                                             f��s     �   �   �   �      I    current_date=$(command date +"%A, %B %d, %Y")   date` to bypass alias5��    �   3                  �                     5�_�   )   +           *   �   3    ����                                                                                                                                                                                                                                                                                                                                                             f��t     �   �   �   �      D    current_date=$(command date +"%A, %B %d, %Y")  ` to bypass alias5��    �   3                  �                     5�_�   *   ,           +   �   3    ����                                                                                                                                                                                                                                                                                                                                                             f��u     �   �   �   �      @    current_date=$(command date +"%A, %B %d, %Y")   bypass alias5��    �   3                  �                     5�_�   +               ,   �   3    ����                                                                                                                                                                                                                                                                                                                                                             f��u    �   �   �   �      9    current_date=$(command date +"%A, %B %d, %Y")   alias5��    �   3                  �                     5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             f��B     �   �   �        5��    �                      �                     5��