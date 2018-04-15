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

%% derivada de primeira ordem e potenciação
e3=diff(e2);
e4=e3.^2;

%% média movel
timeWindow=0.2;
N=fix(timeWindow*fs);
b=(1/N)*ones(1,N);
a=1;
e5=filter(b,a,e4);

%% definição do valor de threshold, numero de pontos de delay (correspondentes a 0.3 s)
% e número de pontos correspondentes ao período de backSearch (0.5 s)
threshold=0.7*mean(e5);

%ALTERAÇÃO RELATIVAMENTE AO ENUNCIADO (determinação de um número inteiro de pontos (fix)
delay=fix(0.3*fs);
backSearch=fix(0.5*fs);


%% definição dos instantes em que o valor de threshold é ultrapassado e
% tendo em consideração o período de delay
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

%% extracção dos instantes em que foi ultrapassado o valor do threshold
instantes=find(marcador~=0); 


%% detecção de picos no sinal original de ECG tendo em consideração o intervalo backSearch

marcador2=zeros(1,length(instantes));
k=1;
for j=instantes   
    temp = max(1,(j - backSearch)); 
    [valor,pos]=max(ecg(1,temp:j));
    marcador2(1,k)=pos+temp-1;
    k=k+1;
end


%% determinação dos parâmetros a devolver

%duração do ECG
duracao=((1/fs)*(length(ecg)-1))/60;  % um sinal amostrado com N pontos, tem N-1 intervalos de tempo de duração 1/fs

%número batimentos
numBatimentos=length(marcador2);

%ritmo cardíaco
ritmo=round(numBatimentos/duracao);