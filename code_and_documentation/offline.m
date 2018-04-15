function [duracao,numBatimentos,ritmo]=offline(path)
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
    temp = max(1,(j - backSearch)); 
    [valor,pos]=max(ecg(1,temp:j));
    marcador2(1,k)=pos+temp-1;
    k=k+1;
end


%% determina��o dos par�metros a devolver

%dura��o do ECG
duracao=((1/fs)*(length(ecg)-1))/60;  % um sinal amostrado com N pontos, tem N-1 intervalos de tempo de dura��o 1/fs

%n�mero batimentos
numBatimentos=length(marcador2);

%ritmo card�aco
ritmo=round(numBatimentos/duracao);