clc;
clear;
close all;

%% 1. LOAD IMAGES

cover = imread('cameraman.tif');

if size(cover,3) == 3
    cover = rgb2gray(cover);
end

cover = imresize(cover,[512 512]);
cover = uint8(cover);

secret = imread("C:\Users\Shreyasbavimj\Desktop\d\DIP\Images-DIP\Images-DIP\lena.png");

if size(secret,3) == 3
    secret = rgb2gray(secret);
end

secret = imresize(secret,[128 128]);
secret = uint8(secret);

%% 2. SET PREDEFINED PASSWORD

password = 'password';

fprintf('Password has been set successfully.\n');

%% 3. ENCRYPT SECRET IMAGE

secretBytes = secret(:);

passwordSeed = mod(sum(double(password).*(1:length(password))),256);

oldState = rng;
rng(passwordSeed,'twister');

keyStream = uint8(randi([0 255],numel(secretBytes),1));

rng(oldState);

encryptedBytes = bitxor(secretBytes,keyStream);

pixelBits = dec2bin(encryptedBytes,8)-'0';

bits = reshape(pixelBits.',[],1);

numBits = numel(bits);

fprintf('Secret image encrypted successfully.\n');

%% 4. HAAR DWT DECOMPOSITION

cover_norm = im2double(cover);

[LL,LH,HL,HH] = dwt2(cover_norm,'haar');

nLH = numel(LH);
nHL = numel(HL);
nHH = numel(HH);

coeff = [LH(:);HL(:);HH(:)];

if numBits > numel(coeff)
    error('Secret image exceeds embedding capacity.');
end

%% 5. QIM EMBEDDING

Delta = 0.05;

embedIdx = round(linspace(1,numel(coeff),numBits));

for k = 1:numBits

    b = bits(k);

    c = coeff(embedIdx(k));

    level = round((c-b*Delta)/(2*Delta));

    coeff(embedIdx(k)) = 2*Delta*level+b*Delta;

end

fprintf('Secret data embedded successfully.\n');

%% 6. RECONSTRUCT STEGO IMAGE

LH_mod = reshape(coeff(1:nLH),size(LH));

HL_mod = reshape(coeff(nLH+1:nLH+nHL),size(HL));

HH_mod = reshape(coeff(nLH+nHL+1:end),size(HH));

stego_norm = idwt2(LL,LH_mod,HL_mod,HH_mod,'haar');

stego_norm = min(max(stego_norm,0),1);

stego_uint8 = im2uint8(stego_norm);

imwrite(stego_uint8,'stego_image.png');

fprintf('Stego image saved as stego_image.png\n');

figure;
imshow(cover);
title('Original Cover Image');

figure;
imshow(stego_uint8);
title('Stego Image');

%% 7. EXTRACT EMBEDDED DATA

received = im2double(imread('stego_image.png'));

[~,rLH,rHL,rHH] = dwt2(received,'haar');

rCoeff = [rLH(:);rHL(:);rHH(:)];

recoveredBits = mod(round(rCoeff(embedIdx)/Delta),2);

recoveredMatrix = reshape(recoveredBits,8,[]).';

encryptedRecovered = uint8(bin2dec(char(recoveredMatrix+'0')));

fprintf('\nEncrypted secret image extracted.\n');

%% 8. PASSWORD AUTHENTICATION

fprintf('\n====================================\n');
fprintf('       PASSWORD AUTHENTICATION\n');
fprintf('====================================\n');

authenticated = false;

while ~authenticated

    enteredPassword = input('Enter password to extract secret image: ','s');

    if strcmp(enteredPassword,password)

        fprintf('\nCorrect password! Access granted.\n');

        authenticated = true;

    else

        fprintf('\nIncorrect password! Access denied.\n');
        fprintf('Please try again.\n\n');

    end

end

%% 9. DECRYPT SECRET IMAGE

oldState = rng;
rng(passwordSeed,'twister');

decryptKey = uint8(randi([0 255],numel(encryptedRecovered),1));

rng(oldState);

decryptedBytes = bitxor(encryptedRecovered,decryptKey);

recoveredSecret = reshape(decryptedBytes,size(secret));

figure;
imshow(recoveredSecret);
title('Recovered Secret Image');

fprintf('\nSecret image successfully recovered!\n');

%% 10. PERFORMANCE EVALUATION

bitErrors = sum(bits ~= recoveredBits);

BER = bitErrors/numBits;

accuracy = 100*(1-BER);

mseVal = mean((double(cover(:))-double(stego_uint8(:))).^2);

if mseVal == 0
    psnrVal = Inf;
else
    psnrVal = 10*log10(255^2/mseVal);
end

secretMSE = mean((double(secret(:))-double(recoveredSecret(:))).^2);

fprintf('\n====================================\n');
fprintf('       PERFORMANCE METRICS\n');
fprintf('====================================\n');

fprintf('PSNR: %.2f dB\n',psnrVal);
fprintf('Bit Errors: %d / %d\n',bitErrors,numBits);
fprintf('BER: %.6f\n',BER);
fprintf('Recovery Accuracy: %.2f%%\n',accuracy);
fprintf('Secret Image MSE: %.4f\n',secretMSE);

fprintf('\nProgram execution completed.\n');
