clear all;
close all;

Fs=200000;
RateSym=10000;
Sample=Fs/RateSym;
CoderConstraint = 7;%  约束长度 
Preamble=[1,0,1,0,1,1,0,0,1,0,1,0,1,1,0,0];
MsgLength=216;
f1 = 10000; f2 = 20000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: StrInput; Output: StrInBit
StrInput = 'A message is for test only!';
StrInAscii = abs(StrInput);   %输入字符串的ASCII码
StrInBit1 = dec2bin(StrInAscii,8);
StrInBit2 = StrInBit1.';
StrInBit3 = StrInBit2(:);   
StrInBit = str2num(StrInBit3(:)).';  %输入字符串的bit流
msg = StrInBit;%  the hidden message

%----------调用matlab库函数生成(2,1,7)卷积码编码结果----------
trel = poly2trellis(CoderConstraint, [171, 133]);
msgWithTail = [msg, zeros(size(1 : CoderConstraint - 1))];%  结尾处理, 在消息的结尾添加 coder_constraint-1 个零
code = convenc(msgWithTail, trel);%  调用库函数所生成卷积码

%----------add preamble-------------
data=[Preamble,code];

%------------ Freequency modulation ----------------%
T = 1:1:Sample; len = length(T);
y0 = zeros(length(data),Sample);
y = reshape(y0,1,[]);
for k=0:1:length(data)-1
    if data(k+1) > 0
        y(k*len + T) = exp(1i*2*pi*f1*T/Fs);
    else 
        y(k*len + T) = exp(1i*2*pi*f2*T/Fs);
    end
end
x0 = 1:1:length(data)*len;
x = 1:1:length(data)*len+2*100*Sample;
modulated=[zeros(1,100*Sample), y, zeros(1,100*Sample)];

figure(1);plot(x, real(modulated));
title('2FSK调制波形(带有0序列)');
axis([1, length(x), -2, 2]);

figure(2);plot(x0, real(y));
title('2FSK调制波形');
axis([1, length(x0), -2, 2]);

%-----------write to wave
wave.time=[];
wave.signals.values = y.';
wave.signals.dimensions = 1;
figure(3);
plot(real(y));



