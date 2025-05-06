%   Demonstration of Eb/N0 Vs SER for all M-PSK modulation scheme
%   Directed by: Ibrahim Bakry as A Charched Project to . . . 

clear;
clc;

%---------Input Fields------------------------
N=1000000;           %Number of input symbols
EbN0dB = 0:2:12;     %Define EbN0dB range for simulation

k=2:1:5;                 % Number of Symbols for each M-PSK modulation
Rc=1;                       %Rc = code rate for a coded system. Since no coding is used Rc=1

%---------------------------------------------
M=2.^k;                %for M-PSK modulation.

S_SER= zeros(length(M),length(EbN0dB));       % simulatedSER 
T_SER= zeros(length(M),length(EbN0dB));       % theoreticalSER 

plotColor =['b','g','r','c'];

for i=M,
    [S_SER(i,:), T_SER(i,:)]= simulateMPSK(i,N,EbN0dB,Rc);
end

%Plot commands

j=1;
for i=M,
     plot(EbN0dB,log10(S_SER(i,:)),sprintf('%s-',plotColor(j))); hold on; 
     j=j+1;
end