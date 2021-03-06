function s = send(vec, size)

s = serial('COM7');
s.Baudrate=115200;
s.StopBits=1;
s.Parity='none';
s.FlowControl='none';
s.TimeOut = 1;
s.OutputBufferSize = 1024;
fopen(s);

fwrite(s,vec)

%for i = 1:size
%     fwrite(s,vec(i))
%     pause(0.01) % wait 1ms to let the data arrive to the FPGA
% end
