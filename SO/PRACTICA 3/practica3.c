#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>

int cridat = 0;
int mostra = 0;
int finalitzat = 0;
void ini(int senyal){
	cridat = 0;
	mostra = 0;
	finalitzat = 0;
}
void finalitzar(int senyal){
  finalitzat = 1;
}
void cridar(int senyal){
   cridat = 1;
}

void mostrar(int senyal){
  mostra = 1;

}
void contador(int senyal){
}

int main(void)
{
  char buffer[100];
  int fdss[2],fdmm[2],fdhh[2];
  int child_pid_ss,child_pid_mm,child_pid_hh;
  int parent_pid;
  pipe(fdss);
  pipe(fdmm);
  pipe(fdhh);

  int fill,len,ss,hh,mm;
  ss = 0;   
  mm = 0; 
  hh = 0;
  fill = fork();
  if (fill == 0) { // child ss
    signal(SIGUSR1, mostrar);
    signal(SIGUSR2, cridar);
    signal(SIGTERM,finalitzar);
    parent_pid = getppid();
    read(fdss[0], &child_pid_mm, sizeof(int));
    sprintf(buffer, "EL PID DEL PARE ËS: %02d\n", parent_pid);
    len = strlen(buffer);
    write(1, buffer, len);
    pause();
    mostra = 0;
    signal(SIGALRM,contador);
    while(1){
        if( ss == 59 ){
	    ss = 0;
            kill(child_pid_mm, SIGUSR2);
	}
        else{
	    ss++;
        }
	if(mostra == 1){
	  write(fdss[1], &ss, sizeof(int));  
	}
	if(finalitzat == 1){
		    exit(0);
		}

	mostra = 0;
	alarm(1);
        pause();
   }
   }

   else{ // child mm
        child_pid_ss = fill;	
	fill = fork();
	if(fill == 0){
	    signal(SIGUSR1, mostrar);
    	    signal(SIGUSR2, cridar);
	    signal(SIGTERM,finalitzar);
            read(fdmm[0], &child_pid_hh, sizeof(int));
	    mostra = 0;
	    while(1){
               pause();
               if(cridat == 1 && mm == 59){
		    mm = 0;
                    kill(child_pid_hh, SIGUSR2);
		}
               else if(cridat == 1 && mm != 59){
                    mm++;
		}
		if(mostra == 1){
		    write(fdmm[1], &mm, sizeof(int));
 		}
                if(finalitzat == 1){
		    exit(0);
		}
 
		cridat = 0;
		mostra = 0;
	   }
		    
	}
	else{//child hh
	  child_pid_mm = fill;
          fill = fork();
          if (fill == 0) {
               signal(SIGUSR1, mostrar);
    	       signal(SIGUSR2, cridar);
	    mostra = 0;
	    while(1){
                pause();
		if(cridat == 1){
                	hh++;
		}
		if(mostra == 1){
			write(fdhh[1], &hh, sizeof(int));
 		}
		if(finalitzat == 1){
		    exit(0);
		}
		cridat = 0;
		mostra = 0;
	   }
	  }
	  else{//parent
           child_pid_hh = fill;
	   signal(SIGTERM,finalitzar);
	   signal(SIGUSR1, ini);
	   signal(SIGTERM,finalitzar);
           write(fdss[1], &child_pid_mm, sizeof(int));
           write(fdmm[1], &child_pid_hh, sizeof(int));
       	   
	   write(1,"A",1);
	   pause();
           kill(child_pid_ss, SIGUSR2);
	   while(1){
	    pause();
	    kill(child_pid_ss, SIGUSR1);
	    kill(child_pid_mm, SIGUSR1);
	    kill(child_pid_hh, SIGUSR1);
	    read(fdss[0], &ss, sizeof(int));
            read(fdmm[0], &mm, sizeof(int));
            read(fdhh[0], &hh, sizeof(int));
	    sprintf(buffer, "%02d:%02d:%02d\n", hh, mm, ss);
	    len = strlen(buffer);
	    write(1, buffer, len);
	    if(finalitzat == 1){
		printf("Temporitzador finalitzat.\n");
	    	kill(child_pid_ss, SIGTERM);
	        kill(child_pid_mm, SIGTERM);
	        kill(child_pid_hh, SIGTERM);
		exit(0);	    
		}
	   }
         }
        
	}
       	
}
return 0;
}
