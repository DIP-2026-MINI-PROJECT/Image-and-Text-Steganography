clc;
clear;
close all;

%% 1. LOAD COVER IMAGE

cover = imread('cameraman.tif');

if size(cover,3) == 3
    cover = rgb2gray(cover);
end

cover = imresize(cover,[512 512]);
cover = uint8(cover);

%% 2. SET MESSAGE AND PASSWORD

message = input('Enter the secret text message: ','s');

if isempty(message)
    error('Message cannot be empty.');
end

password = 'password';

fprintf('\nPassword set successfully.\n');

%% 3. ENCRYPT TEXT MESSAGE

messageBytes = uint8(message);

% Store message length (32-bit header)
messageLength = uint32(numel(messageBytes));

lengthBytes = typecast(messageLength,'uint8');

% Combine length and message
payload = [lengthBytes(:); messageBytes(:)];

% Generate password-derived keystream
passwordSeed = mod(sum(double(password).*(1:length(password))),256);

oldState = rng;
rng(passwordSeed,'twister');

keyStream = uint8(randi([0 255],numel(payload),1));

rng(oldState);

% XOR encryption
encryptedBytes = bitxor(payload,keyStream);

% Convert encrypted bytes to binary
pixelBits = dec2bin(encryptedBytes,8)-'0';

bits = reshape(pixelBits.',[],1);

numBits = numel(bits);

fprintf('Text message encrypted successfully.\n');

%% 4. HAAR DWT DECOMPOSITION

cover_norm = im2double(cover);

[LL,LH,HL,HH] = dwt2(cover_norm,'haar');

nLH = numel(LH);
nHL = numel(HL);

coeff = [LH(:);HL(:);HH(:)];

if numBits > numel(coeff)
    error('Message exceeds available embedding capacity.');
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

fprintf('Text message embedded successfully.\n');

%% 6. RECONSTRUCT STEGO IMAGE

LH_mod = reshape(coeff(1:nLH),size(LH));

HL_mod = reshape(coeff(nLH+1:nLH+numel(HL)),size(HL));

HH_mod = reshape(coeff(nLH+numel(HL)+1:end),size(HH));

stego_norm = idwt2(LL,LH_mod,HL_mod,HH_mod,'haar');

stego_norm = min(max(stego_norm,0),1);

stego_uint8 = im2uint8(stego_norm);

imwrite(stego_uint8,'text_stego_image.png');

fprintf('Stego image saved successfully.\n');

%% 7. DISPLAY IMAGES

figure;
imshow(cover);
title('Original Cover Image');

figure;
imshow(stego_uint8);
title('Stego Image with Hidden Text');

%% 8. EXTRACT ENCRYPTED TEXT

received = im2double(imread('text_stego_image.png'));

[~,rLH,rHL,rHH] = dwt2(received,'haar');

rCoeff = [rLH(:);rHL(:);rHH(:)];

recoveredBits = mod(round(rCoeff(embedIdx)/Delta),2);

recoveredMatrix = reshape(recoveredBits,8,[]).';

encryptedRecovered = uint8(bin2dec(char(recoveredMatrix+'0')));

fprintf('\nEncrypted text extracted successfully.\n');

%% 9. PASSWORD AUTHENTICATION

fprintf('\n====================================\n');
fprintf('       PASSWORD AUTHENTICATION\n');
fprintf('====================================\n');

authenticated = false;

while ~authenticated

    enteredPassword = input('Enter password to read hidden message: ','s');

    if strcmp(enteredPassword,password)

        fprintf('\nCorrect password! Access granted.\n');

        authenticated = true;

    else

        fprintf('\nIncorrect password! Access denied.\n');
        fprintf('Please try again.\n\n');

    end

end

%% 10. DECRYPT MESSAGE

oldState = rng;
rng(passwordSeed,'twister');

decryptKey = uint8(randi([0 255],numel(encryptedRecovered),1));

rng(oldState);

decryptedPayload = bitxor(encryptedRecovered,decryptKey);

% Extract original message length
lengthBytesRecovered = decryptedPayload(1:4);

recoveredLength = double(typecast(uint8(lengthBytesRecovered(:)),'uint32'));

if recoveredLength > numel(decryptedPayload)-4
    error('Invalid message length. Extraction failed.');
end

% Recover message
recoveredMessageBytes = decryptedPayload(5:4+recoveredLength);

recoveredMessage = char(recoveredMessageBytes(:).');

%% 11. DISPLAY RECOVERED MESSAGE

fprintf('\n====================================\n');
fprintf('         HIDDEN MESSAGE\n');
fprintf('====================================\n');

fprintf('%s\n',recoveredMessage);

fprintf('\nMessage successfully recovered!\n');

%% 12. PERFORMANCE EVALUATION

bitErrors = sum(bits ~= recoveredBits);

BER = bitErrors/numBits;

accuracy = 100*(1-BER);

mseVal = mean((double(cover(:))-double(stego_uint8(:))).^2);

if mseVal == 0
    psnrVal = Inf;
else
    psnrVal = 10*log10(255^2/mseVal);
end

fprintf('\n====================================\n');
fprintf('       PERFORMANCE METRICS\n');
fprintf('====================================\n');

fprintf('PSNR: %.2f dB\n',psnrVal);
fprintf('Bit Errors: %d / %d\n',bitErrors,numBits);
fprintf('BER: %.6f\n',BER);
fprintf('Recovery Accuracy: %.2f%%\n',accuracy);

fprintf('\nProgram execution completed.\n');
