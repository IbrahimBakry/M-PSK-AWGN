
M = 8;
Tsym = 0.1;
Tsample = 0.01;
EbNoVec =0:2:12;

% TVec = [1000 1000 1000 15000 20000 100000 100000]*Tsym;

% for i=1:1:7
%     for j=1:1:3
%         SERVec(i,j)=0;
%         BERVec(i,j)=0;
%     end
% end

SERVec=[];
BERVec=[];

for n=1:length(EbNoVec);
% Tmax = TVec(n);
EbNodB = EbNoVec(n);
sim('MPSK_AWGN');
 SERVec(n,:)=SER(50,:);
 BERVec(n,:)=BER(50,:);
end;


semilogy(EbNoVec,SERVec)
hold on
semilogy(EbNoVec,BERVec,'-p')
title ('Symbol & Bit Error Probability')
ylabel ('Error')
xlabel ('Eb/No [db]')
legend ('Theoretical Symbol Error','Uncoded Symbol Error','Gray Coded Symbol Error','Theoretical BER Limits','Uncoded Bit Error','Gray Coded bit Error')
set(legend,'Position',[0.534523809523807 0.337301587301587 0.369642857142857 0.277777777777778]);
% grid on
hold off


%  plot(EbNoVec,SERVec)
%  hold on
%  plot(EbNoVec,BERVec,'p')



