%% BCH matrice

% bch_n=7;   % code block-length
% bch_k=4;   % code dimension
% 
% m = [1 0 0 0;
%      0 1 0 0;
%      0 0 1 0;
%      0 0 0 1];
% 
% G_gf = bchenc(gf(m,1), bch_n, bch_k); % codeur BCH(bch_n,bch_k)
% G = double( G_gf.x )

%% BCH matrice inverse

% bch_n=7;   % code block-length
% bch_k=4;   % code dimension
% 
% m = [1 0 0 0 0 0 0;
%      0 1 0 0 0 0 0;
%      0 0 1 0 0 0 0;
%      0 0 0 1 0 0 0;
%      0 0 0 0 1 0 0;
%      0 0 0 0 0 1 0;
%      0 0 0 0 0 0 1];
%  
% G_inv_gf = bchdec(gf(m,1),bch_n,bch_k); 
% G_inv = double( G_inv_gf.x )

%% BCH test
% s = send_UART([0 0 0 0 0 0 1],7)
% test = recv_UART(s, 4);

% test_vector = [1 0 0 0 0 0 0;
%                0 1 0 0 0 0 0;
%                0 0 1 0 0 0 0;
%                0 0 0 1 0 0 0;
%                1 0 1 1 0 0 0];
% test_vector = fliplr(test_vector);
% 
% S_r_soft_gf=bchdec(gf(test_vector,1),bch_n,bch_k); 
% S_r_soft = uint8(S_r_soft_gf.x);
% 
% S_r_soft_Depad_temp = reshape(S_r_soft.',1,[]);
% S_r_soft_Depad = S_r_soft_Depad_temp(intlvr_pad_bit_nb+1:end);
% S_r_soft_Depad = S_r_soft_Depad(1:end-bch_pad_bit_nb)