clc
clear all
recObj= audiorecorder(8000,16,1);
disp('Start speaking.')
record(recObj);
pause(5);
stop(recObj);
disp('End of Recording.');
x = getaudiodata(recObj);
Fs=8000;
t=0:1/Fs:(length(x)*(1/Fs))-(1/Fs);
 Delay = 0.5;
 Alpha = 0.70;
 Delta = round(Delay*Fs);
 OriginalSound = [x;zeros(Delta,1)];
 Echo = [zeros(Delta,1);x]*Alpha;
 EchoSound = OriginalSound + Echo;
 t=(0:length(EchoSound)-1)/Fs;
figure(1);
subplot(2,1,1)
plot(t,[OriginalSound Echo])
title("Echo Signal")
legend('Original','Echo')
xlabel('Time(s)')
subplot(2,1,2)
plot(t,EchoSound)
title("Echo Signal")
legend('Total')
xlabel('Time(s)')
[Rmm,lags] = xcorr(EchoSound,'unbiased');
Rmm = Rmm(lags>0);
lags = lags(lags>0);
figure(2)
title("Lag of The Signal")
plot(lags/Fs,Rmm)
xlabel('Lag')
[~,dl] = findpeaks(Rmm,lags,'MinPeakHeight',0.22);
Filtered = filter(1,[1 zeros(1,dl-1) Alpha],EchoSound);
figure(3)
subplot(2,1,1)
plot(t,OriginalSound)
title("Original Signal")
legend('Original')
subplot(2,1,2)
plot(t,Filtered)
title("Filtered Signal")
legend('Filtered')
xlabel('Time')
disp('signal to noise ratio (SNR):')
disp(snr(OriginalSound,Filtered))
disp('Mean Squared Error (MSE):')
immse(OriginalSound,Filtered)
 b = [1,zeros(1,Delta),Alpha];
 y = filter(b,1,x);
 Filtered=filter(1,b,y);
 minLength = min(length(t), length(Filtered));
 t2 = t(1:minLength);
 pause(1)
 disp('Original Voice')
 sound(OriginalSound ,Fs)
 pause(4)
 disp('Echo Voice')
 sound(EchoSound,Fs)
 pause(4)
 disp('Filtered Voice')
 sound(Filtered,Fs)

