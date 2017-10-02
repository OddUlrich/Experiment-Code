waveData=wave.data.'; % into row vector
received=reshape(waveData,1,[]);
% figure(1); plot(real(received)); title('real data');
% figure(2); plot(imag(received)); title('image data');

receive_rate = 1000000;
RateSym = 10000;
Sample = receive_rate / RateSym;
Rolloff = 1;

%--- RRC and filtering, RateSym = 10kHz, receive_rate = 1MHz --------%
filterDef = fdesign.pulseshaping(Sample,'Square Root Raised Cosine','Nsym,Beta',6, Rolloff);
myFilter = design(filterDef);
filtered = conv(myFilter.Numerator, received);
% figure(3); plot(real(filtered)); title('filtered');

%--- cut a frame from signal ---%
cutdata = filtered(173604:219761)
oneFrame = reshape(cutdata,1,[]);
% figure(4); plot(real(oneFrame)); title('real of oneFrame');

%--- DPSK ---%
decode = zeros();
j = 1;
for i = 173604:219761
    decode(j) = real(filtered(i) * conj(filtered(i + Sample)));
    j = j + 1;
end
% figure(5); plot(decode); title('DPSK');
    
%--- 100 times downsample ---%
downsample = zeros()
down = 1;
for k = 75:100:length(decode)   % 75 to begin at the precode
    downsample(down) = decode(k);
    down = down + 1;
end
% figure(6); plot(downsample); title('100 times downsample');

code = zeros();
for i = 1:length(downsample)
    if (downsample(i) >= 0)
        code(i) = 0;
    else
        code(i) = 1;
    end
end
% figure(7); plot(code); title('code');
% axis([0 length(downsample) -1 2]);

%-- decode :conv code transformation ---%  
wait_decode = code(17:443+17);  % abandon the precode from 1 to 16
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



