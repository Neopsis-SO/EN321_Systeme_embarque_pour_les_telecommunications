%% Projet EN321 - Simulation d'une TX/RX sans modulation OFDM - Version double codeur de canal
% La chaine de communication est compos�e de 2 codeurs de canal s�par�s par
% un entrelaceur convolutif. Le premier codeur est un codeur en bloc, le
% second est un codeur en ligne.

instrreset;
clear all;
close all;

%%%%%%%%%%%
%% INITIALIZATION
%%%%%%%%%%%

Fe=20e6; % sampling frequency
Te=1/Fe;
TC=40; % temperature (Celcius)
TK=274+TC; % temperature (Kelvin)
f0=2e9; % carrier frequency
kboltzman=1.3806400e-23; % Boltzmann constant
N0=kboltzman*Fe*TK; % Noise power
N0dB=10*log10(N0);
sprintf('Noise power : %d dB',N0dB)
Ptx=0.01; % transmitted signal power (Watt)
Ptx_dB=10*log10(Ptx);
d=100*rand+10; % distance between Tx and Rx (meters)
c=3e8; % speed of light
Prx=Ptx*(c/(f0*4*pi*d))^2; % recevied signal power (Watt)
Prx_dB=10*log10(Prx);

sprintf('Distance Tx/Rx (m): %d',d)
sprintf('Transmitted signal power  : %d dB',Ptx_dB)
sprintf('Received signal power  : %d dB',Prx_dB)
sprintf('SNR at the receiver side : %d dB',Prx_dB-N0dB)

NFFT=64;
% bch_k=52; % sub-carrier number

%W=bch_k/NFFT*Fe; % transmitted signal bandwidth

nb=2; % number of bits per symbol
disp('Code MAC binaire correspondant � la modulation num�rique : ')
b0_b2=de2bi(nb,3,'left-msb')

M=2^nb;
type_mod='psk';

L=30; % size of the channel
freq_axis = [-1/(2*Te):1/(NFFT*Te):1/(2*Te)-1/(NFFT*Te)];
noise_variance=N0; % noise variance

%% Scrambler parameters
scramb_polynomial=[1 1 1 0 1];
scramb_init_state=[0 0 0 0];
Scrambler_U_obj=comm.Scrambler(2,scramb_polynomial,scramb_init_state); % scrambler creation

%% BCH parameters
bch_n=7;   % code block-length
bch_k=4;   % code dimension

%% Convolutionnal interleaver
intlvr_line_nb=7; % nb of lines ( = shift-registers) in the interleaver
intlvr_reg_size=1; % number of bits per register

%% Convolutionnal encoder parameters 
trellis = poly2trellis(3,[5 3]); % generator polynomial : (15,13)


%% Data reading/generation

data_mode = 'rand_binary_image'; % generation of a random binary image
%data_mode = 'color_image';

if(data_mode == 'rand_binary_image')
    
    % Generation de donnees aleatoire et disposition dans une image
    Nb_ligne_IMG=10;
    Nb_colonne_IMG=10;
    U_soft_size=Nb_ligne_IMG*Nb_colonne_IMG;   % nombre de bits utiles codés
    % génération aléatoire de donn?es binaires
    rng(654354)
    tmp=(randi(2,U_soft_size)-1);
    U_soft = tmp(1,:)
    % on place les données dans une matrice qui sera affichée comme une image
    img2send=reshape(U_soft,Nb_ligne_IMG,Nb_colonne_IMG)
    
elseif(data_mode == 'color_image')
    
    % Lecture d'une image
    img2send=imread('./bdd_image/logo.jpg'); % l'image est retourn?e sous la forme d'une matrice 3D RGB
    U_soft_R=reshape(de2bi(reshape(img2send(:,:,1),[],1),8,'left-msb').',[],1); % flux binaire du rouge
    U_soft_G=reshape(de2bi(reshape(img2send(:,:,2),[],1),8,'left-msb').',[],1); % flux binaire du vert
    U_soft_B=reshape(de2bi(reshape(img2send(:,:,3),[],1),8,'left-msb').',[],1); % flux binaire du bleu    
    U_soft=[U_soft_R;U_soft_G;U_soft_B].';
    U_soft_size=length(U_soft);
    Nb_ligne_IMG=size(img2send,1);
    Nb_colonne_IMG=size(img2send,2);
    U_soft=[U_soft_R;U_soft_G;U_soft_B].';
end

U_soft_size=length(U_soft);

%%%--------------------------------------------------------------------%%%%
%%- CHANNEL CODING
%%%---------------------------------------------------------------------%%%


%% Padding for the BCH encoder and the interleaver

full_bch_cwd_nb = floor(U_soft_size/bch_k)
bch_cwd_nb = (full_bch_cwd_nb +1) + (intlvr_line_nb-1);

intlvr_pad_bit_nb = bch_k * intlvr_reg_size * (intlvr_line_nb - 1); % after BCH encoding, there is intlvr_line_nb*intlvr_reg_size*(intlvr_line_nb-1) padding bits for the interleaver
bch_pad_bit_nb = bch_k-(U_soft_size-full_bch_cwd_nb*bch_k);

total_pad_bit_nb = bch_pad_bit_nb + intlvr_pad_bit_nb; 

sprintf('Nb of padding bits for the last BCH codeword + interleaver: %d',total_pad_bit_nb)

padding_bits=zeros(1,total_pad_bit_nb);
bch_bit_nb = bch_cwd_nb * bch_n;

V_soft = [U_soft, padding_bits];
V_soft_size = length(V_soft);

%% Write TX UART
s = send_UART(V_soft, V_soft_size)

%% Read UART REGISTER TEST
% V_hard = recv_UART(s, V_soft_size);
% test = V_soft - V_hard';
% V_soft = V_hard';

%% Scrambler
S_soft=step(Scrambler_U_obj,V_soft.');

%% Read UART SCRAMBLER TEST
% S_hard = recv_UART(s, V_soft_size);
% test = V_soft - S_hard'
% S_soft = S_hard;

%% BCH Encoder
X_gf_soft = bchenc(gf(reshape(S_soft, bch_k, bch_cwd_nb).',1), bch_n, bch_k); % codeur BCH(bch_n,bch_k)
X_soft = double( X_gf_soft.x );

%% Interleaver
P_soft=convintrlv([reshape(X_soft.',1,[])],intlvr_line_nb,intlvr_reg_size);

%% Write UART CONVOLUTION TEST
% s = send_UART(P_soft,length(P_soft))

%% Convolutionnal Encoder
C_soft = convenc(P_soft,trellis);

%% Read TX UART
C_hard = recv_UART(s, bch_bit_nb);
C_hard = reshape(de2bi(C_hard)',1,[]);
test = C_soft - C_hard;
C_soft = C_hard;

%% OFDM Modulator 
% No OFDM here
% % Vérification du nombre de bits padding
% verif = mod(size(C_soft,2),NFFT);
% 
% if verif == 0
%     k = C_soft/NFFT;
%     nb_bit_padding = mod(k,nb)*NFFT;
% else
%     nb_bit_padding = NFFT+verif;
% end

nb_bit_padding = 64;
padding = randi([0,1],1,nb_bit_padding);
C_soft_padding = [C_soft padding];

%%%--------------------------------------------------------------------%%%%
%%- DIGITAL MODULATION
%%%---------------------------------------------------------------------%%%
X=bi2de(reshape(C_soft_padding.',length(C_soft_padding)/nb,nb),'left-msb').'; % bit de poids fort � gauche
init_phase=0;
if type_mod=='psk'
    if nb==2
        init_phase=pi/4;
    end
       symb_utiles = pskmod(X,M,init_phase,'gray');
elseif type_mod=='qam'
       symb_utiles = qammod(X,M,0,'gray');
else
    sprintf('Erreur modulation inconnue')
    s=[];
end

%%%--------------------------------------------------------------------%%%%
%%- IFFT
%%%---------------------------------------------------------------------%%%

Nb_port_utiles = 64;
Nb_symbole = 4;
size_channel = 30;

mat_ifft = reshape(symb_utiles, Nb_port_utiles, Nb_symbole);
for i=1:Nb_symbole
   symb_ofdm(:,i) = ifft(mat_ifft(:,i));
end
size_ofdm = size(symb_ofdm,1);
pref_cycl = symb_ofdm(size_ofdm-size_channel:size_ofdm,:);
symb_ofdm = [pref_cycl; symb_ofdm];
symb_ofdm_tx = reshape(symb_ofdm,1,size(symb_ofdm,1)*size(symb_ofdm,2));

%% Affichage en sortie du modulateur
figure,
polar(real(symb_ofdm_tx),'*')
title('Partie réelle en sortie du modulateur');

figure,
polar(imag(symb_ofdm_tx),'*')
title('Partie imaginaire en sortie du modulateur');

figure,
hist(real(symb_ofdm_tx), 50)
title('Partie réelle en sortie du modulateur');

%%
%%%--------------------------------------------------------------------%%%%
%%- CHANNEL (normalized channel : average power)
%%%---------------------------------------------------------------------%%%
% h = 1; % discrete channel without multi-path
h=sqrt(1/(2*L))*(randn(1,L)+1i*randn(1,L)); % discrete channel with multi-path
y = filter(h,1,symb_ofdm_tx);
       
%%
%%%--------------------------------------------------------------------%%%%
%% RECEIVER
%%%---------------------------------------------------------------------%%%
noise_variance = 2e-4;
noise = sqrt(noise_variance/(2))*(randn(size(y))+1i*randn(size(y)));
z = y + noise; 

%% OFDM Demodulator 
mat_ifft = reshape(z, Nb_port_utiles+size(pref_cycl,1), Nb_symbole);
mat_ifft = mat_ifft(size(pref_cycl,1)+1:Nb_port_utiles+size(pref_cycl,1),:);
for i=1:Nb_symbole
   symb_ofdm_r(:,i) = fft(mat_ifft(:,i));
end

%% Channel Equalizer

H = fft(h,NFFT); % Coefficients du filtre ramené en plan de fourier

for i=1:Nb_symbole
   symb_ofdm_r(:,i) =  symb_ofdm_r(:,i).'./H;
end

symb_ofdm_rx = reshape(symb_ofdm_r,1,Nb_symbole*Nb_port_utiles);

%% Affichage en sortie du démodulateur
figure,
plot(real(symb_ofdm_rx), imag(symb_ofdm_rx),'*')
title('Symboles en sortie du démodulateur');
%% Demodulation

symb_U_Rx = symb_ofdm_rx;

init_phase = 0;
if type_mod=='psk'
    if nb==2
        init_phase=pi/4;
    end
       s = pskdemod(symb_U_Rx,M,init_phase,'gray');
       X=de2bi(s,log2(M),'left-msb').'; % bit de poids fort � gauche   
       
else
       s = qamdemod(symb_U_Rx,M,0,'gray');
       X=de2bi(s,log2(M),'left-msb').'; % bit de poids fort � gauche
       
end

C_r_soft=reshape(X.',1,[]);
C_r_soft = C_r_soft(1:(length(C_r_soft)-nb_bit_padding));
C_r_soft_size = length(C_r_soft);

%% Write RX UART
% s = send_UART(C_r_soft,C_r_soft_size)

%% Read UART REGISTER TEST
% C_r_hard = recv_UART(s, C_r_soft_size);
% test = C_r_soft - C_r_hard';
% C_r_soft = C_r_hard';

%% Viterbi Decoding

trellis_depth=42; % profondeur du trellis

P_r_soft = vitdec(C_r_soft,trellis,trellis_depth,'trunc','hard');

BER_U_A_Viterbi = mean(abs(P_soft-P_r_soft))

%% Read UART Viterbi Decoding TEST
% P_r_hard = recv_UART(s, C_r_soft_size/2);
% test = P_r_soft - P_r_hard';
% P_r_soft = P_r_hard';

%% Deinterleaving

X_r_soft=convdeintrlv(P_r_soft,intlvr_line_nb,intlvr_reg_size);

%% Write UART BCH DECODING TEST
s = send_UART(X_r_soft, length(X_r_soft))

%% BCH decoding

S_r_soft_gf=bchdec(gf(reshape(X_r_soft,bch_n,bch_cwd_nb).',1),bch_n,bch_k); 
S_r_soft = uint8(S_r_soft_gf.x);

S_r_soft_Depad_temp = reshape(S_r_soft.',1,[]);
S_r_soft_Depad = S_r_soft_Depad_temp(intlvr_pad_bit_nb+1:end);
S_r_soft_Depad = S_r_soft_Depad(1:end-bch_pad_bit_nb)
%BER_U = mean(abs(S_r_soft_Depad-uint8(U_soft'))); % final BER

%% Read UART BCH DECODING TEST
S_r_hard_Depad = recv_UART(s, bch_cwd_nb*bch_k);
S_r_hard_Depad = uint8(S_r_hard_Depad);
S_r_hard_Depad = reshape(S_r_hard_Depad,1,[]);
S_r_hard_Depad = S_r_hard_Depad(intlvr_pad_bit_nb+1:end);
S_r_hard_Depad = S_r_hard_Depad(1:end-bch_pad_bit_nb);
test = S_r_soft_Depad - S_r_hard_Depad;
S_r_soft_Depad = S_r_hard_Depad;

%% Write UART DESCRAMBLEUR TEST
% s = send_UART(S_r_soft_Depad,length(S_r_soft_Depad))

%% Descrambler
Descrambler_U_obj = comm.Descrambler(2,scramb_polynomial,scramb_init_state);

S_r_soft_Depad=step(Descrambler_U_obj,S_r_soft_Depad.'); % descrambler

BER_U = mean(abs(S_r_soft_Depad-uint8(U_soft')));

%% Read RX UART
% S_r_hard_Depad = recv_UART(s, length(S_r_soft_Depad));
% S_r_hard_Depad = reshape(de2bi(S_r_hard_Depad),1,[]);
% S_r_hard_Depad = uint8(S_r_hard_Depad).';
% test = S_r_soft_Depad - S_r_hard_Depad;
% S_r_soft_Depad = S_r_hard_Depad;

%% Image reconstruction

if(data_mode == 'rand_binary_image')
    imgRx=reshape(S_r_soft_Depad,Nb_ligne_IMG,Nb_colonne_IMG);
elseif(data_mode == 'color_image')
    bitsRx=reshape(S_r_soft_Depad,[],3);
    intRx_R=uint8(bi2de(reshape(bitsRx(:,1),8,[]).','left-msb'));
    intRx_G=uint8(bi2de(reshape(bitsRx(:,2),8,[]).','left-msb'));
    intRx_B=uint8(bi2de(reshape(bitsRx(:,3),8,[]).','left-msb'));

    imgRx(:,:,1)=reshape(intRx_R,Nb_ligne_IMG,Nb_colonne_IMG);
    imgRx(:,:,2)=reshape(intRx_G,Nb_ligne_IMG,Nb_colonne_IMG);
    imgRx(:,:,3)=reshape(intRx_B,Nb_ligne_IMG,Nb_colonne_IMG);
end

figure(5)
subplot 131;
if(data_mode == 'rand_binary_image')
    imagesc(img2send)
elseif(data_mode == 'color_image')
    image(img2send)
end
title('Image emise')

subplot 132;
if(data_mode == 'rand_binary_image')
    imagesc(imgRx)
elseif(data_mode == 'color_image')
    image(imgRx)
end
title('Image recue')

subplot 133;
if(data_mode == 'rand_binary_image')
    imagesc(uint8(img2send)-imgRx)
elseif(data_mode == 'color_image')
    image(uint8(img2send)-imgRx)
end
title('diff des images')

%% BER results
disp('--------------------------------------------------------------------')
fprintf('SNR at the receiver side : %d dB\n',round(Prx_dB-N0dB))
disp('--------------------------------------------------------------------')

fprintf('BER after Viterbi decoding: %d\n',(BER_U_A_Viterbi))
fprintf('BER after BCH : %d\n',(BER_U))
disp('--------------------------------------------------------------------')
