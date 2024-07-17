function obj = c_24_const_pitch_kown_scale(in1,ps,pc)
C11 = in1(1);
C12 = in1(4);
C13 = in1(7);
C14 = in1(10);
C21 = in1(2);
C22 = in1(5);
C23 = in1(8);
C24 = in1(11);
C31 = in1(3);
C32 = in1(6);
C33 = in1(9);
C34 = in1(12);
obj = [1.0,(C11.*C23.*C34-C11.*C24.*C33-C13.*C21.*C34+C13.*C24.*C31+C14.*C21.*C33-C14.*C23.*C31)./(C11.*C22.*C33-C11.*C23.*C32-C12.*C21.*C33+C12.*C23.*C31+C13.*C21.*C32-C13.*C22.*C31)];
end
