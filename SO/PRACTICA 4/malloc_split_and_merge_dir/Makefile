# Generar l'executable
malloc_split_and_merge.so: malloc_split_and_merge.c 
	gcc -o malloc_split_and_merge.so malloc_split_and_merge.c struct.h -fPIC -g -shared 

# Comanda per utilitzar el meu malloc:
# export LD_PRELOAD=$PWD/malloc_split_and_merge.so



