function online(path)

fs=250;
ecg=load(path);

[linhas,colunas]=size(ecg);
if linhas > 1
    ecg=ecg';
end

%% filtro passa baixo
ordem=4;
wc=20;
fc=wc/(0.5*fs);
[b,a]=butter(ordem,fc);
e1=filter(b,a,ecg);

%% filtro passa alto
ordem=4;
wc=5;
fc=wc/(0.5*fs);
[b,a]=butter(ordem,fc,'high');
e2=filter(b,a,e1);

%% derivada de primeira ordem e potencia��o
e3=diff(e2);
e4=e3.^2;

%% m�dia movel
timeWindow=0.2;
N=fix(timeWindow*fs);
b=(1/N)*ones(1,N);
a=1;
e5=filter(b,a,e4);

%% defini��o do valor de threshold, numero de pontos de delay (correspondentes a 0.3 s)
% e n�mero de pontos correspondentes ao per�odo de backSearch (0.5 s)
threshold=0.7*mean(e5);

%ALTERA��O RELATIVAMENTE AO ENUNCIADO (determina��o de um n�mero inteiro de pontos (fix)
delay=fix(0.3*fs);
backSearch=fix(0.5*fs);


%% defini��o dos instantes em que o valor de threshold � ultrapassado e
% tendo em considera��o o per�odo de delay
marcador=zeros(1,length(e5));
j=0;
for i=1:length(e5)
    if e5(i)>threshold
        if i > j
            marcador(1,i)=1;
            j=i+delay;
        end
    end
end

%% extrac��o dos instantes em que foi ultrapassado o valor do threshold
instantes=find(marcador~=0); 


%% detec��o de picos no sinal original de ECG tendo em considera��o o intervalo backSearch

marcador2=zeros(1,length(instantes));
k=1;
for j=instantes   
    temp = max(1,(j - backSearch)); % de forma a garantir que quando ocorre um pico logo nos primeiros instantes, quando se efectua a pesquisa nos instantes anteriores(backSearch), n�o se t�m um valor inferior a 1 (fora dos limites do array)
    [valor,pos]=max(ecg(1,temp:j));
    marcador2(1,k)=pos+temp-1;
    k=k+1;
end


%% apresenta��o din�mica do ECG

tamanho=length(ecg);
partes=fix(tamanho/2000);
ecra=get(0,'ScreenSize');

f=figure('Position',[0.1*ecra(3) 0.1*ecra(4) 0.8*ecra(3) 0.8*ecra(4)]);


m=0;
batimentos=zeros(1,7);
ritmoOnline=0;

for i = 0:partes
    clf;
    inicio = 1+i*2000;
    fim = (i+1)*2000;
   
    
    if i==partes  %�ltimo grupo de pontos a exibir     
       for j=inicio:tamanho   
            maxY = max(ecg(1,inicio:tamanho));
            minY = min(ecg(1,inicio:tamanho)); 
            
            tempo=inicio/fs:1/fs:j/fs;
            plot(tempo,ecg(1,inicio:j),'-')
            if size(find(marcador2==j),2) == 1
                m=m+1;
                hold on;
                plot([j/fs,j/fs],[minY,ecg(j)],'r-','LineWidth',2); 
                hold off;
                
                if m <= 7                    
                    batimentos(1,m)=j;
                    ritmoOnline=round(m/((batimentos(1,m)-0)/(fs*60)));
                else
                    batimentos(1,1:6)=batimentos(1,2:7);
                    batimentos(1,7)=j;
                    ritmoOnline=round(7/((batimentos(1,7)-batimentos(1,1))/(fs*60)));                    
                end                                

            end
            title(['Ritmo card�aco: ',num2str(ritmoOnline)]);
            axis([inicio/fs fim/fs minY maxY]);
            xlabel('segundos');
            pause(1/fs);
       end

    else %restantes grupos de pontos a exibir
       for j=inicio:fim
            maxY = max(ecg(1,inicio:fim));
            minY = min(ecg(1,inicio:fim));
           
            tempo=inicio/fs:1/fs:(j/fs);
            plot(tempo,ecg(1,inicio:j),'-'); 
                        
            if size(find(marcador2==j),2) == 1
                m=m+1;
                hold on;
                plot([j/fs,j/fs],[minY,ecg(j)],'r-','LineWidth',2); 
                hold off;
                if m <= 7                    
                                       
                    batimentos(1,m)=j;
                    ritmoOnline=round(m/((batimentos(1,m)-0)/(fs*60)));
                    
                else                   
                    batimentos(1,1:6)=batimentos(1,2:7);
                    batimentos(1,7)=j;
                    ritmoOnline=round(7/((batimentos(1,7)-batimentos(1,1))/(fs*60)));                    
                end 
                                               
            end
            
            
            title(['Ritmo card�aco: ',num2str(ritmoOnline)]);
            axis([inicio/fs fim/fs minY maxY]);
            xlabel('segundos');
            pause(1/fs);
       end
    end

    
end

clear all;

