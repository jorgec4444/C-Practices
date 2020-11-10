#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include "struct.h"

/* El fet de fer servir variables 'static' fa que les
 * variables que hi ha a continuacio nomes es puguin
 * fer servir des d'aquest fitxer. Implementeu tot el
 * codi en aquest fitxer! */
static p_meta_data first_element = NULL;
static p_meta_data last_element  = NULL;

/* La seguent variable es la que permet bloquejar un 
 * codi en cas que hi hagi multiples fils. Amb aixo ens
 * assegurem que nomes un fil pugui entrar dintre d'un
 * codi que es bloqueja. Se us demana no tocar la part
 * bloquejada si voleu provar el codi amb executables
 * com el kate, kwrite, ... */
static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

#define ALIGN8(x) (((((x)-1)>>3)<<3)+8)
#define MAGIC     0x87654321

/* Aquesta funcio permet buscar dintre de la llista un block lliure
 * que tingui la mida especificada */
p_meta_data search_available_space(size_t size_bytes) {
    p_meta_data current = first_element;

    while (current && !(current->available && current->size_bytes >= size_bytes)) 
        current = current->next;

    return current;
}

/* Aquesta funcio es la que fa la crida a sistema sbrk per demanar
 * al sistema operatiu un determi nat nombre de bytes. Al principi del
 * tot s'afegiran les metadades, que l'usuari no fa servir. */
p_meta_data request_space(size_t  size_bytes) 
{
    p_meta_data meta_data;

    meta_data = (void *) sbrk(0);
    if(size_bytes > 122880){
       if (sbrk(SIZE_META_DATA + size_bytes) == (void *) -1)
            return (NULL);
       meta_data->size_bytes = size_bytes;
       meta_data->available = 0;
       meta_data->magic = MAGIC;
       meta_data->next = NULL;
       meta_data->previous = NULL;
    }
    else{
      if (sbrk(122800) == (void *) -1)
            return (NULL);
    meta_data->size_bytes = 122800;
    meta_data->available = 0;
    meta_data->magic = MAGIC;
    meta_data->next = NULL;
    meta_data->previous = NULL;
      if(122800 > size_bytes + 12288){
            fprintf(stderr, "Malloc %zu bytes\n", size_bytes);
	    dividirEspai(meta_data,size_bytes);
       }
        
    }
    return meta_data;
}

/* Allibera un bloc. L'argument es el punter del bloc a alliberar.
 * La funcio free accedeix a les metadades per indicar que el bloc
 * es lliure. */
void free(void *ptr)
{
    p_meta_data meta_data,meta_data_previous,meta_data_next;
     if (!ptr) 
        return;
    
    // Bloquegem perque nome	s hi pugui entrar un fil
    pthread_mutex_lock(&mutex);

    meta_data = (p_meta_data) (ptr - SIZE_META_DATA);
  
    if (meta_data->magic != MAGIC) {
      fprintf(stderr, "ERROR free: value of magic not valid\n");
      exit(1);
    } 
    meta_data->available = 1;
    meta_data_next = meta_data->next;
    meta_data_previous = meta_data->previous;
    if(meta_data_next != NULL){
	    if(meta_data_next->available == 1 && meta_data_next->magic == MAGIC){
	 	meta_data->next = meta_data_next->next;
		meta_data->size_bytes = meta_data->size_bytes + meta_data_next->size_bytes + SIZE_META_DATA;
		if(meta_data->next != NULL) 
		           meta_data->next->previous = meta_data;
	    }
    }
    if(meta_data_previous != NULL){
           
	    if(meta_data_previous->available == 1 && meta_data_previous->magic == MAGIC){
	 	meta_data_previous->next = meta_data->next;                
		meta_data_previous->size_bytes = meta_data->size_bytes + meta_data_previous->size_bytes + SIZE_META_DATA;
                if(meta_data->next != NULL)
		      meta_data->next->previous = meta_data_previous;

	    }
            meta_data = meta_data_previous;
    }
    fprintf(stderr, "Free at %x: %zu bytes\n", meta_data, meta_data->size_bytes);
     
    // Desbloquegem aqui perque altres fils puguin entrar
    // a la funcio
    pthread_mutex_unlock(&mutex);
}

/* La funcio malloc per demanar un determinat nombre de bytes. La
 * funcio busca primer a la seva llista si hi ha algun bloc lliure
 * de la mida demanada. Si el troba, el retorna a l'usuari. Si no
 * en troba cap de la mida demanada, fa una crida a request_space
 * la qual internament fa una crida a sistema. */
void *malloc(size_t size_bytes) 
{
  void *p, *ptr;
  p_meta_data meta_data;

  if (size_bytes <= 0) {
    return NULL;
  }

  // Reservem una mida de memoria multiple de 8. Es
  // cosa de l'electronica de l'ordinador que requereix
  // que les dades estiguin alineades amb multiples de 8.
  size_bytes = ALIGN8(size_bytes);
  fprintf(stderr, "Malloc %zu bytes\n", size_bytes);

  // Bloquegem perque nomes hi pugui entrar un fil
  pthread_mutex_lock(&mutex);

  meta_data = search_available_space(size_bytes);

  if (meta_data) { // free block found 
    meta_data->available = 0;
    if(meta_data->size_bytes > size_bytes + 12288){
 
	    dividirEspai(meta_data,size_bytes);
    }
  } else {     // no free block found 
    meta_data = request_space(size_bytes);
    if (!meta_data)
      return (NULL);

    if (last_element) // we add to the last element of the list
      last_element->next = meta_data;
    meta_data->previous = last_element;
    last_element = meta_data;

    if (first_element == NULL) // Is this the first element ?
      first_element = meta_data;
  }

  p = (void *) meta_data;

  // Desbloquegem aqui perque altres fils puguin entrar
  // a la funcio
  pthread_mutex_unlock(&mutex);

  // Retornem a l'usuari l'espai que podra fer servir.
  ptr = p + SIZE_META_DATA;
  return ptr; 
}

void *calloc(size_t nelem, size_t elsize){
  //Reservem un espai de memoria de espai nelem * elsize
  void *ptr = malloc(nelem * elsize);
  //En cas de que no hagi cap problema en cridar a la funció malloc
  //i que el punter no sigui null cridarem a la funció memset per
  //deixar el bloc de dades a 0.
  if(ptr != NULL){
	memset(ptr,0,nelem * elsize);
  }
  return ptr;
}

void dividirEspai(p_meta_data meta_data,size_t size_bytes){
	    p_meta_data meta_data_nova;
	    meta_data_nova = (void *) (meta_data + SIZE_META_DATA + size_bytes);
	    meta_data_nova->size_bytes = meta_data->size_bytes - size_bytes - SIZE_META_DATA;
	    meta_data_nova->available = 1;
	    meta_data_nova->magic = MAGIC;
	    if(meta_data->next != NULL)
	    	meta_data_nova->next = meta_data->next;
            if(meta_data->previous != NULL)
	        meta_data_nova->previous = meta_data;
	    meta_data->size_bytes = size_bytes;
            meta_data->next = meta_data_nova;

}




void *realloc(void *ptr, size_t size_bytes){
  void *p;
  p_meta_data meta_data;
  fprintf(stderr, "ERROR\n");
  //Comprovem que el punter passat per paràmetre no sigui null,
  //però si es null el que farem serà cridar directament a la funció  
  //malloc de mida size_bytes 
  if(ptr == NULL){
       p = malloc(size_bytes);
  }
  //En cas contrari controlarem dos casos diferents
  else{
       meta_data = (p_meta_data) (ptr - SIZE_META_DATA);
       //Si la mida de el ptr passat per paràmetre és més gran que l'espai que 
       //volem retornarem directament el ptr passat per paràmetre
       if(meta_data->size_bytes >= size_bytes){
	   p = ptr;
	}
        //En cas contrari el que farem serà reservar un nou espai de memòria, copiar
        //el contingut de l'anterior a aquest i lliberar l'espai de memòria anterior
	else{
	   p = malloc(size_bytes);
	   memcpy(p,ptr,meta_data->size_bytes);
           free(ptr);
	}
  }
  return p;
 
}






