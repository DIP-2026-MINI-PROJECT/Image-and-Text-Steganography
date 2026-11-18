# Project Name Image and Text Steganography Using Haar DWT and QIM

### Project Description:
#### Summary - This project presents a MATLAB-based implementation of image and text steganography using Haar Discrete Wavelet Transform (DWT) and Quantization Index Modulation (QIM).

The primary objective is to securely conceal secret information inside a digital cover image while maintaining its visual quality.

The project consists of two independent modules:

Image-in-Image Steganography: Hides an encrypted grayscale secret image inside a cover image.

Text-in-Image Steganography: Hides an encrypted text message inside a cover image.

Both modules use password-based XOR encryption before embedding the secret information into selected wavelet detail coefficients using QIM.

The embedded information is extracted by applying DWT again, followed by password authentication and decryption to recover the original secret data.

The performance of the system is evaluated using Peak Signal-to-Noise Ratio (PSNR), Bit Error Rate (BER), recovery accuracy and Mean Squared Error (MSE).

#### Course concepts used - 
1. - Haar Transform: Used to decompose the cover image into four frequency subbands (LL, LH, HL and HH).
2. - Image Transforms: Two-dimensional Discrete Wavelet Transform and Inverse Discrete Wavelet Transform are used for embedding and reconstruction.
3. - Image Sampling and Quantization: QIM uses quantization levels to represent binary information in wavelet coefficients.
4. - Image Processing Operations: Grayscale conversion, image resizing, image reconstruction and image quality evaluation.
   
#### Additional concepts used -
1. - Steganography: Concealing secret information inside a digital cover image.
2. - XOR-Based Encryption: Encrypting secret text and image data using a password-derived pseudorandom keystream.
3. - Quantization Index Modulation (QIM): Embedding binary information by modifying selected wavelet coefficients according to two quantization patterns.
4. - Performance Evaluation: PSNR, BER, MSE and recovery accuracy are used to assess the quality of the stego image and the accuracy of data extraction.
   
#### Dataset - 
The project uses standard grayscale test images.

Cover Image: cameraman.tif, a standard MATLAB sample image.

Secret Image: lena.png, resized to 128 × 128 pixels before encryption and embedding.

Text Message: User-defined text entered during program execution.

The cover image is resized to 512 × 512 pixels. The secret image is resized to 128 × 128 pixels.

The required image files should be placed in the Images/ directory.



#### Novelty - 
1. - Integration of password-based XOR encryption with Haar DWT-based image steganography.
2. - Implementation of two independent steganography modules: Image-in-Image and Text-in-Image.
3. - Integration of QIM-based coefficient embedding, password authentication, extraction and decryption into a complete MATLAB workflow.
4. - Evaluation of the reconstructed stego image and recovered information using PSNR, BER, MSE and recovery accuracy.
   
### Contributors:
1. Name Gurujnan R Achar (PES1UG25EC804)
   Text-in-Image Steganography
   Password-based text encryption and decryption
   QIM embedding and extraction 
   Performance evaluation

3. Name Shreyas B (PES1UG24EC812)
   Image-in-Image Steganography
   Secret image encryption and decryption
   QIM embedding and extraction
   Performance evaluation

### Steps:
1. Clone Repository
git clone https://github.com/DIP-2026-MINI-PROJECT/Image-and-Text-Steganography.git

2. Install Dependencies
   Required software:
   
   MATLAB
   Image Processing Toolbox
   Wavelet Toolbox

4. Run the Code
run(fullfile('Text-in-Image','text_in_image.m'))

run(fullfile('Image-in-Image','image_in_image.m'))

### Outputs:
* Important intermediate steps
* 1. Text-in-Image Module
Original cover image
Stego image containing encrypted text
Password authentication
Successfully recovered secret message
PSNR, BER and recovery accuracy

* 2. Image-in-Image Module
Original cover image
Secret grayscale image
Generated stego image
Recovered secret image
PSNR, BER, recovery accuracy and secret image MSE

* Final output images 


### References:
1. - MATLAB Documentation — dwt2: https://www.mathworks.com/help/wavelet/ref/dwt2.html
2. - MATLAB Documentation — idwt2: https://www.mathworks.com/help/wavelet/ref/idwt2.html
3. - MATLAB Documentation — Image Processing Toolbox: https://www.mathworks.com/help/images/
4. - B. Chen and G. W. Wornell, "Quantization Index Modulation: A Class of Provably Good Methods for Digital Watermarking and Information Embedding," IEEE Transactions on Information Theory, 2001.
5. - I. J. Cox, M. L. Miller, J. A. Bloom, J. Fridrich and T. Kalker, Digital Watermarking and Steganography, 2nd Edition, Morgan Kaufmann, 2007.
   
### Limitations and Future Work:
Limitations

The current XOR-based password-derived encryption mechanism is intended for educational demonstration and is not suitable for production-grade security.
The current implementation has not been validated against JPEG compression, resizing, cropping or noise attacks.
The embedding positions are generated using a fixed coefficient-selection strategy.
The current implementation primarily operates on grayscale images.
Extraction depends on retaining the embedding parameters, including coefficient positions and the number of embedded bits.

Future Work

Replace the current encryption mechanism with AES-GCM and secure password-based key derivation.
Introduce adaptive QIM embedding to improve the trade-off between image quality and extraction robustness.
Implement error-correcting codes to improve recovery under noisy conditions.
Evaluate robustness against JPEG compression, resizing, cropping and other image-processing attacks.
Extend the system to colour images and multi-level wavelet decomposition.
Explore password-keyed coefficient selection for improved embedding security.
