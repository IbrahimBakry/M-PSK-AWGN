M = 8;                    % Modulation order
SamplesPerFrame = 10000;  % Symbols processed for each iteration of the
                          % stream processing loop

% Initialize variables used to determine when to stop processing bits
maxNumErrs=100;
maxNumBits=1e8;

% Since the AWGN Channel as well as the RANDI function uses the default
% random stream, the following commands are executed so that the results
% will be repeatable, i.e. same results will be obtained for every run of
% the example. The default stream will be restored at the end of the
% example.
prevState = rng;
rng(529558);


hInt2Bit = comm.IntegerToBit('BitsPerInteger',log2(M), ...
                    'OutputDataType','uint8');
hBit2Int = comm.BitToInteger('BitsPerInteger',log2(M), ...
                    'OutputDataType','uint8');


hMod = comm.PSKModulator('ModulationOrder',M, ...
                    'SymbolMapping','gray', ...
                    'PhaseOffset',0, ...
                    'BitInput',true);
hDemod = comm.PSKDemodulator('ModulationOrder',M, ...
                    'SymbolMapping','gray', ...
                    'PhaseOffset',0, ...
                    'BitOutput',true, ...
                    'OutputDataType','uint8', ...
                    'DecisionMethod','Hard decision');


hSymError = comm.ErrorRate;
hBitError = comm.ErrorRate;


% For each Eb/No value, simulation stops when either the maximum number of
% errors (maxNumErrs) or the maximum number of bits (maxNumBits) processed
% by the bit error rate calculator System object is reached.
EbNoVec = 0:2:12;                             % Eb/No values to simulate
SERVec = zeros(size(EbNoVec));                % Initialize SER history
BERVec = zeros(size(EbNoVec));                % Initialize BER history
for p = 1:length(EbNoVec)
  % Reset System objects
  reset(hSymError);
  reset(hBitError);
  hChan.EbNo = EbNoVec(p);
  % Reset SER / BER for the current Eb/No value
  SER = zeros(3,1);                           % Symbol Error Rate
  BER = zeros(3,1);                           % Bit Error Rate
  while (BER(2)<maxNumErrs) && (BER(3)<maxNumBits)
    % Generate random data
    txSym = randi([0 M-1], SamplesPerFrame, 1, 'uint8');
    txBits = step(hInt2Bit, txSym);           % Convert symbols to bits
    tx = step(hMod, txBits);                  % Modulate
    rx = step(hChan, tx);                     % Add white Gaussian noise
    rxBits = step(hDemod, rx);                % Demodulate
    rxSym = step(hBit2Int, rxBits);           % Convert bits back to symbols

    % Calculate error rate
    SER = step(hSymError, txSym, rxSym);      % Symbol Error Rate
    BER = step(hBitError, txBits, rxBits);    % Bit Error Rate
  end
  % Save history of SER and BER values
  SERVec(p) = SER(1);
  BERVec(p) = BER(1);
end

[theorBER, theorSER] = berawgn(EbNoVec, 'psk', M, 'nondiff');


Plot the results.
figure;
semilogy(EbNoVec,SERVec,'o',   EbNoVec,BERVec,'*', ...
         EbNoVec,theorSER,'-', EbNoVec,theorBER,'-');
legend  ( 'Symbol error rate',              'Bit error rate', ...
          'Theoretical Symbol error rate',  'Theoretical Bit error rate', ...
          'Location','SouthWest');
xlabel  ( 'Eb/No (dB)' ); ylabel( 'Error Probability' );
title   ( 'Symbol and Bit Error Probability' );   grid on;

