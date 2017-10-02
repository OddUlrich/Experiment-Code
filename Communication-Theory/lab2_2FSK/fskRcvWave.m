waveData=wave.data.'; % into row vector
received=reshape(waveData,1,[]);
% received = modulated;
% figure(1); plot(real(received)); title('real data');
% figure(2); plot(imag(received)); title('image data');

receive_rate = 1000000;
RateSym = 10000;
Sample = receive_rate / RateSym;
Rolloff = 1;
f1 = 10000; f2 = 20000;

num = 0:length(received)-1;
f0 = receive_rate*num/length(received) - receive_rate/2;
spect = fftshift(fft(received));
figure(3);plot(f0,abs(spect));

%--- 2FSK Demodulation ---%
one_frame = received[3441252:3824571];%
d = fdesign.bandpass('N,F3dB1,F3dB2',2, f1, (f2-f1)/2+f1, one_frame); 
Hd = design(d,'butter');
filted1 = filter(Hd, one_frame);
figure(4);plot(real(filted1));
filted2 = hilbert(real(filted1));
figure(5);plot(abs(filted2));

%--- 100 times downsample ---%
downsample = zeros();
down = 1;
for k = 214:100:length(filted2)   % 214 to begin at the precode
    downsample(down) = filted2(k);
    down = down + 1;
end
figure(6); plot(real(downsample)); title('100 times downsample');

code = zeros();
for i = 1:length(downsample)
    if (real(downsample(i)) >= 0)
        code(i) = 0;
    else
        code(i) = 1;
    end
end

%-- decode :conv code transformation ---%  
wait_decode = code(16+91:443+16+91);  % abandon the precode from 1 to 16
CoderConstraint = 7;%  约束长度 
trel = poly2trellis(CoderConstraint, [171, 133]);
StrInBit = vitdec(wait_decode, trel, 2, 'trunc', 'hard');
StrInBit = StrInBit(1:216);

%-- decode: Switch bitflow into string ---%
BitInLen = length(StrInBit)/8;
StrInBit4 = num2str(StrInBit.').';

BitInAscii = zeros(1,BitInLen);
for loop = 1:BitInLen
    loop;
    OneChar = StrInBit4(8*loop-7:8*loop);
    BitInAscii(loop) = bin2dec(OneChar);    
end                             %输入比特流转化为ASCII码

StrOutput = char(BitInAscii);  %输入比特流转化为字符串
disp(StrOutput);   %打印字符串



