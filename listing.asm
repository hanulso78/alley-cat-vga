; ALLYCAT.EXE 코드 세그먼트 (CS=0723)  - tools/mklist.py 가 만든 목록

; ----------------------------------------------------------------------
sub_0000:
0000  1e        push   ds
0001  b80000    mov    ax, 0
0004  50        push   ax
0005  e8585c    call   sub_5c60
0008  b81000    mov    ax, 0x10
000b  8ed8      mov    ds, ax
000d  e89a13    call   sub_13aa
0010  c606900604  mov    byte ptr [0x690], 4
0015  c706f86d0000  mov    word ptr [0x6df8], 0
001b  c6069b0600  mov    byte ptr [0x69b], 0
0020  e8f613    call   sub_1419
0023  e8c213    call   sub_13e8
0026  a19306    mov    ax, word ptr [0x693]
0029  054002    add    ax, 0x240
002c  a3006e    mov    word ptr [0x6e00], ax
002f  b80400    mov    ax, 4
0032  cd10      int    0x10
0034  b004      mov    al, 4
0036  803e9706fd  cmp    byte ptr [0x697], 0xfd
003b  7402      je     loc_003f
003d  b006      mov    al, 6
  loc_003f:
003f  a29006    mov    byte ptr [0x690], al
0042  b40b      mov    ah, 0xb
0044  bb0101    mov    bx, 0x101
0047  cd10      int    0x10
0049  c70616040000  mov    word ptr [0x416], 0
004f  c70604000000  mov    word ptr [4], 0
0055  e8d91c    call   sub_1d31
0058  803e9706fd  cmp    byte ptr [0x697], 0xfd
005d  7406      je     loc_0065
005f  bad903    mov    dx, 0x3d9
0062  b020      mov    al, 0x20
0064  ee        out    dx, al
  loc_0065:
0065  e8a82d    call   sub_2e10
0068  e87626    call   sub_26e1
006b  e86c26    call   sub_26da
006e  c6061a0400  mov    byte ptr [0x41a], 0
0073  b8ffff    mov    ax, 0xffff
0076  a31d04    mov    word ptr [0x41d], ax
0079  a31f04    mov    word ptr [0x41f], ax
007c  c6060000ff  mov    byte ptr [0], 0xff
  loc_0081:
0081  e80c26    call   sub_2690
0084  c70608000000  mov    word ptr [8], 0
008a  c70604000000  mov    word ptr [4], 0
0090  e89e1c    call   sub_1d31
0093  e88b5a    call   sub_5b21
0096  e8175c    call   sub_5cb0
0099  e8855a    call   sub_5b21
009c  803e1a0400  cmp    byte ptr [0x41a], 0
00a1  750b      jne    loc_00ae
  loc_00a3:
00a3  e87b5a    call   sub_5b21
00a6  e83c5e    call   sub_5ee5
00a9  c6061a0401  mov    byte ptr [0x41a], 1
  loc_00ae:
00ae  a1f86d    mov    ax, word ptr [0x6df8]
00b1  a30800    mov    word ptr [8], ax
00b4  c606801f03  mov    byte ptr [0x1f80], 3
00b9  e81e26    call   sub_26da
00bc  c70604000000  mov    word ptr [4], 0
00c2  e86c1c    call   sub_1d31
00c5  e8595a    call   sub_5b21
00c8  c706301c0000  mov    word ptr [0x1c30], 0
00ce  2ae4      sub    ah, ah
00d0  cd1a      int    0x1a
00d2  89161204  mov    word ptr [0x412], dx
00d6  c70614040000  mov    word ptr [0x414], 0
00dc  c606180400  mov    byte ptr [0x418], 0
00e1  c606190400  mov    byte ptr [0x419], 0
00e6  c6061c0400  mov    byte ptr [0x41c], 0
00eb  c6061b0400  mov    byte ptr [0x41b], 0
00f0  e82e5a    call   sub_5b21
  loc_00f3:
00f3  803e801f00  cmp    byte ptr [0x1f80], 0
00f8  7487      je     loc_0081
00fa  803e1b0400  cmp    byte ptr [0x41b], 0
00ff  75ad      jne    loc_00ae
0101  803e1c0400  cmp    byte ptr [0x41c], 0
0106  759b      jne    loc_00a3
0108  e8f528    call   sub_2a00
010b  e8f252    call   sub_5400
010e  c606811fff  mov    byte ptr [0x1f81], 0xff
0113  e80b5a    call   sub_5b21
0116  c70604000000  mov    word ptr [4], 0
011c  803e190400  cmp    byte ptr [0x419], 0
0121  7414      je     loc_0137
0123  e87b06    call   sub_07a1
0126  c606500502  mov    byte ptr [0x550], 2
012b  c606760501  mov    byte ptr [0x576], 1
0130  c606780520  mov    byte ptr [0x578], 0x20
0135  eb09      jmp    loc_0140
  loc_0137:
0137  c70679050000  mov    word ptr [0x579], 0
013d  e8cd05    call   sub_070d
  loc_0140:
0140  e8fd1c    call   sub_1e40
0143  e8ea16    call   sub_1830
0146  e8c720    call   sub_2210
0149  e8e421    call   sub_2330
014c  e8a325    call   sub_26f2
014f  e8aa25    call   sub_26fc
0152  e86857    call   sub_58bd
  loc_0155:
0155  803e801f00  cmp    byte ptr [0x1f80], 0
015a  7503      jne    loc_015f
015c  e922ff    jmp    loc_0081
  loc_015f:
015f  e8d611    call   sub_1338
0162  803e1c0400  cmp    byte ptr [0x41c], 0
0167  7403      je     loc_016c
0169  e937ff    jmp    loc_00a3
  loc_016c:
016c  803e1b0400  cmp    byte ptr [0x41b], 0
0171  7403      je     loc_0176
0173  e938ff    jmp    loc_00ae
  loc_0176:
0176  e88710    call   sub_1200
0179  e86907    call   sub_08e5
017c  e8e41c    call   sub_1e63
017f  803eb81c00  cmp    byte ptr [0x1cb8], 0
0184  750b      jne    loc_0191
0186  fe060f04  inc    byte ptr [0x40f]
018a  f6060f0403  test   byte ptr [0x40f], 3
018f  75c4      jne    loc_0155
  loc_0191:
0191  e8d952    call   sub_546d
0194  e80903    call   sub_04a0
0197  e89c17    call   sub_1936
019a  e8ae16    call   sub_184b
019d  e87620    call   sub_2216
01a0  e8d821    call   sub_237b
01a3  e80d25    call   sub_26b3
01a6  803e510500  cmp    byte ptr [0x551], 0
01ab  74a8      je     loc_0155
01ad  803e801f00  cmp    byte ptr [0x1f80], 0
01b2  7503      jne    loc_01b7
01b4  e9cafe    jmp    loc_0081
  loc_01b7:
01b7  2ae4      sub    ah, ah
01b9  cd1a      int    0x1a
01bb  89161004  mov    word ptr [0x410], dx
01bf  a17905    mov    ax, word ptr [0x579]
01c2  a30100    mov    word ptr [1], ax
01c5  a07b05    mov    al, byte ptr [0x57b]
01c8  a20300    mov    byte ptr [3], al
01cb  c606190401  mov    byte ptr [0x419], 1
01d0  803e180400  cmp    byte ptr [0x418], 0
01d5  740e      je     loc_01e5
01d7  c606180400  mov    byte ptr [0x418], 0
01dc  c70604000700  mov    word ptr [4], 7
01e2  eb54      jmp    loc_0238
01e4  db 90   ; .
  loc_01e5:
01e5  e8152c    call   sub_2dfd
01e8  f6c2a0    test   dl, 0xa0
01eb  741d      je     loc_020a
01ed  8b1e0800  mov    bx, word ptr [8]
01f1  81e30300  and    bx, 3
01f5  83fb03    cmp    bx, 3
01f8  7410      je     loc_020a
01fa  b102      mov    cl, 2
01fc  d3e3      shl    bx, cl
01fe  81e20300  and    dx, 3
0202  03da      add    bx, dx
0204  8a872104  mov    al, byte ptr [bx + 0x421]
0208  eb12      jmp    loc_021c
  loc_020a:
020a  e8f02b    call   sub_2dfd
020d  81e20700  and    dx, 7
0211  83fa05    cmp    dx, 5
0214  73f4      jae    loc_020a
0216  8bda      mov    bx, dx
0218  8a872d04  mov    al, byte ptr [bx + 0x42d]
  loc_021c:
021c  2ae4      sub    ah, ah
021e  3b061d04  cmp    ax, word ptr [0x41d]
0222  7506      jne    loc_022a
0224  3b061f04  cmp    ax, word ptr [0x41f]
0228  74bb      je     loc_01e5
  loc_022a:
022a  a30400    mov    word ptr [4], ax
022d  8b0e1d04  mov    cx, word ptr [0x41d]
0231  890e1f04  mov    word ptr [0x41f], cx
0235  a31d04    mov    word ptr [0x41d], ax
  loc_0238:
0238  c70606000000  mov    word ptr [6], 0
023e  8b1e0400  mov    bx, word ptr [4]
0242  83fb07    cmp    bx, 7
0245  7602      jbe    loc_0249
0247  2bdb      sub    bx, bx
  loc_0249:
0249  d1e3      shl    bx, 1
024b  2effa75002  jmp    word ptr cs:[bx + 0x250]
0250  dw sub_03e2
0252  dw sub_03e2
0254  dw sub_0459
0256  dw sub_0394
0258  dw sub_0349
025a  dw sub_02fe
025c  dw sub_02aa
025e  dw sub_0260

; ----------------------------------------------------------------------
sub_0260:
0260  c70604000700  mov    word ptr [4], 7
0266  e88719    call   sub_1bf0
0269  e82425    call   sub_2790
026c  e83205    call   sub_07a1
026f  e8ce1b    call   sub_1e40
0272  e89031    call   sub_3405
0275  e8885e    call   sub_6100
0278  e8de4c    call   sub_4f59
027b  e83f56    call   sub_58bd
  loc_027e:
027e  e8b710    call   sub_1338
0281  e87c0f    call   sub_1200
0284  e8e651    call   sub_546d
0287  e85b06    call   sub_08e5
028a  e8795e    call   sub_6106
028d  e8d62c    call   sub_2f66
0290  e8cd2b    call   sub_2e60
0293  e87a49    call   sub_4c10
0296  a05105    mov    al, byte ptr [0x551]
0299  0a065305  or     al, byte ptr [0x553]
029d  0a061c04  or     al, byte ptr [0x41c]
02a1  0a061b04  or     al, byte ptr [0x41b]
02a5  74d7      je     loc_027e
02a7  e97d01    jmp    loc_0427

; ----------------------------------------------------------------------
sub_02aa:
02aa  c70604000600  mov    word ptr [4], 6
02b0  e83d19    call   sub_1bf0
02b3  e8da24    call   sub_2790
02b6  e84749    call   sub_4c00
02b9  e8e504    call   sub_07a1
02bc  e84631    call   sub_3405
02bf  e87e1b    call   sub_1e40
02c2  e8f855    call   sub_58bd
  loc_02c5:
02c5  e87010    call   sub_1338
02c8  e8350f    call   sub_1200
02cb  e89f51    call   sub_546d
02ce  e87246    call   sub_4943
02d1  e80245    call   sub_47d6
02d4  e80e06    call   sub_08e5
02d7  803eb81c00  cmp    byte ptr [0x1cb8], 0
02dc  7405      je     loc_02e3
02de  e8821b    call   sub_1e63
02e1  eb03      jmp    loc_02e6
  loc_02e3:
02e3  e86a2e    call   sub_3150
  loc_02e6:
02e6  a05105    mov    al, byte ptr [0x551]
02e9  0a065205  or     al, byte ptr [0x552]
02ed  0a065305  or     al, byte ptr [0x553]
02f1  0a061b04  or     al, byte ptr [0x41b]
02f5  0a061c04  or     al, byte ptr [0x41c]
02f9  74ca      je     loc_02c5
02fb  e92901    jmp    loc_0427

; ----------------------------------------------------------------------
sub_02fe:
02fe  c70604000500  mov    word ptr [4], 5
0304  e8e918    call   sub_1bf0
0307  e88624    call   sub_2790
030a  e86d42    call   sub_457a
030d  e89104    call   sub_07a1
0310  e8f230    call   sub_3405
0313  e82a1b    call   sub_1e40
0316  e8a455    call   sub_58bd
  loc_0319:
0319  e81c10    call   sub_1338
031c  e8e10e    call   sub_1200
031f  e84b51    call   sub_546d
0322  e88642    call   sub_45ab
0325  e81840    call   sub_4340
0328  e8ba05    call   sub_08e5
032b  e8222e    call   sub_3150
032e  e8321b    call   sub_1e63
0331  a05205    mov    al, byte ptr [0x552]
0334  0a065305  or     al, byte ptr [0x553]
0338  0a065105  or     al, byte ptr [0x551]
033c  0a061c04  or     al, byte ptr [0x41c]
0340  0a061b04  or     al, byte ptr [0x41b]
0344  74d3      je     loc_0319
0346  e9de00    jmp    loc_0427

; ----------------------------------------------------------------------
sub_0349:
0349  c70604000400  mov    word ptr [4], 4
034f  e89e18    call   sub_1bf0
0352  e83b24    call   sub_2790
0355  e84904    call   sub_07a1
0358  e8aa30    call   sub_3405
035b  e8e21a    call   sub_1e40
035e  e82f3d    call   sub_4090
0361  e85955    call   sub_58bd
  loc_0364:
0364  e8d10f    call   sub_1338
0367  e8960e    call   sub_1200
036a  e80051    call   sub_546d
036d  e87505    call   sub_08e5
0370  e81d3b    call   sub_3e90
0373  e84c3d    call   sub_40c2
0376  e8d72d    call   sub_3150
0379  e8e71a    call   sub_1e63
037c  a05205    mov    al, byte ptr [0x552]
037f  0a065305  or     al, byte ptr [0x553]
0383  0a065105  or     al, byte ptr [0x551]
0387  0a061c04  or     al, byte ptr [0x41c]
038b  0a061b04  or     al, byte ptr [0x41b]
038f  74d3      je     loc_0364
0391  e99300    jmp    loc_0427

; ----------------------------------------------------------------------
sub_0394:
0394  c70604000300  mov    word ptr [4], 3
039a  e85318    call   sub_1bf0
039d  e8f023    call   sub_2790
03a0  e8fe03    call   sub_07a1
03a3  e85f30    call   sub_3405
03a6  e8971a    call   sub_1e40
03a9  e88437    call   sub_3b30
03ac  e8e138    call   sub_3c90
03af  e80b55    call   sub_58bd
  loc_03b2:
03b2  e8830f    call   sub_1338
03b5  e8480e    call   sub_1200
03b8  e8b250    call   sub_546d
03bb  e82705    call   sub_08e5
03be  e8f038    call   sub_3cb1
03c1  e87e37    call   sub_3b42
03c4  e8892d    call   sub_3150
03c7  e8991a    call   sub_1e63
03ca  a05205    mov    al, byte ptr [0x552]
03cd  0a065305  or     al, byte ptr [0x553]
03d1  0a065105  or     al, byte ptr [0x551]
03d5  0a061c04  or     al, byte ptr [0x41c]
03d9  0a061b04  or     al, byte ptr [0x41b]
03dd  74d3      je     loc_03b2
03df  eb46      jmp    loc_0427
03e1  db 90   ; .

; ----------------------------------------------------------------------
sub_03e2:
03e2  c70604000100  mov    word ptr [4], 1
03e8  e80518    call   sub_1bf0
03eb  e8a223    call   sub_2790
03ee  e8b003    call   sub_07a1
03f1  e81130    call   sub_3405
03f4  e8491a    call   sub_1e40
03f7  e8c354    call   sub_58bd
  loc_03fa:
03fa  e83b0f    call   sub_1338
03fd  e8000e    call   sub_1200
0400  e86a50    call   sub_546d
0403  e8df04    call   sub_08e5
0406  e8472d    call   sub_3150
0409  e8571a    call   sub_1e63
040c  e84134    call   sub_3850
040f  803e540500  cmp    byte ptr [0x554], 0
0414  7543      jne    loc_0459
0416  a05205    mov    al, byte ptr [0x552]
0419  0a065105  or     al, byte ptr [0x551]
041d  0a061b04  or     al, byte ptr [0x41b]
0421  0a061c04  or     al, byte ptr [0x41c]
0425  74d3      je     loc_03fa
  loc_0427:
0427  803e1b0400  cmp    byte ptr [0x41b], 0
042c  7403      je     loc_0431
042e  e97dfc    jmp    loc_00ae
  loc_0431:
0431  803e1c0400  cmp    byte ptr [0x41c], 0
0436  7403      je     loc_043b
0438  e968fc    jmp    loc_00a3
  loc_043b:
043b  803e520500  cmp    byte ptr [0x552], 0
0440  7405      je     loc_0447
0442  c606190400  mov    byte ptr [0x419], 0
  loc_0447:
0447  a10400    mov    ax, word ptr [4]
044a  a30600    mov    word ptr [6], ax
044d  c70604000000  mov    word ptr [4], 0
0453  e89a17    call   sub_1bf0
0456  e99afc    jmp    loc_00f3

; ----------------------------------------------------------------------
sub_0459:
0459  c70604000200  mov    word ptr [4], 2
045f  e88e17    call   sub_1bf0
0462  e82b23    call   sub_2790
0465  e86131    call   sub_35c9
0468  e83603    call   sub_07a1
046b  c606bf1c00  mov    byte ptr [0x1cbf], 0
0470  c606b81c00  mov    byte ptr [0x1cb8], 0
0475  e84554    call   sub_58bd
  loc_0478:
0478  e8bd0e    call   sub_1338
047b  e8820d    call   sub_1200
047e  e8ec4f    call   sub_546d
0481  e86104    call   sub_08e5
0484  e8ee31    call   sub_3675
0487  e85b33    call   sub_37e5
048a  a05205    mov    al, byte ptr [0x552]
048d  0a065305  or     al, byte ptr [0x553]
0491  0a061c04  or     al, byte ptr [0x41c]
0495  0a061b04  or     al, byte ptr [0x41b]
0499  74dd      je     loc_0478
049b  eb8a      jmp    loc_0427
049d  db 00,00,00   ; ...

; ----------------------------------------------------------------------
sub_04a0:
04a0  fe0e3105  dec    byte ptr [0x531]
04a4  7401      je     loc_04a7
  loc_04a6:
04a6  c3        ret
  loc_04a7:
04a7  fe063105  inc    byte ptr [0x531]
04ab  e82a0f    call   sub_13d8
04ae  75f6      jne    loc_04a6
04b0  803e5a0500  cmp    byte ptr [0x55a], 0
04b5  75ef      jne    loc_04a6
04b7  803e731600  cmp    byte ptr [0x1673], 0
04bc  75e8      jne    loc_04a6
04be  2ae4      sub    ah, ah
04c0  cd1a      int    0x1a
04c2  3b164405  cmp    dx, word ptr [0x544]
04c6  74de      je     loc_04a6
04c8  89164405  mov    word ptr [0x544], dx
04cc  8b1e0800  mov    bx, word ptr [8]
04d0  8a873205  mov    al, byte ptr [bx + 0x532]
04d4  803e7b0560  cmp    byte ptr [0x57b], 0x60
04d9  7704      ja     loc_04df
04db  d0e8      shr    al, 1
04dd  d0e8      shr    al, 1
  loc_04df:
04df  a23105    mov    byte ptr [0x531], al
04e2  8b1e2f05  mov    bx, word ptr [0x52f]
04e6  e86f01    call   sub_0658
04e9  7421      je     loc_050c
04eb  a02505    mov    al, byte ptr [0x525]
04ee  02872905  add    al, byte ptr [bx + 0x529]
04f2  3c04      cmp    al, 4
04f4  72b0      jb     loc_04a6
  loc_04f6:
04f6  e80429    call   sub_2dfd
04f9  80e203    and    dl, 3
04fc  3a162f05  cmp    dl, byte ptr [0x52f]
0500  74f4      je     loc_04f6
0502  80fa03    cmp    dl, 3
0505  74ef      je     loc_04f6
0507  8ada      mov    bl, dl
0509  eb2a      jmp    loc_0535
050b  db 90   ; .
  loc_050c:
050c  8a872905  mov    al, byte ptr [bx + 0x529]
0510  00062505  add    byte ptr [0x525], al
0514  803e250504  cmp    byte ptr [0x525], 4
0519  7268      jb     loc_0583
051b  e8df28    call   sub_2dfd
051e  80fa40    cmp    dl, 0x40
0521  7716      ja     loc_0539
  loc_0523:
0523  e8d728    call   sub_2dfd
0526  80e203    and    dl, 3
0529  80fa03    cmp    dl, 3
052c  74f5      je     loc_0523
052e  8ada      mov    bl, dl
0530  e82501    call   sub_0658
0533  75ee      jne    loc_0523
  loc_0535:
0535  891e2f05  mov    word ptr [0x52f], bx
  loc_0539:
0539  8a872605  mov    al, byte ptr [bx + 0x526]
053d  a22505    mov    byte ptr [0x525], al
0540  b81000    mov    ax, 0x10
0543  8ec0      mov    es, ax
0545  bfd704    mov    di, 0x4d7
0548  8aa72c05  mov    ah, byte ptr [bx + 0x52c]
054c  8b1e0800  mov    bx, word ptr [8]
0550  8a9fba2a  mov    bl, byte ptr [bx + 0x2aba]
0554  8afc      mov    bh, ah
0556  e82401    call   sub_067d
0559  833e2f0501  cmp    word ptr [0x52f], 1
055e  740e      je     loc_056e
0560  d02e4005  shr    byte ptr [0x540], 1
0564  e8cc00    call   sub_0633
0567  d02e4005  shr    byte ptr [0x540], 1
056b  eb0f      jmp    loc_057c
056d  db 90   ; .
  loc_056e:
056e  a04005    mov    al, byte ptr [0x540]
0571  d0e8      shr    al, 1
0573  d0e8      shr    al, 1
0575  e8bb00    call   sub_0633
0578  d02e4005  shr    byte ptr [0x540], 1
  loc_057c:
057c  e8b400    call   sub_0633
057f  8b1e2f05  mov    bx, word ptr [0x52f]
  loc_0583:
0583  803ed60400  cmp    byte ptr [0x4d6], 0
0588  7446      je     loc_05d0
058a  a17905    mov    ax, word ptr [0x579]
058d  80fb01    cmp    bl, 1
0590  742d      je     loc_05bf
0592  ff065f05  inc    word ptr [0x55f]
0596  050400    add    ax, 4
0599  3d2301    cmp    ax, 0x123
059c  722f      jb     loc_05cd
  loc_059e:
059e  c6065b0511  mov    byte ptr [0x55b], 0x11
05a3  c606710501  mov    byte ptr [0x571], 1
05a8  c606760501  mov    byte ptr [0x576], 1
05ad  c606780518  mov    byte ptr [0x578], 0x18
05b2  c606720501  mov    byte ptr [0x572], 1
05b7  c6065c0500  mov    byte ptr [0x55c], 0
05bc  eb12      jmp    loc_05d0
05be  db 90   ; .
  loc_05bf:
05bf  ff0e5f05  dec    word ptr [0x55f]
05c3  2d0400    sub    ax, 4
05c6  72d6      jb     loc_059e
05c8  3d0800    cmp    ax, 8
05cb  72d1      jb     loc_059e
  loc_05cd:
05cd  a37905    mov    word ptr [0x579], ax
  loc_05d0:
05d0  1e        push   ds
05d1  d1e3      shl    bx, 1
05d3  8b871d05  mov    ax, word ptr [bx + 0x51d]
05d7  a32305    mov    word ptr [0x523], ax
05da  8bb71705  mov    si, word ptr [bx + 0x517]
05de  b800b8    mov    ax, 0xb800
05e1  8ed8      mov    ds, ax
05e3  8ec0      mov    es, ax
05e5  8bfe      mov    di, si
05e7  83fb02    cmp    bx, 2
05ea  7505      jne    loc_05f1
05ec  fc        cld
05ed  4f        dec    di
05ee  eb03      jmp    loc_05f3
05f0  db 90   ; .
  loc_05f1:
05f1  fd        std
05f2  47        inc    di
  loc_05f3:
05f3  b97f02    mov    cx, 0x27f
05f6  57        push   di
05f7  56        push   si
05f8  f3a4      rep movsb byte ptr es:[di], byte ptr [si]
05fa  5e        pop    si
05fb  5f        pop    di
05fc  81c60020  add    si, 0x2000
0600  81c70020  add    di, 0x2000
0604  b98002    mov    cx, 0x280
0607  f3a4      rep movsb byte ptr es:[di], byte ptr [si]
0609  1f        pop    ds
060a  8b3e2305  mov    di, word ptr [0x523]
060e  8a1e2505  mov    bl, byte ptr [0x525]
0612  2aff      sub    bh, bh
0614  81c3d704  add    bx, 0x4d7
0618  b91000    mov    cx, 0x10
  loc_061b:
061b  8a07      mov    al, byte ptr [bx]
061d  268805    mov    byte ptr es:[di], al
0620  83c304    add    bx, 4
0623  81f70020  xor    di, 0x2000
0627  f7c70020  test   di, 0x2000
062b  7503      jne    loc_0630
062d  83c750    add    di, 0x50
  loc_0630:
0630  e2e9      loop   loc_061b
0632  c3        ret

; ----------------------------------------------------------------------
sub_0633:
0633  9f        lahf
0634  8b1e2f05  mov    bx, word ptr [0x52f]
0638  8a9f4105  mov    bl, byte ptr [bx + 0x541]
063c  b90500    mov    cx, 5
063f  80fb09    cmp    bl, 9
0642  740a      je     loc_064e
  loc_0644:
0644  9e        sahf
0645  d09f1610  rcr    byte ptr [bx + 0x1016], 1
0649  9f        lahf
064a  43        inc    bx
064b  e2f7      loop   loc_0644
064d  c3        ret
  loc_064e:
064e  9e        sahf
064f  d0971610  rcl    byte ptr [bx + 0x1016]
0653  9f        lahf
0654  4b        dec    bx
0655  e2f7      loop   loc_064e
0657  c3        ret

; ----------------------------------------------------------------------
sub_0658:
0658  c606d60400  mov    byte ptr [0x4d6], 0
065d  a07c05    mov    al, byte ptr [0x57c]
0660  3a873d05  cmp    al, byte ptr [bx + 0x53d]
0664  7213      jb     loc_0679
0666  3a873a05  cmp    al, byte ptr [bx + 0x53a]
066a  730d      jae    loc_0679
066c  803e5c0501  cmp    byte ptr [0x55c], 1
0671  7301      jae    loc_0674
0673  c3        ret
  loc_0674:
0674  c606d60401  mov    byte ptr [0x4d6], 1
  loc_0679:
0679  3ac0      cmp    al, al
067b  c3        ret
067c  db c3   ; .

; ----------------------------------------------------------------------
sub_067d:
067d  c606400500  mov    byte ptr [0x540], 0
0682  fc        cld
0683  b92000    mov    cx, 0x20
0686  b8aaaa    mov    ax, 0xaaaa
0689  f3ab      rep stosw word ptr es:[di], ax
068b  83ef40    sub    di, 0x40
068e  b84444    mov    ax, 0x4444
0691  26894504  mov    word ptr es:[di + 4], ax
0695  26894506  mov    word ptr es:[di + 6], ax
0699  e86127    call   sub_2dfd
069c  3ad3      cmp    dl, bl
069e  7204      jb     loc_06a4
06a0  3af7      cmp    dh, bh
06a2  7701      ja     loc_06a5
  loc_06a4:
06a4  c3        ret
  loc_06a5:
06a5  e85527    call   sub_2dfd
06a8  80fa18    cmp    dl, 0x18
06ab  721a      jb     loc_06c7
06ad  80fa60    cmp    dl, 0x60
06b0  721e      jb     loc_06d0
06b2  57        push   di
06b3  e82800    call   sub_06de
06b6  d0e0      shl    al, 1
06b8  a24005    mov    byte ptr [0x540], al
06bb  5f        pop    di
06bc  83c702    add    di, 2
06bf  e81c00    call   sub_06de
06c2  08064005  or     byte ptr [0x540], al
06c6  c3        ret
  loc_06c7:
06c7  b92000    mov    cx, 0x20
06ca  be9004    mov    si, 0x490
06cd  eb07      jmp    loc_06d6
06cf  db 90   ; .
  loc_06d0:
06d0  b91000    mov    cx, 0x10
06d3  be6004    mov    si, 0x460
  loc_06d6:
06d6  f3a5      rep movsw word ptr es:[di], word ptr [si]
06d8  c606400503  mov    byte ptr [0x540], 3
06dd  c3        ret

; ----------------------------------------------------------------------
sub_06de:
06de  e81c27    call   sub_2dfd
06e1  81e20600  and    dx, 6
06e5  80fa06    cmp    dl, 6
06e8  7503      jne    loc_06ed
06ea  2ac0      sub    al, al
06ec  c3        ret
  loc_06ed:
06ed  8bda      mov    bx, dx
06ef  8bb7d004  mov    si, word ptr [bx + 0x4d0]
06f3  b90800    mov    cx, 8
  loc_06f6:
06f6  ad        lodsw  ax, word ptr [si]
06f7  ab        stosw  word ptr es:[di], ax
06f8  83c702    add    di, 2
06fb  e2f9      loop   loc_06f6
06fd  b001      mov    al, 1
06ff  c3        ret

; ----------------------------------------------------------------------
sub_0700:
0700  c7067d050000  mov    word ptr [0x57d], 0
0706  c70684060000  mov    word ptr [0x684], 0
070c  c3        ret

; ----------------------------------------------------------------------
sub_070d:
070d  b90000    mov    cx, 0
0710  b401      mov    ah, 1
0712  813e7905a000  cmp    word ptr [0x579], 0xa0
0718  7205      jb     loc_071f
071a  b92801    mov    cx, 0x128
071d  b4ff      mov    ah, 0xff
  loc_071f:
071f  88266e05  mov    byte ptr [0x56e], ah
0723  c606580503  mov    byte ptr [0x558], 3
0728  c60659050c  mov    byte ptr [0x559], 0xc
072d  b2b4      mov    dl, 0xb4
072f  890e7905  mov    word ptr [0x579], cx
0733  88167b05  mov    byte ptr [0x57b], dl
0737  c6067c05e6  mov    byte ptr [0x57c], 0xe6
073c  e87125    call   sub_2cb0
073f  a35f05    mov    word ptr [0x55f], ax
0742  c7066105030b  mov    word ptr [0x561], 0xb03
0748  e8d909    call   sub_1124
074b  c606710500  mov    byte ptr [0x571], 0
0750  c70672050200  mov    word ptr [0x572], 2
0756  c606760501  mov    byte ptr [0x576], 1
075b  c6065b0500  mov    byte ptr [0x55b], 0
0760  c606500500  mov    byte ptr [0x550], 0
0765  c6065c0500  mov    byte ptr [0x55c], 0
076a  c6065a0500  mov    byte ptr [0x55a], 0
076f  c606830500  mov    byte ptr [0x583], 0
0774  c606980600  mov    byte ptr [0x698], 0
0779  c606990600  mov    byte ptr [0x699], 0
077e  c606510500  mov    byte ptr [0x551], 0
0783  c606840500  mov    byte ptr [0x584], 0
0788  c606520500  mov    byte ptr [0x552], 0
078d  c70654050000  mov    word ptr [0x554], 0
0793  c606530500  mov    byte ptr [0x553], 0
0798  c6067c1200  mov    byte ptr [0x127c], 0
079d  e860ff    call   sub_0700
07a0  c3        ret

; ----------------------------------------------------------------------
sub_07a1:
07a1  8b1e0400  mov    bx, word ptr [4]
07a5  83fb00    cmp    bx, 0
07a8  750b      jne    loc_07b5
07aa  8b0e0100  mov    cx, word ptr [1]
07ae  8a160300  mov    dl, byte ptr [3]
07b2  eb0b      jmp    loc_07bf
07b4  db 90   ; .
  loc_07b5:
07b5  8a97e905  mov    dl, byte ptr [bx + 0x5e9]
07b9  d0e3      shl    bl, 1
07bb  8b8fd905  mov    cx, word ptr [bx + 0x5d9]
  loc_07bf:
07bf  890e7905  mov    word ptr [0x579], cx
07c3  88167b05  mov    byte ptr [0x57b], dl
07c7  8ac2      mov    al, dl
07c9  0432      add    al, 0x32
07cb  a27c05    mov    byte ptr [0x57c], al
07ce  e8df24    call   sub_2cb0
07d1  a35f05    mov    word ptr [0x55f], ax
07d4  a1b20f    mov    ax, word ptr [0xfb2]
07d7  a36905    mov    word ptr [0x569], ax
07da  a1be0f    mov    ax, word ptr [0xfbe]
07dd  a36705    mov    word ptr [0x567], ax
07e0  a36105    mov    word ptr [0x561], ax
07e3  e83e09    call   sub_1124
07e6  c606710501  mov    byte ptr [0x571], 1
07eb  c6066e0500  mov    byte ptr [0x56e], 0
07f0  c606760501  mov    byte ptr [0x576], 1
07f5  c606780540  mov    byte ptr [0x578], 0x40
07fa  b00a      mov    al, 0xa
07fc  833e040007  cmp    word ptr [4], 7
0801  7502      jne    loc_0805
0803  2ac0      sub    al, al
  loc_0805:
0805  a25b05    mov    byte ptr [0x55b], al
0808  c606500500  mov    byte ptr [0x550], 0
080d  c6065c0500  mov    byte ptr [0x55c], 0
0812  c6065a0500  mov    byte ptr [0x55a], 0
0817  c606830500  mov    byte ptr [0x583], 0
081c  c606980600  mov    byte ptr [0x698], 0
0821  c606990600  mov    byte ptr [0x699], 0
0826  c606510500  mov    byte ptr [0x551], 0
082b  c606840500  mov    byte ptr [0x584], 0
0830  c606520500  mov    byte ptr [0x552], 0
0835  c70654050000  mov    word ptr [0x554], 0
083b  c606530500  mov    byte ptr [0x553], 0
0840  c6067c1200  mov    byte ptr [0x127c], 0
0845  e8b8fe    call   sub_0700
0848  833e040002  cmp    word ptr [4], 2
084d  7522      jne    loc_0871
084f  c606760510  mov    byte ptr [0x576], 0x10
0854  c70674051000  mov    word ptr [0x574], 0x10
085a  2ae4      sub    ah, ah
085c  cd1a      int    0x1a
085e  8916f105  mov    word ptr [0x5f1], dx
0862  c606f30500  mov    byte ptr [0x5f3], 0
0867  c606f40505  mov    byte ptr [0x5f4], 5
086c  c606f50501  mov    byte ptr [0x5f5], 1
  loc_0871:
0871  c3        ret

; ----------------------------------------------------------------------
sub_0872:
0872  c7062a590004  mov    word ptr [0x592a], 0x400
0878  803e840500  cmp    byte ptr [0x584], 0
087d  7401      je     loc_0880
087f  c3        ret
  loc_0880:
0880  c606760508  mov    byte ptr [0x576], 8
0885  b2ff      mov    dl, 0xff
0887  a07b05    mov    al, byte ptr [0x57b]
088a  3a065226  cmp    al, byte ptr [0x2652]
088e  7302      jae    loc_0892
0890  b201      mov    dl, 1
  loc_0892:
0892  88167105  mov    byte ptr [0x571], dl
0896  a17905    mov    ax, word ptr [0x579]
0899  2b065026  sub    ax, word ptr [0x2650]
089d  b2ff      mov    dl, 0xff
089f  7704      ja     loc_08a5
08a1  b201      mov    dl, 1
08a3  f7d0      not    ax
  loc_08a5:
08a5  88166e05  mov    byte ptr [0x56e], dl
08a9  80fc00    cmp    ah, 0
08ac  7403      je     loc_08b1
08ae  b8ff00    mov    ax, 0xff
  loc_08b1:
08b1  f6d0      not    al
08b3  3c30      cmp    al, 0x30
08b5  7302      jae    loc_08b9
08b7  b030      mov    al, 0x30
  loc_08b9:
08b9  8ad8      mov    bl, al
08bb  d0eb      shr    bl, 1
08bd  d0eb      shr    bl, 1
08bf  2ac3      sub    al, bl
08c1  a27805    mov    byte ptr [0x578], al
08c4  b105      mov    cl, 5
08c6  d2e8      shr    al, cl
08c8  a37205    mov    word ptr [0x572], ax
08cb  c6065c0500  mov    byte ptr [0x55c], 0
08d0  c606e03900  mov    byte ptr [0x39e0], 0
08d5  c606770501  mov    byte ptr [0x577], 1
08da  c6065b0510  mov    byte ptr [0x55b], 0x10
08df  c606840501  mov    byte ptr [0x584], 1
08e4  c3        ret

; ----------------------------------------------------------------------
sub_08e5:
08e5  2ae4      sub    ah, ah
08e7  cd1a      int    0x1a
08e9  3b167d05  cmp    dx, word ptr [0x57d]
08ed  750e      jne    loc_08fd
08ef  833e840600  cmp    word ptr [0x684], 0
08f4  7406      je     loc_08fc
08f6  ff0e8406  dec    word ptr [0x684]
08fa  7410      je     loc_090c
  loc_08fc:
08fc  c3        ret
  loc_08fd:
08fd  b82000    mov    ax, 0x20
0900  803e9706fd  cmp    byte ptr [0x697], 0xfd
0905  7502      jne    loc_0909
0907  d1e8      shr    ax, 1
  loc_0909:
0909  a38406    mov    word ptr [0x684], ax
  loc_090c:
090c  833e040002  cmp    word ptr [4], 2
0911  740a      je     loc_091d
0913  8a0e7105  mov    cl, byte ptr [0x571]
0917  0a0e6e05  or     cl, byte ptr [0x56e]
091b  7509      jne    loc_0926
  loc_091d:
091d  52        push   dx
091e  50        push   ax
091f  e8b60a    call   sub_13d8
0922  58        pop    ax
0923  5a        pop    dx
0924  74d6      je     loc_08fc
  loc_0926:
0926  89167d05  mov    word ptr [0x57d], dx
092a  a37f05    mov    word ptr [0x57f], ax
092d  833e040004  cmp    word ptr [4], 4
0932  7507      jne    loc_093b
0934  803ee13900  cmp    byte ptr [0x39e1], 0
0939  75c1      jne    loc_08fc
  loc_093b:
093b  833e040006  cmp    word ptr [4], 6
0940  7507      jne    loc_0949
0942  803ebd4400  cmp    byte ptr [0x44bd], 0
0947  75b3      jne    loc_08fc
  loc_0949:
0949  833e040002  cmp    word ptr [4], 2
094e  7403      je     loc_0953
0950  e95902    jmp    loc_0bac
  loc_0953:
0953  8b360800  mov    si, word ptr [8]
0957  d1e6      shl    si, 1
0959  a17d05    mov    ax, word ptr [0x57d]
095c  2b06f105  sub    ax, word ptr [0x5f1]
0960  3b848905  cmp    ax, word ptr [si + 0x589]
0964  7270      jb     loc_09d6
0966  3b849905  cmp    ax, word ptr [si + 0x599]
096a  7205      jb     loc_0971
096c  c606520501  mov    byte ptr [0x552], 1
  loc_0971:
0971  fe0ef505  dec    byte ptr [0x5f5]
0975  7542      jne    loc_09b9
0977  e80550    call   sub_597f
097a  c606f50506  mov    byte ptr [0x5f5], 6
097f  a0f405    mov    al, byte ptr [0x5f4]
0982  803e7b05b3  cmp    byte ptr [0x57b], 0xb3
0987  7209      jb     loc_0992
0989  3cc8      cmp    al, 0xc8
098b  7305      jae    loc_0992
098d  041e      add    al, 0x1e
098f  a2f405    mov    byte ptr [0x5f4], al
  loc_0992:
0992  8a167b05  mov    dl, byte ptr [0x57b]
0996  2ad0      sub    dl, al
0998  7302      jae    loc_099c
099a  2ad2      sub    dl, dl
  loc_099c:
099c  8b0e7905  mov    cx, word ptr [0x579]
09a0  80e2f8    and    dl, 0xf8
09a3  e80a23    call   sub_2cb0
09a6  8bf8      mov    di, ax
09a8  be4e06    mov    si, 0x64e
09ab  b800b8    mov    ax, 0xb800
09ae  8ec0      mov    es, ax
09b0  bd0e00    mov    bp, 0xe
09b3  b90305    mov    cx, 0x503
09b6  e87c23    call   sub_2d35
  loc_09b9:
09b9  c6066e0500  mov    byte ptr [0x56e], 0
09be  c606710501  mov    byte ptr [0x571], 1
09c3  c606f30501  mov    byte ptr [0x5f3], 1
09c8  c606760520  mov    byte ptr [0x576], 0x20
09cd  2bdb      sub    bx, bx
09cf  b40b      mov    ah, 0xb
09d1  cd10      int    0x10
09d3  e9b000    jmp    loc_0a86
  loc_09d6:
09d6  8b360800  mov    si, word ptr [8]
09da  d1e6      shl    si, 1
09dc  2bdb      sub    bx, bx
09de  3b84a905  cmp    ax, word ptr [si + 0x5a9]
09e2  7212      jb     loc_09f6
09e4  fec3      inc    bl
09e6  3b84b905  cmp    ax, word ptr [si + 0x5b9]
09ea  720a      jb     loc_09f6
09ec  b305      mov    bl, 5
09ee  3b84c905  cmp    ax, word ptr [si + 0x5c9]
09f2  7202      jb     loc_09f6
09f4  fecb      dec    bl
  loc_09f6:
09f6  b40b      mov    ah, 0xb
09f8  cd10      int    0x10
09fa  a06e05    mov    al, byte ptr [0x56e]
09fd  a26f05    mov    byte ptr [0x56f], al
0a00  a07105    mov    al, byte ptr [0x571]
0a03  a27005    mov    byte ptr [0x570], al
0a06  a09806    mov    al, byte ptr [0x698]
0a09  3c00      cmp    al, 0
0a0b  750d      jne    loc_0a1a
0a0d  833e740510  cmp    word ptr [0x574], 0x10
0a12  721a      jb     loc_0a2e
0a14  ff0e7405  dec    word ptr [0x574]
0a18  eb1d      jmp    loc_0a37
  loc_0a1a:
0a1a  3a066e05  cmp    al, byte ptr [0x56e]
0a1e  750e      jne    loc_0a2e
0a20  833e740530  cmp    word ptr [0x574], 0x30
0a25  7310      jae    loc_0a37
0a27  8306740503  add    word ptr [0x574], 3
0a2c  eb09      jmp    loc_0a37
  loc_0a2e:
0a2e  a26e05    mov    byte ptr [0x56e], al
0a31  c70674052000  mov    word ptr [0x574], 0x20
  loc_0a37:
0a37  a17405    mov    ax, word ptr [0x574]
0a3a  b103      mov    cl, 3
0a3c  d3e8      shr    ax, cl
0a3e  8b1e0800  mov    bx, word ptr [8]
0a42  d0e3      shl    bl, 1
0a44  3b876c06  cmp    ax, word ptr [bx + 0x66c]
0a48  7604      jbe    loc_0a4e
0a4a  8b876c06  mov    ax, word ptr [bx + 0x66c]
  loc_0a4e:
0a4e  a37205    mov    word ptr [0x572], ax
0a51  e87505    call   sub_0fc9
0a54  a09906    mov    al, byte ptr [0x699]
0a57  3c00      cmp    al, 0
0a59  750f      jne    loc_0a6a
0a5b  f6d0      not    al
0a5d  803e760510  cmp    byte ptr [0x576], 0x10
0a62  721a      jb     loc_0a7e
0a64  fe0e7605  dec    byte ptr [0x576]
0a68  eb1c      jmp    loc_0a86
  loc_0a6a:
0a6a  3a067105  cmp    al, byte ptr [0x571]
0a6e  750e      jne    loc_0a7e
0a70  803e760540  cmp    byte ptr [0x576], 0x40
0a75  730f      jae    loc_0a86
0a77  8006760504  add    byte ptr [0x576], 4
0a7c  eb08      jmp    loc_0a86
  loc_0a7e:
0a7e  a27105    mov    byte ptr [0x571], al
0a81  c606760520  mov    byte ptr [0x576], 0x20
  loc_0a86:
0a86  8b360800  mov    si, word ptr [8]
0a8a  8a167b05  mov    dl, byte ptr [0x57b]
0a8e  b104      mov    cl, 4
0a90  8a1e7605  mov    bl, byte ptr [0x576]
0a94  d2eb      shr    bl, cl
0a96  3a9c7c06  cmp    bl, byte ptr [si + 0x67c]
0a9a  7604      jbe    loc_0aa0
0a9c  8a9c7c06  mov    bl, byte ptr [si + 0x67c]
  loc_0aa0:
0aa0  a07105    mov    al, byte ptr [0x571]
0aa3  3c01      cmp    al, 1
0aa5  7227      jb     loc_0ace
0aa7  750b      jne    loc_0ab4
0aa9  02d3      add    dl, bl
0aab  80fab4    cmp    dl, 0xb4
0aae  721e      jb     loc_0ace
0ab0  b2b3      mov    dl, 0xb3
0ab2  eb1a      jmp    loc_0ace
  loc_0ab4:
0ab4  2ad3      sub    dl, bl
0ab6  7205      jb     loc_0abd
0ab8  80fa03    cmp    dl, 3
0abb  7711      ja     loc_0ace
  loc_0abd:
0abd  a1b809    mov    ax, word ptr [0x9b8]
0ac0  3b065d05  cmp    ax, word ptr [0x55d]
0ac4  7506      jne    loc_0acc
0ac6  a17d05    mov    ax, word ptr [0x57d]
0ac9  a3f105    mov    word ptr [0x5f1], ax
  loc_0acc:
0acc  b202      mov    dl, 2
  loc_0ace:
0ace  88167b05  mov    byte ptr [0x57b], dl
0ad2  8b0e7905  mov    cx, word ptr [0x579]
0ad6  e8d721    call   sub_2cb0
0ad9  a36305    mov    word ptr [0x563], ax
0adc  803ef30500  cmp    byte ptr [0x5f3], 0
0ae1  7406      je     loc_0ae9
0ae3  bb1000    mov    bx, 0x10
0ae6  eb7c      jmp    loc_0b64
0ae8  db 90   ; .
  loc_0ae9:
0ae9  a06e05    mov    al, byte ptr [0x56e]
0aec  3a066f05  cmp    al, byte ptr [0x56f]
0af0  7509      jne    loc_0afb
0af2  a07105    mov    al, byte ptr [0x571]
0af5  3a067005  cmp    al, byte ptr [0x570]
0af9  7405      je     loc_0b00
  loc_0afb:
0afb  bb1800    mov    bx, 0x18
0afe  eb64      jmp    loc_0b64
  loc_0b00:
0b00  ff068705  inc    word ptr [0x587]
0b04  8b1e8705  mov    bx, word ptr [0x587]
0b08  a09806    mov    al, byte ptr [0x698]
0b0b  0a069906  or     al, byte ptr [0x699]
0b0f  7502      jne    loc_0b13
0b11  d0eb      shr    bl, 1
  loc_0b13:
0b13  803e7b05b3  cmp    byte ptr [0x57b], 0xb3
0b18  7207      jb     loc_0b21
0b1a  803e710501  cmp    byte ptr [0x571], 1
0b1f  741b      je     loc_0b3c
  loc_0b21:
0b21  803e7b0504  cmp    byte ptr [0x57b], 4
0b26  7707      ja     loc_0b2f
0b28  803e990600  cmp    byte ptr [0x699], 0
0b2d  7524      jne    loc_0b53
  loc_0b2f:
0b2f  a07605    mov    al, byte ptr [0x576]
0b32  2ae4      sub    ah, ah
0b34  d1e8      shr    ax, 1
0b36  3b067405  cmp    ax, word ptr [0x574]
0b3a  7317      jae    loc_0b53
  loc_0b3c:
0b3c  803e6e0500  cmp    byte ptr [0x56e], 0
0b41  7410      je     loc_0b53
0b43  81e30600  and    bx, 6
0b47  803e6e0501  cmp    byte ptr [0x56e], 1
0b4c  7416      je     loc_0b64
0b4e  80cb08    or     bl, 8
0b51  eb11      jmp    loc_0b64
  loc_0b53:
0b53  81e30200  and    bx, 2
0b57  80cb10    or     bl, 0x10
0b5a  803e710501  cmp    byte ptr [0x571], 1
0b5f  7503      jne    loc_0b64
0b61  80c304    add    bl, 4
  loc_0b64:
0b64  8b87a609  mov    ax, word ptr [bx + 0x9a6]
0b68  a35d05    mov    word ptr [0x55d], ax
0b6b  8b87c009  mov    ax, word ptr [bx + 0x9c0]
0b6f  a36505    mov    word ptr [0x565], ax
0b72  b030      mov    al, 0x30
0b74  b9bc02    mov    cx, 0x2bc
0b77  803e9706fd  cmp    byte ptr [0x697], 0xfd
0b7c  7219      jb     loc_0b97
0b7e  7405      je     loc_0b85
0b80  b008      mov    al, 8
0b82  b9e803    mov    cx, 0x3e8
  loc_0b85:
0b85  38067b05  cmp    byte ptr [0x57b], al
0b89  770c      ja     loc_0b97
  loc_0b8b:
0b8b  e84a08    call   sub_13d8
0b8e  75fb      jne    loc_0b8b
  loc_0b90:
0b90  e84508    call   sub_13d8
0b93  74fb      je     loc_0b90
  loc_0b95:
0b95  e2fe      loop   loc_0b95
  loc_0b97:
0b97  e84906    call   sub_11e3
0b9a  a16305    mov    ax, word ptr [0x563]
0b9d  a35f05    mov    word ptr [0x55f], ax
0ba0  e8a205    call   sub_1145
0ba3  e8fa28    call   sub_34a0
0ba6  7303      jae    loc_0bab
0ba8  e89a05    call   sub_1145
  loc_0bab:
0bab  c3        ret
  loc_0bac:
0bac  e8cb0f    call   sub_1b7a
0baf  7301      jae    loc_0bb2
  loc_0bb1:
0bb1  c3        ret
  loc_0bb2:
0bb2  803eb81c00  cmp    byte ptr [0x1cb8], 0
0bb7  75f8      jne    loc_0bb1
0bb9  803e580500  cmp    byte ptr [0x558], 0
0bbe  745c      je     loc_0c1c
0bc0  803e590500  cmp    byte ptr [0x559], 0
0bc5  740c      je     loc_0bd3
0bc7  803ebf1c00  cmp    byte ptr [0x1cbf], 0
0bcc  7504      jne    loc_0bd2
0bce  fe0e5905  dec    byte ptr [0x559]
  loc_0bd2:
0bd2  c3        ret
  loc_0bd3:
0bd3  fe0e5805  dec    byte ptr [0x558]
0bd7  750c      jne    loc_0be5
0bd9  c70672050800  mov    word ptr [0x572], 8
0bdf  e8e703    call   sub_0fc9
0be2  eb38      jmp    loc_0c1c
0be4  db 90   ; .
  loc_0be5:
0be5  e83804    call   sub_1020
0be8  891e5d05  mov    word ptr [0x55d], bx
0bec  a05805    mov    al, byte ptr [0x558]
0bef  8a266e05  mov    ah, byte ptr [0x56e]
0bf3  e89103    call   sub_0f87
0bf6  803e580502  cmp    byte ptr [0x558], 2
0bfb  7403      je     loc_0c00
0bfd  e8e305    call   sub_11e3
  loc_0c00:
0c00  e8770f    call   sub_1b7a
0c03  7216      jb     loc_0c1b
0c05  e8ed14    call   sub_20f5
0c08  7211      jb     loc_0c1b
0c0a  8a167b05  mov    dl, byte ptr [0x57b]
0c0e  8b0e7905  mov    cx, word ptr [0x579]
0c12  e89b20    call   sub_2cb0
0c15  a35f05    mov    word ptr [0x55f], ax
0c18  e82a05    call   sub_1145
  loc_0c1b:
0c1b  c3        ret
  loc_0c1c:
0c1c  803e5c0501  cmp    byte ptr [0x55c], 1
0c21  7247      jb     loc_0c6a
0c23  753a      jne    loc_0c5f
0c25  fe065c05  inc    byte ptr [0x55c]
0c29  c70672050600  mov    word ptr [0x572], 6
0c2f  8a167b05  mov    dl, byte ptr [0x57b]
0c33  8b0e7905  mov    cx, word ptr [0x579]
0c37  e87620    call   sub_2cb0
0c3a  a36305    mov    word ptr [0x563], ax
0c3d  e8a305    call   sub_11e3
0c40  e8370f    call   sub_1b7a
0c43  7221      jb     loc_0c66
0c45  e8ad14    call   sub_20f5
0c48  721c      jb     loc_0c66
0c4a  a16305    mov    ax, word ptr [0x563]
0c4d  a35f05    mov    word ptr [0x55f], ax
0c50  c7066505030e  mov    word ptr [0x565], 0xe03
0c56  c7065d05da09  mov    word ptr [0x55d], 0x9da
0c5c  e8e604    call   sub_1145
  loc_0c5f:
0c5f  803e990600  cmp    byte ptr [0x699], 0
0c64  7501      jne    loc_0c67
  loc_0c66:
0c66  c3        ret
  loc_0c67:
0c67  e90e02    jmp    loc_0e78
  loc_0c6a:
0c6a  803e710500  cmp    byte ptr [0x571], 0
0c6f  7503      jne    loc_0c74
0c71  e9af01    jmp    loc_0e23
  loc_0c74:
0c74  e85203    call   sub_0fc9
0c77  7317      jae    loc_0c90
0c79  c6066e0500  mov    byte ptr [0x56e], 0
0c7e  c606760502  mov    byte ptr [0x576], 2
0c83  c606710501  mov    byte ptr [0x571], 1
0c88  c6065b0500  mov    byte ptr [0x55b], 0
0c8d  eb32      jmp    loc_0cc1
0c8f  db 90   ; .
  loc_0c90:
0c90  a07805    mov    al, byte ptr [0x578]
0c93  28067705  sub    byte ptr [0x577], al
0c97  7328      jae    loc_0cc1
0c99  803e710501  cmp    byte ptr [0x571], 1
0c9e  7416      je     loc_0cb6
0ca0  803e760501  cmp    byte ptr [0x576], 1
0ca5  7607      jbe    loc_0cae
0ca7  fe0e7605  dec    byte ptr [0x576]
0cab  eb14      jmp    loc_0cc1
0cad  db 90   ; .
  loc_0cae:
0cae  c606710501  mov    byte ptr [0x571], 1
0cb3  eb0c      jmp    loc_0cc1
0cb5  db 90   ; .
  loc_0cb6:
0cb6  803e760504  cmp    byte ptr [0x576], 4
0cbb  7304      jae    loc_0cc1
0cbd  fe067605  inc    byte ptr [0x576]
  loc_0cc1:
0cc1  803e5a0500  cmp    byte ptr [0x55a], 0
0cc6  751f      jne    loc_0ce7
0cc8  803e5b0500  cmp    byte ptr [0x55b], 0
0ccd  7406      je     loc_0cd5
0ccf  fe0e5b05  dec    byte ptr [0x55b]
0cd3  7512      jne    loc_0ce7
  loc_0cd5:
0cd5  803e710501  cmp    byte ptr [0x571], 1
0cda  750b      jne    loc_0ce7
0cdc  e82909    call   sub_1608
0cdf  7306      jae    loc_0ce7
0ce1  a07c05    mov    al, byte ptr [0x57c]
0ce4  eb43      jmp    loc_0d29
0ce6  db 90   ; .
  loc_0ce7:
0ce7  a07c05    mov    al, byte ptr [0x57c]
0cea  803e710501  cmp    byte ptr [0x571], 1
0cef  7415      je     loc_0d06
0cf1  2a067605  sub    al, byte ptr [0x576]
0cf5  7358      jae    loc_0d4f
0cf7  2ac0      sub    al, al
0cf9  c606710501  mov    byte ptr [0x571], 1
0cfe  c606760501  mov    byte ptr [0x576], 1
0d03  eb4a      jmp    loc_0d4f
0d05  db 90   ; .
  loc_0d06:
0d06  02067605  add    al, byte ptr [0x576]
0d0a  3ce6      cmp    al, 0xe6
0d0c  7641      jbe    loc_0d4f
0d0e  833e040007  cmp    word ptr [4], 7
0d13  750d      jne    loc_0d22
0d15  3cf8      cmp    al, 0xf8
0d17  7236      jb     loc_0d4f
0d19  b0f8      mov    al, 0xf8
0d1b  c606510501  mov    byte ptr [0x551], 1
0d20  eb2d      jmp    loc_0d4f
  loc_0d22:
0d22  b0e6      mov    al, 0xe6
0d24  c606500500  mov    byte ptr [0x550], 0
  loc_0d29:
0d29  c606710500  mov    byte ptr [0x571], 0
0d2e  c606840500  mov    byte ptr [0x584], 0
0d33  c70672050200  mov    word ptr [0x572], 2
0d39  c6065b0500  mov    byte ptr [0x55b], 0
0d3e  c6065a0500  mov    byte ptr [0x55a], 0
0d43  803e5c0500  cmp    byte ptr [0x55c], 0
0d48  7405      je     loc_0d4f
0d4a  50        push   ax
0d4b  e8744d    call   sub_5ac2
0d4e  58        pop    ax
  loc_0d4f:
0d4f  a27c05    mov    byte ptr [0x57c], al
0d52  2c32      sub    al, 0x32
0d54  7302      jae    loc_0d58
0d56  2ac0      sub    al, al
  loc_0d58:
0d58  a27b05    mov    byte ptr [0x57b], al
0d5b  8a167b05  mov    dl, byte ptr [0x57b]
0d5f  8b0e7905  mov    cx, word ptr [0x579]
0d63  e84a1f    call   sub_2cb0
0d66  a36305    mov    word ptr [0x563], ax
0d69  803e830500  cmp    byte ptr [0x583], 0
0d6e  7503      jne    loc_0d73
0d70  e87004    call   sub_11e3
  loc_0d73:
0d73  e8040e    call   sub_1b7a
0d76  724c      jb     loc_0dc4
0d78  e87a13    call   sub_20f5
0d7b  7247      jb     loc_0dc4
0d7d  a16305    mov    ax, word ptr [0x563]
0d80  a35f05    mov    word ptr [0x55f], ax
0d83  803e840500  cmp    byte ptr [0x584], 0
0d88  7417      je     loc_0da1
0d8a  8306850502  add    word ptr [0x585], 2
0d8f  8b1e8505  mov    bx, word ptr [0x585]
0d93  81e30e00  and    bx, 0xe
0d97  8b87c20f  mov    ax, word ptr [bx + 0xfc2]
0d9b  8b9fd20f  mov    bx, word ptr [bx + 0xfd2]
0d9f  eb07      jmp    loc_0da8
  loc_0da1:
0da1  a16905    mov    ax, word ptr [0x569]
0da4  8b1e6705  mov    bx, word ptr [0x567]
  loc_0da8:
0da8  a35d05    mov    word ptr [0x55d], ax
0dab  891e6505  mov    word ptr [0x565], bx
0daf  b032      mov    al, 0x32
0db1  2a067c05  sub    al, byte ptr [0x57c]
0db5  7427      je     loc_0dde
0db7  7225      jb     loc_0dde
0db9  b96801    mov    cx, 0x168
  loc_0dbc:
0dbc  e2fe      loop   loc_0dbc
0dbe  2af8      sub    bh, al
0dc0  7402      je     loc_0dc4
0dc2  7306      jae    loc_0dca
  loc_0dc4:
0dc4  c606830501  mov    byte ptr [0x583], 1
0dc9  c3        ret
  loc_0dca:
0dca  891e6505  mov    word ptr [0x565], bx
0dce  8ae3      mov    ah, bl
0dd0  d0e4      shl    ah, 1
0dd2  f6e4      mul    ah
0dd4  03066905  add    ax, word ptr [0x569]
0dd8  a35d05    mov    word ptr [0x55d], ax
0ddb  eb42      jmp    loc_0e1f
0ddd  db 90   ; .
  loc_0dde:
0dde  833e040007  cmp    word ptr [4], 7
0de3  7509      jne    loc_0dee
0de5  a07b05    mov    al, byte ptr [0x57b]
0de8  2cbb      sub    al, 0xbb
0dea  7233      jb     loc_0e1f
0dec  730e      jae    loc_0dfc
  loc_0dee:
0dee  803e500502  cmp    byte ptr [0x550], 2
0df3  752a      jne    loc_0e1f
0df5  a07b05    mov    al, byte ptr [0x57b]
0df8  2c5e      sub    al, 0x5e
0dfa  7223      jb     loc_0e1f
  loc_0dfc:
0dfc  2af8      sub    bh, al
0dfe  7402      je     loc_0e02
0e00  7314      jae    loc_0e16
  loc_0e02:
0e02  833e040007  cmp    word ptr [4], 7
0e07  7506      jne    loc_0e0f
0e09  c606510501  mov    byte ptr [0x551], 1
0e0e  c3        ret
  loc_0e0f:
0e0f  e8fbf8    call   sub_070d
0e12  e8b64b    call   sub_59cb
0e15  c3        ret
  loc_0e16:
0e16  891e6505  mov    word ptr [0x565], bx
0e1a  c606760502  mov    byte ptr [0x576], 2
  loc_0e1f:
0e1f  e82303    call   sub_1145
0e22  c3        ret
  loc_0e23:
0e23  833e040007  cmp    word ptr [4], 7
0e28  7407      je     loc_0e31
0e2a  803e7b05b4  cmp    byte ptr [0x57b], 0xb4
0e2f  7347      jae    loc_0e78
  loc_0e31:
0e31  e8d407    call   sub_1608
0e34  720d      jb     loc_0e43
0e36  c6066e0500  mov    byte ptr [0x56e], 0
0e3b  c606710501  mov    byte ptr [0x571], 1
0e40  eb6f      jmp    loc_0eb1
0e42  db 90   ; .
  loc_0e43:
0e43  833e040000  cmp    word ptr [4], 0
0e48  752e      jne    loc_0e78
0e4a  e8aa14    call   sub_22f7
0e4d  7207      jb     loc_0e56
0e4f  c6066c0500  mov    byte ptr [0x56c], 0
0e54  eb22      jmp    loc_0e78
  loc_0e56:
0e56  803e6c0500  cmp    byte ptr [0x56c], 0
0e5b  7503      jne    loc_0e60
0e5d  e8bf4a    call   sub_591f
  loc_0e60:
0e60  c606990601  mov    byte ptr [0x699], 1
0e65  c6066c0501  mov    byte ptr [0x56c], 1
0e6a  e8901f    call   sub_2dfd
0e6d  80e201    and    dl, 1
0e70  7502      jne    loc_0e74
0e72  b2ff      mov    dl, 0xff
  loc_0e74:
0e74  88169806  mov    byte ptr [0x698], dl
  loc_0e78:
0e78  a06e05    mov    al, byte ptr [0x56e]
0e7b  a26f05    mov    byte ptr [0x56f], al
0e7e  a09806    mov    al, byte ptr [0x698]
0e81  a26e05    mov    byte ptr [0x56e], al
0e84  a09906    mov    al, byte ptr [0x699]
0e87  a27105    mov    byte ptr [0x571], al
0e8a  3c00      cmp    al, 0
0e8c  7503      jne    loc_0e91
0e8e  e9a300    jmp    loc_0f34
  loc_0e91:
0e91  803e710501  cmp    byte ptr [0x571], 1
0e96  7531      jne    loc_0ec9
0e98  803e7b05b4  cmp    byte ptr [0x57b], 0xb4
0e9d  7212      jb     loc_0eb1
0e9f  c606710500  mov    byte ptr [0x571], 0
0ea4  c606840500  mov    byte ptr [0x584], 0
0ea9  c606990600  mov    byte ptr [0x699], 0
0eae  e98300    jmp    loc_0f34
  loc_0eb1:
0eb1  b401      mov    ah, 1
0eb3  b020      mov    al, 0x20
0eb5  c6065b0508  mov    byte ptr [0x55b], 8
0eba  803e500501  cmp    byte ptr [0x550], 1
0ebf  7530      jne    loc_0ef1
0ec1  c606500500  mov    byte ptr [0x550], 0
0ec6  eb29      jmp    loc_0ef1
0ec8  db 90   ; .
  loc_0ec9:
0ec9  c6065b0500  mov    byte ptr [0x55b], 0
0ece  a17205    mov    ax, word ptr [0x572]
0ed1  8ad8      mov    bl, al
0ed3  3c02      cmp    al, 2
0ed5  7602      jbe    loc_0ed9
0ed7  2c02      sub    al, 2
  loc_0ed9:
0ed9  a37205    mov    word ptr [0x572], ax
0edc  b408      mov    ah, 8
0ede  8ac3      mov    al, bl
0ee0  340f      xor    al, 0xf
0ee2  b104      mov    cl, 4
0ee4  d2e0      shl    al, cl
0ee6  803e500501  cmp    byte ptr [0x550], 1
0eeb  7504      jne    loc_0ef1
0eed  fe065005  inc    byte ptr [0x550]
  loc_0ef1:
0ef1  a27805    mov    byte ptr [0x578], al
0ef4  88267605  mov    byte ptr [0x576], ah
0ef8  c606770501  mov    byte ptr [0x577], 1
0efd  c6065c0500  mov    byte ptr [0x55c], 0
0f02  8a1e6e05  mov    bl, byte ptr [0x56e]
0f06  fec3      inc    bl
0f08  d0e3      shl    bl, 1
0f0a  803e7105ff  cmp    byte ptr [0x571], 0xff
0f0f  7403      je     loc_0f14
0f11  80c306    add    bl, 6
  loc_0f14:
0f14  2aff      sub    bh, bh
0f16  8b87aa0f  mov    ax, word ptr [bx + 0xfaa]
0f1a  a36905    mov    word ptr [0x569], ax
0f1d  8b87b60f  mov    ax, word ptr [bx + 0xfb6]
0f21  a36705    mov    word ptr [0x567], ax
0f24  c606e03900  mov    byte ptr [0x39e0], 0
0f29  803e7c1200  cmp    byte ptr [0x127c], 0
0f2e  7403      je     loc_0f33
0f30  e8c549    call   sub_58f8
  loc_0f33:
0f33  c3        ret
  loc_0f34:
0f34  833e040000  cmp    word ptr [4], 0
0f39  740a      je     loc_0f45
0f3b  833e040007  cmp    word ptr [4], 7
0f40  7403      je     loc_0f45
0f42  e80025    call   sub_3445
  loc_0f45:
0f45  e88100    call   sub_0fc9
0f48  8a167b05  mov    dl, byte ptr [0x57b]
0f4c  8b0e7905  mov    cx, word ptr [0x579]
0f50  e85d1d    call   sub_2cb0
0f53  a36305    mov    word ptr [0x563], ax
0f56  a06e05    mov    al, byte ptr [0x56e]
0f59  0a067105  or     al, byte ptr [0x571]
0f5d  7504      jne    loc_0f63
0f5f  e80701    call   sub_1069
0f62  c3        ret
  loc_0f63:
0f63  e8ba00    call   sub_1020
0f66  891e5d05  mov    word ptr [0x55d], bx
0f6a  e87602    call   sub_11e3
0f6d  e80a0c    call   sub_1b7a
0f70  7214      jb     loc_0f86
0f72  e88011    call   sub_20f5
0f75  720f      jb     loc_0f86
0f77  a16305    mov    ax, word ptr [0x563]
0f7a  a35f05    mov    word ptr [0x55f], ax
0f7d  c7066505030b  mov    word ptr [0x565], 0xb03
0f83  e8bf01    call   sub_1145
  loc_0f86:
0f86  c3        ret

; ----------------------------------------------------------------------
sub_0f87:
0f87  b9030b    mov    cx, 0xb03
0f8a  2ac8      sub    cl, al
0f8c  890e6505  mov    word ptr [0x565], cx
0f90  80fcff    cmp    ah, 0xff
0f93  7411      je     loc_0fa6
0f95  2ae4      sub    ah, ah
0f97  d0e0      shl    al, 1
0f99  01065d05  add    word ptr [0x55d], ax
0f9d  c70679050000  mov    word ptr [0x579], 0
0fa3  eb0f      jmp    loc_0fb4
0fa5  db 90   ; .
  loc_0fa6:
0fa6  2ae4      sub    ah, ah
0fa8  d0e0      shl    al, 1
0faa  d0e0      shl    al, 1
0fac  d0e0      shl    al, 1
0fae  052801    add    ax, 0x128
0fb1  a37905    mov    word ptr [0x579], ax
  loc_0fb4:
0fb4  1e        push   ds
0fb5  07        pop    es
0fb6  8b365d05  mov    si, word ptr [0x55d]
0fba  bf0e00    mov    di, 0xe
0fbd  b003      mov    al, 3
0fbf  e8ae1d    call   sub_2d70
0fc2  c7065d050e00  mov    word ptr [0x55d], 0xe
0fc8  c3        ret

; ----------------------------------------------------------------------
sub_0fc9:
0fc9  c706f6050800  mov    word ptr [0x5f6], 8
0fcf  c706f8052301  mov    word ptr [0x5f8], 0x123
0fd5  833e040007  cmp    word ptr [4], 7
0fda  750c      jne    loc_0fe8
0fdc  c706f6052400  mov    word ptr [0x5f6], 0x24
0fe2  c706f8050f01  mov    word ptr [0x5f8], 0x10f
  loc_0fe8:
0fe8  a17905    mov    ax, word ptr [0x579]
0feb  803e6e0501  cmp    byte ptr [0x56e], 1
0ff0  722c      jb     loc_101e
0ff2  7513      jne    loc_1007
0ff4  03067205  add    ax, word ptr [0x572]
0ff8  3b06f805  cmp    ax, word ptr [0x5f8]
0ffc  721d      jb     loc_101b
0ffe  a1f805    mov    ax, word ptr [0x5f8]
1001  48        dec    ax
1002  a37905    mov    word ptr [0x579], ax
1005  f9        stc
1006  c3        ret
  loc_1007:
1007  2b067205  sub    ax, word ptr [0x572]
100b  7206      jb     loc_1013
100d  3b06f605  cmp    ax, word ptr [0x5f6]
1011  7308      jae    loc_101b
  loc_1013:
1013  a1f605    mov    ax, word ptr [0x5f6]
1016  a37905    mov    word ptr [0x579], ax
1019  f9        stc
101a  c3        ret
  loc_101b:
101b  a37905    mov    word ptr [0x579], ax
  loc_101e:
101e  f8        clc
101f  c3        ret

; ----------------------------------------------------------------------
sub_1020:
1020  a06e05    mov    al, byte ptr [0x56e]
1023  3a066f05  cmp    al, byte ptr [0x56f]
1027  7406      je     loc_102f
1029  c70672050200  mov    word ptr [0x572], 2
  loc_102f:
102f  833e720508  cmp    word ptr [0x572], 8
1034  730f      jae    loc_1045
1036  fe0e7705  dec    byte ptr [0x577]
103a  a07705    mov    al, byte ptr [0x577]
103d  2403      and    al, 3
103f  7504      jne    loc_1045
1041  ff067205  inc    word ptr [0x572]
  loc_1045:
1045  8a1e6b05  mov    bl, byte ptr [0x56b]
1049  fec3      inc    bl
104b  80fb06    cmp    bl, 6
104e  7202      jb     loc_1052
1050  b300      mov    bl, 0
  loc_1052:
1052  881e6b05  mov    byte ptr [0x56b], bl
1056  803e6e05ff  cmp    byte ptr [0x56e], 0xff
105b  7503      jne    loc_1060
105d  80c306    add    bl, 6
  loc_1060:
1060  d0e3      shl    bl, 1
1062  2aff      sub    bh, bh
1064  8b9f7a0f  mov    bx, word ptr [bx + 0xf7a]
1068  c3        ret

; ----------------------------------------------------------------------
sub_1069:
1069  c70672050200  mov    word ptr [0x572], 2
106f  c606770508  mov    byte ptr [0x577], 8
1074  813e6105020c  cmp    word ptr [0x561], 0xc02
107a  750b      jne    loc_1087
107c  fe066d05  inc    byte ptr [0x56d]
1080  f6066d0507  test   byte ptr [0x56d], 7
1085  7555      jne    loc_10dc
  loc_1087:
1087  e85901    call   sub_11e3
108a  e8ed0a    call   sub_1b7a
108d  724d      jb     loc_10dc
108f  e86310    call   sub_20f5
1092  7248      jb     loc_10dc
1094  e8661d    call   sub_2dfd
1097  8ada      mov    bl, dl
1099  81e30e00  and    bx, 0xe
109d  8bb7920f  mov    si, word ptr [bx + 0xf92]
10a1  b800b8    mov    ax, 0xb800
10a4  8ec0      mov    es, ax
10a6  8b3e5f05  mov    di, word ptr [0x55f]
10aa  bdfa05    mov    bp, 0x5fa
10ad  c7066105020c  mov    word ptr [0x561], 0xc02
10b3  b90206    mov    cx, 0x602
10b6  e87c1c    call   sub_2d35
10b9  e8411d    call   sub_2dfd
10bc  8ada      mov    bl, dl
10be  81e30600  and    bx, 6
10c2  8bb7a20f  mov    si, word ptr [bx + 0xfa2]
10c6  8b3e5f05  mov    di, word ptr [0x55f]
10ca  81c7f000  add    di, 0xf0
10ce  bd1206    mov    bp, 0x612
10d1  b90206    mov    cx, 0x602
10d4  e85e1c    call   sub_2d35
10d7  c606830500  mov    byte ptr [0x583], 0
  loc_10dc:
10dc  c3        ret

; ----------------------------------------------------------------------
sub_10dd:
10dd  c6065c0500  mov    byte ptr [0x55c], 0
10e2  c606710501  mov    byte ptr [0x571], 1
10e7  c606760502  mov    byte ptr [0x576], 2
10ec  c606780501  mov    byte ptr [0x578], 1
10f1  c6067705ff  mov    byte ptr [0x577], 0xff
10f6  c6066e0500  mov    byte ptr [0x56e], 0
10fb  c6065a0501  mov    byte ptr [0x55a], 1
1100  a1ac0f    mov    ax, word ptr [0xfac]
1103  a36905    mov    word ptr [0x569], ax
1106  a1b80f    mov    ax, word ptr [0xfb8]
1109  a36705    mov    word ptr [0x567], ax
110c  c606500502  mov    byte ptr [0x550], 2
1111  c3        ret

; ----------------------------------------------------------------------
sub_1112:
1112  8b0e7905  mov    cx, word ptr [0x579]
1116  8a167b05  mov    dl, byte ptr [0x57b]
111a  e8931b    call   sub_2cb0
111d  a35f05    mov    word ptr [0x55f], ax
1120  e80100    call   sub_1124
1123  c3        ret

; ----------------------------------------------------------------------
sub_1124:
1124  b81000    mov    ax, 0x10
1127  8ec0      mov    es, ax
1129  bffa05    mov    di, 0x5fa
112c  1e        push   ds
112d  8b365f05  mov    si, word ptr [0x55f]
1131  b800b8    mov    ax, 0xb800
1134  8ed8      mov    ds, ax
1136  268b0e6105  mov    cx, word ptr es:[0x561]
113b  e88c1c    call   sub_2dca
113e  1f        pop    ds
113f  c606830500  mov    byte ptr [0x583], 0
1144  c3        ret

; ----------------------------------------------------------------------
sub_1145:
1145  b800b8    mov    ax, 0xb800
1148  8ec0      mov    es, ax
114a  8b3e5f05  mov    di, word ptr [0x55f]
114e  bdfa05    mov    bp, 0x5fa
1151  8b365d05  mov    si, word ptr [0x55d]
1155  8b0e6505  mov    cx, word ptr [0x565]
1159  890e6105  mov    word ptr [0x561], cx
115d  c606830500  mov    byte ptr [0x583], 0
1162  e8d01b    call   sub_2d35
1165  c3        ret

; ----------------------------------------------------------------------
sub_1166:
1166  8a167b05  mov    dl, byte ptr [0x57b]
116a  8b0e7905  mov    cx, word ptr [0x579]
116e  83e90c    sub    cx, 0xc
1171  7302      jae    loc_1175
1173  2bc9      sub    cx, cx
  loc_1175:
1175  81f90f01  cmp    cx, 0x10f
1179  7203      jb     loc_117e
117b  b90e01    mov    cx, 0x10e
  loc_117e:
117e  e82f1b    call   sub_2cb0
1181  a38105    mov    word ptr [0x581], ax
1184  8bf8      mov    di, ax
1186  b800b8    mov    ax, 0xb800
1189  8ec0      mov    es, ax
118b  bd0e00    mov    bp, 0xe
118e  be7916    mov    si, 0x1679
1191  b90512    mov    cx, 0x1205
1194  e8351b    call   sub_2ccc
1197  2ae4      sub    ah, ah
1199  cd1a      int    0x1a
119b  89167f05  mov    word ptr [0x57f], dx
119f  c7063c5a0000  mov    word ptr [0x5a3c], 0
11a5  c7063e5a0000  mov    word ptr [0x5a3e], 0
  loc_11ab:
11ab  e86e48    call   sub_5a1c
11ae  2ae4      sub    ah, ah
11b0  cd1a      int    0x1a
11b2  2b167f05  sub    dx, word ptr [0x57f]
11b6  83fa0a    cmp    dx, 0xa
11b9  72f0      jb     loc_11ab
11bb  e86349    call   sub_5b21
11be  8b3e8105  mov    di, word ptr [0x581]
11c2  be0e00    mov    si, 0xe
11c5  b90512    mov    cx, 0x1205
11c8  c606830500  mov    byte ptr [0x583], 0
11cd  e8cd1b    call   sub_2d9d
11d0  803e781600  cmp    byte ptr [0x1678], 0
11d5  740b      je     loc_11e2
11d7  803e801f00  cmp    byte ptr [0x1f80], 0
11dc  7404      je     loc_11e2
11de  fe0e801f  dec    byte ptr [0x1f80]
  loc_11e2:
11e2  c3        ret

; ----------------------------------------------------------------------
sub_11e3:
11e3  b800b8    mov    ax, 0xb800
11e6  8ec0      mov    es, ax
11e8  8b3e5f05  mov    di, word ptr [0x55f]
11ec  befa05    mov    si, 0x5fa
11ef  8b0e6105  mov    cx, word ptr [0x561]
11f3  e8a71b    call   sub_2d9d
11f6  c3        ret
11f7  db 00,00,00,00,00,00,00,00,00   ; .........

; ----------------------------------------------------------------------
sub_1200:
1200  2ae4      sub    ah, ah
1202  cd1a      int    0x1a
1204  8bc2      mov    ax, dx
1206  2b069f06  sub    ax, word ptr [0x69f]
120a  3d0200    cmp    ax, 2
120d  7301      jae    loc_1210
120f  c3        ret
  loc_1210:
1210  89169f06  mov    word ptr [0x69f], dx
1214  803e9b0600  cmp    byte ptr [0x69b], 0
1219  7513      jne    loc_122e
121b  e8a300    call   sub_12c1
121e  e89601    call   sub_13b7
1221  8bd0      mov    dx, ax
  loc_1223:
1223  e89101    call   sub_13b7
1226  2bc2      sub    ax, dx
1228  3dedf8    cmp    ax, 0xf8ed
122b  72f6      jb     loc_1223
122d  c3        ret
  loc_122e:
122e  ba0102    mov    dx, 0x201
1231  ec        in     al, dx
1232  2410      and    al, 0x10
1234  a29a06    mov    byte ptr [0x69a], al
1237  c6069e0603  mov    byte ptr [0x69e], 3
123c  e87801    call   sub_13b7
123f  a39c06    mov    word ptr [0x69c], ax
1242  ee        out    dx, al
1243  b9d007    mov    cx, 0x7d0
  loc_1246:
1246  ec        in     al, dx
1247  a801      test   al, 1
1249  7513      jne    loc_125e
124b  f6069e0601  test   byte ptr [0x69e], 1
1250  740c      je     loc_125e
1252  80269e06fe  and    byte ptr [0x69e], 0xfe
1257  e84700    call   sub_12a1
125a  881e9806  mov    byte ptr [0x698], bl
  loc_125e:
125e  a802      test   al, 2
1260  7513      jne    loc_1275
1262  f6069e0602  test   byte ptr [0x69e], 2
1267  740c      je     loc_1275
1269  80269e06fd  and    byte ptr [0x69e], 0xfd
126e  e83000    call   sub_12a1
1271  881e9906  mov    byte ptr [0x699], bl
  loc_1275:
1275  f6069e0603  test   byte ptr [0x69e], 3
127a  7424      je     loc_12a0
127c  e83801    call   sub_13b7
127f  2b069c06  sub    ax, word ptr [0x69c]
1283  3d6419    cmp    ax, 0x1964
1286  e0be      loopne loc_1246
1288  f6069e0601  test   byte ptr [0x69e], 1
128d  7405      je     loc_1294
128f  c6069806ff  mov    byte ptr [0x698], 0xff
  loc_1294:
1294  f6069e0602  test   byte ptr [0x69e], 2
1299  7405      je     loc_12a0
129b  c6069906ff  mov    byte ptr [0x699], 0xff
  loc_12a0:
12a0  c3        ret

; ----------------------------------------------------------------------
sub_12a1:
12a1  50        push   ax
12a2  e81201    call   sub_13b7
12a5  2b069c06  sub    ax, word ptr [0x69c]
12a9  8bd8      mov    bx, ax
12ab  58        pop    ax
12ac  81fbe6f5  cmp    bx, 0xf5e6
12b0  7303      jae    loc_12b5
12b2  b301      mov    bl, 1
12b4  c3        ret
  loc_12b5:
12b5  81fbfafa  cmp    bx, 0xfafa
12b9  7303      jae    loc_12be
12bb  2adb      sub    bl, bl
12bd  c3        ret
  loc_12be:
12be  b3ff      mov    bl, 0xff
12c0  c3        ret

; ----------------------------------------------------------------------
sub_12c1:
12c1  a0ba06    mov    al, byte ptr [0x6ba]
12c4  803e9706fd  cmp    byte ptr [0x697], 0xfd
12c9  7408      je     loc_12d3
12cb  2206bd06  and    al, byte ptr [0x6bd]
12cf  2206be06  and    al, byte ptr [0x6be]
  loc_12d3:
12d3  3480      xor    al, 0x80
12d5  7402      je     loc_12d9
12d7  b001      mov    al, 1
  loc_12d9:
12d9  a29906    mov    byte ptr [0x699], al
12dc  a0b806    mov    al, byte ptr [0x6b8]
12df  803e9706fd  cmp    byte ptr [0x697], 0xfd
12e4  7408      je     loc_12ee
12e6  2206bc06  and    al, byte ptr [0x6bc]
12ea  2206bf06  and    al, byte ptr [0x6bf]
  loc_12ee:
12ee  3480      xor    al, 0x80
12f0  7405      je     loc_12f7
12f2  c6069906ff  mov    byte ptr [0x699], 0xff
  loc_12f7:
12f7  a0b906    mov    al, byte ptr [0x6b9]
12fa  803e9706fd  cmp    byte ptr [0x697], 0xfd
12ff  7408      je     loc_1309
1301  2206bc06  and    al, byte ptr [0x6bc]
1305  2206bd06  and    al, byte ptr [0x6bd]
  loc_1309:
1309  3480      xor    al, 0x80
130b  7402      je     loc_130f
130d  b001      mov    al, 1
  loc_130f:
130f  a29806    mov    byte ptr [0x698], al
1312  a0bb06    mov    al, byte ptr [0x6bb]
1315  803e9706fd  cmp    byte ptr [0x697], 0xfd
131a  7408      je     loc_1324
131c  2206be06  and    al, byte ptr [0x6be]
1320  2206bf06  and    al, byte ptr [0x6bf]
  loc_1324:
1324  3480      xor    al, 0x80
1326  7405      je     loc_132d
1328  c6069806ff  mov    byte ptr [0x698], 0xff
  loc_132d:
132d  a0b706    mov    al, byte ptr [0x6b7]
1330  b103      mov    cl, 3
1332  d2e8      shr    al, cl
1334  a29a06    mov    byte ptr [0x69a], al
1337  c3        ret

; ----------------------------------------------------------------------
sub_1338:
1338  a19306    mov    ax, word ptr [0x693]
133b  3b069106  cmp    ax, word ptr [0x691]
133f  7416      je     loc_1357
1341  a39106    mov    word ptr [0x691], ax
1344  f606c00680  test   byte ptr [0x6c0], 0x80
1349  750d      jne    loc_1358
134b  a19306    mov    ax, word ptr [0x693]
134e  3b06006e  cmp    ax, word ptr [0x6e00]
1352  7403      je     loc_1357
1354  e8194b    call   sub_5e70
  loc_1357:
1357  c3        ret
  loc_1358:
1358  f606c90680  test   byte ptr [0x6c9], 0x80
135d  7401      je     loc_1360
135f  c3        ret
  loc_1360:
1360  f606cc0680  test   byte ptr [0x6cc], 0x80
1365  7506      jne    loc_136d
1367  c606801f09  mov    byte ptr [0x1f80], 9
136c  c3        ret
  loc_136d:
136d  f606c10680  test   byte ptr [0x6c1], 0x80
1372  7431      je     loc_13a5
1374  f606cb0680  test   byte ptr [0x6cb], 0x80
1379  7506      jne    loc_1381
137b  c6061c04ff  mov    byte ptr [0x41c], 0xff
1380  c3        ret
  loc_1381:
1381  f606c80680  test   byte ptr [0x6c8], 0x80
1386  7506      jne    loc_138e
1388  c6061b04ff  mov    byte ptr [0x41b], 0xff
138d  c3        ret
  loc_138e:
138e  f606c70680  test   byte ptr [0x6c7], 0x80
1393  750f      jne    loc_13a4
1395  f6160000  not    byte ptr [0]
1399  803e000000  cmp    byte ptr [0], 0
139e  7503      jne    loc_13a3
13a0  e87e47    call   sub_5b21
  loc_13a3:
13a3  c3        ret
  loc_13a4:
13a4  c3        ret
  loc_13a5:
13a5  e8d700    call   sub_147f
13a8  58        pop    ax
13a9  cb        retf

; ----------------------------------------------------------------------
sub_13aa:
13aa  b800f0    mov    ax, 0xf000
13ad  8ec0      mov    es, ax
13af  26a0feff  mov    al, byte ptr es:[0xfffe]
13b3  a29706    mov    byte ptr [0x697], al
13b6  c3        ret

; ----------------------------------------------------------------------
sub_13b7:
13b7  b000      mov    al, 0
13b9  e643      out    0x43, al
13bb  90        nop
13bc  90        nop
13bd  e440      in     al, 0x40
13bf  8ae0      mov    ah, al
13c1  90        nop
13c2  e440      in     al, 0x40
13c4  86c4      xchg   ah, al
13c6  c3        ret
13c7  db e8,ed,ff,8b,d8,2b,c1,8b,cb,3b,c2,73,01,c3,3b,d2   ; .....+...;.s..;.
13d7  db c3   ; .

; ----------------------------------------------------------------------
sub_13d8:
13d8  bada03    mov    dx, 0x3da
13db  ec        in     al, dx
13dc  2408      and    al, 8
13de  c3        ret
13df  db 00,00,00,00,00,00,00,00,00   ; .........

; ----------------------------------------------------------------------
sub_13e8:
13e8  50        push   ax
13e9  06        push   es
13ea  57        push   di
13eb  51        push   cx
13ec  b81000    mov    ax, 0x10
13ef  8ec0      mov    es, ax
13f1  fc        cld
13f2  bfb706    mov    di, 0x6b7
13f5  b91600    mov    cx, 0x16
13f8  b080      mov    al, 0x80
13fa  f3aa      rep stosb byte ptr es:[di], al
13fc  26a19306  mov    ax, word ptr es:[0x693]
1400  2d7000    sub    ax, 0x70
1403  26a39106  mov    word ptr es:[0x691], ax
1407  b84000    mov    ax, 0x40
140a  8ec0      mov    es, ax
140c  26a01200  mov    al, byte ptr es:[0x12]
1410  2ea2e713  mov    byte ptr cs:[0x13e7], al
1414  59        pop    cx
1415  5f        pop    di
1416  07        pop    es
1417  58        pop    ax
1418  c3        ret

; ----------------------------------------------------------------------
sub_1419:
1419  2bc0      sub    ax, ax
141b  8ec0      mov    es, ax
141d  26a12400  mov    ax, word ptr es:[0x24]
1421  268b1e2600  mov    bx, word ptr es:[0x26]
1426  268b0e2001  mov    cx, word ptr es:[0x120]
142b  268b162201  mov    dx, word ptr es:[0x122]
1430  2ea3df13  mov    word ptr cs:[0x13df], ax
1434  2e891ee113  mov    word ptr cs:[0x13e1], bx
1439  2e890ee313  mov    word ptr cs:[0x13e3], cx
143e  2e8916e513  mov    word ptr cs:[0x13e5], dx
1443  bbb314    mov    bx, 0x14b3
1446  803e9706fd  cmp    byte ptr [0x697], 0xfd
144b  7503      jne    loc_1450
144d  bbfb14    mov    bx, 0x14fb
  loc_1450:
1450  fa        cli
1451  26891e2400  mov    word ptr es:[0x24], bx
1456  268c0e2600  mov    word ptr es:[0x26], cs
145b  803e9706fd  cmp    byte ptr [0x697], 0xfd
1460  751b      jne    loc_147d
1462  26c70620015415  mov    word ptr es:[0x120], 0x1554
1469  268c0e2201  mov    word ptr es:[0x122], cs
146e  b84000    mov    ax, 0x40
1471  8ec0      mov    es, ax
1473  26a01800  mov    al, byte ptr es:[0x18]
1477  0c01      or     al, 1
1479  26a21800  mov    byte ptr es:[0x18], al
  loc_147d:
147d  fb        sti
147e  c3        ret

; ----------------------------------------------------------------------
sub_147f:
147f  2bc0      sub    ax, ax
1481  8ec0      mov    es, ax
1483  2ea1df13  mov    ax, word ptr cs:[0x13df]
1487  2e8b1ee113  mov    bx, word ptr cs:[0x13e1]
148c  2e8b0ee313  mov    cx, word ptr cs:[0x13e3]
1491  2e8b16e513  mov    dx, word ptr cs:[0x13e5]
1496  fa        cli
1497  26a32400  mov    word ptr es:[0x24], ax
149b  26891e2600  mov    word ptr es:[0x26], bx
14a0  803e9706fd  cmp    byte ptr [0x697], 0xfd
14a5  750a      jne    loc_14b1
14a7  26890e2001  mov    word ptr es:[0x120], cx
14ac  2689162201  mov    word ptr es:[0x122], dx
  loc_14b1:
14b1  fb        sti
14b2  c3        ret
14b3  db 50,06,57,51,bf,10,00,8e,c7,e4,60,8a,e0,24,7f,f6   ; P.WQ......`..$..
14c3  db c4,80,75,05,26,ff,06,93,06,bf,a1,06,b9,16,00,fc   ; ..u.&...........
14d3  db f2,ae,75,0c,81,ef,a2,06,80,e4,80,26,88,a5,b7,06   ; ..u........&....
14e3  db e4,61,8a,e0,0c,80,e6,61,8a,c4,e6,61,e8,80,00,59   ; .a.....a...a...Y
14f3  db 5f,07,b0,20,e6,20,58,cf,fb,50,06,57,51,bf,10,00   ; _.. . X..P.WQ...
1503  db 8e,c7,8a,e0,24,7f,f6,c4,80,75,05,26,ff,06,93,06   ; ....$....u.&....
1513  db 80,fc,ff,74,18,80,fc,55,74,13,06,bf,40,00,8e,c7   ; ...t...Ut...@...
1523  db 26,8a,0e,12,00,07,2e,3a,0e,e7,13,74,05,e8,b5,fe   ; &......:...t....
1533  db eb,17,bf,a1,06,b9,16,00,fc,f2,ae,75,0c,81,ef,a2   ; ...........u....
1543  db 06,80,e4,80,26,88,a5,b7,06,e8,23,00,59,5f,07,58   ; ....&.....#.Y_.X
1553  db cf,cd,09,cf,b8,00,f0,8e,d0,b8,40,00,8e,d8,bb,72   ; ..........@....r
1563  db 00,c7,07,34,12,b8,00,00,8e,c0,ea,5b,e0,00,f0,26   ; ...4.......[...&
1573  db a0,c9,06,26,0a,06,b7,06,3c,00,75,4a,26,f6,06,ca   ; ...&....<.uJ&...
1583  db 06,80,75,06,b0,20,e6,20,eb,ca,26,f6,06,b9,06,80   ; ..u.. . ..&.....
1593  db 75,0f,26,80,3e,90,06,01,72,2c,26,fe,0e,90,06,eb   ; u.&.>...r,&.....
15a3  db 15,26,f6,06,bb,06,80,75,1d,26,80,3e,90,06,07,73   ; .&.....u.&.>...s
15b3  db 15,26,fe,06,90,06,52,b0,02,ba,d4,03,ee,26,a0,90   ; .&....R......&..
15c3  db 06,04,27,42,ee,5a,c3,00,00,00,00,00,00   ; ..'B.Z.......

; ----------------------------------------------------------------------
sub_15d0:
15d0  8b1e0800  mov    bx, word ptr [8]
15d4  8a8f0e10  mov    cl, byte ptr [bx + 0x100e]
  loc_15d8:
15d8  e82218    call   sub_2dfd
15db  80e207    and    dl, 7
15de  3ad1      cmp    dl, cl
15e0  77f6      ja     loc_15d8
15e2  02970610  add    dl, byte ptr [bx + 0x1006]
15e6  3a162810  cmp    dl, byte ptr [0x1028]
15ea  74ec      je     loc_15d8
15ec  88162810  mov    byte ptr [0x1028], dl
15f0  8ada      mov    bl, dl
15f2  8a8ff00f  mov    cl, byte ptr [bx + 0xff0]
15f6  b288      mov    dl, 0x88
15f8  f6c180    test   cl, 0x80
15fb  7502      jne    loc_15ff
15fd  b290      mov    dl, 0x90
  loc_15ff:
15ff  81e17f00  and    cx, 0x7f
1603  d1e1      shl    cx, 1
1605  d1e1      shl    cx, 1
1607  c3        ret

; ----------------------------------------------------------------------
sub_1608:
1608  833e040007  cmp    word ptr [4], 7
160d  7504      jne    loc_1613
160f  e8e81a    call   sub_30fa
1612  c3        ret
  loc_1613:
1613  833e040000  cmp    word ptr [4], 0
1618  7404      je     loc_161e
161a  e8a900    call   sub_16c6
161d  c3        ret
  loc_161e:
161e  a07b05    mov    al, byte ptr [0x57b]
1621  24f8      and    al, 0xf8
1623  3c60      cmp    al, 0x60
1625  7409      je     loc_1630
1627  e82d00    call   sub_1657
162a  722a      jb     loc_1656
162c  e87e01    call   sub_17ad
162f  c3        ret
  loc_1630:
1630  803e500502  cmp    byte ptr [0x550], 2
1635  731e      jae    loc_1655
1637  a27b05    mov    byte ptr [0x57b], al
163a  0432      add    al, 0x32
163c  a27c05    mov    byte ptr [0x57c], al
163f  803e500501  cmp    byte ptr [0x550], 1
1644  740d      je     loc_1653
1646  c606500501  mov    byte ptr [0x550], 1
164b  2ae4      sub    ah, ah
164d  cd1a      int    0x1a
164f  89165605  mov    word ptr [0x556], dx
  loc_1653:
1653  f9        stc
1654  c3        ret
  loc_1655:
1655  f8        clc
  loc_1656:
1656  c3        ret

; ----------------------------------------------------------------------
sub_1657:
1657  8a0e7b05  mov    cl, byte ptr [0x57b]
165b  80c102    add    cl, 2
165e  80e1f8    and    cl, 0xf8
1661  8b1e0800  mov    bx, word ptr [8]
1665  8a9f0610  mov    bl, byte ptr [bx + 0x1006]
  loc_1669:
1669  8a87f00f  mov    al, byte ptr [bx + 0xff0]
166d  3c00      cmp    al, 0
166f  7507      jne    loc_1678
1671  c6067c1200  mov    byte ptr [0x127c], 0
1676  f8        clc
1677  c3        ret
  loc_1678:
1678  43        inc    bx
1679  b588      mov    ch, 0x88
167b  a880      test   al, 0x80
167d  7502      jne    loc_1681
167f  b590      mov    ch, 0x90
  loc_1681:
1681  3acd      cmp    cl, ch
1683  75e4      jne    loc_1669
1685  257f00    and    ax, 0x7f
1688  d1e0      shl    ax, 1
168a  d1e0      shl    ax, 1
168c  8b167905  mov    dx, word ptr [0x579]
1690  81e2f8ff  and    dx, 0xfff8
1694  3bd0      cmp    dx, ax
1696  72d1      jb     loc_1669
1698  8b167905  mov    dx, word ptr [0x579]
169c  83ea0f    sub    dx, 0xf
169f  81e2f8ff  and    dx, 0xfff8
16a3  3bd0      cmp    dx, ax
16a5  77c2      ja     loc_1669
16a7  80ed02    sub    ch, 2
16aa  882e7b05  mov    byte ptr [0x57b], ch
16ae  80c532    add    ch, 0x32
16b1  882e7c05  mov    byte ptr [0x57c], ch
16b5  803e7c1200  cmp    byte ptr [0x127c], 0
16ba  7508      jne    loc_16c4
16bc  c6067c1201  mov    byte ptr [0x127c], 1
16c1  e84a42    call   sub_590e
  loc_16c4:
16c4  f9        stc
16c5  c3        ret

; ----------------------------------------------------------------------
sub_16c6:
16c6  c606e03900  mov    byte ptr [0x39e0], 0
16cb  803e710501  cmp    byte ptr [0x571], 1
16d0  752a      jne    loc_16fc
16d2  a15026    mov    ax, word ptr [0x2650]
16d5  2d0400    sub    ax, 4
16d8  8a165226  mov    dl, byte ptr [0x2652]
16dc  80ea08    sub    dl, 8
16df  be0c00    mov    si, 0xc
16e2  8b1e7905  mov    bx, word ptr [0x579]
16e6  8a367b05  mov    dh, byte ptr [0x57b]
16ea  bf1800    mov    di, 0x18
16ed  b9100e    mov    cx, 0xe10
16f0  e83617    call   sub_2e29
16f3  7307      jae    loc_16fc
16f5  c606510501  mov    byte ptr [0x551], 1
16fa  f8        clc
16fb  c3        ret
  loc_16fc:
16fc  833e040003  cmp    word ptr [4], 3
1701  750b      jne    loc_170e
1703  e83d25    call   sub_3c43
1706  7306      jae    loc_170e
1708  c6065c0501  mov    byte ptr [0x55c], 1
170d  c3        ret
  loc_170e:
170e  8a0e7b05  mov    cl, byte ptr [0x57b]
1712  80e1f8    and    cl, 0xf8
1715  8b1e0400  mov    bx, word ptr [4]
1719  d1e3      shl    bx, 1
171b  8b9f6912  mov    bx, word ptr [bx + 0x1269]
  loc_171f:
171f  8aaf2910  mov    ch, byte ptr [bx + 0x1029]
1723  80fd00    cmp    ch, 0
1726  7502      jne    loc_172a
1728  f8        clc
1729  c3        ret
  loc_172a:
172a  8a878910  mov    al, byte ptr [bx + 0x1089]
172e  a27b12    mov    byte ptr [0x127b], al
1731  d0e3      shl    bl, 1
1733  8b87a911  mov    ax, word ptr [bx + 0x11a9]
1737  a37912    mov    word ptr [0x1279], ax
173a  8b87e910  mov    ax, word ptr [bx + 0x10e9]
173e  d0eb      shr    bl, 1
1740  43        inc    bx
1741  3acd      cmp    cl, ch
1743  75da      jne    loc_171f
1745  8b167905  mov    dx, word ptr [0x579]
1749  81e2f8ff  and    dx, 0xfff8
174d  3bd0      cmp    dx, ax
174f  72ce      jb     loc_171f
1751  8b167905  mov    dx, word ptr [0x579]
1755  2b167912  sub    dx, word ptr [0x1279]
1759  7302      jae    loc_175d
175b  2bd2      sub    dx, dx
  loc_175d:
175d  81e2fcff  and    dx, 0xfffc
1761  3bd0      cmp    dx, ax
1763  77ba      ja     loc_171f
1765  882e7b05  mov    byte ptr [0x57b], ch
1769  80c532    add    ch, 0x32
176c  882e7c05  mov    byte ptr [0x57c], ch
1770  a07b12    mov    al, byte ptr [0x127b]
1773  a25c05    mov    byte ptr [0x55c], al
1776  3c00      cmp    al, 0
1778  7406      je     loc_1780
177a  81267905fcff  and    word ptr [0x579], 0xfffc
  loc_1780:
1780  833e040004  cmp    word ptr [4], 4
1785  7510      jne    loc_1797
1787  4b        dec    bx
1788  83eb27    sub    bx, 0x27
178b  720a      jb     loc_1797
178d  83fb10    cmp    bx, 0x10
1790  7305      jae    loc_1797
1792  43        inc    bx
1793  881ee039  mov    byte ptr [0x39e0], bl
  loc_1797:
1797  f9        stc
1798  c3        ret

; ----------------------------------------------------------------------
sub_1799:
1799  b103      mov    cl, 3
179b  d3eb      shr    bx, cl
179d  8aeb      mov    ch, bl
179f  b103      mov    cl, 3
17a1  d3eb      shr    bx, cl
17a3  8acd      mov    cl, ch
17a5  80e107    and    cl, 7
17a8  b580      mov    ch, 0x80
17aa  d2ed      shr    ch, cl
17ac  c3        ret

; ----------------------------------------------------------------------
sub_17ad:
17ad  8a167b05  mov    dl, byte ptr [0x57b]
17b1  80e2f8    and    dl, 0xf8
17b4  2bdb      sub    bx, bx
17b6  80fa08    cmp    dl, 8
17b9  740e      je     loc_17c9
17bb  fec3      inc    bl
17bd  80fa28    cmp    dl, 0x28
17c0  7407      je     loc_17c9
17c2  fec3      inc    bl
17c4  80fa48    cmp    dl, 0x48
17c7  7547      jne    loc_1810
  loc_17c9:
17c9  a17905    mov    ax, word ptr [0x579]
17cc  3b1e2f05  cmp    bx, word ptr [0x52f]
17d0  752a      jne    loc_17fc
17d2  803e250503  cmp    byte ptr [0x525], 3
17d7  7723      ja     loc_17fc
17d9  80fb01    cmp    bl, 1
17dc  7410      je     loc_17ee
17de  b90400    mov    cx, 4
17e1  2a0e2505  sub    cl, byte ptr [0x525]
17e5  d0e1      shl    cl, 1
17e7  d0e1      shl    cl, 1
17e9  03c1      add    ax, cx
17eb  eb0f      jmp    loc_17fc
17ed  db 90   ; .
  loc_17ee:
17ee  2aed      sub    ch, ch
17f0  8a0e2505  mov    cl, byte ptr [0x525]
17f4  fec1      inc    cl
17f6  d0e1      shl    cl, 1
17f8  d0e1      shl    cl, 1
17fa  2bc1      sub    ax, cx
  loc_17fc:
17fc  8a9f2510  mov    bl, byte ptr [bx + 0x1025]
1800  8bf3      mov    si, bx
1802  8bd8      mov    bx, ax
1804  83c30a    add    bx, 0xa
1807  e88fff    call   sub_1799
180a  84a81610  test   byte ptr [bx + si + 0x1016], ch
180e  7502      jne    loc_1812
  loc_1810:
1810  f8        clc
1811  c3        ret
  loc_1812:
1812  88167b05  mov    byte ptr [0x57b], dl
1816  80c232    add    dl, 0x32
1819  88167c05  mov    byte ptr [0x57c], dl
181d  81267905f8ff  and    word ptr [0x579], 0xfff8
1823  c6065c0501  mov    byte ptr [0x55c], 1
1828  f9        stc
1829  c3        ret
182a  db 00,00,00,00,00,00   ; ......

; ----------------------------------------------------------------------
sub_1830:
1830  c606651600  mov    byte ptr [0x1665], 0
1835  c606731600  mov    byte ptr [0x1673], 0
183a  c606771600  mov    byte ptr [0x1677], 0
183f  c606781600  mov    byte ptr [0x1678], 0
1844  c7066c160900  mov    word ptr [0x166c], 9
184a  c3        ret

; ----------------------------------------------------------------------
sub_184b:
184b  803e731600  cmp    byte ptr [0x1673], 0
1850  740a      je     loc_185c
1852  2ae4      sub    ah, ah
1854  cd1a      int    0x1a
1856  3b16ec17  cmp    dx, word ptr [0x17ec]
185a  7501      jne    loc_185d
  loc_185c:
185c  c3        ret
  loc_185d:
185d  8916ec17  mov    word ptr [0x17ec], dx
1861  803e771600  cmp    byte ptr [0x1677], 0
1866  7417      je     loc_187f
1868  a17116    mov    ax, word ptr [0x1671]
186b  25f8ff    and    ax, 0xfff8
186e  8b1e7905  mov    bx, word ptr [0x579]
1872  81e3f8ff  and    bx, 0xfff8
1876  3bc3      cmp    ax, bx
1878  7505      jne    loc_187f
187a  c606741600  mov    byte ptr [0x1674], 0
  loc_187f:
187f  fe06e917  inc    byte ptr [0x17e9]
1883  833eea1701  cmp    word ptr [0x17ea], 1
1888  7704      ja     loc_188e
188a  ff0eea17  dec    word ptr [0x17ea]
  loc_188e:
188e  a17116    mov    ax, word ptr [0x1671]
1891  8b16ea17  mov    dx, word ptr [0x17ea]
1895  b103      mov    cl, 3
1897  d2ea      shr    dl, cl
1899  803e741601  cmp    byte ptr [0x1674], 1
189e  7215      jb     loc_18b5
18a0  750d      jne    loc_18af
18a2  03c2      add    ax, dx
18a4  3d2f01    cmp    ax, 0x12f
18a7  720c      jb     loc_18b5
18a9  b82e01    mov    ax, 0x12e
18ac  eb07      jmp    loc_18b5
18ae  db 90   ; .
  loc_18af:
18af  2bc2      sub    ax, dx
18b1  7302      jae    loc_18b5
18b3  2bc0      sub    ax, ax
  loc_18b5:
18b5  a37116    mov    word ptr [0x1671], ax
18b8  8b1edf17  mov    bx, word ptr [0x17df]
18bc  a0e917    mov    al, byte ptr [0x17e9]
18bf  d0e8      shr    al, 1
18c1  02067316  add    al, byte ptr [0x1673]
18c5  8ad0      mov    dl, al
18c7  2a067616  sub    al, byte ptr [0x1676]
18cb  7214      jb     loc_18e1
18cd  2af8      sub    bh, al
18cf  7402      je     loc_18d3
18d1  730e      jae    loc_18e1
  loc_18d3:
18d3  c606731600  mov    byte ptr [0x1673], 0
18d8  c606781600  mov    byte ptr [0x1678], 0
18dd  e84200    call   sub_1922
  loc_18e0:
18e0  c3        ret
  loc_18e1:
18e1  88167316  mov    byte ptr [0x1673], dl
18e5  8b0e7116  mov    cx, word ptr [0x1671]
18e9  891ee117  mov    word ptr [0x17e1], bx
18ed  e8c013    call   sub_2cb0
18f0  a3e717    mov    word ptr [0x17e7], ax
18f3  803ee91702  cmp    byte ptr [0x17e9], 2
18f8  7403      je     loc_18fd
18fa  e82500    call   sub_1922
  loc_18fd:
18fd  e87a02    call   sub_1b7a
1900  72de      jb     loc_18e0
1902  8b3ee717  mov    di, word ptr [0x17e7]
1906  893ee517  mov    word ptr [0x17e5], di
190a  8b0ee117  mov    cx, word ptr [0x17e1]
190e  890ee317  mov    word ptr [0x17e3], cx
1912  b800b8    mov    ax, 0xb800
1915  8ec0      mov    es, ax
1917  8b36dd17  mov    si, word ptr [0x17dd]
191b  bdee17    mov    bp, 0x17ee
191e  e8ab13    call   sub_2ccc
1921  c3        ret

; ----------------------------------------------------------------------
sub_1922:
1922  b800b8    mov    ax, 0xb800
1925  8ec0      mov    es, ax
1927  8b3ee517  mov    di, word ptr [0x17e5]
192b  beee17    mov    si, 0x17ee
192e  8b0ee317  mov    cx, word ptr [0x17e3]
1932  e86814    call   sub_2d9d
1935  c3        ret

; ----------------------------------------------------------------------
sub_1936:
1936  fe0e6a16  dec    byte ptr [0x166a]
193a  7401      je     loc_193d
  loc_193c:
193c  c3        ret
  loc_193d:
193d  c6066a160d  mov    byte ptr [0x166a], 0xd
1942  e893fa    call   sub_13d8
1945  75f5      jne    loc_193c
1947  803e651600  cmp    byte ptr [0x1665], 0
194c  7403      je     loc_1951
194e  e8b401    call   sub_1b05
  loc_1951:
1951  803e731600  cmp    byte ptr [0x1673], 0
1956  75e4      jne    loc_193c
1958  803e651600  cmp    byte ptr [0x1665], 0
195d  756e      jne    loc_19cd
195f  803e7b0560  cmp    byte ptr [0x57b], 0x60
1964  77d6      ja     loc_193c
1966  c606771600  mov    byte ptr [0x1677], 0
196b  803e500501  cmp    byte ptr [0x550], 1
1970  7518      jne    loc_198a
1972  803e180400  cmp    byte ptr [0x418], 0
1977  7511      jne    loc_198a
1979  2ae4      sub    ah, ah
197b  cd1a      int    0x1a
197d  2b165605  sub    dx, word ptr [0x556]
1981  83fa48    cmp    dx, 0x48
1984  7204      jb     loc_198a
1986  fe067716  inc    byte ptr [0x1677]
  loc_198a:
198a  e87014    call   sub_2dfd
198d  803e771600  cmp    byte ptr [0x1677], 0
1992  7406      je     loc_199a
1994  80e203    and    dl, 3
1997  eb09      jmp    loc_19a2
1999  db 90   ; .
  loc_199a:
199a  80e20f    and    dl, 0xf
199d  80fa0c    cmp    dl, 0xc
19a0  739a      jae    loc_193c
  loc_19a2:
19a2  88166916  mov    byte ptr [0x1669], dl
19a6  e84101    call   sub_1aea
19a9  890e6616  mov    word ptr [0x1666], cx
19ad  88166816  mov    byte ptr [0x1668], dl
19b1  e85101    call   sub_1b05
19b4  72d4      jb     loc_198a
19b6  c60665161d  mov    byte ptr [0x1665], 0x1d
19bb  8b1e0800  mov    bx, word ptr [8]
19bf  d0e3      shl    bl, 1
19c1  8b871e18  mov    ax, word ptr [bx + 0x181e]
19c5  a36c16    mov    word ptr [0x166c], ax
19c8  c606701601  mov    byte ptr [0x1670], 1
  loc_19cd:
19cd  e83501    call   sub_1b05
19d0  720e      jb     loc_19e0
19d2  c606641600  mov    byte ptr [0x1664], 0
19d7  e87201    call   sub_1b4c
19da  7305      jae    loc_19e1
19dc  fe066416  inc    byte ptr [0x1664]
  loc_19e0:
19e0  c3        ret
  loc_19e1:
19e1  803e651610  cmp    byte ptr [0x1665], 0x10
19e6  7508      jne    loc_19f0
19e8  2ae4      sub    ah, ah
19ea  cd1a      int    0x1a
19ec  89166e16  mov    word ptr [0x166e], dx
  loc_19f0:
19f0  803e65160f  cmp    byte ptr [0x1665], 0xf
19f5  757f      jne    loc_1a76
19f7  2ae4      sub    ah, ah
19f9  cd1a      int    0x1a
19fb  2b166e16  sub    dx, word ptr [0x166e]
19ff  3b166c16  cmp    dx, word ptr [0x166c]
1a03  7371      jae    loc_1a76
1a05  803e701600  cmp    byte ptr [0x1670], 0
1a0a  7469      je     loc_1a75
1a0c  803e731600  cmp    byte ptr [0x1673], 0
1a11  7562      jne    loc_1a75
1a13  803e180400  cmp    byte ptr [0x418], 0
1a18  755b      jne    loc_1a75
1a1a  fe0e7016  dec    byte ptr [0x1670]
1a1e  c606781601  mov    byte ptr [0x1678], 1
1a23  a06816    mov    al, byte ptr [0x1668]
1a26  a27316    mov    byte ptr [0x1673], al
1a29  e8d113    call   sub_2dfd
1a2c  81e20f00  and    dx, 0xf
1a30  03166616  add    dx, word ptr [0x1666]
1a34  89167116  mov    word ptr [0x1671], dx
1a38  b001      mov    al, 1
1a3a  3b167905  cmp    dx, word ptr [0x579]
1a3e  7202      jb     loc_1a42
1a40  b0ff      mov    al, 0xff
  loc_1a42:
1a42  a27416    mov    byte ptr [0x1674], al
1a45  e8b513    call   sub_2dfd
1a48  8ada      mov    bl, dl
1a4a  81e30600  and    bx, 6
1a4e  8b87c917  mov    ax, word ptr [bx + 0x17c9]
1a52  a3dd17    mov    word ptr [0x17dd], ax
1a55  8b87d117  mov    ax, word ptr [bx + 0x17d1]
1a59  a3df17    mov    word ptr [0x17df], ax
1a5c  d0eb      shr    bl, 1
1a5e  8a87d917  mov    al, byte ptr [bx + 0x17d9]
1a62  a27616    mov    byte ptr [0x1676], al
1a65  c706ea172000  mov    word ptr [0x17ea], 0x20
1a6b  c606e91701  mov    byte ptr [0x17e9], 1
1a70  c606751600  mov    byte ptr [0x1675], 0
  loc_1a75:
1a75  c3        ret
  loc_1a76:
1a76  fe0e6516  dec    byte ptr [0x1665]
1a7a  8b0e6616  mov    cx, word ptr [0x1666]
1a7e  8a166816  mov    dl, byte ptr [0x1668]
1a82  803e65160e  cmp    byte ptr [0x1665], 0xe
1a87  760a      jbe    loc_1a93
1a89  02166516  add    dl, byte ptr [0x1665]
1a8d  80ea0e    sub    dl, 0xe
1a90  eb08      jmp    loc_1a9a
1a92  db 90   ; .
  loc_1a93:
1a93  80c20e    add    dl, 0xe
1a96  2a166516  sub    dl, byte ptr [0x1665]
  loc_1a9a:
1a9a  88166b16  mov    byte ptr [0x166b], dl
1a9e  e80f12    call   sub_2cb0
1aa1  8bf8      mov    di, ax
1aa3  b800b8    mov    ax, 0xb800
1aa6  8ec0      mov    es, ax
1aa8  fc        cld
1aa9  b90400    mov    cx, 4
1aac  803e65160e  cmp    byte ptr [0x1665], 0xe
1ab1  7624      jbe    loc_1ad7
1ab3  803e180400  cmp    byte ptr [0x418], 0
1ab8  7418      je     loc_1ad2
1aba  a06b16    mov    al, byte ptr [0x166b]
1abd  2a066816  sub    al, byte ptr [0x1668]
1ac1  2ae4      sub    ah, ah
1ac3  b103      mov    cl, 3
1ac5  d3e0      shl    ax, cl
1ac7  05e015    add    ax, 0x15e0
1aca  8bf0      mov    si, ax
1acc  b90400    mov    cx, 4
1acf  f3a5      rep movsw word ptr es:[di], word ptr [si]
1ad1  c3        ret
  loc_1ad2:
1ad2  2bc0      sub    ax, ax
1ad4  f3ab      rep stosw word ptr es:[di], ax
1ad6  c3        ret
  loc_1ad7:
1ad7  a06b16    mov    al, byte ptr [0x166b]
1ada  2a066816  sub    al, byte ptr [0x1668]
1ade  b40a      mov    ah, 0xa
1ae0  f6e4      mul    ah
1ae2  058126    add    ax, 0x2681
1ae5  8bf0      mov    si, ax
1ae7  f3a5      rep movsw word ptr es:[di], word ptr [si]
1ae9  c3        ret

; ----------------------------------------------------------------------
sub_1aea:
1aea  2aff      sub    bh, bh
1aec  8ada      mov    bl, dl
1aee  80e303    and    bl, 3
1af1  d0e3      shl    bl, 1
1af3  8b8f5816  mov    cx, word ptr [bx + 0x1658]
1af7  8ada      mov    bl, dl
1af9  d0eb      shr    bl, 1
1afb  d0eb      shr    bl, 1
1afd  80e303    and    bl, 3
1b00  8a976016  mov    dl, byte ptr [bx + 0x1660]
1b04  c3        ret

; ----------------------------------------------------------------------
sub_1b05:
1b05  a16616    mov    ax, word ptr [0x1666]
1b08  8a166816  mov    dl, byte ptr [0x1668]
1b0c  8b1e7905  mov    bx, word ptr [0x579]
1b10  8a367b05  mov    dh, byte ptr [0x57b]
1b14  be2000    mov    si, 0x20
1b17  bf1800    mov    di, 0x18
1b1a  b90f0e    mov    cx, 0xe0f
1b1d  e80913    call   sub_2e29
1b20  7329      jae    loc_1b4b
1b22  803e710501  cmp    byte ptr [0x571], 1
1b27  7521      jne    loc_1b4a
1b29  803e5a0500  cmp    byte ptr [0x55a], 0
1b2e  751a      jne    loc_1b4a
1b30  803e7b0560  cmp    byte ptr [0x57b], 0x60
1b35  7313      jae    loc_1b4a
1b37  803e651605  cmp    byte ptr [0x1665], 5
1b3c  720c      jb     loc_1b4a
1b3e  803e651619  cmp    byte ptr [0x1665], 0x19
1b43  7305      jae    loc_1b4a
1b45  c606510501  mov    byte ptr [0x551], 1
  loc_1b4a:
1b4a  f9        stc
  loc_1b4b:
1b4b  c3        ret

; ----------------------------------------------------------------------
sub_1b4c:
1b4c  a06916    mov    al, byte ptr [0x1669]
1b4f  3c08      cmp    al, 8
1b51  7325      jae    loc_1b78
1b53  bb0200    mov    bx, 2
1b56  a804      test   al, 4
1b58  7402      je     loc_1b5c
1b5a  d0e3      shl    bl, 1
  loc_1b5c:
1b5c  8b87301f  mov    ax, word ptr [bx + 0x1f30]
1b60  051000    add    ax, 0x10
1b63  3b066616  cmp    ax, word ptr [0x1666]
1b67  720f      jb     loc_1b78
1b69  2d3000    sub    ax, 0x30
1b6c  7302      jae    loc_1b70
1b6e  2bc0      sub    ax, ax
  loc_1b70:
1b70  3b066616  cmp    ax, word ptr [0x1666]
1b74  7702      ja     loc_1b78
1b76  f9        stc
1b77  c3        ret
  loc_1b78:
1b78  f8        clc
1b79  c3        ret

; ----------------------------------------------------------------------
sub_1b7a:
1b7a  833e040000  cmp    word ptr [4], 0
1b7f  7560      jne    loc_1be1
1b81  8a167316  mov    dl, byte ptr [0x1673]
1b85  80fa00    cmp    dl, 0
1b88  7457      je     loc_1be1
1b8a  8b0edf17  mov    cx, word ptr [0x17df]
1b8e  86cd      xchg   ch, cl
1b90  be1000    mov    si, 0x10
1b93  a17116    mov    ax, word ptr [0x1671]
1b96  8b1e7905  mov    bx, word ptr [0x579]
1b9a  8a367b05  mov    dh, byte ptr [0x57b]
1b9e  bf1800    mov    di, 0x18
1ba1  b50e      mov    ch, 0xe
1ba3  e88312    call   sub_2e29
1ba6  733a      jae    loc_1be2
1ba8  e838f6    call   sub_11e3
1bab  e874fd    call   sub_1922
1bae  e82cf5    call   sub_10dd
1bb1  803e751600  cmp    byte ptr [0x1675], 0
1bb6  7527      jne    loc_1bdf
1bb8  c606751601  mov    byte ptr [0x1675], 1
1bbd  e8a6f5    call   sub_1166
1bc0  b201      mov    dl, 1
1bc2  803e7416ff  cmp    byte ptr [0x1674], 0xff
1bc7  7402      je     loc_1bcb
1bc9  b2ff      mov    dl, 0xff
  loc_1bcb:
1bcb  88167416  mov    byte ptr [0x1674], dl
1bcf  c706ea176000  mov    word ptr [0x17ea], 0x60
1bd5  c606e91701  mov    byte ptr [0x17e9], 1
1bda  c6065c0500  mov    byte ptr [0x55c], 0
  loc_1bdf:
1bdf  f9        stc
1be0  c3        ret
  loc_1be1:
1be1  f8        clc
  loc_1be2:
1be2  c3        ret
1be3  db 00,00,00,00,00,00,00,00,00,00,00,00,00   ; .............

; ----------------------------------------------------------------------
sub_1bf0:
1bf0  2bdb      sub    bx, bx
1bf2  b40b      mov    ah, 0xb
1bf4  cd10      int    0x10
1bf6  833e060007  cmp    word ptr [6], 7
1bfb  7515      jne    loc_1c12
1bfd  803e530500  cmp    byte ptr [0x553], 0
1c02  740e      je     loc_1c12
1c04  e88436    call   sub_528b
1c07  c70679059800  mov    word ptr [0x579], 0x98
1c0d  c6067b055f  mov    byte ptr [0x57b], 0x5f
  loc_1c12:
1c12  b800b8    mov    ax, 0xb800
1c15  8ec0      mov    es, ax
1c17  fc        cld
1c18  c70639180000  mov    word ptr [0x1839], 0
1c1e  e84600    call   sub_1c67
1c21  e8fd3e    call   sub_5b21
1c24  e80a01    call   sub_1d31
1c27  833e040000  cmp    word ptr [4], 0
1c2c  751b      jne    loc_1c49
1c2e  803e530500  cmp    byte ptr [0x553], 0
1c33  7411      je     loc_1c46
1c35  833e060007  cmp    word ptr [6], 7
1c3a  7505      jne    loc_1c41
1c3c  e8d436    call   sub_5313
1c3f  eb08      jmp    loc_1c49
  loc_1c41:
1c41  e86c1c    call   sub_38b0
1c44  eb03      jmp    loc_1c49
  loc_1c46:
1c46  e82d01    call   sub_1d76
  loc_1c49:
1c49  833e040007  cmp    word ptr [4], 7
1c4e  740a      je     loc_1c5a
1c50  b8aaaa    mov    ax, 0xaaaa
1c53  833e040002  cmp    word ptr [4], 2
1c58  7503      jne    loc_1c5d
  loc_1c5a:
1c5a  b85555    mov    ax, 0x5555
  loc_1c5d:
1c5d  a33918    mov    word ptr [0x1839], ax
1c60  e80400    call   sub_1c67
1c63  e8bb3e    call   sub_5b21
1c66  c3        ret

; ----------------------------------------------------------------------
sub_1c67:
1c67  e82c3c    call   sub_5896
1c6a  c70635180100  mov    word ptr [0x1835], 1
1c70  c606371808  mov    byte ptr [0x1837], 8
1c75  8b0e7905  mov    cx, word ptr [0x579]
1c79  8a167b05  mov    dl, byte ptr [0x57b]
1c7d  83c10c    add    cx, 0xc
1c80  81e1f0ff  and    cx, 0xfff0
1c84  80c208    add    dl, 8
1c87  c606381800  mov    byte ptr [0x1838], 0
  loc_1c8c:
1c8c  e8083c    call   sub_5897
1c8f  890e3218  mov    word ptr [0x1832], cx
1c93  88163418  mov    byte ptr [0x1834], dl
1c97  e81610    call   sub_2cb0
1c9a  8bf8      mov    di, ax
1c9c  8a1e3718  mov    bl, byte ptr [0x1837]
  loc_1ca0:
1ca0  a13918    mov    ax, word ptr [0x1839]
1ca3  8b0e3518  mov    cx, word ptr [0x1835]
1ca7  d1e9      shr    cx, 1
1ca9  d1e9      shr    cx, 1
1cab  d1e9      shr    cx, 1
1cad  f3ab      rep stosw word ptr es:[di], ax
1caf  8b0e3518  mov    cx, word ptr [0x1835]
1cb3  d1e9      shr    cx, 1
1cb5  d1e9      shr    cx, 1
1cb7  81e1fe00  and    cx, 0xfe
1cbb  2bf9      sub    di, cx
1cbd  81f70020  xor    di, 0x2000
1cc1  f7c70020  test   di, 0x2000
1cc5  7503      jne    loc_1cca
1cc7  83c750    add    di, 0x50
  loc_1cca:
1cca  fecb      dec    bl
1ccc  75d2      jne    loc_1ca0
1cce  803e38180f  cmp    byte ptr [0x1838], 0xf
1cd3  7501      jne    loc_1cd6
1cd5  c3        ret
  loc_1cd6:
1cd6  8306351820  add    word ptr [0x1835], 0x20
1cdb  8006371810  add    byte ptr [0x1837], 0x10
1ce0  8b0e3218  mov    cx, word ptr [0x1832]
1ce4  8a163418  mov    dl, byte ptr [0x1834]
1ce8  83e910    sub    cx, 0x10
1ceb  7307      jae    loc_1cf4
1ced  2bc9      sub    cx, cx
1cef  800e381801  or     byte ptr [0x1838], 1
  loc_1cf4:
1cf4  a13518    mov    ax, word ptr [0x1835]
1cf7  03c1      add    ax, cx
1cf9  3d4001    cmp    ax, 0x140
1cfc  720d      jb     loc_1d0b
1cfe  b84001    mov    ax, 0x140
1d01  2bc1      sub    ax, cx
1d03  a33518    mov    word ptr [0x1835], ax
1d06  800e381802  or     byte ptr [0x1838], 2
  loc_1d0b:
1d0b  80ea08    sub    dl, 8
1d0e  7307      jae    loc_1d17
1d10  2ad2      sub    dl, dl
1d12  800e381804  or     byte ptr [0x1838], 4
  loc_1d17:
1d17  a03718    mov    al, byte ptr [0x1837]
1d1a  02c2      add    al, dl
1d1c  7204      jb     loc_1d22
1d1e  3cc8      cmp    al, 0xc8
1d20  720c      jb     loc_1d2e
  loc_1d22:
1d22  b0c8      mov    al, 0xc8
1d24  2ac2      sub    al, dl
1d26  a23718    mov    byte ptr [0x1837], al
1d29  800e381808  or     byte ptr [0x1838], 8
  loc_1d2e:
1d2e  e95bff    jmp    loc_1c8c

; ----------------------------------------------------------------------
sub_1d31:
1d31  803e9706fd  cmp    byte ptr [0x697], 0xfd
1d36  7410      je     loc_1d48
1d38  b40b      mov    ah, 0xb
1d3a  b701      mov    bh, 1
1d3c  8b360400  mov    si, word ptr [4]
1d40  8a9c5318  mov    bl, byte ptr [si + 0x1853]
1d44  cd10      int    0x10
1d46  eb1f      jmp    loc_1d67
  loc_1d48:
1d48  8b360400  mov    si, word ptr [4]
1d4c  b301      mov    bl, 1
1d4e  8abc3b18  mov    bh, byte ptr [si + 0x183b]
1d52  e81900    call   sub_1d6e
1d55  b302      mov    bl, 2
1d57  8abc4318  mov    bh, byte ptr [si + 0x1843]
1d5b  e81000    call   sub_1d6e
1d5e  b303      mov    bl, 3
1d60  8abc4b18  mov    bh, byte ptr [si + 0x184b]
1d64  e80700    call   sub_1d6e
  loc_1d67:
1d67  b40b      mov    ah, 0xb
1d69  2bdb      sub    bx, bx
1d6b  cd10      int    0x10
1d6d  c3        ret

; ----------------------------------------------------------------------
sub_1d6e:
1d6e  b80010    mov    ax, 0x1000
1d71  56        push   si
1d72  cd10      int    0x10
1d74  5e        pop    si
1d75  c3        ret

; ----------------------------------------------------------------------
sub_1d76:
1d76  833e060007  cmp    word ptr [6], 7
1d7b  7504      jne    loc_1d81
1d7d  e8c042    call   sub_6040
1d80  c3        ret
  loc_1d81:
1d81  e8513a    call   sub_57d5
1d84  b85b18    mov    ax, 0x185b
1d87  803e520500  cmp    byte ptr [0x552], 0
1d8c  7438      je     loc_1dc6
1d8e  8b1e301c  mov    bx, word ptr [0x1c30]
1d92  8306301c02  add    word ptr [0x1c30], 2
1d97  81e30600  and    bx, 6
1d9b  8b87261c  mov    ax, word ptr [bx + 0x1c26]
1d9f  803e801f00  cmp    byte ptr [0x1f80], 0
1da4  7404      je     loc_1daa
1da6  fe0e801f  dec    byte ptr [0x1f80]
  loc_1daa:
1daa  803e5205dd  cmp    byte ptr [0x552], 0xdd
1daf  7515      jne    loc_1dc6
1db1  833e080000  cmp    word ptr [8], 0
1db6  740e      je     loc_1dc6
1db8  803e801f01  cmp    byte ptr [0x1f80], 1
1dbd  7207      jb     loc_1dc6
1dbf  e81e3e    call   sub_5be0
1dc2  e85c3d    call   sub_5b21
1dc5  c3        ret
  loc_1dc6:
1dc6  a32e1c    mov    word ptr [0x1c2e], ax
1dc9  c7061b1c8080  mov    word ptr [0x1c1b], 0x8080
1dcf  c6061d1c1c  mov    byte ptr [0x1c1d], 0x1c
  loc_1dd4:
1dd4  e84000    call   sub_1e17
1dd7  2ae4      sub    ah, ah
1dd9  cd1a      int    0x1a
1ddb  89163018  mov    word ptr [0x1830], dx
  loc_1ddf:
1ddf  e8023a    call   sub_57e4
1de2  2ae4      sub    ah, ah
1de4  cd1a      int    0x1a
1de6  3b163018  cmp    dx, word ptr [0x1830]
1dea  74f3      je     loc_1ddf
1dec  803e1d1c14  cmp    byte ptr [0x1c1d], 0x14
1df1  770f      ja     loc_1e02
1df3  2aff      sub    bh, bh
1df5  8a1e1d1c  mov    bl, byte ptr [0x1c1d]
1df9  80e306    and    bl, 6
1dfc  8b871e1c  mov    ax, word ptr [bx + 0x1c1e]
1e00  eb08      jmp    loc_1e0a
  loc_1e02:
1e02  a11b1c    mov    ax, word ptr [0x1c1b]
1e05  f9        stc
1e06  d0d8      rcr    al, 1
1e08  8ae0      mov    ah, al
  loc_1e0a:
1e0a  a31b1c    mov    word ptr [0x1c1b], ax
1e0d  fe0e1d1c  dec    byte ptr [0x1c1d]
1e11  75c1      jne    loc_1dd4
1e13  e80b3d    call   sub_5b21
1e16  c3        ret

; ----------------------------------------------------------------------
sub_1e17:
1e17  fc        cld
1e18  1e        push   ds
1e19  07        pop    es
1e1a  8b362e1c  mov    si, word ptr [0x1c2e]
1e1e  bf0e00    mov    di, 0xe
1e21  b96000    mov    cx, 0x60
  loc_1e24:
1e24  ad        lodsw  ax, word ptr [si]
1e25  23061b1c  and    ax, word ptr [0x1c1b]
1e29  ab        stosw  word ptr es:[di], ax
1e2a  e2f8      loop   loc_1e24
1e2c  b800b8    mov    ax, 0xb800
1e2f  8ec0      mov    es, ax
1e31  be0e00    mov    si, 0xe
1e34  bfd00e    mov    di, 0xed0
1e37  b9080c    mov    cx, 0xc08
1e3a  e8600f    call   sub_2d9d
1e3d  c3        ret
1e3e  db 00,00   ; ..

; ----------------------------------------------------------------------
sub_1e40:
1e40  c606bf1c00  mov    byte ptr [0x1cbf], 0
1e45  c706e11c0000  mov    word ptr [0x1ce1], 0
1e4b  c606c01c00  mov    byte ptr [0x1cc0], 0
1e50  c606c11c00  mov    byte ptr [0x1cc1], 0
1e55  c606b81c00  mov    byte ptr [0x1cb8], 0
1e5a  c606c81cb1  mov    byte ptr [0x1cc8], 0xb1
1e5f  e8ee35    call   sub_5450
1e62  c3        ret

; ----------------------------------------------------------------------
sub_1e63:
1e63  2ae4      sub    ah, ah
1e65  cd1a      int    0x1a
1e67  8bca      mov    cx, dx
1e69  2b16c91c  sub    dx, word ptr [0x1cc9]
1e6d  a1e11c    mov    ax, word ptr [0x1ce1]
1e70  250100    and    ax, 1
1e73  050100    add    ax, 1
1e76  3bd0      cmp    dx, ax
1e78  7301      jae    loc_1e7b
  loc_1e7a:
1e7a  c3        ret
  loc_1e7b:
1e7b  e85af5    call   sub_13d8
1e7e  74fa      je     loc_1e7a
1e80  890ec91c  mov    word ptr [0x1cc9], cx
1e84  ff06e11c  inc    word ptr [0x1ce1]
1e88  803ec11c00  cmp    byte ptr [0x1cc1], 0
1e8d  7453      je     loc_1ee2
1e8f  fe0ec11c  dec    byte ptr [0x1cc1]
1e93  7534      jne    loc_1ec9
1e95  e8893c    call   sub_5b21
1e98  803eb81c00  cmp    byte ptr [0x1cb8], 0
1e9d  7423      je     loc_1ec2
1e9f  833e040000  cmp    word ptr [4], 0
1ea4  7411      je     loc_1eb7
1ea6  c6065205dd  mov    byte ptr [0x552], 0xdd
1eab  c7067905a000  mov    word ptr [0x579], 0xa0
1eb1  c6067b0560  mov    byte ptr [0x57b], 0x60
1eb6  c3        ret
  loc_1eb7:
1eb7  803e801f00  cmp    byte ptr [0x1f80], 0
1ebc  7404      je     loc_1ec2
1ebe  fe0e801f  dec    byte ptr [0x1f80]
  loc_1ec2:
1ec2  e81c02    call   sub_20e1
1ec5  e878ff    call   sub_1e40
1ec8  c3        ret
  loc_1ec9:
1ec9  e85601    call   sub_2022
1ecc  b80401    mov    ax, 0x104
1ecf  2a06c11c  sub    al, byte ptr [0x1cc1]
1ed3  803ed01cff  cmp    byte ptr [0x1cd0], 0xff
1ed8  7402      je     loc_1edc
1eda  b4ff      mov    ah, 0xff
  loc_1edc:
1edc  e87a01    call   sub_2059
1edf  e91901    jmp    loc_1ffb
  loc_1ee2:
1ee2  803eb81c00  cmp    byte ptr [0x1cb8], 0
1ee7  7423      je     loc_1f0c
1ee9  8a16b81c  mov    dl, byte ptr [0x1cb8]
1eed  833eb91c00  cmp    word ptr [0x1cb9], 0
1ef2  740e      je     loc_1f02
1ef4  ff0eb91c  dec    word ptr [0x1cb9]
1ef8  e8020f    call   sub_2dfd
1efb  80e201    and    dl, 1
1efe  7502      jne    loc_1f02
1f00  b2ff      mov    dl, 0xff
  loc_1f02:
1f02  8816d01c  mov    byte ptr [0x1cd0], dl
1f06  a1c61c    mov    ax, word ptr [0x1cc6]
1f09  e99f00    jmp    loc_1fab
  loc_1f0c:
1f0c  803ebf1c00  cmp    byte ptr [0x1cbf], 0
1f11  7562      jne    loc_1f75
1f13  803ec01c00  cmp    byte ptr [0x1cc0], 0
1f18  753d      jne    loc_1f57
1f1a  803e581d00  cmp    byte ptr [0x1d58], 0
1f1f  751c      jne    loc_1f3d
1f21  803e7b05b4  cmp    byte ptr [0x57b], 0xb4
1f26  7214      jb     loc_1f3c
1f28  803e580500  cmp    byte ptr [0x558], 0
1f2d  750d      jne    loc_1f3c
1f2f  e8cb0e    call   sub_2dfd
1f32  8b1e0800  mov    bx, word ptr [8]
1f36  3a97d11c  cmp    dl, byte ptr [bx + 0x1cd1]
1f3a  7201      jb     loc_1f3d
  loc_1f3c:
1f3c  c3        ret
  loc_1f3d:
1f3d  b001      mov    al, 1
1f3f  c706ba590000  mov    word ptr [0x59ba], 0
1f45  813e7905a000  cmp    word ptr [0x579], 0xa0
1f4b  7302      jae    loc_1f4f
1f4d  b0ff      mov    al, 0xff
  loc_1f4f:
1f4f  a2d01c    mov    byte ptr [0x1cd0], al
1f52  c606c01c04  mov    byte ptr [0x1cc0], 4
  loc_1f57:
1f57  fe0ec01c  dec    byte ptr [0x1cc0]
1f5b  7508      jne    loc_1f65
1f5d  c606bf1c01  mov    byte ptr [0x1cbf], 1
1f62  eb11      jmp    loc_1f75
1f64  db 90   ; .
  loc_1f65:
1f65  e8ba00    call   sub_2022
1f68  a0c01c    mov    al, byte ptr [0x1cc0]
1f6b  8a26d01c  mov    ah, byte ptr [0x1cd0]
1f6f  e8e700    call   sub_2059
1f72  e98600    jmp    loc_1ffb
  loc_1f75:
1f75  c606581d00  mov    byte ptr [0x1d58], 0
1f7a  a1c61c    mov    ax, word ptr [0x1cc6]
1f7d  803e7b05b4  cmp    byte ptr [0x57b], 0xb4
1f82  7227      jb     loc_1fab
1f84  803e580500  cmp    byte ptr [0x558], 0
1f89  7520      jne    loc_1fab
1f8b  e86f0e    call   sub_2dfd
1f8e  8b1e0800  mov    bx, word ptr [8]
1f92  3a97d91c  cmp    dl, byte ptr [bx + 0x1cd9]
1f96  7713      ja     loc_1fab
1f98  3b067905  cmp    ax, word ptr [0x579]
1f9c  7708      ja     loc_1fa6
1f9e  c606d01c01  mov    byte ptr [0x1cd0], 1
1fa3  eb06      jmp    loc_1fab
1fa5  db 90   ; .
  loc_1fa6:
1fa6  c606d01cff  mov    byte ptr [0x1cd0], 0xff
  loc_1fab:
1fab  803ed01c01  cmp    byte ptr [0x1cd0], 1
1fb0  723d      jb     loc_1fef
1fb2  742e      je     loc_1fe2
1fb4  2d0800    sub    ax, 8
1fb7  7336      jae    loc_1fef
1fb9  2bc0      sub    ax, ax
  loc_1fbb:
1fbb  803eb81c00  cmp    byte ptr [0x1cb8], 0
1fc0  740a      je     loc_1fcc
1fc2  833eb91c00  cmp    word ptr [0x1cb9], 0
1fc7  7526      jne    loc_1fef
1fc9  eb0f      jmp    loc_1fda
1fcb  db 90   ; .
  loc_1fcc:
1fcc  803e7b05b4  cmp    byte ptr [0x57b], 0xb4
1fd1  7207      jb     loc_1fda
1fd3  803e580500  cmp    byte ptr [0x558], 0
1fd8  7415      je     loc_1fef
  loc_1fda:
1fda  c606c11c04  mov    byte ptr [0x1cc1], 4
1fdf  eb0e      jmp    loc_1fef
1fe1  db 90   ; .
  loc_1fe2:
1fe2  050800    add    ax, 8
1fe5  3d1e01    cmp    ax, 0x11e
1fe8  7205      jb     loc_1fef
1fea  b81e01    mov    ax, 0x11e
1fed  ebcc      jmp    loc_1fbb
  loc_1fef:
1fef  a3c61c    mov    word ptr [0x1cc6], ax
1ff2  e82d00    call   sub_2022
1ff5  c706c41c040f  mov    word ptr [0x1cc4], 0xf04
  loc_1ffb:
1ffb  8b0ec61c  mov    cx, word ptr [0x1cc6]
1fff  8a16c81c  mov    dl, byte ptr [0x1cc8]
2003  e8aa0c    call   sub_2cb0
2006  a3cd1c    mov    word ptr [0x1ccd], ax
2009  803ec01c03  cmp    byte ptr [0x1cc0], 3
200e  7403      je     loc_2013
2010  e8ce00    call   sub_20e1
  loc_2013:
2013  e8df00    call   sub_20f5
2016  7209      jb     loc_2021
2018  a1cd1c    mov    ax, word ptr [0x1ccd]
201b  a3bd1c    mov    word ptr [0x1cbd], ax
201e  e87a00    call   sub_209b
  loc_2021:
2021  c3        ret

; ----------------------------------------------------------------------
sub_2022:
2022  2aff      sub    bh, bh
2024  803eb81c00  cmp    byte ptr [0x1cb8], 0
2029  7410      je     loc_203b
202b  fe06cf1c  inc    byte ptr [0x1ccf]
202f  8a1ecf1c  mov    bl, byte ptr [0x1ccf]
2033  80e306    and    bl, 6
2036  80cb08    or     bl, 8
2039  7516      jne    loc_2051
  loc_203b:
203b  8006cf1c02  add    byte ptr [0x1ccf], 2
2040  8a1ecf1c  mov    bl, byte ptr [0x1ccf]
2044  80e302    and    bl, 2
2047  803ed01c01  cmp    byte ptr [0x1cd0], 1
204c  7503      jne    loc_2051
204e  80cb04    or     bl, 4
  loc_2051:
2051  8b87c815  mov    ax, word ptr [bx + 0x15c8]
2055  a3bb1c    mov    word ptr [0x1cbb], ax
2058  c3        ret

; ----------------------------------------------------------------------
sub_2059:
2059  b9040f    mov    cx, 0xf04
205c  2ac8      sub    cl, al
205e  890ec41c  mov    word ptr [0x1cc4], cx
2062  80fcff    cmp    ah, 0xff
2065  7411      je     loc_2078
2067  2ae4      sub    ah, ah
2069  d0e0      shl    al, 1
206b  0106bb1c  add    word ptr [0x1cbb], ax
206f  c706c61c0000  mov    word ptr [0x1cc6], 0
2075  eb0f      jmp    loc_2086
2077  db 90   ; .
  loc_2078:
2078  2ae4      sub    ah, ah
207a  d0e0      shl    al, 1
207c  d0e0      shl    al, 1
207e  d0e0      shl    al, 1
2080  052001    add    ax, 0x120
2083  a3c61c    mov    word ptr [0x1cc6], ax
  loc_2086:
2086  1e        push   ds
2087  07        pop    es
2088  8b36bb1c  mov    si, word ptr [0x1cbb]
208c  bf0e00    mov    di, 0xe
208f  b004      mov    al, 4
2091  e8dc0c    call   sub_2d70
2094  c706bb1c0e00  mov    word ptr [0x1cbb], 0xe
209a  c3        ret

; ----------------------------------------------------------------------
sub_209b:
209b  8b0ec41c  mov    cx, word ptr [0x1cc4]
209f  890ec21c  mov    word ptr [0x1cc2], cx
20a3  b800b8    mov    ax, 0xb800
20a6  803eb81c00  cmp    byte ptr [0x1cb8], 0
20ab  7511      jne    loc_20be
20ad  8ec0      mov    es, ax
20af  8b3ebd1c  mov    di, word ptr [0x1cbd]
20b3  8b36bb1c  mov    si, word ptr [0x1cbb]
20b7  bd401c    mov    bp, 0x1c40
20ba  e80f0c    call   sub_2ccc
20bd  c3        ret
  loc_20be:
20be  1e        push   ds
20bf  8ed8      mov    ds, ax
20c1  07        pop    es
20c2  06        push   es
20c3  1e        push   ds
20c4  268b36bd1c  mov    si, word ptr es:[0x1cbd]
20c9  bf401c    mov    di, 0x1c40
20cc  e8fb0c    call   sub_2dca
20cf  07        pop    es
20d0  1f        pop    ds
20d1  8b36bb1c  mov    si, word ptr [0x1cbb]
20d5  8b3ebd1c  mov    di, word ptr [0x1cbd]
20d9  8b0ec41c  mov    cx, word ptr [0x1cc4]
20dd  e8bd0c    call   sub_2d9d
20e0  c3        ret

; ----------------------------------------------------------------------
sub_20e1:
20e1  b800b8    mov    ax, 0xb800
20e4  8ec0      mov    es, ax
20e6  8b3ebd1c  mov    di, word ptr [0x1cbd]
20ea  be401c    mov    si, 0x1c40
20ed  8b0ec21c  mov    cx, word ptr [0x1cc2]
20f1  e8a90c    call   sub_2d9d
20f4  c3        ret

; ----------------------------------------------------------------------
sub_20f5:
20f5  803eb81c00  cmp    byte ptr [0x1cb8], 0
20fa  7538      jne    loc_2134
20fc  a0bf1c    mov    al, byte ptr [0x1cbf]
20ff  0a06c01c  or     al, byte ptr [0x1cc0]
2103  0a06c11c  or     al, byte ptr [0x1cc1]
2107  742b      je     loc_2134
2109  803e7b05a3  cmp    byte ptr [0x57b], 0xa3
210e  7224      jb     loc_2134
2110  803e580500  cmp    byte ptr [0x558], 0
2115  751d      jne    loc_2134
2117  a1c61c    mov    ax, word ptr [0x1cc6]
211a  052000    add    ax, 0x20
211d  3b067905  cmp    ax, word ptr [0x579]
2121  7211      jb     loc_2134
2123  2d3800    sub    ax, 0x38
2126  7302      jae    loc_212a
2128  2bc0      sub    ax, ax
  loc_212a:
212a  3b067905  cmp    ax, word ptr [0x579]
212e  7704      ja     loc_2134
2130  e80300    call   sub_2136
2133  c3        ret
  loc_2134:
2134  f8        clc
2135  c3        ret

; ----------------------------------------------------------------------
sub_2136:
2136  833e040006  cmp    word ptr [4], 6
213b  750c      jne    loc_2149
213d  a07b05    mov    al, byte ptr [0x57b]
2140  a2c81c    mov    byte ptr [0x1cc8], al
2143  a17905    mov    ax, word ptr [0x579]
2146  a3c61c    mov    word ptr [0x1cc6], ax
  loc_2149:
2149  a1c61c    mov    ax, word ptr [0x1cc6]
214c  03067905  add    ax, word ptr [0x579]
2150  d1e8      shr    ax, 1
2152  3d1801    cmp    ax, 0x118
2155  7203      jb     loc_215a
2157  b81701    mov    ax, 0x117
  loc_215a:
215a  a3c61c    mov    word ptr [0x1cc6], ax
215d  b301      mov    bl, 1
215f  3da000    cmp    ax, 0xa0
2162  770a      ja     loc_216e
2164  b3ff      mov    bl, 0xff
2166  baa100    mov    dx, 0xa1
2169  2bd0      sub    dx, ax
216b  eb06      jmp    loc_2173
216d  db 90   ; .
  loc_216e:
216e  2d9f00    sub    ax, 0x9f
2171  8bd0      mov    dx, ax
  loc_2173:
2173  881eb81c  mov    byte ptr [0x1cb8], bl
2177  c606bf1c01  mov    byte ptr [0x1cbf], 1
217c  c606c11c00  mov    byte ptr [0x1cc1], 0
2181  b103      mov    cl, 3
2183  d3ea      shr    dx, cl
2185  8916b91c  mov    word ptr [0x1cb9], dx
2189  833e040006  cmp    word ptr [4], 6
218e  752d      jne    loc_21bd
2190  e850f0    call   sub_11e3
2193  a0b81c    mov    al, byte ptr [0x1cb8]
2196  50        push   ax
2197  c606b81c00  mov    byte ptr [0x1cb8], 0
219c  c706c41c040f  mov    word ptr [0x1cc4], 0xf04
21a2  a1c815    mov    ax, word ptr [0x15c8]
21a5  a3bb1c    mov    word ptr [0x1cbb], ax
21a8  8b0ec61c  mov    cx, word ptr [0x1cc6]
21ac  8a16c81c  mov    dl, byte ptr [0x1cc8]
21b0  e8fd0a    call   sub_2cb0
21b3  a3bd1c    mov    word ptr [0x1cbd], ax
21b6  e8e2fe    call   sub_209b
21b9  58        pop    ax
21ba  a2b81c    mov    byte ptr [0x1cb8], al
  loc_21bd:
21bd  e821ff    call   sub_20e1
21c0  e820f0    call   sub_11e3
21c3  b80000    mov    ax, 0
21c6  813e7905a000  cmp    word ptr [0x579], 0xa0
21cc  7303      jae    loc_21d1
21ce  b82201    mov    ax, 0x122
  loc_21d1:
21d1  a37905    mov    word ptr [0x579], ax
21d4  833e040000  cmp    word ptr [4], 0
21d9  7503      jne    loc_21de
21db  e82fe5    call   sub_070d
  loc_21de:
21de  f9        stc
21df  c3        ret

; ----------------------------------------------------------------------
sub_21e0:
21e0  a0bf1c    mov    al, byte ptr [0x1cbf]
21e3  0a06c01c  or     al, byte ptr [0x1cc0]
21e7  0a06c11c  or     al, byte ptr [0x1cc1]
21eb  741c      je     loc_2209
21ed  a17d32    mov    ax, word ptr [0x327d]
21f0  8a167f32  mov    dl, byte ptr [0x327f]
21f4  be1000    mov    si, 0x10
21f7  8b1ec61c  mov    bx, word ptr [0x1cc6]
21fb  8a36c81c  mov    dh, byte ptr [0x1cc8]
21ff  bf2000    mov    di, 0x20
2202  b91e0f    mov    cx, 0xf1e
2205  e8210c    call   sub_2e29
2208  c3        ret
  loc_2209:
2209  f8        clc
220a  c3        ret
220b  db 00,00,00,00,00   ; .....

; ----------------------------------------------------------------------
sub_2210:
2210  c606591d00  mov    byte ptr [0x1d59], 0
2215  c3        ret

; ----------------------------------------------------------------------
sub_2216:
2216  2ae4      sub    ah, ah
2218  cd1a      int    0x1a
221a  3b165a1d  cmp    dx, word ptr [0x1d5a]
221e  7501      jne    loc_2221
  loc_2220:
2220  c3        ret
  loc_2221:
2221  8bca      mov    cx, dx
2223  e8b2f1    call   sub_13d8
2226  74f8      je     loc_2220
2228  890e5a1d  mov    word ptr [0x1d5a], cx
222c  e8c800    call   sub_22f7
222f  72ef      jb     loc_2220
2231  803e591d00  cmp    byte ptr [0x1d59], 0
2236  7535      jne    loc_226d
2238  803e7b0586  cmp    byte ptr [0x57b], 0x86
223d  740f      je     loc_224e
223f  803e7b058e  cmp    byte ptr [0x57b], 0x8e
2244  7408      je     loc_224e
2246  e8b40b    call   sub_2dfd
2249  80fa05    cmp    dl, 5
224c  77d2      ja     loc_2220
  loc_224e:
224e  e87ff3    call   sub_15d0
2251  80c203    add    dl, 3
2254  88165e1d  mov    byte ptr [0x1d5e], dl
2258  e8a20b    call   sub_2dfd
225b  81e20700  and    dx, 7
225f  03ca      add    cx, dx
2261  83c106    add    cx, 6
2264  890e5c1d  mov    word ptr [0x1d5c], cx
2268  c606591d1b  mov    byte ptr [0x1d59], 0x1b
  loc_226d:
226d  fe0e591d  dec    byte ptr [0x1d59]
2271  8b0e5c1d  mov    cx, word ptr [0x1d5c]
2275  8a165e1d  mov    dl, byte ptr [0x1d5e]
2279  803e591d0d  cmp    byte ptr [0x1d59], 0xd
227e  7611      jbe    loc_2291
2280  0216591d  add    dl, byte ptr [0x1d59]
2284  80ea0f    sub    dl, 0xf
2287  bb021b    mov    bx, 0x1b02
228a  2a3e591d  sub    bh, byte ptr [0x1d59]
228e  eb0f      jmp    loc_229f
2290  db 90   ; .
  loc_2291:
2291  80c20c    add    dl, 0xc
2294  2a16591d  sub    dl, byte ptr [0x1d59]
2298  bb0200    mov    bx, 2
229b  023e591d  add    bh, byte ptr [0x1d59]
  loc_229f:
229f  891e641d  mov    word ptr [0x1d64], bx
22a3  88165f1d  mov    byte ptr [0x1d5f], dl
22a7  e8060a    call   sub_2cb0
22aa  a3621d    mov    word ptr [0x1d62], ax
22ad  e82c00    call   sub_22dc
22b0  e84400    call   sub_22f7
22b3  7207      jb     loc_22bc
22b5  803e591d00  cmp    byte ptr [0x1d59], 0
22ba  7501      jne    loc_22bd
  loc_22bc:
22bc  c3        ret
  loc_22bd:
22bd  b800b8    mov    ax, 0xb800
22c0  8ec0      mov    es, ax
22c2  8b3e621d  mov    di, word ptr [0x1d62]
22c6  bef01c    mov    si, 0x1cf0
22c9  893e601d  mov    word ptr [0x1d60], di
22cd  8b0e641d  mov    cx, word ptr [0x1d64]
22d1  890e661d  mov    word ptr [0x1d66], cx
22d5  bd241d    mov    bp, 0x1d24
22d8  e8f109    call   sub_2ccc
22db  c3        ret

; ----------------------------------------------------------------------
sub_22dc:
22dc  803e591d1a  cmp    byte ptr [0x1d59], 0x1a
22e1  7413      je     loc_22f6
22e3  b800b8    mov    ax, 0xb800
22e6  8ec0      mov    es, ax
22e8  8b3e601d  mov    di, word ptr [0x1d60]
22ec  be241d    mov    si, 0x1d24
22ef  8b0e661d  mov    cx, word ptr [0x1d66]
22f3  e8a70a    call   sub_2d9d
  loc_22f6:
22f6  c3        ret

; ----------------------------------------------------------------------
sub_22f7:
22f7  803e591d00  cmp    byte ptr [0x1d59], 0
22fc  7502      jne    loc_2300
22fe  f8        clc
22ff  c3        ret
  loc_2300:
2300  8b0e641d  mov    cx, word ptr [0x1d64]
2304  86e9      xchg   cl, ch
2306  a15c1d    mov    ax, word ptr [0x1d5c]
2309  8a165f1d  mov    dl, byte ptr [0x1d5f]
230d  be1000    mov    si, 0x10
2310  8b1e7905  mov    bx, word ptr [0x579]
2314  8a367b05  mov    dh, byte ptr [0x57b]
2318  bf1800    mov    di, 0x18
231b  b50e      mov    ch, 0xe
231d  e8090b    call   sub_2e29
2320  7305      jae    loc_2327
2322  c606581d01  mov    byte ptr [0x1d58], 1
  loc_2327:
2327  c3        ret
2328  db 00,00,00,00,00,00,00,00   ; ........

; ----------------------------------------------------------------------
sub_2330:
2330  c7066c1f0000  mov    word ptr [0x1f6c], 0
2336  2bc0      sub    ax, ax
2338  b201      mov    dl, 1
233a  813e7905a000  cmp    word ptr [0x579], 0xa0
2340  7705      ja     loc_2347
2342  b82c01    mov    ax, 0x12c
2345  b2ff      mov    dl, 0xff
  loc_2347:
2347  a3301f    mov    word ptr [0x1f30], ax
234a  a3321f    mov    word ptr [0x1f32], ax
234d  a3341f    mov    word ptr [0x1f34], ax
2350  88163c1f  mov    byte ptr [0x1f3c], dl
2354  88163d1f  mov    byte ptr [0x1f3d], dl
2358  88163e1f  mov    byte ptr [0x1f3e], dl
235c  c606481f01  mov    byte ptr [0x1f48], 1
2361  c606491f01  mov    byte ptr [0x1f49], 1
2366  c6064a1f01  mov    byte ptr [0x1f4a], 1
236b  c606501f00  mov    byte ptr [0x1f50], 0
2370  c606511f00  mov    byte ptr [0x1f51], 0
2375  c606521f00  mov    byte ptr [0x1f52], 0
237a  c3        ret

; ----------------------------------------------------------------------
sub_237b:
237b  2ae4      sub    ah, ah
237d  cd1a      int    0x1a
237f  3b16651f  cmp    dx, word ptr [0x1f65]
2383  7501      jne    loc_2386
  loc_2385:
2385  c3        ret
  loc_2386:
2386  8916651f  mov    word ptr [0x1f65], dx
238a  803e5a0500  cmp    byte ptr [0x55a], 0
238f  75f4      jne    loc_2385
2391  8b1e6c1f  mov    bx, word ptr [0x1f6c]
2395  43        inc    bx
2396  83fb03    cmp    bx, 3
2399  7203      jb     loc_239e
239b  bb0000    mov    bx, 0
  loc_239e:
239e  891e6c1f  mov    word ptr [0x1f6c], bx
23a2  e8b902    call   sub_265e
23a5  72de      jb     loc_2385
23a7  e8bd01    call   sub_2567
23aa  72d9      jb     loc_2385
23ac  8b1e6c1f  mov    bx, word ptr [0x1f6c]
23b0  80bf501f00  cmp    byte ptr [bx + 0x1f50], 0
23b5  7434      je     loc_23eb
23b7  2ae4      sub    ah, ah
23b9  cd1a      int    0x1a
23bb  8b1e6c1f  mov    bx, word ptr [0x1f6c]
23bf  d0e3      shl    bl, 1
23c1  2b97531f  sub    dx, word ptr [bx + 0x1f53]
23c5  83fa36    cmp    dx, 0x36
23c8  72bb      jb     loc_2385
23ca  b201      mov    dl, 1
23cc  b80000    mov    ax, 0
23cf  813e7905a000  cmp    word ptr [0x579], 0xa0
23d5  7705      ja     loc_23dc
23d7  b82c01    mov    ax, 0x12c
23da  b2ff      mov    dl, 0xff
  loc_23dc:
23dc  8987301f  mov    word ptr [bx + 0x1f30], ax
23e0  d0eb      shr    bl, 1
23e2  c687501f00  mov    byte ptr [bx + 0x1f50], 0
23e7  88973c1f  mov    byte ptr [bx + 0x1f3c], dl
  loc_23eb:
23eb  8a973c1f  mov    dl, byte ptr [bx + 0x1f3c]
23ef  88973f1f  mov    byte ptr [bx + 0x1f3f], dl
23f3  803e641600  cmp    byte ptr [0x1664], 0
23f8  7409      je     loc_2403
23fa  c706691f0c00  mov    word ptr [0x1f69], 0xc
2400  eb16      jmp    loc_2418
2402  db 90   ; .
  loc_2403:
2403  b80800    mov    ax, 8
2406  803e7b0560  cmp    byte ptr [0x57b], 0x60
240b  7602      jbe    loc_240f
240d  d0e8      shr    al, 1
  loc_240f:
240f  a3691f    mov    word ptr [0x1f69], ax
2412  3b1e2f05  cmp    bx, word ptr [0x52f]
2416  750d      jne    loc_2425
  loc_2418:
2418  80bf3c1f00  cmp    byte ptr [bx + 0x1f3c], 0
241d  7506      jne    loc_2425
241f  e8db09    call   sub_2dfd
2422  eb66      jmp    loc_248a
2424  db 90   ; .
  loc_2425:
2425  803e5c0500  cmp    byte ptr [0x55c], 0
242a  743a      je     loc_2466
242c  8a87361f  mov    al, byte ptr [bx + 0x1f36]
2430  3a067b05  cmp    al, byte ptr [0x57b]
2434  7730      ja     loc_2466
2436  0410      add    al, 0x10
2438  3a067b05  cmp    al, byte ptr [0x57b]
243c  7228      jb     loc_2466
243e  e8bc09    call   sub_2dfd
2441  8b360800  mov    si, word ptr [8]
2445  3a946e1f  cmp    dl, byte ptr [si + 0x1f6e]
2449  771b      ja     loc_2466
244b  c706691f0c00  mov    word ptr [0x1f69], 0xc
2451  b001      mov    al, 1
2453  d0e3      shl    bl, 1
2455  8b8f301f  mov    cx, word ptr [bx + 0x1f30]
2459  d0eb      shr    bl, 1
245b  3b0e7905  cmp    cx, word ptr [0x579]
245f  7202      jb     loc_2463
2461  b0ff      mov    al, 0xff
  loc_2463:
2463  eb2d      jmp    loc_2492
2465  db 90   ; .
  loc_2466:
2466  b118      mov    cl, 0x18
2468  803e7b0560  cmp    byte ptr [0x57b], 0x60
246d  760b      jbe    loc_247a
246f  b128      mov    cl, 0x28
2471  80bf3c1f00  cmp    byte ptr [bx + 0x1f3c], 0
2476  7502      jne    loc_247a
2478  b110      mov    cl, 0x10
  loc_247a:
247a  e88009    call   sub_2dfd
247d  3ad1      cmp    dl, cl
247f  7715      ja     loc_2496
2481  b000      mov    al, 0
2483  80bf3c1f00  cmp    byte ptr [bx + 0x1f3c], 0
2488  7508      jne    loc_2492
  loc_248a:
248a  8ac2      mov    al, dl
248c  2401      and    al, 1
248e  7502      jne    loc_2492
2490  b0ff      mov    al, 0xff
  loc_2492:
2492  88873c1f  mov    byte ptr [bx + 0x1f3c], al
  loc_2496:
2496  8a973c1f  mov    dl, byte ptr [bx + 0x1f3c]
249a  d0e3      shl    bl, 1
249c  8b87301f  mov    ax, word ptr [bx + 0x1f30]
24a0  80fa01    cmp    dl, 1
24a3  721d      jb     loc_24c2
24a5  7511      jne    loc_24b8
24a7  0306691f  add    ax, word ptr [0x1f69]
24ab  3d2f01    cmp    ax, 0x12f
24ae  7212      jb     loc_24c2
24b0  b82e01    mov    ax, 0x12e
24b3  b2ff      mov    dl, 0xff
24b5  eb0b      jmp    loc_24c2
24b7  db 90   ; .
  loc_24b8:
24b8  2b06691f  sub    ax, word ptr [0x1f69]
24bc  7304      jae    loc_24c2
24be  2bc0      sub    ax, ax
24c0  b201      mov    dl, 1
  loc_24c2:
24c2  8987301f  mov    word ptr [bx + 0x1f30], ax
24c6  d0eb      shr    bl, 1
24c8  88973c1f  mov    byte ptr [bx + 0x1f3c], dl
24cc  8a97361f  mov    dl, byte ptr [bx + 0x1f36]
24d0  8bc8      mov    cx, ax
24d2  e8db07    call   sub_2cb0
24d5  a34b1f    mov    word ptr [0x1f4b], ax
24d8  8b1e6c1f  mov    bx, word ptr [0x1f6c]
24dc  80bf481f00  cmp    byte ptr [bx + 0x1f48], 0
24e1  750d      jne    loc_24f0
24e3  8a873c1f  mov    al, byte ptr [bx + 0x1f3c]
24e7  0a873f1f  or     al, byte ptr [bx + 0x1f3f]
24eb  7403      je     loc_24f0
24ed  e85d00    call   sub_254d
  loc_24f0:
24f0  e86b01    call   sub_265e
24f3  7205      jb     loc_24fa
24f5  e86f00    call   sub_2567
24f8  7301      jae    loc_24fb
  loc_24fa:
24fa  c3        ret
  loc_24fb:
24fb  8b1e6c1f  mov    bx, word ptr [0x1f6c]
24ff  c687481f00  mov    byte ptr [bx + 0x1f48], 0
2504  80bf3c1f00  cmp    byte ptr [bx + 0x1f3c], 0
2509  750d      jne    loc_2518
250b  80bf3f1f00  cmp    byte ptr [bx + 0x1f3f], 0
2510  743a      je     loc_254c
2512  be301e    mov    si, 0x1e30
2515  eb1c      jmp    loc_2533
2517  db 90   ; .
  loc_2518:
2518  be501e    mov    si, 0x1e50
251b  fe874d1f  inc    byte ptr [bx + 0x1f4d]
251f  f6874d1f01  test   byte ptr [bx + 0x1f4d], 1
2524  7503      jne    loc_2529
2526  83c620    add    si, 0x20
  loc_2529:
2529  80bf3c1f01  cmp    byte ptr [bx + 0x1f3c], 1
252e  7403      je     loc_2533
2530  83c640    add    si, 0x40
  loc_2533:
2533  d0e3      shl    bl, 1
2535  8b3e4b1f  mov    di, word ptr [0x1f4b]
2539  89bf421f  mov    word ptr [bx + 0x1f42], di
253d  b800b8    mov    ax, 0xb800
2540  8ec0      mov    es, ax
2542  8baf591f  mov    bp, word ptr [bx + 0x1f59]
2546  b90208    mov    cx, 0x802
2549  e8e907    call   sub_2d35
  loc_254c:
254c  c3        ret

; ----------------------------------------------------------------------
sub_254d:
254d  8b1e6c1f  mov    bx, word ptr [0x1f6c]
2551  d0e3      shl    bl, 1
2553  b800b8    mov    ax, 0xb800
2556  8ec0      mov    es, ax
2558  8bbf421f  mov    di, word ptr [bx + 0x1f42]
255c  8bb7591f  mov    si, word ptr [bx + 0x1f59]
2560  b90208    mov    cx, 0x802
2563  e83708    call   sub_2d9d
2566  c3        ret

; ----------------------------------------------------------------------
sub_2567:
2567  8b1e6c1f  mov    bx, word ptr [0x1f6c]
256b  8a97361f  mov    dl, byte ptr [bx + 0x1f36]
256f  d0e3      shl    bl, 1
2571  8b87301f  mov    ax, word ptr [bx + 0x1f30]
2575  be1000    mov    si, 0x10
2578  8b1e7905  mov    bx, word ptr [0x579]
257c  8a367b05  mov    dh, byte ptr [0x57b]
2580  bf1800    mov    di, 0x18
2583  b9080e    mov    cx, 0xe08
2586  e8a008    call   sub_2e29
2589  7203      jb     loc_258e
258b  e9cf00    jmp    loc_265d
  loc_258e:
258e  8b1e6c1f  mov    bx, word ptr [0x1f6c]
2592  80bf501f00  cmp    byte ptr [bx + 0x1f50], 0
2597  7573      jne    loc_260c
2599  803e7c0526  cmp    byte ptr [0x57c], 0x26
259e  726c      jb     loc_260c
25a0  803e5c0500  cmp    byte ptr [0x55c], 0
25a5  7467      je     loc_260e
25a7  c6065c0500  mov    byte ptr [0x55c], 0
25ac  c6065b0511  mov    byte ptr [0x55b], 0x11
25b1  c606710501  mov    byte ptr [0x571], 1
25b6  c6066e0500  mov    byte ptr [0x56e], 0
25bb  8b1e6c1f  mov    bx, word ptr [0x1f6c]
25bf  d0e3      shl    bl, 1
25c1  8bbf421f  mov    di, word ptr [bx + 0x1f42]
25c5  83bf301f10  cmp    word ptr [bx + 0x1f30], 0x10
25ca  7203      jb     loc_25cf
25cc  83ef04    sub    di, 4
  loc_25cf:
25cf  893e671f  mov    word ptr [0x1f67], di
25d3  b800b8    mov    ax, 0xb800
25d6  8ec0      mov    es, ax
25d8  be701d    mov    si, 0x1d70
25db  bd0e00    mov    bp, 0xe
25de  b90608    mov    cx, 0x806
25e1  e8e806    call   sub_2ccc
25e4  2ae4      sub    ah, ah
25e6  cd1a      int    0x1a
25e8  8916651f  mov    word ptr [0x1f65], dx
  loc_25ec:
25ec  e8a134    call   sub_5a90
25ef  2ae4      sub    ah, ah
25f1  cd1a      int    0x1a
25f3  2b16651f  sub    dx, word ptr [0x1f65]
25f7  83fa08    cmp    dx, 8
25fa  72f0      jb     loc_25ec
25fc  e82235    call   sub_5b21
25ff  8b3e671f  mov    di, word ptr [0x1f67]
2603  be0e00    mov    si, 0xe
2606  b90608    mov    cx, 0x806
2609  e89107    call   sub_2d9d
  loc_260c:
260c  f9        stc
260d  c3        ret
  loc_260e:
260e  2ae4      sub    ah, ah
2610  cd1a      int    0x1a
2612  8b1e6c1f  mov    bx, word ptr [0x1f6c]
2616  c687501f01  mov    byte ptr [bx + 0x1f50], 1
261b  c6873c1f01  mov    byte ptr [bx + 0x1f3c], 1
2620  d0e3      shl    bl, 1
2622  8997531f  mov    word ptr [bx + 0x1f53], dx
2626  e8baeb    call   sub_11e3
2629  8b1e6c1f  mov    bx, word ptr [0x1f6c]
262d  d0e3      shl    bl, 1
262f  8bb75f1f  mov    si, word ptr [bx + 0x1f5f]
2633  8bbf421f  mov    di, word ptr [bx + 0x1f42]
2637  b800b8    mov    ax, 0xb800
263a  8ec0      mov    es, ax
263c  bd0e00    mov    bp, 0xe
263f  b90208    mov    cx, 0x802
2642  e88706    call   sub_2ccc
2645  e8dcea    call   sub_1124
2648  8b1e6c1f  mov    bx, word ptr [0x1f6c]
264c  8a87391f  mov    al, byte ptr [bx + 0x1f39]
2650  e8b300    call   sub_2706
2653  b8e803    mov    ax, 0x3e8
2656  bbee02    mov    bx, 0x2ee
2659  e8df32    call   sub_593b
265c  f9        stc
  loc_265d:
265d  c3        ret

; ----------------------------------------------------------------------
sub_265e:
265e  803e731600  cmp    byte ptr [0x1673], 0
2663  7502      jne    loc_2667
2665  f8        clc
2666  c3        ret
  loc_2667:
2667  8b1e6c1f  mov    bx, word ptr [0x1f6c]
266b  8a97361f  mov    dl, byte ptr [bx + 0x1f36]
266f  d0e3      shl    bl, 1
2671  8b87301f  mov    ax, word ptr [bx + 0x1f30]
2675  be1000    mov    si, 0x10
2678  8bfe      mov    di, si
267a  8b1e7116  mov    bx, word ptr [0x1671]
267e  8a367316  mov    dh, byte ptr [0x1673]
2682  b9080c    mov    cx, 0xc08
2685  e8a107    call   sub_2e29
2688  c3        ret
2689  db 00,00,00,00,00,00,00   ; .......

; ----------------------------------------------------------------------
sub_2690:
2690  1e        push   ds
2691  07        pop    es
2692  b90700    mov    cx, 7
2695  be821f    mov    si, 0x1f82
  loc_2698:
2698  ac        lodsb  al, byte ptr [si]
2699  bb0700    mov    bx, 7
269c  2bd9      sub    bx, cx
269e  3a87891f  cmp    al, byte ptr [bx + 0x1f89]
26a2  e1f4      loope  loc_2698
26a4  7701      ja     loc_26a7
26a6  c3        ret
  loc_26a7:
26a7  be821f    mov    si, 0x1f82
26aa  bf891f    mov    di, 0x1f89
26ad  b90700    mov    cx, 7
26b0  f3a4      rep movsb byte ptr es:[di], byte ptr [si]
26b2  c3        ret

; ----------------------------------------------------------------------
sub_26b3:
26b3  a0801f    mov    al, byte ptr [0x1f80]
26b6  3a06811f  cmp    al, byte ptr [0x1f81]
26ba  7501      jne    loc_26bd
26bc  c3        ret
  loc_26bd:
26bd  a2811f    mov    byte ptr [0x1f81], al
26c0  2ae4      sub    ah, ah
26c2  b104      mov    cl, 4
26c4  d3e0      shl    ax, cl
26c6  052027    add    ax, 0x2720
26c9  8bf0      mov    si, ax
26cb  b800b8    mov    ax, 0xb800
26ce  8ec0      mov    es, ax
26d0  bf6012    mov    di, 0x1260
26d3  b90108    mov    cx, 0x801
26d6  e8c406    call   sub_2d9d
26d9  c3        ret

; ----------------------------------------------------------------------
sub_26da:
26da  bf821f    mov    di, 0x1f82
26dd  e80800    call   sub_26e8
26e0  c3        ret

; ----------------------------------------------------------------------
sub_26e1:
26e1  bf891f    mov    di, 0x1f89
26e4  e80100    call   sub_26e8
26e7  c3        ret

; ----------------------------------------------------------------------
sub_26e8:
26e8  1e        push   ds
26e9  07        pop    es
26ea  b90700    mov    cx, 7
26ed  2ac0      sub    al, al
26ef  f3aa      rep stosb byte ptr es:[di], al
26f1  c3        ret

; ----------------------------------------------------------------------
sub_26f2:
26f2  bb891f    mov    bx, 0x1f89
26f5  bfca12    mov    di, 0x12ca
26f8  e83e00    call   sub_2739
26fb  c3        ret

; ----------------------------------------------------------------------
sub_26fc:
26fc  bb821f    mov    bx, 0x1f82
26ff  bf3c14    mov    di, 0x143c
2702  e83400    call   sub_2739
2705  c3        ret

; ----------------------------------------------------------------------
sub_2706:
2706  b90600    mov    cx, 6
  loc_2709:
2709  8bd9      mov    bx, cx
270b  b400      mov    ah, 0
270d  0287811f  add    al, byte ptr [bx + 0x1f81]
2711  37        aaa
2712  8887811f  mov    byte ptr [bx + 0x1f81], al
2716  8ac4      mov    al, ah
2718  e2ef      loop   loc_2709
271a  e8dfff    call   sub_26fc
271d  c3        ret

; ----------------------------------------------------------------------
sub_271e:
271e  51        push   cx
271f  50        push   ax
2720  53        push   bx
2721  f8        clc
2722  9c        pushf
2723  b90700    mov    cx, 7
  loc_2726:
2726  9d        popf
2727  8bd9      mov    bx, cx
2729  4b        dec    bx
272a  8a01      mov    al, byte ptr [bx + di]
272c  1200      adc    al, byte ptr [bx + si]
272e  37        aaa
272f  8801      mov    byte ptr [bx + di], al
2731  9c        pushf
2732  e2f2      loop   loc_2726
2734  9d        popf
2735  5b        pop    bx
2736  58        pop    ax
2737  59        pop    cx
2738  c3        ret

; ----------------------------------------------------------------------
sub_2739:
2739  b800b8    mov    ax, 0xb800
273c  8ec0      mov    es, ax
273e  893e901f  mov    word ptr [0x1f90], di
2742  891e931f  mov    word ptr [0x1f93], bx
2746  c606921f00  mov    byte ptr [0x1f92], 0
  loc_274b:
274b  8b1e931f  mov    bx, word ptr [0x1f93]
274f  8a07      mov    al, byte ptr [bx]
2751  2ae4      sub    ah, ah
2753  b104      mov    cl, 4
2755  d3e0      shl    ax, cl
2757  052027    add    ax, 0x2720
275a  8bf0      mov    si, ax
275c  8b3e901f  mov    di, word ptr [0x1f90]
2760  b90108    mov    cx, 0x801
2763  e83706    call   sub_2d9d
2766  8306901f02  add    word ptr [0x1f90], 2
276b  ff06931f  inc    word ptr [0x1f93]
276f  fe06921f  inc    byte ptr [0x1f92]
2773  803e921f07  cmp    byte ptr [0x1f92], 7
2778  740e      je     loc_2788
277a  803e921f03  cmp    byte ptr [0x1f92], 3
277f  75ca      jne    loc_274b
2781  8306901f02  add    word ptr [0x1f90], 2
2786  ebc3      jmp    loc_274b
  loc_2788:
2788  c3        ret
2789  db 00,00,00,00,00,00,00   ; .......

; ----------------------------------------------------------------------
sub_2790:
2790  b800b8    mov    ax, 0xb800
2793  8ec0      mov    es, ax
2795  833e040002  cmp    word ptr [4], 2
279a  7552      jne    loc_27ee
279c  fc        cld
279d  2bff      sub    di, di
279f  b8aaaa    mov    ax, 0xaaaa
27a2  b95000    mov    cx, 0x50
27a5  f3ab      rep stosw word ptr es:[di], ax
27a7  bf0020    mov    di, 0x2000
27aa  b95000    mov    cx, 0x50
27ad  f3ab      rep stosw word ptr es:[di], ax
27af  c70654260000  mov    word ptr [0x2654], 0
  loc_27b5:
27b5  e84506    call   sub_2dfd
27b8  81e21800  and    dx, 0x18
27bc  3a165326  cmp    dl, byte ptr [0x2653]
27c0  74f3      je     loc_27b5
27c2  88165326  mov    byte ptr [0x2653], dl
27c6  8b1e5426  mov    bx, word ptr [0x2654]
27ca  88975626  mov    byte ptr [bx + 0x2656], dl
27ce  81c22020  add    dx, 0x2020
27d2  8bf2      mov    si, dx
27d4  8bfb      mov    di, bx
27d6  d1e7      shl    di, 1
27d8  81c7a000  add    di, 0xa0
27dc  b90104    mov    cx, 0x401
27df  e8bb05    call   sub_2d9d
27e2  ff065426  inc    word ptr [0x2654]
27e6  833e542628  cmp    word ptr [0x2654], 0x28
27eb  72c8      jb     loc_27b5
27ed  c3        ret
  loc_27ee:
27ee  833e040007  cmp    word ptr [4], 7
27f3  7504      jne    loc_27f9
27f5  e81708    call   sub_300f
27f8  c3        ret
  loc_27f9:
27f9  833e040006  cmp    word ptr [4], 6
27fe  753e      jne    loc_283e
2800  2bc0      sub    ax, ax
2802  e89b01    call   sub_29a0
2805  bb7025    mov    bx, 0x2570
2808  b84a06    mov    ax, 0x64a
280b  e81603    call   sub_2b24
280e  c70650264800  mov    word ptr [0x2650], 0x48
2814  c606522638  mov    byte ptr [0x2652], 0x38
2819  b8d20d    mov    ax, 0xdd2
281c  e83901    call   sub_2958
281f  b8f60d    mov    ax, 0xdf6
2822  e84b01    call   sub_2970
2825  bea01f    mov    si, 0x1fa0
2828  bf7e06    mov    di, 0x67e
282b  b90210    mov    cx, 0x1002
282e  e86c05    call   sub_2d9d
2831  bb4423    mov    bx, 0x2344
2834  b8840b    mov    ax, 0xb84
2837  e8ea02    call   sub_2b24
283a  e80a23    call   sub_4b47
283d  c3        ret
  loc_283e:
283e  833e040005  cmp    word ptr [4], 5
2843  7548      jne    loc_288d
2845  b84006    mov    ax, 0x640
2848  e85501    call   sub_29a0
284b  bb7025    mov    bx, 0x2570
284e  b8b60c    mov    ax, 0xcb6
2851  e8d002    call   sub_2b24
2854  c7065026f800  mov    word ptr [0x2650], 0xf8
285a  c606522660  mov    byte ptr [0x2652], 0x60
285f  b80e14    mov    ax, 0x140e
2862  e8f300    call   sub_2958
2865  b83414    mov    ax, 0x1434
2868  e80501    call   sub_2970
286b  b83e14    mov    ax, 0x143e
286e  e8ff00    call   sub_2970
2871  b8a016    mov    ax, 0x16a0
2874  e81101    call   sub_2988
2877  bb4423    mov    bx, 0x2344
287a  b88411    mov    ax, 0x1184
287d  e8a402    call   sub_2b24
2880  bee01f    mov    si, 0x1fe0
2883  bfd60d    mov    di, 0xdd6
2886  b90210    mov    cx, 0x1002
2889  e81105    call   sub_2d9d
288c  c3        ret
  loc_288d:
288d  833e040004  cmp    word ptr [4], 4
2892  752a      jne    loc_28be
2894  b84006    mov    ax, 0x640
2897  e80601    call   sub_29a0
289a  bb7025    mov    bx, 0x2570
289d  b8ba0c    mov    ax, 0xcba
28a0  e88102    call   sub_2b24
28a3  c70650260801  mov    word ptr [0x2650], 0x108
28a9  c606522660  mov    byte ptr [0x2652], 0x60
28ae  b83914    mov    ax, 0x1439
28b1  e8a400    call   sub_2958
28b4  b8c016    mov    ax, 0x16c0
28b7  e88b00    call   sub_2945
28ba  e8e116    call   sub_3f9e
28bd  c3        ret
  loc_28be:
28be  833e040003  cmp    word ptr [4], 3
28c3  7544      jne    loc_2909
28c5  b84006    mov    ax, 0x640
28c8  e8d500    call   sub_29a0
28cb  bb7025    mov    bx, 0x2570
28ce  b8900c    mov    ax, 0xc90
28d1  e85002    call   sub_2b24
28d4  c70650266000  mov    word ptr [0x2650], 0x60
28da  c606522660  mov    byte ptr [0x2652], 0x60
28df  b80c14    mov    ax, 0x140c
28e2  e87300    call   sub_2958
28e5  b81814    mov    ax, 0x1418
28e8  e88500    call   sub_2970
28eb  bb4423    mov    bx, 0x2344
28ee  b88411    mov    ax, 0x1184
28f1  e83002    call   sub_2b24
28f4  bb4423    mov    bx, 0x2344
28f7  b8a211    mov    ax, 0x11a2
28fa  e82702    call   sub_2b24
28fd  bb2426    mov    bx, 0x2624
2900  2bc0      sub    ax, ax
2902  e81f02    call   sub_2b24
2905  e8d312    call   sub_3bdb
2908  c3        ret
  loc_2909:
2909  b84006    mov    ax, 0x640
290c  e89100    call   sub_29a0
290f  bb7025    mov    bx, 0x2570
2912  b8a00c    mov    ax, 0xca0
2915  e80c02    call   sub_2b24
2918  c7065026a000  mov    word ptr [0x2650], 0xa0
291e  c606522660  mov    byte ptr [0x2652], 0x60
2923  b80614    mov    ax, 0x1406
2926  e82f00    call   sub_2958
2929  bb4423    mov    bx, 0x2344
292c  b8c411    mov    ax, 0x11c4
292f  e8f201    call   sub_2b24
2932  b82214    mov    ax, 0x1422
2935  e83800    call   sub_2970
2938  b89016    mov    ax, 0x1690
293b  e84a00    call   sub_2988
293e  b8b616    mov    ax, 0x16b6
2941  e80100    call   sub_2945
2944  c3        ret

; ----------------------------------------------------------------------
sub_2945:
2945  a33426    mov    word ptr [0x2634], ax
2948  bb8423    mov    bx, 0x2384
294b  e8d601    call   sub_2b24
294e  a13426    mov    ax, word ptr [0x2634]
2951  bb8c23    mov    bx, 0x238c
2954  e8cd01    call   sub_2b24
2957  c3        ret

; ----------------------------------------------------------------------
sub_2958:
2958  a33426    mov    word ptr [0x2634], ax
295b  be0800    mov    si, 8
  loc_295e:
295e  a13426    mov    ax, word ptr [0x2634]
2961  8b9c3426  mov    bx, word ptr [si + 0x2634]
2965  56        push   si
2966  e8bb01    call   sub_2b24
2969  5e        pop    si
296a  83ee02    sub    si, 2
296d  75ef      jne    loc_295e
296f  c3        ret

; ----------------------------------------------------------------------
sub_2970:
2970  a33426    mov    word ptr [0x2634], ax
2973  be0a00    mov    si, 0xa
  loc_2976:
2976  a13426    mov    ax, word ptr [0x2634]
2979  8b9c3c26  mov    bx, word ptr [si + 0x263c]
297d  56        push   si
297e  e8a301    call   sub_2b24
2981  5e        pop    si
2982  83ee02    sub    si, 2
2985  75ef      jne    loc_2976
2987  c3        ret

; ----------------------------------------------------------------------
sub_2988:
2988  a33426    mov    word ptr [0x2634], ax
298b  be0800    mov    si, 8
  loc_298e:
298e  a13426    mov    ax, word ptr [0x2634]
2991  8b9c4626  mov    bx, word ptr [si + 0x2646]
2995  56        push   si
2996  e88b01    call   sub_2b24
2999  5e        pop    si
299a  83ee02    sub    si, 2
299d  75ef      jne    loc_298e
299f  c3        ret

; ----------------------------------------------------------------------
sub_29a0:
29a0  a37e26    mov    word ptr [0x267e], ax
29a3  bb1c25    mov    bx, 0x251c
29a6  e87b01    call   sub_2b24
29a9  2bc0      sub    ax, ax
29ab  fc        cld
29ac  8b3e7e26  mov    di, word ptr [0x267e]
29b0  81c78402  add    di, 0x284
29b4  b92400    mov    cx, 0x24
29b7  f3ab      rep stosw word ptr es:[di], ax
29b9  8b3e7e26  mov    di, word ptr [0x267e]
29bd  81c78411  add    di, 0x1184
29c1  b92400    mov    cx, 0x24
29c4  f3ab      rep stosw word ptr es:[di], ax
29c6  8b3e7e26  mov    di, word ptr [0x267e]
29ca  81c78422  add    di, 0x2284
29ce  b02a      mov    al, 0x2a
29d0  e80e00    call   sub_29e1
29d3  8b3e7e26  mov    di, word ptr [0x267e]
29d7  81c7cb22  add    di, 0x22cb
29db  b0a8      mov    al, 0xa8
29dd  e80100    call   sub_29e1
29e0  c3        ret

; ----------------------------------------------------------------------
sub_29e1:
29e1  b95f00    mov    cx, 0x5f
  loc_29e4:
29e4  268805    mov    byte ptr es:[di], al
29e7  81f70020  xor    di, 0x2000
29eb  f7c70020  test   di, 0x2000
29ef  7503      jne    loc_29f4
29f1  83c750    add    di, 0x50
  loc_29f4:
29f4  e2ee      loop   loc_29e4
29f6  c3        ret
29f7  db 00,00,00,00,00,00,00,00,00   ; .........

; ----------------------------------------------------------------------
sub_2a00:
2a00  b800b8    mov    ax, 0xb800
2a03  8ec0      mov    es, ax
2a05  fc        cld
2a06  2bff      sub    di, di
2a08  b8aaaa    mov    ax, 0xaaaa
2a0b  b9a00f    mov    cx, 0xfa0
2a0e  f3ab      rep stosw word ptr es:[di], ax
2a10  bf0020    mov    di, 0x2000
2a13  b9a00f    mov    cx, 0xfa0
2a16  f3ab      rep stosw word ptr es:[di], ax
2a18  e88301    call   sub_2b9e
2a1b  bba028    mov    bx, 0x28a0
2a1e  2bc0      sub    ax, ax
2a20  e80101    call   sub_2b24
2a23  e84200    call   sub_2a68
2a26  e85b02    call   sub_2c84
2a29  e85f01    call   sub_2b8b
2a2c  e85100    call   sub_2a80
2a2f  c3        ret

; ----------------------------------------------------------------------
sub_2a30:
2a30  b800b8    mov    ax, 0xb800
2a33  8ec0      mov    es, ax
2a35  fc        cld
2a36  2bff      sub    di, di
2a38  b8aaaa    mov    ax, 0xaaaa
2a3b  b9a00f    mov    cx, 0xfa0
2a3e  f3ab      rep stosw word ptr es:[di], ax
2a40  bf0020    mov    di, 0x2000
2a43  b9a00f    mov    cx, 0xfa0
2a46  f3ab      rep stosw word ptr es:[di], ax
2a48  e85301    call   sub_2b9e
2a4b  bba028    mov    bx, 0x28a0
2a4e  2bc0      sub    ax, ax
2a50  e8d100    call   sub_2b24
2a53  e81200    call   sub_2a68
2a56  a10800    mov    ax, word ptr [8]
2a59  50        push   ax
2a5a  c70608000100  mov    word ptr [8], 1
2a60  e82102    call   sub_2c84
2a63  58        pop    ax
2a64  a30800    mov    word ptr [8], ax
2a67  c3        ret

; ----------------------------------------------------------------------
sub_2a68:
2a68  8b1ef86d  mov    bx, word ptr [0x6df8]
2a6c  81e30300  and    bx, 3
2a70  d0e3      shl    bl, 1
2a72  8bb7d12a  mov    si, word ptr [bx + 0x2ad1]
2a76  bf0219    mov    di, 0x1902
2a79  b90108    mov    cx, 0x801
2a7c  e81e03    call   sub_2d9d
2a7f  c3        ret

; ----------------------------------------------------------------------
sub_2a80:
2a80  bb0f00    mov    bx, 0xf
  loc_2a83:
2a83  c687151000  mov    byte ptr [bx + 0x1015], 0
2a88  4b        dec    bx
2a89  75f8      jne    loc_2a83
2a8b  bf4001    mov    di, 0x140
2a8e  b780      mov    bh, 0x80
2a90  c706ca2a0000  mov    word ptr [0x2aca], 0
2a96  e82d00    call   sub_2ac6
2a99  bf4006    mov    di, 0x640
2a9c  b730      mov    bh, 0x30
2a9e  c706ca2a0500  mov    word ptr [0x2aca], 5
2aa4  e81f00    call   sub_2ac6
2aa7  bf400b    mov    di, 0xb40
2aaa  b700      mov    bh, 0
2aac  c706ca2a0a00  mov    word ptr [0x2aca], 0xa
2ab2  e81100    call   sub_2ac6
2ab5  c606250510  mov    byte ptr [0x525], 0x10
2aba  c7062f050000  mov    word ptr [0x52f], 0
2ac0  c606310501  mov    byte ptr [0x531], 1
2ac5  c3        ret

; ----------------------------------------------------------------------
sub_2ac6:
2ac6  883ec92a  mov    byte ptr [0x2ac9], bh
2aca  c606c42a00  mov    byte ptr [0x2ac4], 0
  loc_2acf:
2acf  57        push   di
2ad0  06        push   es
2ad1  8b1e0800  mov    bx, word ptr [8]
2ad5  8a9fba2a  mov    bl, byte ptr [bx + 0x2aba]
2ad9  8a3ec92a  mov    bh, byte ptr [0x2ac9]
2add  b81000    mov    ax, 0x10
2ae0  8ec0      mov    es, ax
2ae2  bfd704    mov    di, 0x4d7
2ae5  e895db    call   sub_067d
2ae8  07        pop    es
2ae9  5f        pop    di
2aea  57        push   di
2aeb  bed704    mov    si, 0x4d7
2aee  b90210    mov    cx, 0x1002
2af1  e8a902    call   sub_2d9d
2af4  2aff      sub    bh, bh
2af6  8a1ec42a  mov    bl, byte ptr [0x2ac4]
2afa  8acb      mov    cl, bl
2afc  d0eb      shr    bl, 1
2afe  d0eb      shr    bl, 1
2b00  f6d1      not    cl
2b02  80e103    and    cl, 3
2b05  d0e1      shl    cl, 1
2b07  a04005    mov    al, byte ptr [0x540]
2b0a  d2e0      shl    al, cl
2b0c  8b36ca2a  mov    si, word ptr [0x2aca]
2b10  08801610  or     byte ptr [bx + si + 0x1016], al
2b14  5f        pop    di
2b15  83c704    add    di, 4
2b18  fe06c42a  inc    byte ptr [0x2ac4]
2b1c  803ec42a14  cmp    byte ptr [0x2ac4], 0x14
2b21  72ac      jb     loc_2acf
2b23  c3        ret

; ----------------------------------------------------------------------
sub_2b24:
2b24  8b0f      mov    cx, word ptr [bx]
2b26  890ec72a  mov    word ptr [0x2ac7], cx
2b2a  a3cc2a    mov    word ptr [0x2acc], ax
2b2d  83c302    add    bx, 2
  loc_2b30:
2b30  8b37      mov    si, word ptr [bx]
2b32  81feffff  cmp    si, 0xffff
2b36  7501      jne    loc_2b39
2b38  c3        ret
  loc_2b39:
2b39  8b7f02    mov    di, word ptr [bx + 2]
2b3c  033ecc2a  add    di, word ptr [0x2acc]
2b40  fc        cld
2b41  882ed02a  mov    byte ptr [0x2ad0], ch
2b45  2aed      sub    ch, ch
2b47  890ece2a  mov    word ptr [0x2ace], cx
  loc_2b4b:
2b4b  8b0ece2a  mov    cx, word ptr [0x2ace]
2b4f  f3a4      rep movsb byte ptr es:[di], byte ptr [si]
2b51  2b3ece2a  sub    di, word ptr [0x2ace]
2b55  81f70020  xor    di, 0x2000
2b59  f7c70020  test   di, 0x2000
2b5d  7503      jne    loc_2b62
2b5f  83c750    add    di, 0x50
  loc_2b62:
2b62  fe0ed02a  dec    byte ptr [0x2ad0]
2b66  75e3      jne    loc_2b4b
2b68  83c304    add    bx, 4
2b6b  8b0ec72a  mov    cx, word ptr [0x2ac7]
2b6f  ebbf      jmp    loc_2b30

; ----------------------------------------------------------------------
sub_2b71:
2b71  c606c42a04  mov    byte ptr [0x2ac4], 4
  loc_2b76:
2b76  be8026    mov    si, 0x2680
2b79  b90510    mov    cx, 0x1005
2b7c  57        push   di
2b7d  e81d02    call   sub_2d9d
2b80  5f        pop    di
2b81  83c714    add    di, 0x14
2b84  fe0ec42a  dec    byte ptr [0x2ac4]
2b88  75ec      jne    loc_2b76
2b8a  c3        ret

; ----------------------------------------------------------------------
sub_2b8b:
2b8b  bfc503    mov    di, 0x3c5
2b8e  e8e0ff    call   sub_2b71
2b91  bfc508    mov    di, 0x8c5
2b94  e8daff    call   sub_2b71
2b97  bfc50d    mov    di, 0xdc5
2b9a  e8d4ff    call   sub_2b71
2b9d  c3        ret

; ----------------------------------------------------------------------
sub_2b9e:
2b9e  c706c22a3e10  mov    word ptr [0x2ac2], 0x103e
  loc_2ba4:
2ba4  8306c22a02  add    word ptr [0x2ac2], 2
2ba9  8b3ec22a  mov    di, word ptr [0x2ac2]
2bad  81ff9010  cmp    di, 0x1090
2bb1  731f      jae    loc_2bd2
  loc_2bb3:
2bb3  e84702    call   sub_2dfd
2bb6  81e23000  and    dx, 0x30
2bba  3a16c42a  cmp    dl, byte ptr [0x2ac4]
2bbe  74f3      je     loc_2bb3
2bc0  8816c42a  mov    byte ptr [0x2ac4], dl
2bc4  81c20429  add    dx, 0x2904
2bc8  8bf2      mov    si, dx
2bca  b90108    mov    cx, 0x801
2bcd  e8cd01    call   sub_2d9d
2bd0  ebd2      jmp    loc_2ba4
  loc_2bd2:
2bd2  bf8011    mov    di, 0x1180
2bd5  b85556    mov    ax, 0x5655
2bd8  b90005    mov    cx, 0x500
2bdb  fc        cld
2bdc  f3ab      rep stosw word ptr es:[di], ax
2bde  bf8031    mov    di, 0x3180
2be1  b90005    mov    cx, 0x500
2be4  f3ab      rep stosw word ptr es:[di], ax
2be6  c706c22a4429  mov    word ptr [0x2ac2], 0x2944
  loc_2bec:
2bec  c606c42a09  mov    byte ptr [0x2ac4], 9
  loc_2bf1:
2bf1  e80902    call   sub_2dfd
2bf4  81e27607  and    dx, 0x776
2bf8  81c2c012  add    dx, 0x12c0
2bfc  8bfa      mov    di, dx
2bfe  8b36c22a  mov    si, word ptr [0x2ac2]
2c02  b90105    mov    cx, 0x501
2c05  e89501    call   sub_2d9d
2c08  fe0ec42a  dec    byte ptr [0x2ac4]
2c0c  75e3      jne    loc_2bf1
2c0e  8306c22a0a  add    word ptr [0x2ac2], 0xa
2c13  813ec22a6c29  cmp    word ptr [0x2ac2], 0x296c
2c19  72d1      jb     loc_2bec
2c1b  c606c42a05  mov    byte ptr [0x2ac4], 5
  loc_2c20:
2c20  e8da01    call   sub_2dfd
2c23  81e23e00  and    dx, 0x3e
2c27  81c2983a  add    dx, 0x3a98
2c2b  8bfa      mov    di, dx
2c2d  be6c29    mov    si, 0x296c
2c30  b90105    mov    cx, 0x501
2c33  e86701    call   sub_2d9d
2c36  fe0ec42a  dec    byte ptr [0x2ac4]
2c3a  75e4      jne    loc_2c20
2c3c  c3        ret

; ----------------------------------------------------------------------
sub_2c3d:
2c3d  893ec22a  mov    word ptr [0x2ac2], di
2c41  b003      mov    al, 3
2c43  81ff2017  cmp    di, 0x1720
2c47  7202      jb     loc_2c4b
2c49  fec8      dec    al
  loc_2c4b:
2c4b  a2c42a    mov    byte ptr [0x2ac4], al
2c4e  8106c22ae001  add    word ptr [0x2ac2], 0x1e0
2c54  be7629    mov    si, 0x2976
2c57  b9050c    mov    cx, 0xc05
2c5a  e84001    call   sub_2d9d
  loc_2c5d:
2c5d  8b3ec22a  mov    di, word ptr [0x2ac2]
2c61  8106c22a4001  add    word ptr [0x2ac2], 0x140
2c67  beee29    mov    si, 0x29ee
2c6a  b90408    mov    cx, 0x804
2c6d  e82d01    call   sub_2d9d
2c70  fe0ec42a  dec    byte ptr [0x2ac4]
2c74  75e7      jne    loc_2c5d
2c76  8b3ec22a  mov    di, word ptr [0x2ac2]
2c7a  be2e2a    mov    si, 0x2a2e
2c7d  b9040b    mov    cx, 0xb04
2c80  e81a01    call   sub_2d9d
2c83  c3        ret

; ----------------------------------------------------------------------
sub_2c84:
2c84  8b1e0800  mov    bx, word ptr [8]
2c88  8a9fb22a  mov    bl, byte ptr [bx + 0x2ab2]
  loc_2c8c:
2c8c  891ec52a  mov    word ptr [0x2ac5], bx
2c90  8bbf862a  mov    di, word ptr [bx + 0x2a86]
2c94  83ff00    cmp    di, 0
2c97  7501      jne    loc_2c9a
2c99  c3        ret
  loc_2c9a:
2c9a  e8a0ff    call   sub_2c3d
2c9d  8b1ec52a  mov    bx, word ptr [0x2ac5]
2ca1  83c302    add    bx, 2
2ca4  ebe6      jmp    loc_2c8c
2ca6  db c3,00,00,00,00,00,00,00,00,00   ; ..........

; ----------------------------------------------------------------------
sub_2cb0:
2cb0  8ac2      mov    al, dl
2cb2  b428      mov    ah, 0x28
2cb4  f6e4      mul    ah
2cb6  f6c201    test   dl, 1
2cb9  7403      je     loc_2cbe
2cbb  05d81f    add    ax, 0x1fd8
  loc_2cbe:
2cbe  8bd1      mov    dx, cx
2cc0  d1ea      shr    dx, 1
2cc2  d1ea      shr    dx, 1
2cc4  03c2      add    ax, dx
2cc6  80e103    and    cl, 3
2cc9  d0e1      shl    cl, 1
2ccb  c3        ret

; ----------------------------------------------------------------------
sub_2ccc:
2ccc  fc        cld
2ccd  880ee02a  mov    byte ptr [0x2ae0], cl
2cd1  882ee22a  mov    byte ptr [0x2ae2], ch
2cd5  2aed      sub    ch, ch
2cd7  baf00f    mov    dx, 0xff0
  loc_2cda:
2cda  8a0ee02a  mov    cl, byte ptr [0x2ae0]
  loc_2cde:
2cde  bac030    mov    dx, 0x30c0
2ce1  268b1d    mov    bx, word ptr es:[di]
2ce4  3e895e00  mov    word ptr ds:[bp], bx
2ce8  ad        lodsw  ax, word ptr [si]
2ce9  a3e32a    mov    word ptr [0x2ae3], ax
  loc_2cec:
2cec  84e2      test   dl, ah
2cee  7502      jne    loc_2cf2
2cf0  0ae2      or     ah, dl
  loc_2cf2:
2cf2  84e6      test   dh, ah
2cf4  7502      jne    loc_2cf8
2cf6  0ae6      or     ah, dh
  loc_2cf8:
2cf8  84c2      test   dl, al
2cfa  7502      jne    loc_2cfe
2cfc  0ac2      or     al, dl
  loc_2cfe:
2cfe  84c6      test   dh, al
2d00  7502      jne    loc_2d04
2d02  0ac6      or     al, dh
  loc_2d04:
2d04  81f2cc33  xor    dx, 0x33cc
2d08  f6c603    test   dh, 3
2d0b  75df      jne    loc_2cec
2d0d  23c3      and    ax, bx
2d0f  0b06e32a  or     ax, word ptr [0x2ae3]
2d13  ab        stosw  word ptr es:[di], ax
2d14  83c502    add    bp, 2
2d17  e2c5      loop   loc_2cde
2d19  2b3ee02a  sub    di, word ptr [0x2ae0]
2d1d  2b3ee02a  sub    di, word ptr [0x2ae0]
2d21  81f70020  xor    di, 0x2000
2d25  f7c70020  test   di, 0x2000
2d29  7503      jne    loc_2d2e
2d2b  83c750    add    di, 0x50
  loc_2d2e:
2d2e  fe0ee22a  dec    byte ptr [0x2ae2]
2d32  75a6      jne    loc_2cda
2d34  c3        ret

; ----------------------------------------------------------------------
sub_2d35:
2d35  fc        cld
2d36  880ee02a  mov    byte ptr [0x2ae0], cl
2d3a  882ee22a  mov    byte ptr [0x2ae2], ch
2d3e  2aed      sub    ch, ch
  loc_2d40:
2d40  8a0ee02a  mov    cl, byte ptr [0x2ae0]
  loc_2d44:
2d44  268b1d    mov    bx, word ptr es:[di]
2d47  3e895e00  mov    word ptr ds:[bp], bx
2d4b  ad        lodsw  ax, word ptr [si]
2d4c  23c3      and    ax, bx
2d4e  ab        stosw  word ptr es:[di], ax
2d4f  83c502    add    bp, 2
2d52  e2f0      loop   loc_2d44
2d54  2b3ee02a  sub    di, word ptr [0x2ae0]
2d58  2b3ee02a  sub    di, word ptr [0x2ae0]
2d5c  81f70020  xor    di, 0x2000
2d60  f7c70020  test   di, 0x2000
2d64  7503      jne    loc_2d69
2d66  83c750    add    di, 0x50
  loc_2d69:
2d69  fe0ee22a  dec    byte ptr [0x2ae2]
2d6d  75d1      jne    loc_2d40
2d6f  c3        ret

; ----------------------------------------------------------------------
sub_2d70:
2d70  fc        cld
2d71  8936e92a  mov    word ptr [0x2ae9], si
2d75  880ee02a  mov    byte ptr [0x2ae0], cl
2d79  882ee22a  mov    byte ptr [0x2ae2], ch
2d7d  d0e0      shl    al, 1
2d7f  a2eb2a    mov    byte ptr [0x2aeb], al
2d82  2aed      sub    ch, ch
  loc_2d84:
2d84  8a0ee02a  mov    cl, byte ptr [0x2ae0]
2d88  f3a5      rep movsw word ptr es:[di], word ptr [si]
2d8a  8a0eeb2a  mov    cl, byte ptr [0x2aeb]
2d8e  010ee92a  add    word ptr [0x2ae9], cx
2d92  8b36e92a  mov    si, word ptr [0x2ae9]
2d96  fe0ee22a  dec    byte ptr [0x2ae2]
2d9a  75e8      jne    loc_2d84
2d9c  c3        ret

; ----------------------------------------------------------------------
sub_2d9d:
2d9d  fc        cld
2d9e  880ee02a  mov    byte ptr [0x2ae0], cl
2da2  882ee22a  mov    byte ptr [0x2ae2], ch
2da6  2aed      sub    ch, ch
  loc_2da8:
2da8  8a0ee02a  mov    cl, byte ptr [0x2ae0]
2dac  f3a5      rep movsw word ptr es:[di], word ptr [si]
2dae  2b3ee02a  sub    di, word ptr [0x2ae0]
2db2  2b3ee02a  sub    di, word ptr [0x2ae0]
2db6  81f70020  xor    di, 0x2000
2dba  f7c70020  test   di, 0x2000
2dbe  7503      jne    loc_2dc3
2dc0  83c750    add    di, 0x50
  loc_2dc3:
2dc3  fe0ee22a  dec    byte ptr [0x2ae2]
2dc7  75df      jne    loc_2da8
2dc9  c3        ret

; ----------------------------------------------------------------------
sub_2dca:
2dca  fc        cld
2dcb  26880ee02a  mov    byte ptr es:[0x2ae0], cl
2dd0  26882ee22a  mov    byte ptr es:[0x2ae2], ch
2dd5  2aed      sub    ch, ch
  loc_2dd7:
2dd7  268a0ee02a  mov    cl, byte ptr es:[0x2ae0]
2ddc  f3a5      rep movsw word ptr es:[di], word ptr [si]
2dde  262b36e02a  sub    si, word ptr es:[0x2ae0]
2de3  262b36e02a  sub    si, word ptr es:[0x2ae0]
2de8  81f60020  xor    si, 0x2000
2dec  f7c60020  test   si, 0x2000
2df0  7503      jne    loc_2df5
2df2  83c650    add    si, 0x50
  loc_2df5:
2df5  26fe0ee22a  dec    byte ptr es:[0x2ae2]
2dfa  75db      jne    loc_2dd7
2dfc  c3        ret

; ----------------------------------------------------------------------
sub_2dfd:
2dfd  8b16e52a  mov    dx, word ptr [0x2ae5]
2e01  32d6      xor    dl, dh
2e03  d0ea      shr    dl, 1
2e05  d0ea      shr    dl, 1
2e07  d11ee52a  rcr    word ptr [0x2ae5], 1
2e0b  8b16e52a  mov    dx, word ptr [0x2ae5]
2e0f  c3        ret

; ----------------------------------------------------------------------
sub_2e10:
2e10  b000      mov    al, 0
2e12  e643      out    0x43, al
2e14  90        nop
2e15  90        nop
2e16  e440      in     al, 0x40
2e18  8ae0      mov    ah, al
2e1a  90        nop
2e1b  e440      in     al, 0x40
2e1d  3d0000    cmp    ax, 0
2e20  7503      jne    loc_2e25
2e22  b859fa    mov    ax, 0xfa59
  loc_2e25:
2e25  a3e52a    mov    word ptr [0x2ae5], ax
2e28  c3        ret

; ----------------------------------------------------------------------
sub_2e29:
2e29  03c6      add    ax, si
2e2b  3bc3      cmp    ax, bx
2e2d  7220      jb     loc_2e4f
2e2f  2bc6      sub    ax, si
2e31  2bc7      sub    ax, di
2e33  7302      jae    loc_2e37
2e35  2bc0      sub    ax, ax
  loc_2e37:
2e37  3bc3      cmp    ax, bx
2e39  7714      ja     loc_2e4f
2e3b  02d1      add    dl, cl
2e3d  3ad6      cmp    dl, dh
2e3f  720e      jb     loc_2e4f
2e41  2ad1      sub    dl, cl
2e43  2ad5      sub    dl, ch
2e45  7302      jae    loc_2e49
2e47  2ad2      sub    dl, dl
  loc_2e49:
2e49  3ad6      cmp    dl, dh
2e4b  7702      ja     loc_2e4f
2e4d  f9        stc
2e4e  c3        ret
  loc_2e4f:
2e4f  f8        clc
2e50  c3        ret
2e51  db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00   ; ...............

; ----------------------------------------------------------------------
sub_2e60:
2e60  833e8d2e08  cmp    word ptr [0x2e8d], 8
2e65  7201      jb     loc_2e68
  loc_2e67:
2e67  c3        ret
  loc_2e68:
2e68  803e9a0600  cmp    byte ptr [0x69a], 0
2e6d  75f8      jne    loc_2e67
2e6f  c706922effff  mov    word ptr [0x2e92], 0xffff
2e75  c606912eff  mov    byte ptr [0x2e91], 0xff
2e7a  b90700    mov    cx, 7
  loc_2e7d:
2e7d  8bd9      mov    bx, cx
2e7f  4b        dec    bx
2e80  a07b05    mov    al, byte ptr [0x57b]
2e83  2a87d42b  sub    al, byte ptr [bx + 0x2bd4]
2e87  7302      jae    loc_2e8b
2e89  f6d0      not    al
  loc_2e8b:
2e8b  3a06912e  cmp    al, byte ptr [0x2e91]
2e8f  7707      ja     loc_2e98
2e91  a2912e    mov    byte ptr [0x2e91], al
2e94  891e922e  mov    word ptr [0x2e92], bx
  loc_2e98:
2e98  e2e3      loop   loc_2e7d
2e9a  813e922effff  cmp    word ptr [0x2e92], 0xffff
2ea0  7506      jne    loc_2ea8
2ea2  c706922e0000  mov    word ptr [0x2e92], 0
  loc_2ea8:
2ea8  8b1e8d2e  mov    bx, word ptr [0x2e8d]
2eac  8b36922e  mov    si, word ptr [0x2e92]
2eb0  8a84d42b  mov    al, byte ptr [si + 0x2bd4]
2eb4  88876a2b  mov    byte ptr [bx + 0x2b6a], al
2eb8  a2982e    mov    byte ptr [0x2e98], al
2ebb  a17905    mov    ax, word ptr [0x579]
2ebe  d0e3      shl    bl, 1
2ec0  3d0801    cmp    ax, 0x108
2ec3  7203      jb     loc_2ec8
2ec5  b80701    mov    ax, 0x107
  loc_2ec8:
2ec8  25fc0f    and    ax, 0xffc
2ecb  89875a2b  mov    word ptr [bx + 0x2b5a], ax
2ecf  a3962e    mov    word ptr [0x2e96], ax
2ed2  b90800    mov    cx, 8
  loc_2ed5:
2ed5  8bd9      mov    bx, cx
2ed7  4b        dec    bx
2ed8  3b1e8d2e  cmp    bx, word ptr [0x2e8d]
2edc  7429      je     loc_2f07
2ede  80bf722b00  cmp    byte ptr [bx + 0x2b72], 0
2ee3  7422      je     loc_2f07
2ee5  51        push   cx
2ee6  8a976a2b  mov    dl, byte ptr [bx + 0x2b6a]
2eea  d0e3      shl    bl, 1
2eec  8b875a2b  mov    ax, word ptr [bx + 0x2b5a]
2ef0  8b1e962e  mov    bx, word ptr [0x2e96]
2ef4  8a36982e  mov    dh, byte ptr [0x2e98]
2ef8  be1800    mov    si, 0x18
2efb  8bfe      mov    di, si
2efd  b90f0f    mov    cx, 0xf0f
2f00  e826ff    call   sub_2e29
2f03  59        pop    cx
2f04  7301      jae    loc_2f07
2f06  c3        ret
  loc_2f07:
2f07  e2cc      loop   loc_2ed5
2f09  e8d7e2    call   sub_11e3
2f0c  803ef27000  cmp    byte ptr [0x70f2], 0
2f11  7403      je     loc_2f16
2f13  e81533    call   sub_622b
  loc_2f16:
2f16  8b1e8d2e  mov    bx, word ptr [0x2e8d]
2f1a  891e942e  mov    word ptr [0x2e94], bx
2f1e  c687722b01  mov    byte ptr [bx + 0x2b72], 1
2f23  8a976a2b  mov    dl, byte ptr [bx + 0x2b6a]
2f27  d0e3      shl    bl, 1
2f29  8b8f5a2b  mov    cx, word ptr [bx + 0x2b5a]
2f2d  e880fd    call   sub_2cb0
2f30  8bf8      mov    di, ax
2f32  bef02a    mov    si, 0x2af0
2f35  b800b8    mov    ax, 0xb800
2f38  8ec0      mov    es, ax
2f3a  b9030f    mov    cx, 0xf03
2f3d  e85dfe    call   sub_2d9d
2f40  c7068d2effff  mov    word ptr [0x2e8d], 0xffff
2f46  2bdb      sub    bx, bx
2f48  b40b      mov    ah, 0xb
2f4a  cd10      int    0x10
2f4c  e8ef1e    call   sub_4e3e
2f4f  803ef27000  cmp    byte ptr [0x70f2], 0
2f54  7403      je     loc_2f59
2f56  e8a132    call   sub_61fa
  loc_2f59:
2f59  e8e9e1    call   sub_1145
2f5c  b8e803    mov    ax, 0x3e8
2f5f  bba504    mov    bx, 0x4a5
2f62  e8d629    call   sub_593b
2f65  c3        ret

; ----------------------------------------------------------------------
sub_2f66:
2f66  2ae4      sub    ah, ah
2f68  cd1a      int    0x1a
2f6a  3b168f2e  cmp    dx, word ptr [0x2e8f]
2f6e  7501      jne    loc_2f71
2f70  c3        ret
  loc_2f71:
2f71  89168f2e  mov    word ptr [0x2e8f], dx
2f75  833e8d2e08  cmp    word ptr [0x2e8d], 8
2f7a  7230      jb     loc_2fac
2f7c  b90800    mov    cx, 8
  loc_2f7f:
2f7f  8bd9      mov    bx, cx
2f81  4b        dec    bx
2f82  80bf722b00  cmp    byte ptr [bx + 0x2b72], 0
2f87  7421      je     loc_2faa
2f89  51        push   cx
2f8a  8a976a2b  mov    dl, byte ptr [bx + 0x2b6a]
2f8e  d0e3      shl    bl, 1
2f90  8b875a2b  mov    ax, word ptr [bx + 0x2b5a]
2f94  be1800    mov    si, 0x18
2f97  8bfe      mov    di, si
2f99  8b1e7905  mov    bx, word ptr [0x579]
2f9d  8a367b05  mov    dh, byte ptr [0x57b]
2fa1  b90f0e    mov    cx, 0xe0f
2fa4  e882fe    call   sub_2e29
2fa7  59        pop    cx
2fa8  7209      jb     loc_2fb3
  loc_2faa:
2faa  e2d3      loop   loc_2f7f
  loc_2fac:
2fac  c706942effff  mov    word ptr [0x2e94], 0xffff
  loc_2fb2:
2fb2  c3        ret
  loc_2fb3:
2fb3  8bd9      mov    bx, cx
2fb5  4b        dec    bx
2fb6  3b1e942e  cmp    bx, word ptr [0x2e94]
2fba  74f6      je     loc_2fb2
2fbc  53        push   bx
2fbd  e823e2    call   sub_11e3
2fc0  803ef27000  cmp    byte ptr [0x70f2], 0
2fc5  7403      je     loc_2fca
2fc7  e86132    call   sub_622b
  loc_2fca:
2fca  5b        pop    bx
2fcb  c687722b00  mov    byte ptr [bx + 0x2b72], 0
2fd0  8a976a2b  mov    dl, byte ptr [bx + 0x2b6a]
2fd4  891e8d2e  mov    word ptr [0x2e8d], bx
2fd8  d0e3      shl    bl, 1
2fda  8b8f5a2b  mov    cx, word ptr [bx + 0x2b5a]
2fde  e8cffc    call   sub_2cb0
2fe1  8bf8      mov    di, ax
2fe3  be7a2b    mov    si, 0x2b7a
2fe6  b800b8    mov    ax, 0xb800
2fe9  8ec0      mov    es, ax
2feb  b9030f    mov    cx, 0xf03
2fee  e8acfd    call   sub_2d9d
2ff1  803ef27000  cmp    byte ptr [0x70f2], 0
2ff6  7403      je     loc_2ffb
2ff8  e8ff31    call   sub_61fa
  loc_2ffb:
2ffb  e847e1    call   sub_1145
2ffe  bb0100    mov    bx, 1
3001  b40b      mov    ah, 0xb
3003  cd10      int    0x10
3005  b8e803    mov    ax, 0x3e8
3008  bb4903    mov    bx, 0x349
300b  e82d29    call   sub_593b
300e  c3        ret

; ----------------------------------------------------------------------
sub_300f:
300f  2bc0      sub    ax, ax
3011  bb242e    mov    bx, 0x2e24
3014  e80dfb    call   sub_2b24
3017  c6068a2ebf  mov    byte ptr [0x2e8a], 0xbf
301c  c7068b2e0000  mov    word ptr [0x2e8b], 0
  loc_3022:
3022  c706882e2000  mov    word ptr [0x2e88], 0x20
  loc_3028:
3028  2bdb      sub    bx, bx
302a  803e8a2ebf  cmp    byte ptr [0x2e8a], 0xbf
302f  7408      je     loc_3039
3031  e8c9fd    call   sub_2dfd
3034  8ada      mov    bl, dl
3036  80e302    and    bl, 2
  loc_3039:
3039  8b0e882e  mov    cx, word ptr [0x2e88]
303d  8a168a2e  mov    dl, byte ptr [0x2e8a]
3041  53        push   bx
3042  e89e00    call   sub_30e3
3045  5b        pop    bx
3046  8b368b2e  mov    si, word ptr [0x2e8b]
304a  a1882e    mov    ax, word ptr [0x2e88]
304d  b104      mov    cl, 4
304f  d3e8      shr    ax, cl
3051  2d0200    sub    ax, 2
3054  7302      jae    loc_3058
3056  2bc0      sub    ax, ax
  loc_3058:
3058  3d1200    cmp    ax, 0x12
305b  7203      jb     loc_3060
305d  b81100    mov    ax, 0x11
  loc_3060:
3060  8a94db2b  mov    dl, byte ptr [si + 0x2bdb]
3064  2af6      sub    dh, dh
3066  03c2      add    ax, dx
3068  8bf0      mov    si, ax
306a  889ce22b  mov    byte ptr [si + 0x2be2], bl
306e  8306882e10  add    word ptr [0x2e88], 0x10
3073  813e882e1101  cmp    word ptr [0x2e88], 0x111
3079  72ad      jb     loc_3028
307b  ff068b2e  inc    word ptr [0x2e8b]
307f  802e8a2e18  sub    byte ptr [0x2e8a], 0x18
3084  803e8a2e2f  cmp    byte ptr [0x2e8a], 0x2f
3089  7397      jae    loc_3022
308b  b8ffff    mov    ax, 0xffff
308e  a38d2e    mov    word ptr [0x2e8d], ax
3091  a3942e    mov    word ptr [0x2e94], ax
3094  2bc0      sub    ax, ax
3096  a3722b    mov    word ptr [0x2b72], ax
3099  a3742b    mov    word ptr [0x2b74], ax
309c  a3762b    mov    word ptr [0x2b76], ax
309f  a3782b    mov    word ptr [0x2b78], ax
30a2  8b0e1404  mov    cx, word ptr [0x414]
30a6  83f900    cmp    cx, 0
30a9  7505      jne    loc_30b0
30ab  41        inc    cx
30ac  890e1404  mov    word ptr [0x414], cx
  loc_30b0:
30b0  83f908    cmp    cx, 8
30b3  7603      jbe    loc_30b8
30b5  b90800    mov    cx, 8
  loc_30b8:
30b8  8bd9      mov    bx, cx
30ba  4b        dec    bx
30bb  c687722b01  mov    byte ptr [bx + 0x2b72], 1
30c0  b2b0      mov    dl, 0xb0
30c2  88976a2b  mov    byte ptr [bx + 0x2b6a], dl
30c6  51        push   cx
30c7  d0e3      shl    bl, 1
30c9  8b8f4a2b  mov    cx, word ptr [bx + 0x2b4a]
30cd  898f5a2b  mov    word ptr [bx + 0x2b5a], cx
30d1  e8dcfb    call   sub_2cb0
30d4  8bf8      mov    di, ax
30d6  bef02a    mov    si, 0x2af0
30d9  b9030f    mov    cx, 0xf03
30dc  e8befc    call   sub_2d9d
30df  59        pop    cx
30e0  e2d6      loop   loc_30b8
30e2  c3        ret

; ----------------------------------------------------------------------
sub_30e3:
30e3  53        push   bx
30e4  e8c9fb    call   sub_2cb0
30e7  8bf8      mov    di, ax
30e9  b800b8    mov    ax, 0xb800
30ec  8ec0      mov    es, ax
30ee  5b        pop    bx
30ef  8bb7202e  mov    si, word ptr [bx + 0x2e20]
30f3  b90208    mov    cx, 0x802
30f6  e8a4fc    call   sub_2d9d
30f9  c3        ret

; ----------------------------------------------------------------------
sub_30fa:
30fa  a07b05    mov    al, byte ptr [0x57b]
30fd  2c05      sub    al, 5
30ff  24f8      and    al, 0xf8
3101  b90700    mov    cx, 7
  loc_3104:
3104  8bd9      mov    bx, cx
3106  4b        dec    bx
3107  3a87d42b  cmp    al, byte ptr [bx + 0x2bd4]
310b  7404      je     loc_3111
310d  e2f5      loop   loc_3104
310f  eb3c      jmp    loc_314d
  loc_3111:
3111  8ae8      mov    ch, al
3113  a17905    mov    ax, word ptr [0x579]
3116  050700    add    ax, 7
3119  b104      mov    cl, 4
311b  d3e8      shr    ax, cl
311d  2d0200    sub    ax, 2
3120  7302      jae    loc_3124
3122  2bc0      sub    ax, ax
  loc_3124:
3124  3d1200    cmp    ax, 0x12
3127  7203      jb     loc_312c
3129  b81100    mov    ax, 0x11
  loc_312c:
312c  8a97db2b  mov    dl, byte ptr [bx + 0x2bdb]
3130  2af6      sub    dh, dh
3132  03c2      add    ax, dx
3134  8bf0      mov    si, ax
3136  80bce22b00  cmp    byte ptr [si + 0x2be2], 0
313b  7510      jne    loc_314d
313d  80c505    add    ch, 5
3140  882e7b05  mov    byte ptr [0x57b], ch
3144  80c532    add    ch, 0x32
3147  882e7c05  mov    byte ptr [0x57c], ch
314b  f9        stc
314c  c3        ret
  loc_314d:
314d  f8        clc
314e  c3        ret
314f  db 00   ; .

; ----------------------------------------------------------------------
sub_3150:
3150  2ae4      sub    ah, ah
3152  cd1a      int    0x1a
3154  8b1e0400  mov    bx, word ptr [4]
3158  d0e3      shl    bl, 1
315a  8b8ff232  mov    cx, word ptr [bx + 0x32f2]
315e  8bc2      mov    ax, dx
3160  2b068c32  sub    ax, word ptr [0x328c]
3164  3bc1      cmp    ax, cx
3166  7301      jae    loc_3169
  loc_3168:
3168  c3        ret
  loc_3169:
3169  89168c32  mov    word ptr [0x328c], dx
316d  e84a02    call   sub_33ba
3170  72f6      jb     loc_3168
3172  e86bf0    call   sub_21e0
3175  72f1      jb     loc_3168
3177  fe06ea32  inc    byte ptr [0x32ea]
317b  e87ffc    call   sub_2dfd
317e  a0ea32    mov    al, byte ptr [0x32ea]
3181  22c2      and    al, dl
3183  3006eb32  xor    byte ptr [0x32eb], al
3187  a17d32    mov    ax, word ptr [0x327d]
318a  2b067905  sub    ax, word ptr [0x579]
318e  b2ff      mov    dl, 0xff
3190  7304      jae    loc_3196
3192  f7d0      not    ax
3194  b201      mov    dl, 1
  loc_3196:
3196  8816ed32  mov    byte ptr [0x32ed], dl
319a  8a1e7f32  mov    bl, byte ptr [0x327f]
319e  80c314    add    bl, 0x14
31a1  2a1e7b05  sub    bl, byte ptr [0x57b]
31a5  b2ff      mov    dl, 0xff
31a7  7304      jae    loc_31ad
31a9  f6d3      not    bl
31ab  b201      mov    dl, 1
  loc_31ad:
31ad  8816ee32  mov    byte ptr [0x32ee], dl
31b1  d1e8      shr    ax, 1
31b3  d1e8      shr    ax, 1
31b5  d0eb      shr    bl, 1
31b7  02c3      add    al, bl
31b9  a2ec32    mov    byte ptr [0x32ec], al
31bc  8b1e8a32  mov    bx, word ptr [0x328a]
31c0  83fb27    cmp    bx, 0x27
31c3  7207      jb     loc_31cc
31c5  bb2600    mov    bx, 0x26
31c8  891e8a32  mov    word ptr [0x328a], bx
  loc_31cc:
31cc  80bf8e3200  cmp    byte ptr [bx + 0x328e], 0
31d1  7578      jne    loc_324b
31d3  ff0e8a32  dec    word ptr [0x328a]
31d7  2ae4      sub    ah, ah
31d9  cd1a      int    0x1a
31db  2b161004  sub    dx, word ptr [0x410]
31df  b103      mov    cl, 3
31e1  d3ea      shr    dx, cl
31e3  a0ec32    mov    al, byte ptr [0x32ec]
31e6  2ac2      sub    al, dl
31e8  7302      jae    loc_31ec
31ea  2ac0      sub    al, al
  loc_31ec:
31ec  3a06eb32  cmp    al, byte ptr [0x32eb]
31f0  7220      jb     loc_3212
31f2  c606813201  mov    byte ptr [0x3281], 1
31f7  e803fc    call   sub_2dfd
31fa  80fa00    cmp    dl, 0
31fd  740c      je     loc_320b
31ff  80fa07    cmp    dl, 7
3202  770b      ja     loc_320f
3204  80e201    and    dl, 1
3207  7502      jne    loc_320b
3209  b2ff      mov    dl, 0xff
  loc_320b:
320b  88168032  mov    byte ptr [0x3280], dl
  loc_320f:
320f  e99a00    jmp    loc_32ac
  loc_3212:
3212  a0eb32    mov    al, byte ptr [0x32eb]
3215  242f      and    al, 0x2f
3217  751f      jne    loc_3238
3219  e8e1fb    call   sub_2dfd
321c  80e201    and    dl, 1
321f  7502      jne    loc_3223
3221  b2ff      mov    dl, 0xff
  loc_3223:
3223  88168032  mov    byte ptr [0x3280], dl
3227  e8d3fb    call   sub_2dfd
322a  80e201    and    dl, 1
322d  7502      jne    loc_3231
322f  b2ff      mov    dl, 0xff
  loc_3231:
3231  88168132  mov    byte ptr [0x3281], dl
3235  eb75      jmp    loc_32ac
3237  db 90   ; .
  loc_3238:
3238  2407      and    al, 7
323a  7570      jne    loc_32ac
323c  a0ed32    mov    al, byte ptr [0x32ed]
323f  a28032    mov    byte ptr [0x3280], al
3242  a0ee32    mov    al, byte ptr [0x32ee]
3245  a28132    mov    byte ptr [0x3281], al
3248  eb62      jmp    loc_32ac
324a  db 90   ; .
  loc_324b:
324b  c606813201  mov    byte ptr [0x3281], 1
3250  8bc3      mov    ax, bx
3252  b103      mov    cl, 3
3254  d3e0      shl    ax, cl
3256  39067d32  cmp    word ptr [0x327d], ax
325a  740d      je     loc_3269
325c  b201      mov    dl, 1
325e  7202      jb     loc_3262
3260  b2ff      mov    dl, 0xff
  loc_3262:
3262  88168032  mov    byte ptr [0x3280], dl
3266  eb44      jmp    loc_32ac
3268  db 90   ; .
  loc_3269:
3269  c606803200  mov    byte ptr [0x3280], 0
326e  803e7f32a5  cmp    byte ptr [0x327f], 0xa5
3273  7537      jne    loc_32ac
3275  c606813200  mov    byte ptr [0x3281], 0
327a  833e7a3206  cmp    word ptr [0x327a], 6
327f  7407      je     loc_3288
3281  833e7a3212  cmp    word ptr [0x327a], 0x12
3286  7524      jne    loc_32ac
  loc_3288:
3288  53        push   bx
3289  bee831    mov    si, 0x31e8
328c  8b3e8232  mov    di, word ptr [0x3282]
3290  b9021e    mov    cx, 0x1e02
3293  b800b8    mov    ax, 0xb800
3296  8ec0      mov    es, ax
3298  e802fb    call   sub_2d9d
329b  5b        pop    bx
329c  fe8f8e32  dec    byte ptr [bx + 0x328e]
32a0  8a878e32  mov    al, byte ptr [bx + 0x328e]
32a4  e8d801    call   sub_347f
32a7  c606863201  mov    byte ptr [0x3286], 1
  loc_32ac:
32ac  8b0e7d32  mov    cx, word ptr [0x327d]
32b0  8a167f32  mov    dl, byte ptr [0x327f]
32b4  890eef32  mov    word ptr [0x32ef], cx
32b8  8816f132  mov    byte ptr [0x32f1], dl
32bc  803e803201  cmp    byte ptr [0x3280], 1
32c1  7217      jb     loc_32da
32c3  750e      jne    loc_32d3
32c5  83c108    add    cx, 8
32c8  81f93101  cmp    cx, 0x131
32cc  720c      jb     loc_32da
32ce  b93001    mov    cx, 0x130
32d1  eb07      jmp    loc_32da
  loc_32d3:
32d3  83e908    sub    cx, 8
32d6  7302      jae    loc_32da
32d8  2bc9      sub    cx, cx
  loc_32da:
32da  81e1f8ff  and    cx, 0xfff8
32de  890e7d32  mov    word ptr [0x327d], cx
32e2  803e813201  cmp    byte ptr [0x3281], 1
32e7  7215      jb     loc_32fe
32e9  750c      jne    loc_32f7
32eb  80c202    add    dl, 2
32ee  80faa6    cmp    dl, 0xa6
32f1  720b      jb     loc_32fe
32f3  b2a5      mov    dl, 0xa5
32f5  eb07      jmp    loc_32fe
  loc_32f7:
32f7  80ea02    sub    dl, 2
32fa  7302      jae    loc_32fe
32fc  2ad2      sub    dl, dl
  loc_32fe:
32fe  88167f32  mov    byte ptr [0x327f], dl
3302  e8abf9    call   sub_2cb0
3305  a38432    mov    word ptr [0x3284], ax
3308  e8af00    call   sub_33ba
330b  731b      jae    loc_3328
  loc_330d:
330d  c606803200  mov    byte ptr [0x3280], 0
3312  c606813200  mov    byte ptr [0x3281], 0
3317  8b0eef32  mov    cx, word ptr [0x32ef]
331b  890e7d32  mov    word ptr [0x327d], cx
331f  8a16f132  mov    dl, byte ptr [0x32f1]
3323  88167f32  mov    byte ptr [0x327f], dl
3327  c3        ret
  loc_3328:
3328  e8b5ee    call   sub_21e0
332b  72e0      jb     loc_330d
332d  e87000    call   sub_33a0
3330  83067a3202  add    word ptr [0x327a], 2
3335  e80100    call   sub_3339
3338  c3        ret

; ----------------------------------------------------------------------
sub_3339:
3339  8b1e7a32  mov    bx, word ptr [0x327a]
333d  8b876032  mov    ax, word ptr [bx + 0x3260]
3341  3d0000    cmp    ax, 0
3344  7505      jne    loc_334b
3346  a37a32    mov    word ptr [0x327a], ax
3349  ebee      jmp    loc_3339
  loc_334b:
334b  8bf0      mov    si, ax
334d  8b3e8432  mov    di, word ptr [0x3284]
3351  893e8232  mov    word ptr [0x3282], di
3355  bde831    mov    bp, 0x31e8
3358  b800b8    mov    ax, 0xb800
335b  8ec0      mov    es, ax
335d  b9021e    mov    cx, 0x1e02
3360  c606863200  mov    byte ptr [0x3286], 0
3365  fc        cld
3366  882e8932  mov    byte ptr [0x3289], ch
336a  2aed      sub    ch, ch
336c  890e8732  mov    word ptr [0x3287], cx
  loc_3370:
3370  8b0e8732  mov    cx, word ptr [0x3287]
  loc_3374:
3374  268b1d    mov    bx, word ptr es:[di]
3377  3e895e00  mov    word ptr ds:[bp], bx
337b  ad        lodsw  ax, word ptr [si]
337c  0bc3      or     ax, bx
337e  ab        stosw  word ptr es:[di], ax
337f  83c502    add    bp, 2
3382  e2f0      loop   loc_3374
3384  2b3e8732  sub    di, word ptr [0x3287]
3388  2b3e8732  sub    di, word ptr [0x3287]
338c  81f70020  xor    di, 0x2000
3390  f7c70020  test   di, 0x2000
3394  7503      jne    loc_3399
3396  83c750    add    di, 0x50
  loc_3399:
3399  fe0e8932  dec    byte ptr [0x3289]
339d  75d1      jne    loc_3370
339f  c3        ret

; ----------------------------------------------------------------------
sub_33a0:
33a0  803e863200  cmp    byte ptr [0x3286], 0
33a5  7512      jne    loc_33b9
33a7  b800b8    mov    ax, 0xb800
33aa  8ec0      mov    es, ax
33ac  bee831    mov    si, 0x31e8
33af  8b3e8232  mov    di, word ptr [0x3282]
33b3  b9021e    mov    cx, 0x1e02
33b6  e8e4f9    call   sub_2d9d
  loc_33b9:
33b9  c3        ret

; ----------------------------------------------------------------------
sub_33ba:
33ba  803eb81c00  cmp    byte ptr [0x1cb8], 0
33bf  7542      jne    loc_3403
33c1  833e040006  cmp    word ptr [4], 6
33c6  750b      jne    loc_33d3
33c8  803ebd4400  cmp    byte ptr [0x44bd], 0
33cd  7404      je     loc_33d3
33cf  e8de13    call   sub_47b0
33d2  c3        ret
  loc_33d3:
33d3  a17d32    mov    ax, word ptr [0x327d]
33d6  8a167f32  mov    dl, byte ptr [0x327f]
33da  be1000    mov    si, 0x10
33dd  8b1e7905  mov    bx, word ptr [0x579]
33e1  8a367b05  mov    dh, byte ptr [0x57b]
33e5  bf1800    mov    di, 0x18
33e8  b91e0e    mov    cx, 0xe1e
33eb  e83bfa    call   sub_2e29
33ee  7313      jae    loc_3403
33f0  833e040004  cmp    word ptr [4], 4
33f5  7507      jne    loc_33fe
33f7  803ee13900  cmp    byte ptr [0x39e1], 0
33fc  7503      jne    loc_3401
  loc_33fe:
33fe  e871d4    call   sub_0872
  loc_3401:
3401  f9        stc
3402  c3        ret
  loc_3403:
3403  f8        clc
3404  c3        ret

; ----------------------------------------------------------------------
sub_3405:
3405  fc        cld
3406  2bc0      sub    ax, ax
3408  1e        push   ds
3409  07        pop    es
340a  bf8e32    mov    di, 0x328e
340d  b91400    mov    cx, 0x14
3410  f3ab      rep stosw word ptr es:[di], ax
3412  c706b632ff00  mov    word ptr [0x32b6], 0xff
3418  c7067a320000  mov    word ptr [0x327a], 0
341e  c7067d320000  mov    word ptr [0x327d], 0
3424  c6067f32a0  mov    byte ptr [0x327f], 0xa0
3429  c606863201  mov    byte ptr [0x3286], 1
342e  c606803200  mov    byte ptr [0x3280], 0
3433  c606813200  mov    byte ptr [0x3281], 0
3438  e8c2f9    call   sub_2dfd
343b  8816eb32  mov    byte ptr [0x32eb], dl
343f  c606ea326c  mov    byte ptr [0x32ea], 0x6c
3444  c3        ret

; ----------------------------------------------------------------------
sub_3445:
3445  803e7b05b4  cmp    byte ptr [0x57b], 0xb4
344a  7232      jb     loc_347e
344c  803e6e0500  cmp    byte ptr [0x56e], 0
3451  742b      je     loc_347e
3453  a17905    mov    ax, word ptr [0x579]
3456  050c00    add    ax, 0xc
3459  b103      mov    cl, 3
345b  d3e8      shr    ax, cl
345d  3d2700    cmp    ax, 0x27
3460  771c      ja     loc_347e
3462  3b06b632  cmp    ax, word ptr [0x32b6]
3466  7416      je     loc_347e
3468  a3b632    mov    word ptr [0x32b6], ax
346b  8bd8      mov    bx, ax
346d  8a878e32  mov    al, byte ptr [bx + 0x328e]
3471  3c04      cmp    al, 4
3473  7309      jae    loc_347e
3475  fec0      inc    al
3477  88878e32  mov    byte ptr [bx + 0x328e], al
347b  e80100    call   sub_347f
  loc_347e:
347e  c3        ret

; ----------------------------------------------------------------------
sub_347f:
347f  b40a      mov    ah, 0xa
3481  f6e4      mul    ah
3483  05b832    add    ax, 0x32b8
3486  8bf0      mov    si, ax
3488  8bfb      mov    di, bx
348a  d1e7      shl    di, 1
348c  81c7001e  add    di, 0x1e00
3490  b800b8    mov    ax, 0xb800
3493  8ec0      mov    es, ax
3495  b90105    mov    cx, 0x501
3498  e802f9    call   sub_2d9d
349b  c3        ret
349c  db 00,00,00,00   ; ....

; ----------------------------------------------------------------------
sub_34a0:
34a0  c70611350000  mov    word ptr [0x3511], 0
34a6  c6061b3500  mov    byte ptr [0x351b], 0
  loc_34ab:
34ab  8b1e1135  mov    bx, word ptr [0x3511]
34af  80bfa73400  cmp    byte ptr [bx + 0x34a7], 0
34b4  7403      je     loc_34b9
  loc_34b6:
34b6  e9f400    jmp    loc_35ad
  loc_34b9:
34b9  8bf3      mov    si, bx
34bb  d1e6      shl    si, 1
34bd  8b844734  mov    ax, word ptr [si + 0x3447]
34c1  8a977734  mov    dl, byte ptr [bx + 0x3477]
34c5  bf0000    mov    di, 0
34c8  83fb0c    cmp    bx, 0xc
34cb  7203      jb     loc_34d0
34cd  bf0200    mov    di, 2
  loc_34d0:
34d0  8bb51335  mov    si, word ptr [di + 0x3513]
34d4  8b8d1735  mov    cx, word ptr [di + 0x3517]
34d8  8b1e7905  mov    bx, word ptr [0x579]
34dc  8a367b05  mov    dh, byte ptr [0x57b]
34e0  bf1800    mov    di, 0x18
34e3  b50e      mov    ch, 0xe
34e5  e841f9    call   sub_2e29
34e8  73cc      jae    loc_34b6
34ea  8b1e1135  mov    bx, word ptr [0x3511]
34ee  83fb0c    cmp    bx, 0xc
34f1  727c      jb     loc_356f
34f3  803e530500  cmp    byte ptr [0x553], 0
34f8  7575      jne    loc_356f
34fa  803ef30500  cmp    byte ptr [0x5f3], 0
34ff  756e      jne    loc_356f
3501  c606520501  mov    byte ptr [0x552], 1
3506  8b0e7905  mov    cx, word ptr [0x579]
350a  83e908    sub    cx, 8
350d  7302      jae    loc_3511
350f  2bc9      sub    cx, cx
  loc_3511:
3511  81f91701  cmp    cx, 0x117
3515  7203      jb     loc_351a
3517  b91601    mov    cx, 0x116
  loc_351a:
351a  8a167b05  mov    dl, byte ptr [0x57b]
351e  80fab5    cmp    dl, 0xb5
3521  7202      jb     loc_3525
3523  b2b4      mov    dl, 0xb4
  loc_3525:
3525  e888f7    call   sub_2cb0
3528  8bf8      mov    di, ax
352a  be5033    mov    si, 0x3350
352d  b800b8    mov    ax, 0xb800
3530  8ec0      mov    es, ax
3532  b90512    mov    cx, 0x1205
3535  e865f8    call   sub_2d9d
3538  e85c22    call   sub_5797
353b  2ae4      sub    ah, ah
353d  cd1a      int    0x1a
353f  89160935  mov    word ptr [0x3509], dx
  loc_3543:
3543  52        push   dx
  loc_3544:
3544  e85f22    call   sub_57a6
3547  e88ede    call   sub_13d8
354a  74f8      je     loc_3544
354c  e85722    call   sub_57a6
354f  5a        pop    dx
3550  bb0100    mov    bx, 1
3553  f6c201    test   dl, 1
3556  7502      jne    loc_355a
3558  b30f      mov    bl, 0xf
  loc_355a:
355a  b40b      mov    ah, 0xb
355c  cd10      int    0x10
355e  e84522    call   sub_57a6
3561  2ae4      sub    ah, ah
3563  cd1a      int    0x1a
3565  2b160935  sub    dx, word ptr [0x3509]
3569  83fa0d    cmp    dx, 0xd
356c  72d5      jb     loc_3543
356e  c3        ret
  loc_356f:
356f  fe061b35  inc    byte ptr [0x351b]
3573  b8dc05    mov    ax, 0x5dc
3576  bb2504    mov    bx, 0x425
3579  e8bf23    call   sub_593b
357c  803e1b3501  cmp    byte ptr [0x351b], 1
3581  7503      jne    loc_3586
3583  e85ddc    call   sub_11e3
  loc_3586:
3586  8b1e1135  mov    bx, word ptr [0x3511]
358a  e83402    call   sub_37c1
358d  8b1e1135  mov    bx, word ptr [0x3511]
3591  c687a73401  mov    byte ptr [bx + 0x34a7], 1
3596  83fb0c    cmp    bx, 0xc
3599  7312      jae    loc_35ad
359b  fe0e1034  dec    byte ptr [0x3410]
359f  750c      jne    loc_35ad
35a1  803ef30500  cmp    byte ptr [0x5f3], 0
35a6  7505      jne    loc_35ad
35a8  c606530501  mov    byte ptr [0x553], 1
  loc_35ad:
35ad  ff061135  inc    word ptr [0x3511]
35b1  833e113518  cmp    word ptr [0x3511], 0x18
35b6  7303      jae    loc_35bb
35b8  e9f0fe    jmp    loc_34ab
  loc_35bb:
35bb  803e1b3500  cmp    byte ptr [0x351b], 0
35c0  7405      je     loc_35c7
35c2  e87800    call   sub_363d
35c5  f9        stc
35c6  c3        ret
  loc_35c7:
35c7  f8        clc
35c8  c3        ret

; ----------------------------------------------------------------------
sub_35c9:
35c9  c70611340000  mov    word ptr [0x3411], 0
35cf  c70615340000  mov    word ptr [0x3415], 0
35d5  c60610340c  mov    byte ptr [0x3410], 0xc
35da  b91800    mov    cx, 0x18
  loc_35dd:
35dd  8bd9      mov    bx, cx
35df  4b        dec    bx
35e0  c6878f3401  mov    byte ptr [bx + 0x348f], 1
35e5  c687a73400  mov    byte ptr [bx + 0x34a7], 0
35ea  8a87f134  mov    al, byte ptr [bx + 0x34f1]
35ee  88877734  mov    byte ptr [bx + 0x3477], al
35f2  c6872f3401  mov    byte ptr [bx + 0x342f], 1
35f7  e803f8    call   sub_2dfd
35fa  80e201    and    dl, 1
35fd  7502      jne    loc_3601
35ff  f6d2      not    dl
  loc_3601:
3601  88971734  mov    byte ptr [bx + 0x3417], dl
3605  d1e3      shl    bx, 1
3607  e8f3f7    call   sub_2dfd
360a  2af6      sub    dh, dh
360c  89974734  mov    word ptr [bx + 0x3447], dx
3610  e2cb      loop   loc_35dd
3612  8b1e0800  mov    bx, word ptr [8]
3616  8a8f1c35  mov    cl, byte ptr [bx + 0x351c]
361a  2aed      sub    ch, ch
  loc_361c:
361c  e8def7    call   sub_2dfd
361f  80e20f    and    dl, 0xf
3622  80fa0c    cmp    dl, 0xc
3625  73f5      jae    loc_361c
3627  8ada      mov    bl, dl
3629  80c30c    add    bl, 0xc
362c  2aff      sub    bh, bh
362e  80bfa73400  cmp    byte ptr [bx + 0x34a7], 0
3633  75e7      jne    loc_361c
3635  c687a73401  mov    byte ptr [bx + 0x34a7], 1
363a  e2e0      loop   loc_361c
363c  c3        ret

; ----------------------------------------------------------------------
sub_363d:
363d  b90c00    mov    cx, 0xc
  loc_3640:
3640  8bd9      mov    bx, cx
3642  83c30b    add    bx, 0xb
3645  80bfa73400  cmp    byte ptr [bx + 0x34a7], 0
364a  7426      je     loc_3672
364c  2bc0      sub    ax, ax
364e  b201      mov    dl, 1
3650  8887a734  mov    byte ptr [bx + 0x34a7], al
3654  813e7905a000  cmp    word ptr [0x579], 0xa0
365a  7705      ja     loc_3661
365c  b82e01    mov    ax, 0x12e
365f  b2ff      mov    dl, 0xff
  loc_3661:
3661  88971734  mov    byte ptr [bx + 0x3417], dl
3665  d0e3      shl    bl, 1
3667  89874734  mov    word ptr [bx + 0x3447], ax
366b  fe0e1b35  dec    byte ptr [0x351b]
366f  75cc      jne    loc_363d
3671  c3        ret
  loc_3672:
3672  e2cc      loop   loc_3640
3674  c3        ret

; ----------------------------------------------------------------------
sub_3675:
3675  2ae4      sub    ah, ah
3677  cd1a      int    0x1a
3679  3b160935  cmp    dx, word ptr [0x3509]
367d  7501      jne    loc_3680
  loc_367f:
367f  c3        ret
  loc_3680:
3680  89160b35  mov    word ptr [0x350b], dx
3684  ff061534  inc    word ptr [0x3415]
3688  8b1e1534  mov    bx, word ptr [0x3415]
368c  83fb18    cmp    bx, 0x18
368f  7213      jb     loc_36a4
3691  2bdb      sub    bx, bx
3693  891e1534  mov    word ptr [0x3415], bx
3697  813611340c00  xor    word ptr [0x3411], 0xc
369d  8306133408  add    word ptr [0x3413], 8
36a2  eb13      jmp    loc_36b7
  loc_36a4:
36a4  83fb0c    cmp    bx, 0xc
36a7  7514      jne    loc_36bd
36a9  803e9706fd  cmp    byte ptr [0x697], 0xfd
36ae  7507      jne    loc_36b7
36b0  803e7b0530  cmp    byte ptr [0x57b], 0x30
36b5  7206      jb     loc_36bd
  loc_36b7:
36b7  a10b35    mov    ax, word ptr [0x350b]
36ba  a30935    mov    word ptr [0x3509], ax
  loc_36bd:
36bd  8bf3      mov    si, bx
36bf  d1e6      shl    si, 1
36c1  80bfa73400  cmp    byte ptr [bx + 0x34a7], 0
36c6  75b7      jne    loc_367f
36c8  e832f7    call   sub_2dfd
36cb  80fa10    cmp    dl, 0x10
36ce  7719      ja     loc_36e9
36d0  80e201    and    dl, 1
36d3  7502      jne    loc_36d7
36d5  f6d2      not    dl
  loc_36d7:
36d7  88971734  mov    byte ptr [bx + 0x3417], dl
36db  e81ff7    call   sub_2dfd
36de  80e201    and    dl, 1
36e1  7502      jne    loc_36e5
36e3  f6d2      not    dl
  loc_36e5:
36e5  88972f34  mov    byte ptr [bx + 0x342f], dl
  loc_36e9:
36e9  b90400    mov    cx, 4
36ec  83fb0c    cmp    bx, 0xc
36ef  7202      jb     loc_36f3
36f1  d0e9      shr    cl, 1
  loc_36f3:
36f3  8b844734  mov    ax, word ptr [si + 0x3447]
36f7  80bf173401  cmp    byte ptr [bx + 0x3417], 1
36fc  740d      je     loc_370b
36fe  2bc1      sub    ax, cx
3700  7318      jae    loc_371a
3702  2bc0      sub    ax, ax
3704  c687173401  mov    byte ptr [bx + 0x3417], 1
3709  eb0f      jmp    loc_371a
  loc_370b:
370b  03c1      add    ax, cx
370d  3d2f01    cmp    ax, 0x12f
3710  7208      jb     loc_371a
3712  b82e01    mov    ax, 0x12e
3715  c6871734ff  mov    byte ptr [bx + 0x3417], 0xff
  loc_371a:
371a  89844734  mov    word ptr [si + 0x3447], ax
371e  8a877734  mov    al, byte ptr [bx + 0x3477]
3722  80bf2f3401  cmp    byte ptr [bx + 0x342f], 1
3727  7413      je     loc_373c
3729  fec8      dec    al
372b  3a87f134  cmp    al, byte ptr [bx + 0x34f1]
372f  731f      jae    loc_3750
3731  8a87f134  mov    al, byte ptr [bx + 0x34f1]
3735  c6872f3401  mov    byte ptr [bx + 0x342f], 1
373a  eb14      jmp    loc_3750
  loc_373c:
373c  fec0      inc    al
373e  8a97f134  mov    dl, byte ptr [bx + 0x34f1]
3742  80c218    add    dl, 0x18
3745  3ac2      cmp    al, dl
3747  7607      jbe    loc_3750
3749  8ac2      mov    al, dl
374b  c6872f34ff  mov    byte ptr [bx + 0x342f], 0xff
  loc_3750:
3750  88877734  mov    byte ptr [bx + 0x3477], al
3754  8ad0      mov    dl, al
3756  8b8c4734  mov    cx, word ptr [si + 0x3447]
375a  e853f5    call   sub_2cb0
375d  a3ef34    mov    word ptr [0x34ef], ax
3760  8b1e1534  mov    bx, word ptr [0x3415]
3764  e85a00    call   sub_37c1
3767  8b1e1534  mov    bx, word ptr [0x3415]
376b  8bf3      mov    si, bx
376d  d1e6      shl    si, 1
376f  8b3eef34  mov    di, word ptr [0x34ef]
3773  89bcbf34  mov    word ptr [si + 0x34bf], di
3777  c6878f3400  mov    byte ptr [bx + 0x348f], 0
377c  b800b8    mov    ax, 0xb800
377f  8ec0      mov    es, ax
3781  83fb0c    cmp    bx, 0xc
3784  7219      jb     loc_379f
3786  8bf3      mov    si, bx
3788  b103      mov    cl, 3
378a  d3e6      shl    si, cl
378c  03361334  add    si, word ptr [0x3413]
3790  81e61800  and    si, 0x18
3794  81c63033  add    si, 0x3330
3798  b90202    mov    cx, 0x202
379b  e8fff5    call   sub_2d9d
379e  c3        ret
  loc_379f:
379f  8b361134  mov    si, word ptr [0x3411]
37a3  f6c301    test   bl, 1
37a6  7504      jne    loc_37ac
37a8  81f60c00  xor    si, 0xc
  loc_37ac:
37ac  80bf173401  cmp    byte ptr [bx + 0x3417], 1
37b1  7403      je     loc_37b6
37b3  83c618    add    si, 0x18
  loc_37b6:
37b6  81c60033  add    si, 0x3300
37ba  b90106    mov    cx, 0x601
37bd  e8ddf5    call   sub_2d9d
37c0  c3        ret

; ----------------------------------------------------------------------
sub_37c1:
37c1  80bf8f3400  cmp    byte ptr [bx + 0x348f], 0
37c6  751c      jne    loc_37e4
37c8  d1e3      shl    bx, 1
37ca  be0434    mov    si, 0x3404
37cd  8bbfbf34  mov    di, word ptr [bx + 0x34bf]
37d1  b800b8    mov    ax, 0xb800
37d4  8ec0      mov    es, ax
37d6  b90106    mov    cx, 0x601
37d9  83fb18    cmp    bx, 0x18
37dc  7203      jb     loc_37e1
37de  b90202    mov    cx, 0x202
  loc_37e1:
37e1  e8b9f5    call   sub_2d9d
  loc_37e4:
37e4  c3        ret

; ----------------------------------------------------------------------
sub_37e5:
37e5  2ae4      sub    ah, ah
37e7  cd1a      int    0x1a
37e9  8bc2      mov    ax, dx
37eb  2b060f35  sub    ax, word ptr [0x350f]
37ef  3d0800    cmp    ax, 8
37f2  7256      jb     loc_384a
37f4  ff060d35  inc    word ptr [0x350d]
37f8  8b1e0d35  mov    bx, word ptr [0x350d]
37fc  83fb28    cmp    bx, 0x28
37ff  720a      jb     loc_380b
3801  2bdb      sub    bx, bx
3803  891e0d35  mov    word ptr [0x350d], bx
3807  89160f35  mov    word ptr [0x350f], dx
  loc_380b:
380b  8bfb      mov    di, bx
380d  d1e7      shl    di, 1
380f  803e7b0507  cmp    byte ptr [0x57b], 7
3814  7713      ja     loc_3829
3816  a17905    mov    ax, word ptr [0x579]
3819  b102      mov    cl, 2
381b  d3e8      shr    ax, cl
381d  40        inc    ax
381e  2bc7      sub    ax, di
3820  7302      jae    loc_3824
3822  f7d0      not    ax
  loc_3824:
3824  3d0400    cmp    ax, 4
3827  7221      jb     loc_384a
  loc_3829:
3829  81c7a000  add    di, 0xa0
382d  8a875626  mov    al, byte ptr [bx + 0x2656]
3831  0408      add    al, 8
3833  88875626  mov    byte ptr [bx + 0x2656], al
3837  251800    and    ax, 0x18
383a  052020    add    ax, 0x2020
383d  8bf0      mov    si, ax
383f  b800b8    mov    ax, 0xb800
3842  8ec0      mov    es, ax
3844  b90104    mov    cx, 0x401
3847  e853f5    call   sub_2d9d
  loc_384a:
384a  c3        ret
384b  db 00,00,00,00,00   ; .....

; ----------------------------------------------------------------------
sub_3850:
3850  2ae4      sub    ah, ah
3852  cd1a      int    0x1a
3854  8bc2      mov    ax, dx
3856  2b06da35  sub    ax, word ptr [0x35da]
385a  3d0600    cmp    ax, 6
385d  7301      jae    loc_3860
385f  c3        ret
  loc_3860:
3860  8916da35  mov    word ptr [0x35da], dx
3864  8306d83502  add    word ptr [0x35d8], 2
3869  8b1ed835  mov    bx, word ptr [0x35d8]
386d  81e30600  and    bx, 6
3871  8bb7d035  mov    si, word ptr [bx + 0x35d0]
3875  bfc915    mov    di, 0x15c9
3878  b800b8    mov    ax, 0xb800
387b  8ec0      mov    es, ax
387d  b9020a    mov    cx, 0xa02
3880  e81af5    call   sub_2d9d
3883  b8e400    mov    ax, 0xe4
3886  b28a      mov    dl, 0x8a
3888  be1000    mov    si, 0x10
388b  8b1e7905  mov    bx, word ptr [0x579]
388f  8a367b05  mov    dh, byte ptr [0x57b]
3893  bf1800    mov    di, 0x18
3896  b90a0e    mov    cx, 0xe0a
3899  e88df5    call   sub_2e29
389c  7305      jae    loc_38a3
389e  c606540501  mov    byte ptr [0x554], 1
  loc_38a3:
38a3  c3        ret
38a4  db 00,00,00,00,00,00,00,00,00,00,00,00   ; ............

; ----------------------------------------------------------------------
sub_38b0:
38b0  833e060007  cmp    word ptr [6], 7
38b5  7503      jne    loc_38ba
38b7  eb1a      jmp    loc_38d3
38b9  db 90   ; .
  loc_38ba:
38ba  ff061404  inc    word ptr [0x414]
38be  c606180401  mov    byte ptr [0x418], 1
38c3  baaaaa    mov    dx, 0xaaaa
38c6  e8cd01    call   sub_3a96
38c9  2bc0      sub    ax, ax
38cb  c6069f3600  mov    byte ptr [0x369f], 0
38d0  e8d901    call   sub_3aac
  loc_38d3:
38d3  2ae4      sub    ah, ah
38d5  cd1a      int    0x1a
38d7  833e060007  cmp    word ptr [6], 7
38dc  7511      jne    loc_38ef
38de  2b161204  sub    dx, word ptr [0x412]
38e2  b8302a    mov    ax, 0x2a30
38e5  2bc2      sub    ax, dx
38e7  7302      jae    loc_38eb
38e9  2bc0      sub    ax, ax
  loc_38eb:
38eb  d1e8      shr    ax, 1
38ed  eb1f      jmp    loc_390e
  loc_38ef:
38ef  2b161004  sub    dx, word ptr [0x410]
38f3  b84605    mov    ax, 0x546
38f6  833e060006  cmp    word ptr [6], 6
38fb  7502      jne    loc_38ff
38fd  d1e0      shl    ax, 1
  loc_38ff:
38ff  2bc2      sub    ax, dx
3901  7302      jae    loc_3905
3903  2bc0      sub    ax, ax
  loc_3905:
3905  833e060006  cmp    word ptr [6], 6
390a  7402      je     loc_390e
390c  d1e0      shl    ax, 1
  loc_390e:
390e  a39736    mov    word ptr [0x3697], ax
3911  e8e001    call   sub_3af4
3914  8b1e0600  mov    bx, word ptr [6]
3918  d0e3      shl    bl, 1
391a  8bb7cc36  mov    si, word ptr [bx + 0x36cc]
391e  bf8d36    mov    di, 0x368d
3921  e8faed    call   sub_271e
3924  833e060007  cmp    word ptr [6], 7
3929  7543      jne    loc_396e
392b  8b1e0800  mov    bx, word ptr [8]
392f  d0e3      shl    bl, 1
3931  8bc3      mov    ax, bx
3933  8b8fdc36  mov    cx, word ptr [bx + 0x36dc]
3937  833e8d2e08  cmp    word ptr [0x2e8d], 8
393c  7305      jae    loc_3943
393e  d1e1      shl    cx, 1
3940  051000    add    ax, 0x10
  loc_3943:
3943  a30c37    mov    word ptr [0x370c], ax
  loc_3946:
3946  be8d36    mov    si, 0x368d
3949  bf821f    mov    di, 0x1f82
394c  51        push   cx
394d  e8ceed    call   sub_271e
3950  59        pop    cx
3951  e2f3      loop   loc_3946
3953  e8a400    call   sub_39fa
3956  c6069e3638  mov    byte ptr [0x369e], 0x38
395b  c606993601  mov    byte ptr [0x3699], 1
3960  c70622374400  mov    word ptr [0x3722], 0x44
3966  e8d100    call   sub_3a3a
3969  e80001    call   sub_3a6c
396c  eb39      jmp    loc_39a7
  loc_396e:
396e  be8d36    mov    si, 0x368d
3971  bf821f    mov    di, 0x1f82
3974  e8a7ed    call   sub_271e
3977  c606993602  mov    byte ptr [0x3699], 2
397c  c70622371e00  mov    word ptr [0x3722], 0x1e
3982  baffff    mov    dx, 0xffff
3985  e80e01    call   sub_3a96
3988  b88c0a    mov    ax, 0xa8c
398b  2b069736  sub    ax, word ptr [0x3697]
398f  b104      mov    cl, 4
3991  d3e8      shr    ax, cl
3993  24f0      and    al, 0xf0
3995  a29e36    mov    byte ptr [0x369e], al
3998  b428      mov    ah, 0x28
399a  f6e4      mul    ah
399c  c6069f3601  mov    byte ptr [0x369f], 1
39a1  e80801    call   sub_3aac
39a4  e89300    call   sub_3a3a
  loc_39a7:
39a7  2ae4      sub    ah, ah
39a9  cd1a      int    0x1a
39ab  89169536  mov    word ptr [0x3695], dx
  loc_39af:
39af  833e060007  cmp    word ptr [6], 7
39b4  7505      jne    loc_39bb
39b6  e8aa21    call   sub_5b63
39b9  eb03      jmp    loc_39be
  loc_39bb:
39bb  e8771e    call   sub_5835
  loc_39be:
39be  e85b00    call   sub_3a1c
39c1  2b169536  sub    dx, word ptr [0x3695]
39c5  3b162237  cmp    dx, word ptr [0x3722]
39c9  72e4      jb     loc_39af
39cb  2bdb      sub    bx, bx
39cd  b40b      mov    ah, 0xb
39cf  cd10      int    0x10
39d1  833e060007  cmp    word ptr [6], 7
39d6  7404      je     loc_39dc
39d8  e84621    call   sub_5b21
39db  c3        ret
  loc_39dc:
39dc  b800b8    mov    ax, 0xb800
39df  8ec0      mov    es, ax
39e1  be0e00    mov    si, 0xe
39e4  bfe408    mov    di, 0x8e4
39e7  b90408    mov    cx, 0x804
39ea  e8b0f3    call   sub_2d9d
39ed  be4e00    mov    si, 0x4e
39f0  bf940c    mov    di, 0xc94
39f3  b91408    mov    cx, 0x814
39f6  e8a4f3    call   sub_2d9d
39f9  c3        ret

; ----------------------------------------------------------------------
sub_39fa:
39fa  1e        push   ds
39fb  07        pop    es
39fc  b800b8    mov    ax, 0xb800
39ff  8ed8      mov    ds, ax
3a01  b90408    mov    cx, 0x804
3a04  bf0e00    mov    di, 0xe
3a07  bee408    mov    si, 0x8e4
3a0a  e8bdf3    call   sub_2dca
3a0d  b91408    mov    cx, 0x814
3a10  bf4e00    mov    di, 0x4e
3a13  be940c    mov    si, 0xc94
3a16  e8b1f3    call   sub_2dca
3a19  06        push   es
3a1a  1f        pop    ds
3a1b  c3        ret

; ----------------------------------------------------------------------
sub_3a1c:
3a1c  2ae4      sub    ah, ah
3a1e  cd1a      int    0x1a
3a20  52        push   dx
  loc_3a21:
3a21  e8b4d9    call   sub_13d8
3a24  74fb      je     loc_3a21
3a26  5a        pop    dx
3a27  52        push   dx
3a28  2bdb      sub    bx, bx
3a2a  f7c20400  test   dx, 4
3a2e  7504      jne    loc_3a34
3a30  8a1e9936  mov    bl, byte ptr [0x3699]
  loc_3a34:
3a34  b40b      mov    ah, 0xb
3a36  cd10      int    0x10
3a38  5a        pop    dx
3a39  c3        ret

; ----------------------------------------------------------------------
sub_3a3a:
3a3a  b402      mov    ah, 2
3a3c  8a369e36  mov    dh, byte ptr [0x369e]
3a40  b103      mov    cl, 3
3a42  d2ee      shr    dh, cl
3a44  b212      mov    dl, 0x12
3a46  2aff      sub    bh, bh
3a48  cd10      int    0x10
3a4a  c706a0360300  mov    word ptr [0x36a0], 3
  loc_3a50:
3a50  8b1ea036  mov    bx, word ptr [0x36a0]
3a54  8a878d36  mov    al, byte ptr [bx + 0x368d]
3a58  0430      add    al, 0x30
3a5a  b40e      mov    ah, 0xe
3a5c  b303      mov    bl, 3
3a5e  cd10      int    0x10
3a60  ff06a036  inc    word ptr [0x36a0]
3a64  833ea03607  cmp    word ptr [0x36a0], 7
3a69  72e5      jb     loc_3a50
3a6b  c3        ret

; ----------------------------------------------------------------------
sub_3a6c:
3a6c  b402      mov    ah, 2
3a6e  b20a      mov    dl, 0xa
3a70  8af2      mov    dh, dl
3a72  2bdb      sub    bx, bx
3a74  cd10      int    0x10
3a76  8b1e0c37  mov    bx, word ptr [0x370c]
3a7a  8b87ec36  mov    ax, word ptr [bx + 0x36ec]
3a7e  a32037    mov    word ptr [0x3720], ax
3a81  2bdb      sub    bx, bx
  loc_3a83:
3a83  b40e      mov    ah, 0xe
3a85  8a870e37  mov    al, byte ptr [bx + 0x370e]
3a89  53        push   bx
3a8a  b303      mov    bl, 3
3a8c  cd10      int    0x10
3a8e  5b        pop    bx
3a8f  43        inc    bx
3a90  83fb14    cmp    bx, 0x14
3a93  72ee      jb     loc_3a83
3a95  c3        ret

; ----------------------------------------------------------------------
sub_3a96:
3a96  fc        cld
3a97  b81000    mov    ax, 0x10
3a9a  8ec0      mov    es, ax
3a9c  bf0e00    mov    di, 0xe
3a9f  bee035    mov    si, 0x35e0
3aa2  b91e00    mov    cx, 0x1e
  loc_3aa5:
3aa5  ad        lodsw  ax, word ptr [si]
3aa6  23c2      and    ax, dx
3aa8  ab        stosw  word ptr es:[di], ax
3aa9  e2fa      loop   loc_3aa5
3aab  c3        ret

; ----------------------------------------------------------------------
sub_3aac:
3aac  a39a36    mov    word ptr [0x369a], ax
3aaf  b800b8    mov    ax, 0xb800
3ab2  8ec0      mov    es, ax
3ab4  e8721d    call   sub_5829
3ab7  b8801b    mov    ax, 0x1b80
  loc_3aba:
3aba  bb1c36    mov    bx, 0x361c
3abd  a39c36    mov    word ptr [0x369c], ax
3ac0  e861f0    call   sub_2b24
3ac3  803e9f3600  cmp    byte ptr [0x369f], 0
3ac8  7418      je     loc_3ae2
3aca  e89c1d    call   sub_5869
3acd  2ae4      sub    ah, ah
3acf  cd1a      int    0x1a
3ad1  89169536  mov    word ptr [0x3695], dx
  loc_3ad5:
3ad5  2ae4      sub    ah, ah
3ad7  cd1a      int    0x1a
3ad9  2b169536  sub    dx, word ptr [0x3695]
3add  83fa02    cmp    dx, 2
3ae0  72f3      jb     loc_3ad5
  loc_3ae2:
3ae2  a19c36    mov    ax, word ptr [0x369c]
3ae5  2d8002    sub    ax, 0x280
3ae8  7206      jb     loc_3af0
3aea  3b069a36  cmp    ax, word ptr [0x369a]
3aee  73ca      jae    loc_3aba
  loc_3af0:
3af0  e82e20    call   sub_5b21
3af3  c3        ret

; ----------------------------------------------------------------------
sub_3af4:
3af4  a38b36    mov    word ptr [0x368b], ax
3af7  2bc0      sub    ax, ax
3af9  a38d36    mov    word ptr [0x368d], ax
3afc  a38f36    mov    word ptr [0x368f], ax
3aff  a39136    mov    word ptr [0x3691], ax
3b02  a39336    mov    word ptr [0x3693], ax
3b05  bb8436    mov    bx, 0x3684
3b08  ba0010    mov    dx, 0x1000
  loc_3b0b:
3b0b  85168b36  test   word ptr [0x368b], dx
3b0f  7408      je     loc_3b19
3b11  8bf3      mov    si, bx
3b13  bf8d36    mov    di, 0x368d
3b16  e805ec    call   sub_271e
  loc_3b19:
3b19  83eb07    sub    bx, 7
3b1c  d1ea      shr    dx, 1
3b1e  73eb      jae    loc_3b0b
3b20  c3        ret
3b21  db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00   ; ...............

; ----------------------------------------------------------------------
sub_3b30:
3b30  c606af3703  mov    byte ptr [0x37af], 3
3b35  b80100    mov    ax, 1
3b38  a3b037    mov    word ptr [0x37b0], ax
3b3b  a3b237    mov    word ptr [0x37b2], ax
3b3e  a3b437    mov    word ptr [0x37b4], ax
3b41  c3        ret

; ----------------------------------------------------------------------
sub_3b42:
3b42  2ae4      sub    ah, ah
3b44  cd1a      int    0x1a
3b46  3b16b837  cmp    dx, word ptr [0x37b8]
3b4a  7501      jne    loc_3b4d
3b4c  c3        ret
  loc_3b4d:
3b4d  8916b837  mov    word ptr [0x37b8], dx
3b51  c706b6370400  mov    word ptr [0x37b6], 4
  loc_3b57:
3b57  8b1eb637  mov    bx, word ptr [0x37b6]
3b5b  83bfb03700  cmp    word ptr [bx + 0x37b0], 0
3b60  7439      je     loc_3b9b
3b62  8b87a337  mov    ax, word ptr [bx + 0x37a3]
3b66  b218      mov    dl, 0x18
3b68  be1000    mov    si, 0x10
3b6b  8b1e7905  mov    bx, word ptr [0x579]
3b6f  8a367b05  mov    dh, byte ptr [0x57b]
3b73  bf1800    mov    di, 0x18
3b76  b9100e    mov    cx, 0xe10
3b79  e8adf2    call   sub_2e29
3b7c  731d      jae    loc_3b9b
3b7e  b8000c    mov    ax, 0xc00
3b81  bbfd08    mov    bx, 0x8fd
3b84  e8b41d    call   sub_593b
3b87  e859d6    call   sub_11e3
3b8a  e8ab02    call   sub_3e38
3b8d  8b1eb637  mov    bx, word ptr [0x37b6]
3b91  e80f00    call   sub_3ba3
3b94  e88dd5    call   sub_1124
3b97  e87a02    call   sub_3e14
3b9a  c3        ret
  loc_3b9b:
3b9b  832eb63702  sub    word ptr [0x37b6], 2
3ba0  73b5      jae    loc_3b57
3ba2  c3        ret

; ----------------------------------------------------------------------
sub_3ba3:
3ba3  c787b0370000  mov    word ptr [bx + 0x37b0], 0
3ba9  1e        push   ds
3baa  07        pop    es
3bab  fc        cld
3bac  b8aaaa    mov    ax, 0xaaaa
3baf  bf0e00    mov    di, 0xe
3bb2  8bf7      mov    si, di
3bb4  b92000    mov    cx, 0x20
3bb7  f3ab      rep stosw word ptr es:[di], ax
3bb9  8bbfa937  mov    di, word ptr [bx + 0x37a9]
3bbd  b800b8    mov    ax, 0xb800
3bc0  8ec0      mov    es, ax
3bc2  b90210    mov    cx, 0x1002
3bc5  e8d5f1    call   sub_2d9d
3bc8  fe0eaf37  dec    byte ptr [0x37af]
3bcc  750c      jne    loc_3bda
3bce  803e520500  cmp    byte ptr [0x552], 0
3bd3  7505      jne    loc_3bda
3bd5  c606530501  mov    byte ptr [0x553], 1
  loc_3bda:
3bda  c3        ret

; ----------------------------------------------------------------------
sub_3bdb:
3bdb  b800b8    mov    ax, 0xb800
3bde  8ec0      mov    es, ax
3be0  c706a0376a06  mov    word ptr [0x37a0], 0x66a
3be6  b91000    mov    cx, 0x10
  loc_3be9:
3be9  2bc0      sub    ax, ax
3beb  8bd8      mov    bx, ax
  loc_3bed:
3bed  a2a237    mov    byte ptr [0x37a2], al
3bf0  2ae4      sub    ah, ah
3bf2  053037    add    ax, 0x3730
3bf5  8bf0      mov    si, ax
3bf7  8b3ea037  mov    di, word ptr [0x37a0]
3bfb  03fb      add    di, bx
3bfd  51        push   cx
3bfe  b90108    mov    cx, 0x801
3c01  53        push   bx
3c02  e898f1    call   sub_2d9d
3c05  5b        pop    bx
3c06  59        pop    cx
3c07  83c302    add    bx, 2
3c0a  83fb1e    cmp    bx, 0x1e
3c0d  720f      jb     loc_3c1e
3c0f  7504      jne    loc_3c15
3c11  b020      mov    al, 0x20
3c13  ebd8      jmp    loc_3bed
  loc_3c15:
3c15  8106a0374001  add    word ptr [0x37a0], 0x140
3c1b  e2cc      loop   loc_3be9
3c1d  c3        ret
  loc_3c1e:
3c1e  803ea23750  cmp    byte ptr [0x37a2], 0x50
3c23  7411      je     loc_3c36
3c25  f6c101    test   cl, 1
3c28  750c      jne    loc_3c36
3c2a  e8d0f1    call   sub_2dfd
3c2d  80fa40    cmp    dl, 0x40
3c30  7204      jb     loc_3c36
3c32  b010      mov    al, 0x10
3c34  ebb7      jmp    loc_3bed
  loc_3c36:
3c36  e8c4f1    call   sub_2dfd
3c39  8ac2      mov    al, dl
3c3b  2ac3      sub    al, bl
3c3d  2430      and    al, 0x30
3c3f  0430      add    al, 0x30
3c41  ebaa      jmp    loc_3bed

; ----------------------------------------------------------------------
sub_3c43:
3c43  a17905    mov    ax, word ptr [0x579]
3c46  25fcff    and    ax, 0xfffc
3c49  3da400    cmp    ax, 0xa4
3c4c  7231      jb     loc_3c7f
3c4e  3d1801    cmp    ax, 0x118
3c51  772c      ja     loc_3c7f
3c53  8a167b05  mov    dl, byte ptr [0x57b]
3c57  80ea02    sub    dl, 2
3c5a  80e2f8    and    dl, 0xf8
3c5d  f6c208    test   dl, 8
3c60  741d      je     loc_3c7f
3c62  80fa28    cmp    dl, 0x28
3c65  7218      jb     loc_3c7f
3c67  80faa0    cmp    dl, 0xa0
3c6a  7713      ja     loc_3c7f
3c6c  a37905    mov    word ptr [0x579], ax
3c6f  80c202    add    dl, 2
3c72  88167b05  mov    byte ptr [0x57b], dl
3c76  80c232    add    dl, 0x32
3c79  88167c05  mov    byte ptr [0x57c], dl
3c7d  f9        stc
3c7e  c3        ret
  loc_3c7f:
3c7f  f8        clc
3c80  c3        ret
3c81  db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00   ; ...............

; ----------------------------------------------------------------------
sub_3c90:
3c90  c606663908  mov    byte ptr [0x3966], 8
3c95  c6066a3901  mov    byte ptr [0x396a], 1
3c9a  c606673900  mov    byte ptr [0x3967], 0
3c9f  c6066d3902  mov    byte ptr [0x396d], 2
3ca4  c70664391801  mov    word ptr [0x3964], 0x118
3caa  c7066b390000  mov    word ptr [0x396b], 0
3cb0  c3        ret

; ----------------------------------------------------------------------
sub_3cb1:
3cb1  2ae4      sub    ah, ah
3cb3  cd1a      int    0x1a
3cb5  8bc2      mov    ax, dx
3cb7  2b06c839  sub    ax, word ptr [0x39c8]
3cbb  3d0200    cmp    ax, 2
3cbe  7301      jae    loc_3cc1
  loc_3cc0:
3cc0  c3        ret
  loc_3cc1:
3cc1  8916c839  mov    word ptr [0x39c8], dx
3cc5  e88a01    call   sub_3e52
3cc8  72f6      jb     loc_3cc0
3cca  e8a101    call   sub_3e6e
3ccd  7303      jae    loc_3cd2
3ccf  e9be00    jmp    loc_3d90
  loc_3cd2:
3cd2  8b1e0800  mov    bx, word ptr [8]
3cd6  d0e3      shl    bl, 1
3cd8  8b87cc39  mov    ax, word ptr [bx + 0x39cc]
3cdc  a3c639    mov    word ptr [0x39c6], ax
3cdf  a16439    mov    ax, word ptr [0x3964]
3ce2  a3c339    mov    word ptr [0x39c3], ax
3ce5  8a166639  mov    dl, byte ptr [0x3966]
3ce9  8816c539  mov    byte ptr [0x39c5], dl
3ced  80fa08    cmp    dl, 8
3cf0  7533      jne    loc_3d25
3cf2  25f8ff    and    ax, 0xfff8
3cf5  8b167905  mov    dx, word ptr [0x579]
3cf9  81e2f8ff  and    dx, 0xfff8
3cfd  3bc2      cmp    ax, dx
3cff  750c      jne    loc_3d0d
3d01  c606673901  mov    byte ptr [0x3967], 1
3d06  c6066e3901  mov    byte ptr [0x396e], 1
3d0b  eb18      jmp    loc_3d25
  loc_3d0d:
3d0d  a16439    mov    ax, word ptr [0x3964]
3d10  720a      jb     loc_3d1c
3d12  2b06c639  sub    ax, word ptr [0x39c6]
3d16  7308      jae    loc_3d20
3d18  2bc0      sub    ax, ax
3d1a  eb04      jmp    loc_3d20
  loc_3d1c:
3d1c  0306c639  add    ax, word ptr [0x39c6]
  loc_3d20:
3d20  a36439    mov    word ptr [0x3964], ax
3d23  eb54      jmp    loc_3d79
  loc_3d25:
3d25  a06639    mov    al, byte ptr [0x3966]
3d28  fe066e39  inc    byte ptr [0x396e]
3d2c  8a166e39  mov    dl, byte ptr [0x396e]
3d30  d0ea      shr    dl, 1
3d32  d0ea      shr    dl, 1
3d34  80e203    and    dl, 3
3d37  80c202    add    dl, 2
3d3a  803e673901  cmp    byte ptr [0x3967], 1
3d3f  7411      je     loc_3d52
3d41  2ac2      sub    al, dl
3d43  7204      jb     loc_3d49
3d45  3c09      cmp    al, 9
3d47  732d      jae    loc_3d76
  loc_3d49:
3d49  b008      mov    al, 8
3d4b  c606673900  mov    byte ptr [0x3967], 0
3d50  eb24      jmp    loc_3d76
  loc_3d52:
3d52  02c2      add    al, dl
3d54  3a067b05  cmp    al, byte ptr [0x57b]
3d58  7717      ja     loc_3d71
3d5a  8b1e6439  mov    bx, word ptr [0x3964]
3d5e  2b1e7905  sub    bx, word ptr [0x579]
3d62  7302      jae    loc_3d66
3d64  f7d3      not    bx
  loc_3d66:
3d66  83fb30    cmp    bx, 0x30
3d69  7706      ja     loc_3d71
3d6b  3ca0      cmp    al, 0xa0
3d6d  7207      jb     loc_3d76
3d6f  b09f      mov    al, 0x9f
  loc_3d71:
3d71  c6066739ff  mov    byte ptr [0x3967], 0xff
  loc_3d76:
3d76  a26639    mov    byte ptr [0x3966], al
  loc_3d79:
3d79  e8d600    call   sub_3e52
3d7c  730d      jae    loc_3d8b
3d7e  a1c339    mov    ax, word ptr [0x39c3]
3d81  a36439    mov    word ptr [0x3964], ax
3d84  a0c539    mov    al, byte ptr [0x39c5]
3d87  a26639    mov    byte ptr [0x3966], al
3d8a  c3        ret
  loc_3d8b:
3d8b  e8e000    call   sub_3e6e
3d8e  735e      jae    loc_3dee
  loc_3d90:
3d90  803e530500  cmp    byte ptr [0x553], 0
3d95  7401      je     loc_3d98
3d97  c3        ret
  loc_3d98:
3d98  8b0e7905  mov    cx, word ptr [0x579]
3d9c  83e90c    sub    cx, 0xc
3d9f  7302      jae    loc_3da3
3da1  2bc9      sub    cx, cx
  loc_3da3:
3da3  81f90f01  cmp    cx, 0x10f
3da7  7203      jb     loc_3dac
3da9  b90e01    mov    cx, 0x10e
  loc_3dac:
3dac  8a167b05  mov    dl, byte ptr [0x57b]
3db0  80ea04    sub    dl, 4
3db3  7302      jae    loc_3db7
3db5  2ad2      sub    dl, dl
  loc_3db7:
3db7  e8f6ee    call   sub_2cb0
3dba  8bf8      mov    di, ax
3dbc  b800b8    mov    ax, 0xb800
3dbf  8ec0      mov    es, ax
3dc1  bec037    mov    si, 0x37c0
3dc4  bd0e00    mov    bp, 0xe
3dc7  b90615    mov    cx, 0x1506
3dca  e8ffee    call   sub_2ccc
3dcd  e82419    call   sub_56f4
3dd0  2ae4      sub    ah, ah
3dd2  cd1a      int    0x1a
3dd4  8916c839  mov    word ptr [0x39c8], dx
  loc_3dd8:
3dd8  e82919    call   sub_5704
3ddb  2ae4      sub    ah, ah
3ddd  cd1a      int    0x1a
3ddf  2b16c839  sub    dx, word ptr [0x39c8]
3de3  83fa09    cmp    dx, 9
3de6  72f0      jb     loc_3dd8
3de8  c606520501  mov    byte ptr [0x552], 1
3ded  c3        ret
  loc_3dee:
3dee  8b0e6439  mov    cx, word ptr [0x3964]
3df2  8a166639  mov    dl, byte ptr [0x3966]
3df6  e8b7ee    call   sub_2cb0
3df9  a3ca39    mov    word ptr [0x39ca], ax
3dfc  e83900    call   sub_3e38
3dff  fe0e6d39  dec    byte ptr [0x396d]
3e03  750b      jne    loc_3e10
3e05  c6066d3902  mov    byte ptr [0x396d], 2
3e0a  81366b395400  xor    word ptr [0x396b], 0x54
  loc_3e10:
3e10  e80100    call   sub_3e14
3e13  c3        ret

; ----------------------------------------------------------------------
sub_3e14:
3e14  b800b8    mov    ax, 0xb800
3e17  8ec0      mov    es, ax
3e19  8b3eca39  mov    di, word ptr [0x39ca]
3e1d  893e6839  mov    word ptr [0x3968], di
3e21  bd6f39    mov    bp, 0x396f
3e24  c6066a3900  mov    byte ptr [0x396a], 0
3e29  8b366b39  mov    si, word ptr [0x396b]
3e2d  81c6bc38  add    si, 0x38bc
3e31  b9030e    mov    cx, 0xe03
3e34  e895ee    call   sub_2ccc
3e37  c3        ret

; ----------------------------------------------------------------------
sub_3e38:
3e38  b800b8    mov    ax, 0xb800
3e3b  8ec0      mov    es, ax
3e3d  803e6a3900  cmp    byte ptr [0x396a], 0
3e42  750d      jne    loc_3e51
3e44  8b3e6839  mov    di, word ptr [0x3968]
3e48  be6f39    mov    si, 0x396f
3e4b  b9030e    mov    cx, 0xe03
3e4e  e84cef    call   sub_2d9d
  loc_3e51:
3e51  c3        ret

; ----------------------------------------------------------------------
sub_3e52:
3e52  a16439    mov    ax, word ptr [0x3964]
3e55  8a166639  mov    dl, byte ptr [0x3966]
3e59  be1800    mov    si, 0x18
3e5c  8b1e7d32  mov    bx, word ptr [0x327d]
3e60  8a367f32  mov    dh, byte ptr [0x327f]
3e64  bf1000    mov    di, 0x10
3e67  b90e1e    mov    cx, 0x1e0e
3e6a  e8bcef    call   sub_2e29
3e6d  c3        ret

; ----------------------------------------------------------------------
sub_3e6e:
3e6e  a16439    mov    ax, word ptr [0x3964]
3e71  8a166639  mov    dl, byte ptr [0x3966]
3e75  be1800    mov    si, 0x18
3e78  8bfe      mov    di, si
3e7a  8b1e7905  mov    bx, word ptr [0x579]
3e7e  8a367b05  mov    dh, byte ptr [0x57b]
3e82  b90e0e    mov    cx, 0xe0e
3e85  e8a1ef    call   sub_2e29
3e88  c3        ret
3e89  db 00,00,00,00,00,00,00   ; .......

; ----------------------------------------------------------------------
sub_3e90:
3e90  803ee13900  cmp    byte ptr [0x39e1], 0
3e95  740d      je     loc_3ea4
3e97  2ae4      sub    ah, ah
3e99  cd1a      int    0x1a
3e9b  3b16163d  cmp    dx, word ptr [0x3d16]
3e9f  7418      je     loc_3eb9
3ea1  e99100    jmp    loc_3f35
  loc_3ea4:
3ea4  803e840500  cmp    byte ptr [0x584], 0
3ea9  750e      jne    loc_3eb9
3eab  803e9a0600  cmp    byte ptr [0x69a], 0
3eb0  7507      jne    loc_3eb9
3eb2  803ee03900  cmp    byte ptr [0x39e0], 0
3eb7  7501      jne    loc_3eba
  loc_3eb9:
3eb9  c3        ret
  loc_3eba:
3eba  e8a801    call   sub_4065
3ebd  72fa      jb     loc_3eb9
3ebf  2ae4      sub    ah, ah
3ec1  cd1a      int    0x1a
3ec3  8bc2      mov    ax, dx
3ec5  2b06183d  sub    ax, word ptr [0x3d18]
3ec9  3d0c00    cmp    ax, 0xc
3ecc  72eb      jb     loc_3eb9
3ece  8916183d  mov    word ptr [0x3d18], dx
3ed2  c6065c0500  mov    byte ptr [0x55c], 0
3ed7  8a1ee039  mov    bl, byte ptr [0x39e0]
3edb  fecb      dec    bl
3edd  2aff      sub    bh, bh
3edf  8bf3      mov    si, bx
3ee1  b102      mov    cl, 2
3ee3  d3e6      shl    si, cl
3ee5  8b845a3c  mov    ax, word ptr [si + 0x3c5a]
3ee9  a3e239    mov    word ptr [0x39e2], ax
3eec  2bc0      sub    ax, ax
3eee  80fb03    cmp    bl, 3
3ef1  7302      jae    loc_3ef5
3ef3  b080      mov    al, 0x80
  loc_3ef5:
3ef5  a3e439    mov    word ptr [0x39e4], ax
3ef8  8a9fe33c  mov    bl, byte ptr [bx + 0x3ce3]
3efc  8bf3      mov    si, bx
3efe  b102      mov    cl, 2
3f00  d3e6      shl    si, cl
3f02  8b845a3c  mov    ax, word ptr [si + 0x3c5a]
3f06  a3e639    mov    word ptr [0x39e6], ax
3f09  2bc0      sub    ax, ax
3f0b  80fb03    cmp    bl, 3
3f0e  7302      jae    loc_3f12
3f10  b080      mov    al, 0x80
  loc_3f12:
3f12  a3e839    mov    word ptr [0x39e8], ax
3f15  8a875010  mov    al, byte ptr [bx + 0x1050]
3f19  a2053d    mov    byte ptr [0x3d05], al
3f1c  d0e3      shl    bl, 1
3f1e  8b873711  mov    ax, word ptr [bx + 0x1137]
3f22  050800    add    ax, 8
3f25  a3033d    mov    word ptr [0x3d03], ax
3f28  e8b8d2    call   sub_11e3
3f2b  c606e1390e  mov    byte ptr [0x39e1], 0xe
3f30  c6069a0610  mov    byte ptr [0x69a], 0x10
  loc_3f35:
3f35  803ebf1c00  cmp    byte ptr [0x1cbf], 0
3f3a  7503      jne    loc_3f3f
3f3c  e861f4    call   sub_33a0
  loc_3f3f:
3f3f  802ee13902  sub    byte ptr [0x39e1], 2
3f44  2aff      sub    bh, bh
3f46  8a1ee139  mov    bl, byte ptr [0x39e1]
3f4a  80fb08    cmp    bl, 8
3f4d  7209      jb     loc_3f58
3f4f  8b3ee239  mov    di, word ptr [0x39e2]
3f53  a1e439    mov    ax, word ptr [0x39e4]
3f56  eb18      jmp    loc_3f70
  loc_3f58:
3f58  8b3ee639  mov    di, word ptr [0x39e6]
3f5c  a0053d    mov    al, byte ptr [0x3d05]
3f5f  a27b05    mov    byte ptr [0x57b], al
3f62  0432      add    al, 0x32
3f64  a27c05    mov    byte ptr [0x57c], al
3f67  a1033d    mov    ax, word ptr [0x3d03]
3f6a  a37905    mov    word ptr [0x579], ax
3f6d  a1e839    mov    ax, word ptr [0x39e8]
  loc_3f70:
3f70  0387063d  add    ax, word ptr [bx + 0x3d06]
3f74  8bf0      mov    si, ax
3f76  b800b8    mov    ax, 0xb800
3f79  8ec0      mov    es, ax
3f7b  b90210    mov    cx, 0x1002
3f7e  e81cee    call   sub_2d9d
3f81  803ebf1c00  cmp    byte ptr [0x1cbf], 0
3f86  7503      jne    loc_3f8b
3f88  e8aef3    call   sub_3339
  loc_3f8b:
3f8b  2ae4      sub    ah, ah
3f8d  cd1a      int    0x1a
3f8f  8916163d  mov    word ptr [0x3d16], dx
3f93  803ee13900  cmp    byte ptr [0x39e1], 0
3f98  7503      jne    loc_3f9d
3f9a  e875d1    call   sub_1112
  loc_3f9d:
3f9d  c3        ret

; ----------------------------------------------------------------------
sub_3f9e:
3f9e  b800b8    mov    ax, 0xb800
3fa1  8ec0      mov    es, ax
3fa3  c606e03900  mov    byte ptr [0x39e0], 0
3fa8  c606e13900  mov    byte ptr [0x39e1], 0
3fad  c706bf3c0605  mov    word ptr [0x3cbf], 0x506
3fb3  c706c13c0000  mov    word ptr [0x3cc1], 0
  loc_3fb9:
3fb9  8b1ec13c  mov    bx, word ptr [0x3cc1]
3fbd  8a8fae3c  mov    cl, byte ptr [bx + 0x3cae]
3fc1  2bdb      sub    bx, bx
3fc3  8aeb      mov    ch, bl
  loc_3fc5:
3fc5  beea3a    mov    si, 0x3aea
3fc8  e832ee    call   sub_2dfd
3fcb  80fa30    cmp    dl, 0x30
3fce  770b      ja     loc_3fdb
3fd0  bef83a    mov    si, 0x3af8
3fd3  f6c204    test   dl, 4
3fd6  7503      jne    loc_3fdb
3fd8  be023b    mov    si, 0x3b02
  loc_3fdb:
3fdb  8b3ebf3c  mov    di, word ptr [0x3cbf]
3fdf  03fb      add    di, bx
3fe1  51        push   cx
3fe2  53        push   bx
3fe3  b90108    mov    cx, 0x801
3fe6  e8b4ed    call   sub_2d9d
3fe9  5b        pop    bx
3fea  59        pop    cx
3feb  83c302    add    bx, 2
3fee  e2d5      loop   loc_3fc5
3ff0  8106bf3c4001  add    word ptr [0x3cbf], 0x140
3ff6  ff06c13c  inc    word ptr [0x3cc1]
3ffa  833ec13c11  cmp    word ptr [0x3cc1], 0x11
3fff  72b8      jb     loc_3fb9
4001  bb223c    mov    bx, 0x3c22
4004  2bc0      sub    ax, ax
4006  e81beb    call   sub_2b24
4009  bb3e3c    mov    bx, 0x3c3e
400c  2bc0      sub    ax, ax
400e  e813eb    call   sub_2b24
4011  bb9a3c    mov    bx, 0x3c9a
4014  2bc0      sub    ax, ax
4016  e80beb    call   sub_2b24
4019  bb563c    mov    bx, 0x3c56
401c  2bc0      sub    ax, ax
401e  e803eb    call   sub_2b24
4021  beaa3c    mov    si, 0x3caa
4024  bfec08    mov    di, 0x8ec
4027  b90201    mov    cx, 0x102
402a  bd0e00    mov    bp, 0xe
402d  e805ed    call   sub_2d35
4030  2bf6      sub    si, si
4032  8b1e0800  mov    bx, word ptr [8]
4036  b103      mov    cl, 3
4038  22d9      and    bl, cl
403a  d2e3      shl    bl, cl
  loc_403c:
403c  8a87c33c  mov    al, byte ptr [bx + 0x3cc3]
4040  8ae0      mov    ah, al
4042  b104      mov    cl, 4
4044  d2e8      shr    al, cl
4046  8884e33c  mov    byte ptr [si + 0x3ce3], al
404a  c684f33c00  mov    byte ptr [si + 0x3cf3], 0
404f  80e40f    and    ah, 0xf
4052  88a4e43c  mov    byte ptr [si + 0x3ce4], ah
4056  c684f43c00  mov    byte ptr [si + 0x3cf4], 0
405b  83c602    add    si, 2
405e  43        inc    bx
405f  83fe10    cmp    si, 0x10
4062  72d8      jb     loc_403c
4064  c3        ret

; ----------------------------------------------------------------------
sub_4065:
4065  a17d32    mov    ax, word ptr [0x327d]
4068  8a167f32  mov    dl, byte ptr [0x327f]
406c  be1000    mov    si, 0x10
406f  8b1e7905  mov    bx, word ptr [0x579]
4073  8a367b05  mov    dh, byte ptr [0x57b]
4077  bf1800    mov    di, 0x18
407a  b91e0e    mov    cx, 0xe1e
407d  e8a9ed    call   sub_2e29
4080  c3        ret
4081  db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00   ; ...............

; ----------------------------------------------------------------------
sub_4090:
4090  b90400    mov    cx, 4
  loc_4093:
4093  8bd9      mov    bx, cx
4095  4b        dec    bx
4096  8bf3      mov    si, bx
4098  d1e6      shl    si, 1
409a  c687ae3e01  mov    byte ptr [bx + 0x3eae], 1
409f  c687b23e00  mov    byte ptr [bx + 0x3eb2], 0
40a4  e8d001    call   sub_4277
40a7  e853ed    call   sub_2dfd
40aa  80e20f    and    dl, 0xf
40ad  80c214    add    dl, 0x14
40b0  8897b63e  mov    byte ptr [bx + 0x3eb6], dl
40b4  e2dd      loop   loc_4093
40b6  c706da3e0000  mov    word ptr [0x3eda], 0
40bc  c606d83e04  mov    byte ptr [0x3ed8], 4
40c1  c3        ret

; ----------------------------------------------------------------------
sub_40c2:
40c2  2ae4      sub    ah, ah
40c4  cd1a      int    0x1a
40c6  3b16dc3e  cmp    dx, word ptr [0x3edc]
40ca  7501      jne    loc_40cd
  loc_40cc:
40cc  c3        ret
  loc_40cd:
40cd  ff06da3e  inc    word ptr [0x3eda]
40d1  8b1eda3e  mov    bx, word ptr [0x3eda]
40d5  83fb02    cmp    bx, 2
40d8  760b      jbe    loc_40e5
40da  83fb04    cmp    bx, 4
40dd  720a      jb     loc_40e9
40df  2bdb      sub    bx, bx
40e1  891eda3e  mov    word ptr [0x3eda], bx
  loc_40e5:
40e5  8916dc3e  mov    word ptr [0x3edc], dx
  loc_40e9:
40e9  8bf3      mov    si, bx
40eb  d1e6      shl    si, 1
40ed  80bfb23e00  cmp    byte ptr [bx + 0x3eb2], 0
40f2  75d8      jne    loc_40cc
40f4  e8e401    call   sub_42db
40f7  7303      jae    loc_40fc
40f9  eb29      jmp    loc_4124
40fb  db 90   ; .
  loc_40fc:
40fc  e8fd01    call   sub_42fc
40ff  72cb      jb     loc_40cc
4101  80bfb63e00  cmp    byte ptr [bx + 0x3eb6], 0
4106  7510      jne    loc_4118
4108  e86c01    call   sub_4277
410b  e8efec    call   sub_2dfd
410e  80e207    and    dl, 7
4111  80c214    add    dl, 0x14
4114  8897b63e  mov    byte ptr [bx + 0x3eb6], dl
  loc_4118:
4118  fe8fb63e  dec    byte ptr [bx + 0x3eb6]
411c  e8bc01    call   sub_42db
411f  7203      jb     loc_4124
4121  eb5e      jmp    loc_4181
4123  db 90   ; .
  loc_4124:
4124  80bfae3e00  cmp    byte ptr [bx + 0x3eae], 0
4129  7507      jne    loc_4132
412b  80bfb63e14  cmp    byte ptr [bx + 0x3eb6], 0x14
4130  7201      jb     loc_4133
  loc_4132:
4132  c3        ret
  loc_4133:
4133  e8add0    call   sub_11e3
4136  e81b01    call   sub_4254
4139  8b1eda3e  mov    bx, word ptr [0x3eda]
413d  c687b23e01  mov    byte ptr [bx + 0x3eb2], 1
4142  e8dfcf    call   sub_1124
4145  c6065c0500  mov    byte ptr [0x55c], 0
414a  fe0ed83e  dec    byte ptr [0x3ed8]
414e  7505      jne    loc_4155
4150  c606530501  mov    byte ptr [0x553], 1
  loc_4155:
4155  b004      mov    al, 4
4157  2a06d83e  sub    al, byte ptr [0x3ed8]
415b  b102      mov    cl, 2
415d  d2e0      shl    al, cl
415f  2ae4      sub    ah, ah
4161  055100    add    ax, 0x51
4164  8bf8      mov    di, ax
4166  bd0e00    mov    bp, 0xe
4169  be203d    mov    si, 0x3d20
416c  b800b8    mov    ax, 0xb800
416f  8ec0      mov    es, ax
4171  b9020c    mov    cx, 0xc02
4174  e8beeb    call   sub_2d35
4177  b8e803    mov    ax, 0x3e8
417a  bbee02    mov    bx, 0x2ee
417d  e8bb17    call   sub_593b
4180  c3        ret
  loc_4181:
4181  e83001    call   sub_42b4
4184  8b3e0800  mov    di, word ptr [8]
4188  d1e7      shl    di, 1
418a  8badde3e  mov    bp, word ptr [di + 0x3ede]
418e  e88b01    call   sub_431c
4191  731d      jae    loc_41b0
4193  80bfb63e02  cmp    byte ptr [bx + 0x3eb6], 2
4198  7216      jb     loc_41b0
419a  b001      mov    al, 1
419c  80bfb63e11  cmp    byte ptr [bx + 0x3eb6], 0x11
41a1  7609      jbe    loc_41ac
41a3  80bfb63e14  cmp    byte ptr [bx + 0x3eb6], 0x14
41a8  7306      jae    loc_41b0
41aa  fec8      dec    al
  loc_41ac:
41ac  8887b63e  mov    byte ptr [bx + 0x3eb6], al
  loc_41b0:
41b0  8a87b63e  mov    al, byte ptr [bx + 0x3eb6]
41b4  3c01      cmp    al, 1
41b6  7620      jbe    loc_41d8
41b8  3c12      cmp    al, 0x12
41ba  723c      jb     loc_41f8
41bc  b001      mov    al, 1
41be  83bcba3e03  cmp    word ptr [si + 0x3eba], 3
41c3  7302      jae    loc_41c7
41c5  b003      mov    al, 3
  loc_41c7:
41c7  0087d43e  add    byte ptr [bx + 0x3ed4], al
41cb  80bfb63e13  cmp    byte ptr [bx + 0x3eb6], 0x13
41d0  7221      jb     loc_41f3
41d2  741a      je     loc_41ee
41d4  2bc0      sub    ax, ax
41d6  eb2c      jmp    loc_4204
  loc_41d8:
41d8  b001      mov    al, 1
41da  83bcba3e03  cmp    word ptr [si + 0x3eba], 3
41df  7302      jae    loc_41e3
41e1  b003      mov    al, 3
  loc_41e3:
41e3  0087d43e  add    byte ptr [bx + 0x3ed4], al
41e7  80bfb63e01  cmp    byte ptr [bx + 0x3eb6], 1
41ec  7305      jae    loc_41f3
  loc_41ee:
41ee  b8b03d    mov    ax, 0x3db0
41f1  eb11      jmp    loc_4204
  loc_41f3:
41f3  b8803d    mov    ax, 0x3d80
41f6  eb0c      jmp    loc_4204
  loc_41f8:
41f8  d0e0      shl    al, 1
41fa  8bf8      mov    di, ax
41fc  81e70200  and    di, 2
4200  8b85e03d  mov    ax, word ptr [di + 0x3de0]
  loc_4204:
4204  a3ca3e    mov    word ptr [0x3eca], ax
4207  8a97d43e  mov    dl, byte ptr [bx + 0x3ed4]
420b  8b8ccc3e  mov    cx, word ptr [si + 0x3ecc]
420f  e89eea    call   sub_2cb0
4212  a3e43d    mov    word ptr [0x3de4], ax
4215  e83c00    call   sub_4254
4218  8b1eda3e  mov    bx, word ptr [0x3eda]
421c  8bf3      mov    si, bx
421e  d1e6      shl    si, 1
4220  e8d900    call   sub_42fc
4223  7301      jae    loc_4226
4225  c3        ret
  loc_4226:
4226  833eca3e00  cmp    word ptr [0x3eca], 0
422b  7506      jne    loc_4233
422d  c687ae3e01  mov    byte ptr [bx + 0x3eae], 1
4232  c3        ret
  loc_4233:
4233  c687ae3e00  mov    byte ptr [bx + 0x3eae], 0
4238  8b3ee43d  mov    di, word ptr [0x3de4]
423c  89bca63e  mov    word ptr [si + 0x3ea6], di
4240  b800b8    mov    ax, 0xb800
4243  8ec0      mov    es, ax
4245  8bacc23e  mov    bp, word ptr [si + 0x3ec2]
4249  b9020c    mov    cx, 0xc02
424c  8b36ca3e  mov    si, word ptr [0x3eca]
4250  e8e2ea    call   sub_2d35
4253  c3        ret

; ----------------------------------------------------------------------
sub_4254:
4254  8b1eda3e  mov    bx, word ptr [0x3eda]
4258  8bf3      mov    si, bx
425a  d1e6      shl    si, 1
425c  80bfae3e00  cmp    byte ptr [bx + 0x3eae], 0
4261  7513      jne    loc_4276
4263  8bbca63e  mov    di, word ptr [si + 0x3ea6]
4267  b9020c    mov    cx, 0xc02
426a  8bb4c23e  mov    si, word ptr [si + 0x3ec2]
426e  b800b8    mov    ax, 0xb800
4271  8ec0      mov    es, ax
4273  e827eb    call   sub_2d9d
  loc_4276:
4276  c3        ret

; ----------------------------------------------------------------------
sub_4277:
4277  c606d93e20  mov    byte ptr [0x3ed9], 0x20
  loc_427c:
427c  e87eeb    call   sub_2dfd
427f  81e20f00  and    dx, 0xf
4283  2bff      sub    di, di
  loc_4285:
4285  3bfe      cmp    di, si
4287  7406      je     loc_428f
4289  3b95ba3e  cmp    dx, word ptr [di + 0x3eba]
428d  74ed      je     loc_427c
  loc_428f:
428f  83c702    add    di, 2
4292  83ff08    cmp    di, 8
4295  72ee      jb     loc_4285
4297  8994ba3e  mov    word ptr [si + 0x3eba], dx
429b  e81600    call   sub_42b4
429e  803ed93e00  cmp    byte ptr [0x3ed9], 0
42a3  740e      je     loc_42b3
42a5  bd3200    mov    bp, 0x32
42a8  e87100    call   sub_431c
42ab  7306      jae    loc_42b3
42ad  fe0ed93e  dec    byte ptr [0x3ed9]
42b1  ebc9      jmp    loc_427c
  loc_42b3:
42b3  c3        ret

; ----------------------------------------------------------------------
sub_42b4:
42b4  8bbcba3e  mov    di, word ptr [si + 0x3eba]
42b8  8a855010  mov    al, byte ptr [di + 0x1050]
42bc  b20a      mov    dl, 0xa
42be  83ff03    cmp    di, 3
42c1  7302      jae    loc_42c5
42c3  2ad2      sub    dl, dl
  loc_42c5:
42c5  2ac2      sub    al, dl
42c7  0403      add    al, 3
42c9  8887d43e  mov    byte ptr [bx + 0x3ed4], al
42cd  d1e7      shl    di, 1
42cf  8b853711  mov    ax, word ptr [di + 0x1137]
42d3  050800    add    ax, 8
42d6  8984cc3e  mov    word ptr [si + 0x3ecc], ax
42da  c3        ret

; ----------------------------------------------------------------------
sub_42db:
42db  56        push   si
42dc  53        push   bx
42dd  8b84cc3e  mov    ax, word ptr [si + 0x3ecc]
42e1  8a97d43e  mov    dl, byte ptr [bx + 0x3ed4]
42e5  be1000    mov    si, 0x10
42e8  8b1e7905  mov    bx, word ptr [0x579]
42ec  8a367b05  mov    dh, byte ptr [0x57b]
42f0  bf1800    mov    di, 0x18
42f3  b90c0e    mov    cx, 0xe0c
42f6  e830eb    call   sub_2e29
42f9  5b        pop    bx
42fa  5e        pop    si
42fb  c3        ret

; ----------------------------------------------------------------------
sub_42fc:
42fc  56        push   si
42fd  53        push   bx
42fe  8b84cc3e  mov    ax, word ptr [si + 0x3ecc]
4302  8a97d43e  mov    dl, byte ptr [bx + 0x3ed4]
4306  be1000    mov    si, 0x10
4309  8b1e7d32  mov    bx, word ptr [0x327d]
430d  8a367f32  mov    dh, byte ptr [0x327f]
4311  8bfe      mov    di, si
4313  b90c1e    mov    cx, 0x1e0c
4316  e810eb    call   sub_2e29
4319  5b        pop    bx
431a  5e        pop    si
431b  c3        ret

; ----------------------------------------------------------------------
sub_431c:
431c  8b84cc3e  mov    ax, word ptr [si + 0x3ecc]
4320  2b067905  sub    ax, word ptr [0x579]
4324  7302      jae    loc_4328
4326  f7d0      not    ax
  loc_4328:
4328  8a97d43e  mov    dl, byte ptr [bx + 0x3ed4]
432c  2a167b05  sub    dl, byte ptr [0x57b]
4330  7302      jae    loc_4334
4332  f6d2      not    dl
  loc_4334:
4334  2af6      sub    dh, dh
4336  03c2      add    ax, dx
4338  3bc5      cmp    ax, bp
433a  7202      jb     loc_433e
433c  f8        clc
433d  c3        ret
  loc_433e:
433e  f9        stc
433f  c3        ret

; ----------------------------------------------------------------------
sub_4340:
4340  2ae4      sub    ah, ah
4342  cd1a      int    0x1a
4344  3b16b540  cmp    dx, word ptr [0x40b5]
4348  7501      jne    loc_434b
  loc_434a:
434a  c3        ret
  loc_434b:
434b  fe06ff40  inc    byte ptr [0x40ff]
434f  f606ff4003  test   byte ptr [0x40ff], 3
4354  7404      je     loc_435a
4356  8916b540  mov    word ptr [0x40b5], dx
  loc_435a:
435a  803eaa40a4  cmp    byte ptr [0x40aa], 0xa4
435f  72e9      jb     loc_434a
4361  e8c901    call   sub_452d
4364  e8f001    call   sub_4557
4367  72e1      jb     loc_434a
4369  e891ea    call   sub_2dfd
436c  80fa30    cmp    dl, 0x30
436f  772b      ja     loc_439c
4371  e88701    call   sub_44fb
4374  8b360800  mov    si, word ptr [8]
4378  d1e6      shl    si, 1
437a  8b84ce40  mov    ax, word ptr [si + 0x40ce]
437e  3906cc40  cmp    word ptr [0x40cc], ax
4382  7718      ja     loc_439c
4384  e8d615    call   sub_595d
4387  c706c840ff00  mov    word ptr [0x40c8], 0xff
438d  a0ca40    mov    al, byte ptr [0x40ca]
4390  a2b740    mov    byte ptr [0x40b7], al
4393  a0cb40    mov    al, byte ptr [0x40cb]
4396  a2b840    mov    byte ptr [0x40b8], al
4399  e99200    jmp    loc_442e
  loc_439c:
439c  833ec8400a  cmp    word ptr [0x40c8], 0xa
43a1  770e      ja     loc_43b1
43a3  e857ea    call   sub_2dfd
43a6  80fa06    cmp    dl, 6
43a9  7709      ja     loc_43b4
43ab  c706c840ff00  mov    word ptr [0x40c8], 0xff
  loc_43b1:
43b1  eb4f      jmp    loc_4402
43b3  db 90   ; .
  loc_43b4:
43b4  8b1ec840  mov    bx, word ptr [0x40c8]
43b8  8bf3      mov    si, bx
43ba  d1e6      shl    si, 1
43bc  2ad2      sub    dl, dl
43be  a1b240    mov    ax, word ptr [0x40b2]
43c1  25fc0f    and    ax, 0xffc
43c4  3b84de40  cmp    ax, word ptr [si + 0x40de]
43c8  7406      je     loc_43d0
43ca  fec2      inc    dl
43cc  7202      jb     loc_43d0
43ce  b2ff      mov    dl, 0xff
  loc_43d0:
43d0  8816b740  mov    byte ptr [0x40b7], dl
43d4  2ad2      sub    dl, dl
43d6  a0b440    mov    al, byte ptr [0x40b4]
43d9  24fe      and    al, 0xfe
43db  3a87f440  cmp    al, byte ptr [bx + 0x40f4]
43df  7406      je     loc_43e7
43e1  fec2      inc    dl
43e3  7202      jb     loc_43e7
43e5  b2ff      mov    dl, 0xff
  loc_43e7:
43e7  8816b840  mov    byte ptr [0x40b8], dl
43eb  0a16b740  or     dl, byte ptr [0x40b7]
43ef  753d      jne    loc_442e
43f1  e809ea    call   sub_2dfd
43f4  80fa10    cmp    dl, 0x10
43f7  7735      ja     loc_442e
43f9  c706c840ff00  mov    word ptr [0x40c8], 0xff
43ff  e85b15    call   sub_595d
  loc_4402:
4402  e8f8e9    call   sub_2dfd
4405  80fa30    cmp    dl, 0x30
4408  7719      ja     loc_4423
440a  80e201    and    dl, 1
440d  7502      jne    loc_4411
440f  b2ff      mov    dl, 0xff
  loc_4411:
4411  8816b740  mov    byte ptr [0x40b7], dl
4415  e8e5e9    call   sub_2dfd
4418  80e201    and    dl, 1
441b  7502      jne    loc_441f
441d  b2ff      mov    dl, 0xff
  loc_441f:
441f  8816b840  mov    byte ptr [0x40b8], dl
  loc_4423:
4423  e8d7e9    call   sub_2dfd
4426  81e2ff00  and    dx, 0xff
442a  8916c840  mov    word ptr [0x40c8], dx
  loc_442e:
442e  a0b440    mov    al, byte ptr [0x40b4]
4431  803eb84001  cmp    byte ptr [0x40b8], 1
4436  7221      jb     loc_4459
4438  750f      jne    loc_4449
443a  0402      add    al, 2
443c  3ca8      cmp    al, 0xa8
443e  7216      jb     loc_4456
4440  b0a7      mov    al, 0xa7
4442  c606b840ff  mov    byte ptr [0x40b8], 0xff
4447  eb0d      jmp    loc_4456
  loc_4449:
4449  2c02      sub    al, 2
444b  3c30      cmp    al, 0x30
444d  7307      jae    loc_4456
444f  b030      mov    al, 0x30
4451  c606b84001  mov    byte ptr [0x40b8], 1
  loc_4456:
4456  a2b440    mov    byte ptr [0x40b4], al
  loc_4459:
4459  a1b240    mov    ax, word ptr [0x40b2]
445c  803eb74001  cmp    byte ptr [0x40b7], 1
4461  7223      jb     loc_4486
4463  7512      jne    loc_4477
4465  050400    add    ax, 4
4468  3d3601    cmp    ax, 0x136
446b  7216      jb     loc_4483
446d  b83501    mov    ax, 0x135
4470  c606b740ff  mov    byte ptr [0x40b7], 0xff
4475  eb0c      jmp    loc_4483
  loc_4477:
4477  2d0400    sub    ax, 4
447a  7307      jae    loc_4483
447c  2bc0      sub    ax, ax
447e  c606b74001  mov    byte ptr [0x40b7], 1
  loc_4483:
4483  a3b240    mov    word ptr [0x40b2], ax
  loc_4486:
4486  e8a400    call   sub_452d
4489  8b0eb240  mov    cx, word ptr [0x40b2]
448d  8a16b440  mov    dl, byte ptr [0x40b4]
4491  e81ce8    call   sub_2cb0
4494  a3bc40    mov    word ptr [0x40bc], ax
4497  b800b8    mov    ax, 0xb800
449a  8ec0      mov    es, ax
449c  803eb94000  cmp    byte ptr [0x40b9], 0
44a1  750d      jne    loc_44b0
44a3  be2c3f    mov    si, 0x3f2c
44a6  8b3eba40  mov    di, word ptr [0x40ba]
44aa  b90105    mov    cx, 0x501
44ad  e8ede8    call   sub_2d9d
  loc_44b0:
44b0  e8a400    call   sub_4557
44b3  7231      jb     loc_44e6
44b5  c606b94000  mov    byte ptr [0x40b9], 0
44ba  8306be4002  add    word ptr [0x40be], 2
44bf  8b1ebe40  mov    bx, word ptr [0x40be]
44c3  81e30600  and    bx, 6
44c7  8bb7c040  mov    si, word ptr [bx + 0x40c0]
44cb  803eb740ff  cmp    byte ptr [0x40b7], 0xff
44d0  7503      jne    loc_44d5
44d2  83c61e    add    si, 0x1e
  loc_44d5:
44d5  8b3ebc40  mov    di, word ptr [0x40bc]
44d9  893eba40  mov    word ptr [0x40ba], di
44dd  bd2c3f    mov    bp, 0x3f2c
44e0  b90105    mov    cx, 0x501
44e3  e8e6e7    call   sub_2ccc
  loc_44e6:
44e6  c3        ret

; ----------------------------------------------------------------------
sub_44e7:
44e7  803e710500  cmp    byte ptr [0x571], 0
44ec  750b      jne    loc_44f9
44ee  a07b05    mov    al, byte ptr [0x57b]
44f1  24f8      and    al, 0xf8
44f3  3c88      cmp    al, 0x88
44f5  7502      jne    loc_44f9
44f7  f9        stc
44f8  c3        ret
  loc_44f9:
44f9  f8        clc
44fa  c3        ret

; ----------------------------------------------------------------------
sub_44fb:
44fb  a1b240    mov    ax, word ptr [0x40b2]
44fe  b201      mov    dl, 1
4500  2b067905  sub    ax, word ptr [0x579]
4504  7304      jae    loc_450a
4506  f7d0      not    ax
4508  b2ff      mov    dl, 0xff
  loc_450a:
450a  8816ca40  mov    byte ptr [0x40ca], dl
450e  a3cc40    mov    word ptr [0x40cc], ax
4511  a0b440    mov    al, byte ptr [0x40b4]
4514  b201      mov    dl, 1
4516  2a067b05  sub    al, byte ptr [0x57b]
451a  7304      jae    loc_4520
451c  f6d0      not    al
451e  b2ff      mov    dl, 0xff
  loc_4520:
4520  8816cb40  mov    byte ptr [0x40cb], dl
4524  2ae4      sub    ah, ah
4526  d1e0      shl    ax, 1
4528  0106cc40  add    word ptr [0x40cc], ax
452c  c3        ret

; ----------------------------------------------------------------------
sub_452d:
452d  a1b240    mov    ax, word ptr [0x40b2]
4530  8a16b440  mov    dl, byte ptr [0x40b4]
4534  be0800    mov    si, 8
4537  8b1e7905  mov    bx, word ptr [0x579]
453b  8a367b05  mov    dh, byte ptr [0x57b]
453f  bf1800    mov    di, 0x18
4542  b9050e    mov    cx, 0xe05
4545  e8e1e8    call   sub_2e29
4548  730c      jae    loc_4556
454a  803e520500  cmp    byte ptr [0x552], 0
454f  7505      jne    loc_4556
4551  c606530501  mov    byte ptr [0x553], 1
  loc_4556:
4556  c3        ret

; ----------------------------------------------------------------------
sub_4557:
4557  a1b240    mov    ax, word ptr [0x40b2]
455a  8a16b440  mov    dl, byte ptr [0x40b4]
455e  be0800    mov    si, 8
4561  8b1e7d32  mov    bx, word ptr [0x327d]
4565  8a367f32  mov    dh, byte ptr [0x327f]
4569  bf1000    mov    di, 0x10
456c  b9051e    mov    cx, 0x1e05
456f  e8b7e8    call   sub_2e29
4572  7305      jae    loc_4579
4574  c606b840ff  mov    byte ptr [0x40b8], 0xff
  loc_4579:
4579  c3        ret

; ----------------------------------------------------------------------
sub_457a:
457a  b99000    mov    cx, 0x90
457d  b286      mov    dl, 0x86
457f  890ea840  mov    word ptr [0x40a8], cx
4583  8816aa40  mov    byte ptr [0x40aa], dl
4587  e826e7    call   sub_2cb0
458a  a3ab40    mov    word ptr [0x40ab], ax
458d  e8c901    call   sub_4759
4590  c606af4000  mov    byte ptr [0x40af], 0
4595  c606b14000  mov    byte ptr [0x40b1], 0
459a  c606b94001  mov    byte ptr [0x40b9], 1
459f  c606b84000  mov    byte ptr [0x40b8], 0
45a4  c706c840ff00  mov    word ptr [0x40c8], 0xff
45aa  c3        ret

; ----------------------------------------------------------------------
sub_45ab:
45ab  2ae4      sub    ah, ah
45ad  cd1a      int    0x1a
45af  3b16ad40  cmp    dx, word ptr [0x40ad]
45b3  7501      jne    loc_45b6
  loc_45b5:
45b5  c3        ret
  loc_45b6:
45b6  8916ad40  mov    word ptr [0x40ad], dx
45ba  803eaa40a4  cmp    byte ptr [0x40aa], 0xa4
45bf  73f4      jae    loc_45b5
45c1  e8c201    call   sub_4786
45c4  7310      jae    loc_45d6
45c6  e81eff    call   sub_44e7
45c9  73ea      jae    loc_45b5
45cb  c606710501  mov    byte ptr [0x571], 1
45d0  c6065b0510  mov    byte ptr [0x55b], 0x10
45d5  c3        ret
  loc_45d6:
45d6  e86501    call   sub_473e
45d9  736e      jae    loc_4649
45db  803eaf4000  cmp    byte ptr [0x40af], 0
45e0  7518      jne    loc_45fa
45e2  a06e05    mov    al, byte ptr [0x56e]
45e5  3c00      cmp    al, 0
45e7  750e      jne    loc_45f7
45e9  fec0      inc    al
45eb  8b1ea840  mov    bx, word ptr [0x40a8]
45ef  3b1e7905  cmp    bx, word ptr [0x579]
45f3  7702      ja     loc_45f7
45f5  b0ff      mov    al, 0xff
  loc_45f7:
45f7  a2b040    mov    byte ptr [0x40b0], al
  loc_45fa:
45fa  c606af4001  mov    byte ptr [0x40af], 1
45ff  b92000    mov    cx, 0x20
  loc_4602:
4602  a17905    mov    ax, word ptr [0x579]
4605  b201      mov    dl, 1
4607  803eb04001  cmp    byte ptr [0x40b0], 1
460c  7507      jne    loc_4615
460e  2d0800    sub    ax, 8
4611  b2ff      mov    dl, 0xff
4613  eb03      jmp    loc_4618
  loc_4615:
4615  050800    add    ax, 8
  loc_4618:
4618  a37905    mov    word ptr [0x579], ax
461b  88166e05  mov    byte ptr [0x56e], dl
461f  a07b05    mov    al, byte ptr [0x57b]
4622  803e710501  cmp    byte ptr [0x571], 1
4627  7210      jb     loc_4639
4629  7504      jne    loc_462f
462b  2c03      sub    al, 3
462d  eb02      jmp    loc_4631
  loc_462f:
462f  0403      add    al, 3
  loc_4631:
4631  a27b05    mov    byte ptr [0x57b], al
4634  0432      add    al, 0x32
4636  a27c05    mov    byte ptr [0x57c], al
  loc_4639:
4639  51        push   cx
463a  e80101    call   sub_473e
463d  59        pop    cx
463e  7302      jae    loc_4642
4640  e2c0      loop   loc_4602
  loc_4642:
4642  e89ecb    call   sub_11e3
4645  e8caca    call   sub_1112
  loc_4648:
4648  c3        ret
  loc_4649:
4649  803eb14000  cmp    byte ptr [0x40b1], 0
464e  7552      jne    loc_46a2
4650  803eaf4000  cmp    byte ptr [0x40af], 0
4655  74f1      je     loc_4648
4657  a1a840    mov    ax, word ptr [0x40a8]
465a  803eb04001  cmp    byte ptr [0x40b0], 1
465f  7505      jne    loc_4666
4661  050800    add    ax, 8
4664  eb03      jmp    loc_4669
  loc_4666:
4666  2d0800    sub    ax, 8
  loc_4669:
4669  a3a840    mov    word ptr [0x40a8], ax
466c  e8cf00    call   sub_473e
466f  7301      jae    loc_4672
4671  c3        ret
  loc_4672:
4672  b8000c    mov    ax, 0xc00
4675  bb540b    mov    bx, 0xb54
4678  e8c012    call   sub_593b
467b  c606af4000  mov    byte ptr [0x40af], 0
4680  8b0ea840  mov    cx, word ptr [0x40a8]
4684  8a16aa40  mov    dl, byte ptr [0x40aa]
4688  e825e6    call   sub_2cb0
468b  a3ab40    mov    word ptr [0x40ab], ax
468e  e8e200    call   sub_4773
4691  e8c500    call   sub_4759
4694  a1a840    mov    ax, word ptr [0x40a8]
4697  3d7800    cmp    ax, 0x78
469a  7206      jb     loc_46a2
469c  3da800    cmp    ax, 0xa8
469f  7701      ja     loc_46a2
46a1  c3        ret
  loc_46a2:
46a2  c606b14001  mov    byte ptr [0x40b1], 1
46a7  803ebf1c00  cmp    byte ptr [0x1cbf], 0
46ac  7410      je     loc_46be
46ae  e836fe    call   sub_44e7
46b1  730a      jae    loc_46bd
46b3  c606710501  mov    byte ptr [0x571], 1
46b8  c6065b0510  mov    byte ptr [0x55b], 0x10
  loc_46bd:
46bd  c3        ret
  loc_46be:
46be  2ae4      sub    ah, ah
46c0  cd1a      int    0x1a
46c2  3b16ad40  cmp    dx, word ptr [0x40ad]
46c6  74da      je     loc_46a2
46c8  8916ad40  mov    word ptr [0x40ad], dx
46cc  803e000000  cmp    byte ptr [0], 0
46d1  7419      je     loc_46ec
46d3  b0b6      mov    al, 0xb6
46d5  e643      out    0x43, al
46d7  a0aa40    mov    al, byte ptr [0x40aa]
46da  2ae4      sub    ah, ah
46dc  d1e0      shl    ax, 1
46de  d1e0      shl    ax, 1
46e0  e642      out    0x42, al
46e2  8ac4      mov    al, ah
46e4  e642      out    0x42, al
46e6  e461      in     al, 0x61
46e8  0c03      or     al, 3
46ea  e661      out    0x61, al
  loc_46ec:
46ec  8a16aa40  mov    dl, byte ptr [0x40aa]
46f0  80faa4    cmp    dl, 0xa4
46f3  7319      jae    loc_470e
46f5  80c205    add    dl, 5
46f8  8816aa40  mov    byte ptr [0x40aa], dl
46fc  8b0ea840  mov    cx, word ptr [0x40a8]
4700  e8ade5    call   sub_2cb0
4703  a3ab40    mov    word ptr [0x40ab], ax
4706  e86a00    call   sub_4773
4709  e84d00    call   sub_4759
470c  ebb0      jmp    loc_46be
  loc_470e:
470e  e81014    call   sub_5b21
4711  e85f00    call   sub_4773
4714  bd1e40    mov    bp, 0x401e
4717  ff0ea640  dec    word ptr [0x40a6]
471b  8b3ea640  mov    di, word ptr [0x40a6]
471f  be363f    mov    si, 0x3f36
4722  b90411    mov    cx, 0x1104
4725  e80de6    call   sub_2d35
4728  a1a840    mov    ax, word ptr [0x40a8]
472b  a3b240    mov    word ptr [0x40b2], ax
472e  a0aa40    mov    al, byte ptr [0x40aa]
4731  a2b440    mov    byte ptr [0x40b4], al
4734  e8c4fd    call   sub_44fb
4737  a0ca40    mov    al, byte ptr [0x40ca]
473a  a2b740    mov    byte ptr [0x40b7], al
473d  c3        ret

; ----------------------------------------------------------------------
sub_473e:
473e  a1a840    mov    ax, word ptr [0x40a8]
4741  8a16aa40  mov    dl, byte ptr [0x40aa]
4745  be1800    mov    si, 0x18
4748  8b1e7905  mov    bx, word ptr [0x579]
474c  8a367b05  mov    dh, byte ptr [0x57b]
4750  8bfe      mov    di, si
4752  b9100e    mov    cx, 0xe10
4755  e8d1e6    call   sub_2e29
4758  c3        ret

; ----------------------------------------------------------------------
sub_4759:
4759  b800b8    mov    ax, 0xb800
475c  8ec0      mov    es, ax
475e  bd1e40    mov    bp, 0x401e
4761  bebe3f    mov    si, 0x3fbe
4764  8b3eab40  mov    di, word ptr [0x40ab]
4768  893ea640  mov    word ptr [0x40a6], di
476c  b90310    mov    cx, 0x1003
476f  e8c3e5    call   sub_2d35
4772  c3        ret

; ----------------------------------------------------------------------
sub_4773:
4773  b800b8    mov    ax, 0xb800
4776  8ec0      mov    es, ax
4778  be1e40    mov    si, 0x401e
477b  8b3ea640  mov    di, word ptr [0x40a6]
477f  b90310    mov    cx, 0x1003
4782  e818e6    call   sub_2d9d
4785  c3        ret

; ----------------------------------------------------------------------
sub_4786:
4786  803e7f3266  cmp    byte ptr [0x327f], 0x66
478b  7217      jb     loc_47a4
478d  a1a840    mov    ax, word ptr [0x40a8]
4790  2d1400    sub    ax, 0x14
4793  3b067d32  cmp    ax, word ptr [0x327d]
4797  770b      ja     loc_47a4
4799  053000    add    ax, 0x30
479c  3b067d32  cmp    ax, word ptr [0x327d]
47a0  7202      jb     loc_47a4
47a2  f9        stc
47a3  c3        ret
  loc_47a4:
47a4  f8        clc
47a5  c3        ret
47a6  db 00,00,00,00,00,00,00,00,00,00   ; ..........

; ----------------------------------------------------------------------
sub_47b0:
47b0  a17d32    mov    ax, word ptr [0x327d]
47b3  8a167f32  mov    dl, byte ptr [0x327f]
47b7  be1000    mov    si, 0x10
47ba  8b1e7905  mov    bx, word ptr [0x579]
47be  83eb08    sub    bx, 8
47c1  7302      jae    loc_47c5
47c3  2bdb      sub    bx, bx
  loc_47c5:
47c5  8a367b05  mov    dh, byte ptr [0x57b]
47c9  80c603    add    dh, 3
47cc  bf2800    mov    di, 0x28
47cf  b91e0e    mov    cx, 0xe1e
47d2  e854e6    call   sub_2e29
47d5  c3        ret

; ----------------------------------------------------------------------
sub_47d6:
47d6  2ae4      sub    ah, ah
47d8  cd1a      int    0x1a
47da  8bc2      mov    ax, dx
47dc  2b06d744  sub    ax, word ptr [0x44d7]
47e0  8b360800  mov    si, word ptr [8]
47e4  d1e6      shl    si, 1
47e6  3b84dc44  cmp    ax, word ptr [si + 0x44dc]
47ea  7701      ja     loc_47ed
  loc_47ec:
47ec  c3        ret
  loc_47ed:
47ed  8916d744  mov    word ptr [0x44d7], dx
47f1  803eb81c00  cmp    byte ptr [0x1cb8], 0
47f6  75f4      jne    loc_47ec
47f8  c606fc4400  mov    byte ptr [0x44fc], 0
47fd  b90c00    mov    cx, 0xc
  loc_4800:
4800  8bd9      mov    bx, cx
4802  4b        dec    bx
4803  d0e3      shl    bl, 1
4805  83bf414400  cmp    word ptr [bx + 0x4441], 0
480a  7471      je     loc_487d
480c  8b87f943  mov    ax, word ptr [bx + 0x43f9]
4810  3a067b05  cmp    al, byte ptr [0x57b]
4814  7547      jne    loc_485d
4816  8b87e143  mov    ax, word ptr [bx + 0x43e1]
481a  2b067905  sub    ax, word ptr [0x579]
481e  7302      jae    loc_4822
4820  f7d0      not    ax
  loc_4822:
4822  8b360800  mov    si, word ptr [8]
4826  d1e6      shl    si, 1
4828  3b84ec44  cmp    ax, word ptr [si + 0x44ec]
482c  772f      ja     loc_485d
482e  83bf594402  cmp    word ptr [bx + 0x4459], 2
4833  7217      jb     loc_484c
4835  8b871144  mov    ax, word ptr [bx + 0x4411]
4839  a3da44    mov    word ptr [0x44da], ax
483c  e84e00    call   sub_488d
483f  e85f00    call   sub_48a1
4842  e8f4ea    call   sub_3339
4845  e8fdc8    call   sub_1145
4848  e8ebd8    call   sub_2136
484b  c3        ret
  loc_484c:
484c  ff875944  inc    word ptr [bx + 0x4459]
4850  83bf594402  cmp    word ptr [bx + 0x4459], 2
4855  7219      jb     loc_4870
4857  fe06fc44  inc    byte ptr [0x44fc]
485b  eb13      jmp    loc_4870
  loc_485d:
485d  83bf594400  cmp    word ptr [bx + 0x4459], 0
4862  7419      je     loc_487d
4864  e896e5    call   sub_2dfd
4867  80fa38    cmp    dl, 0x38
486a  7704      ja     loc_4870
486c  ff8f5944  dec    word ptr [bx + 0x4459]
  loc_4870:
4870  51        push   cx
4871  53        push   bx
4872  e86200    call   sub_48d7
4875  5b        pop    bx
4876  e89d00    call   sub_4916
4879  e84500    call   sub_48c1
487c  59        pop    cx
  loc_487d:
487d  e20b      loop   loc_488a
487f  803efc4400  cmp    byte ptr [0x44fc], 0
4884  7403      je     loc_4889
4886  e8080e    call   sub_5691
  loc_4889:
4889  c3        ret
  loc_488a:
488a  e973ff    jmp    loc_4800

; ----------------------------------------------------------------------
sub_488d:
488d  803ebd4400  cmp    byte ptr [0x44bd], 0
4892  7409      je     loc_489d
4894  e86c02    call   sub_4b03
4897  c606bd4400  mov    byte ptr [0x44bd], 0
489c  c3        ret
  loc_489d:
489d  e843c9    call   sub_11e3
48a0  c3        ret

; ----------------------------------------------------------------------
sub_48a1:
48a1  1e        push   ds
48a2  07        pop    es
48a3  fc        cld
48a4  bf0e00    mov    di, 0xe
48a7  8bf7      mov    si, di
48a9  b8aaaa    mov    ax, 0xaaaa
48ac  b94100    mov    cx, 0x41
48af  f3ab      rep stosw word ptr es:[di], ax
48b1  b800b8    mov    ax, 0xb800
48b4  8ec0      mov    es, ax
48b6  8b3eda44  mov    di, word ptr [0x44da]
48ba  b9050d    mov    cx, 0xd05
48bd  e8dde4    call   sub_2d9d
48c0  c3        ret

; ----------------------------------------------------------------------
sub_48c1:
48c1  803ed94400  cmp    byte ptr [0x44d9], 0
48c6  740a      je     loc_48d2
48c8  803ebd4400  cmp    byte ptr [0x44bd], 0
48cd  7404      je     loc_48d3
48cf  e84b02    call   sub_4b1d
  loc_48d2:
48d2  c3        ret
  loc_48d3:
48d3  e86fc8    call   sub_1145
48d6  c3        ret

; ----------------------------------------------------------------------
sub_48d7:
48d7  c606d94400  mov    byte ptr [0x44d9], 0
48dc  8b87e143  mov    ax, word ptr [bx + 0x43e1]
48e0  8b97f943  mov    dx, word ptr [bx + 0x43f9]
48e4  2d1400    sub    ax, 0x14
48e7  be2800    mov    si, 0x28
48ea  8b1e7905  mov    bx, word ptr [0x579]
48ee  8a367b05  mov    dh, byte ptr [0x57b]
48f2  b9060e    mov    cx, 0xe06
48f5  bf1800    mov    di, 0x18
48f8  e82ee5    call   sub_2e29
48fb  7318      jae    loc_4915
48fd  c606d94401  mov    byte ptr [0x44d9], 1
  loc_4902:
4902  e8d3ca    call   sub_13d8
4905  74fb      je     loc_4902
4907  803ebd4400  cmp    byte ptr [0x44bd], 0
490c  7404      je     loc_4912
490e  e8f201    call   sub_4b03
4911  c3        ret
  loc_4912:
4912  e8cec8    call   sub_11e3
  loc_4915:
4915  c3        ret

; ----------------------------------------------------------------------
sub_4916:
4916  8b871144  mov    ax, word ptr [bx + 0x4411]
491a  8bb75944  mov    si, word ptr [bx + 0x4459]
491e  d1e6      shl    si, 1
4920  81c60041  add    si, 0x4100
4924  05a700    add    ax, 0xa7
4927  81bf29449c42  cmp    word ptr [bx + 0x4429], 0x429c
492d  7406      je     loc_4935
492f  2d0600    sub    ax, 6
4932  83c606    add    si, 6
  loc_4935:
4935  8bf8      mov    di, ax
4937  b800b8    mov    ax, 0xb800
493a  8ec0      mov    es, ax
493c  b90101    mov    cx, 0x101
493f  e85be4    call   sub_2d9d
4942  c3        ret

; ----------------------------------------------------------------------
sub_4943:
4943  803eb81c00  cmp    byte ptr [0x1cb8], 0
4948  751c      jne    loc_4966
494a  803ebe4400  cmp    byte ptr [0x44be], 0
494f  740b      je     loc_495c
4951  a0be44    mov    al, byte ptr [0x44be]
4954  a29806    mov    byte ptr [0x698], al
4957  c606990600  mov    byte ptr [0x699], 0
  loc_495c:
495c  2ae4      sub    ah, ah
495e  cd1a      int    0x1a
4960  3b16d344  cmp    dx, word ptr [0x44d3]
4964  7501      jne    loc_4967
  loc_4966:
4966  c3        ret
  loc_4967:
4967  8916d344  mov    word ptr [0x44d3], dx
496b  803e840500  cmp    byte ptr [0x584], 0
4970  7423      je     loc_4995
4972  803ebd4400  cmp    byte ptr [0x44bd], 0
4977  741b      je     loc_4994
4979  e88701    call   sub_4b03
497c  e821ea    call   sub_33a0
497f  e8a2c7    call   sub_1124
4982  e8b4e9    call   sub_3339
4985  c606bd4400  mov    byte ptr [0x44bd], 0
498a  c606e04301  mov    byte ptr [0x43e0], 1
498f  c606be4400  mov    byte ptr [0x44be], 0
  loc_4994:
4994  c3        ret
  loc_4995:
4995  803e9a0600  cmp    byte ptr [0x69a], 0
499a  7403      je     loc_499f
499c  eb5b      jmp    loc_49f9
499e  db 90   ; .
  loc_499f:
499f  b8ffff    mov    ax, 0xffff
49a2  a3c144    mov    word ptr [0x44c1], ax
49a5  a3bf44    mov    word ptr [0x44bf], ax
49a8  b90c00    mov    cx, 0xc
49ab  8b367905  mov    si, word ptr [0x579]
49af  8a167b05  mov    dl, byte ptr [0x57b]
49b3  80c208    add    dl, 8
  loc_49b6:
49b6  8bd9      mov    bx, cx
49b8  4b        dec    bx
49b9  80bfc44401  cmp    byte ptr [bx + 0x44c4], 1
49be  7230      jb     loc_49f0
49c0  3a979944  cmp    dl, byte ptr [bx + 0x4499]
49c4  752a      jne    loc_49f0
49c6  8bc6      mov    ax, si
49c8  d0e3      shl    bl, 1
49ca  b6ff      mov    dh, 0xff
49cc  2b878144  sub    ax, word ptr [bx + 0x4481]
49d0  7304      jae    loc_49d6
49d2  f7d0      not    ax
49d4  b601      mov    dh, 1
  loc_49d6:
49d6  3b06bf44  cmp    ax, word ptr [0x44bf]
49da  7714      ja     loc_49f0
49dc  a3bf44    mov    word ptr [0x44bf], ax
49df  8b87a544  mov    ax, word ptr [bx + 0x44a5]
49e3  a3d144    mov    word ptr [0x44d1], ax
49e6  d0eb      shr    bl, 1
49e8  891ec144  mov    word ptr [0x44c1], bx
49ec  8836c344  mov    byte ptr [0x44c3], dh
  loc_49f0:
49f0  e2c4      loop   loc_49b6
49f2  833ec1440c  cmp    word ptr [0x44c1], 0xc
49f7  7227      jb     loc_4a20
  loc_49f9:
49f9  803ebd4400  cmp    byte ptr [0x44bd], 0
49fe  740b      je     loc_4a0b
4a00  e80001    call   sub_4b03
4a03  e83fc7    call   sub_1145
4a06  c6069a0610  mov    byte ptr [0x69a], 0x10
  loc_4a0b:
4a0b  c606bd4400  mov    byte ptr [0x44bd], 0
4a10  c606e04301  mov    byte ptr [0x43e0], 1
4a15  c606d04400  mov    byte ptr [0x44d0], 0
4a1a  c606be4400  mov    byte ptr [0x44be], 0
4a1f  c3        ret
  loc_4a20:
4a20  833ebf4404  cmp    word ptr [0x44bf], 4
4a25  7224      jb     loc_4a4b
4a27  833ebf4408  cmp    word ptr [0x44bf], 8
4a2c  7705      ja     loc_4a33
4a2e  c606720504  mov    byte ptr [0x572], 4
  loc_4a33:
4a33  a0c344    mov    al, byte ptr [0x44c3]
4a36  a29806    mov    byte ptr [0x698], al
4a39  a26e05    mov    byte ptr [0x56e], al
4a3c  a2be44    mov    byte ptr [0x44be], al
4a3f  c606990600  mov    byte ptr [0x699], 0
4a44  c606710500  mov    byte ptr [0x571], 0
4a49  ebae      jmp    loc_49f9
  loc_4a4b:
4a4b  c606be4400  mov    byte ptr [0x44be], 0
4a50  803ebd4400  cmp    byte ptr [0x44bd], 0
4a55  7506      jne    loc_4a5d
4a57  e889c7    call   sub_11e3
4a5a  e8c7c6    call   sub_1124
  loc_4a5d:
4a5d  c606bd4401  mov    byte ptr [0x44bd], 1
4a62  2ac0      sub    al, al
4a64  8006d04430  add    byte ptr [0x44d0], 0x30
4a69  7302      jae    loc_4a6d
4a6b  fec0      inc    al
  loc_4a6d:
4a6d  a2d544    mov    byte ptr [0x44d5], al
4a70  8b0e7905  mov    cx, word ptr [0x579]
4a74  81e1fc0f  and    cx, 0xffc
4a78  8a167b05  mov    dl, byte ptr [0x57b]
4a7c  80c203    add    dl, 3
4a7f  813ed1440c41  cmp    word ptr [0x44d1], 0x410c
4a85  740e      je     loc_4a95
4a87  83c108    add    cx, 8
4a8a  81f92701  cmp    cx, 0x127
4a8e  720c      jb     loc_4a9c
4a90  b92601    mov    cx, 0x126
4a93  eb07      jmp    loc_4a9c
  loc_4a95:
4a95  83e908    sub    cx, 8
4a98  7302      jae    loc_4a9c
4a9a  2bc9      sub    cx, cx
  loc_4a9c:
4a9c  e811e2    call   sub_2cb0
4a9f  a3dc43    mov    word ptr [0x43dc], ax
  loc_4aa2:
4aa2  e833c9    call   sub_13d8
4aa5  74fb      je     loc_4aa2
4aa7  e85900    call   sub_4b03
4aaa  803ed54400  cmp    byte ptr [0x44d5], 0
4aaf  744e      je     loc_4aff
4ab1  8b1ec144  mov    bx, word ptr [0x44c1]
4ab5  80bfc44400  cmp    byte ptr [bx + 0x44c4], 0
4aba  7443      je     loc_4aff
4abc  fe8fc444  dec    byte ptr [bx + 0x44c4]
4ac0  7525      jne    loc_4ae7
4ac2  53        push   bx
4ac3  b8fd08    mov    ax, 0x8fd
4ac6  bb2307    mov    bx, 0x723
4ac9  e86f0e    call   sub_593b
4acc  5b        pop    bx
4acd  c606980600  mov    byte ptr [0x698], 0
4ad2  c606be4400  mov    byte ptr [0x44be], 0
4ad7  c6069a0610  mov    byte ptr [0x69a], 0x10
4adc  fe0ed644  dec    byte ptr [0x44d6]
4ae0  7505      jne    loc_4ae7
4ae2  c606530501  mov    byte ptr [0x553], 1
  loc_4ae7:
4ae7  53        push   bx
4ae8  e8c5fc    call   sub_47b0
4aeb  5b        pop    bx
4aec  730e      jae    loc_4afc
4aee  53        push   bx
4aef  e8aee8    call   sub_33a0
4af2  5b        pop    bx
4af3  e8d200    call   sub_4bc8
4af6  e840e8    call   sub_3339
4af9  eb04      jmp    loc_4aff
4afb  db 90   ; .
  loc_4afc:
4afc  e8c900    call   sub_4bc8
  loc_4aff:
4aff  e81b00    call   sub_4b1d
4b02  c3        ret

; ----------------------------------------------------------------------
sub_4b03:
4b03  803ee04300  cmp    byte ptr [0x43e0], 0
4b08  7512      jne    loc_4b1c
4b0a  8b3ede43  mov    di, word ptr [0x43de]
4b0e  bea043    mov    si, 0x43a0
4b11  b800b8    mov    ax, 0xb800
4b14  8ec0      mov    es, ax
4b16  b9030a    mov    cx, 0xa03
4b19  e881e2    call   sub_2d9d
  loc_4b1c:
4b1c  c3        ret

; ----------------------------------------------------------------------
sub_4b1d:
4b1d  c606e04300  mov    byte ptr [0x43e0], 0
4b22  b800b8    mov    ax, 0xb800
4b25  8ec0      mov    es, ax
4b27  8b3edc43  mov    di, word ptr [0x43dc]
4b2b  893ede43  mov    word ptr [0x43de], di
4b2f  bda043    mov    bp, 0x43a0
4b32  8b36d144  mov    si, word ptr [0x44d1]
4b36  803ed04480  cmp    byte ptr [0x44d0], 0x80
4b3b  7203      jb     loc_4b40
4b3d  83c63c    add    si, 0x3c
  loc_4b40:
4b40  b9030a    mov    cx, 0xa03
4b43  e8efe1    call   sub_2d35
4b46  c3        ret

; ----------------------------------------------------------------------
sub_4b47:
4b47  1e        push   ds
4b48  07        pop    es
4b49  2bc0      sub    ax, ax
4b4b  bf4144    mov    di, 0x4441
4b4e  b90c00    mov    cx, 0xc
4b51  f3ab      rep stosw word ptr es:[di], ax
4b53  b800b8    mov    ax, 0xb800
4b56  8ec0      mov    es, ax
4b58  8b1e0800  mov    bx, word ptr [8]
4b5c  8a8f7144  mov    cl, byte ptr [bx + 0x4471]
4b60  2aed      sub    ch, ch
  loc_4b62:
4b62  e898e2    call   sub_2dfd
4b65  8ada      mov    bl, dl
4b67  81e31e00  and    bx, 0x1e
4b6b  80fb18    cmp    bl, 0x18
4b6e  73f2      jae    loc_4b62
4b70  83bf414400  cmp    word ptr [bx + 0x4441], 0
4b75  75eb      jne    loc_4b62
4b77  c78759440000  mov    word ptr [bx + 0x4459], 0
4b7d  c78741440100  mov    word ptr [bx + 0x4441], 1
4b83  51        push   cx
4b84  8bb72944  mov    si, word ptr [bx + 0x4429]
4b88  8bbf1144  mov    di, word ptr [bx + 0x4411]
4b8c  b9050d    mov    cx, 0xd05
4b8f  e80be2    call   sub_2d9d
4b92  59        pop    cx
4b93  e2cd      loop   loc_4b62
4b95  b90c00    mov    cx, 0xc
  loc_4b98:
4b98  8bd9      mov    bx, cx
4b9a  4b        dec    bx
4b9b  8b360800  mov    si, word ptr [8]
4b9f  8a947944  mov    dl, byte ptr [si + 0x4479]
4ba3  8897c444  mov    byte ptr [bx + 0x44c4], dl
4ba7  51        push   cx
4ba8  e81d00    call   sub_4bc8
4bab  59        pop    cx
4bac  e2ea      loop   loc_4b98
4bae  c606d04400  mov    byte ptr [0x44d0], 0
4bb3  c606bd4400  mov    byte ptr [0x44bd], 0
4bb8  c606e04301  mov    byte ptr [0x43e0], 1
4bbd  c606d6440c  mov    byte ptr [0x44d6], 0xc
4bc2  c606be4400  mov    byte ptr [0x44be], 0
4bc7  c3        ret

; ----------------------------------------------------------------------
sub_4bc8:
4bc8  e81d00    call   sub_4be8
4bcb  8bf8      mov    di, ax
4bcd  8a87c444  mov    al, byte ptr [bx + 0x44c4]
4bd1  2ae4      sub    ah, ah
4bd3  b105      mov    cl, 5
4bd5  d3e0      shl    ax, cl
4bd7  05fc41    add    ax, 0x41fc
4bda  8bf0      mov    si, ax
4bdc  b90208    mov    cx, 0x802
4bdf  b800b8    mov    ax, 0xb800
4be2  8ec0      mov    es, ax
4be4  e8b6e1    call   sub_2d9d
4be7  c3        ret

; ----------------------------------------------------------------------
sub_4be8:
4be8  53        push   bx
4be9  8a979944  mov    dl, byte ptr [bx + 0x4499]
4bed  d0e3      shl    bl, 1
4bef  8b8f8144  mov    cx, word ptr [bx + 0x4481]
4bf3  e8bae0    call   sub_2cb0
4bf6  5b        pop    bx
4bf7  c3        ret
4bf8  db 00,00,00,00,00,00,00,00   ; ........

; ----------------------------------------------------------------------
sub_4c00:
4c00  c3        ret
4c01  db c3,c3,c3,f8,c3,f8,c3,c3,00,00,00,00,00,00,00   ; ...............

; ----------------------------------------------------------------------
sub_4c10:
4c10  2ae4      sub    ah, ah
4c12  cd1a      int    0x1a
4c14  3b16b845  cmp    dx, word ptr [0x45b8]
4c18  7501      jne    loc_4c1b
4c1a  c3        ret
  loc_4c1b:
4c1b  ff06b645  inc    word ptr [0x45b6]
4c1f  8b1eb645  mov    bx, word ptr [0x45b6]
4c23  83fb01    cmp    bx, 1
4c26  7410      je     loc_4c38
4c28  83fb04    cmp    bx, 4
4c2b  740b      je     loc_4c38
4c2d  83fb07    cmp    bx, 7
4c30  720a      jb     loc_4c3c
4c32  2bdb      sub    bx, bx
4c34  891eb645  mov    word ptr [0x45b6], bx
  loc_4c38:
4c38  8916b845  mov    word ptr [0x45b8], dx
  loc_4c3c:
4c3c  e88e03    call   sub_4fcd
4c3f  e8eb03    call   sub_502d
4c42  7301      jae    loc_4c45
  loc_4c44:
4c44  c3        ret
  loc_4c45:
4c45  833e4f4500  cmp    word ptr [0x454f], 0
4c4a  7440      je     loc_4c8c
4c4c  2ae4      sub    ah, ah
4c4e  cd1a      int    0x1a
4c50  2b164f45  sub    dx, word ptr [0x454f]
4c54  8b1e0800  mov    bx, word ptr [8]
4c58  d0e3      shl    bl, 1
4c5a  8b87c745  mov    ax, word ptr [bx + 0x45c7]
4c5e  833eb64500  cmp    word ptr [0x45b6], 0
4c63  7502      jne    loc_4c67
4c65  d1e0      shl    ax, 1
  loc_4c67:
4c67  3bd0      cmp    dx, ax
4c69  72d9      jb     loc_4c44
4c6b  c7064f450000  mov    word ptr [0x454f], 0
4c71  c6064e4501  mov    byte ptr [0x454e], 1
4c76  b82400    mov    ax, 0x24
4c79  813e7905a000  cmp    word ptr [0x579], 0xa0
4c7f  7703      ja     loc_4c84
4c81  b80801    mov    ax, 0x108
  loc_4c84:
4c84  a34845    mov    word ptr [0x4548], ax
4c87  c6064a4500  mov    byte ptr [0x454a], 0
  loc_4c8c:
4c8c  e84101    call   sub_4dd0
4c8f  7308      jae    loc_4c99
4c91  8b1eb645  mov    bx, word ptr [0x45b6]
4c95  e82303    call   sub_4fbb
4c98  c3        ret
  loc_4c99:
4c99  803e534500  cmp    byte ptr [0x4553], 0
4c9e  7418      je     loc_4cb8
4ca0  fe0e5345  dec    byte ptr [0x4553]
4ca4  750f      jne    loc_4cb5
4ca6  b201      mov    dl, 1
4ca8  803e4a45ff  cmp    byte ptr [0x454a], 0xff
4cad  7402      je     loc_4cb1
4caf  b2ff      mov    dl, 0xff
  loc_4cb1:
4cb1  88164a45  mov    byte ptr [0x454a], dl
  loc_4cb5:
4cb5  eb5d      jmp    loc_4d14
4cb7  db 90   ; .
  loc_4cb8:
4cb8  a04b45    mov    al, byte ptr [0x454b]
4cbb  3a067b05  cmp    al, byte ptr [0x57b]
4cbf  7753      ja     loc_4d14
4cc1  833eb64506  cmp    word ptr [0x45b6], 6
4cc6  7507      jne    loc_4ccf
4cc8  803e7b0528  cmp    byte ptr [0x57b], 0x28
4ccd  720d      jb     loc_4cdc
  loc_4ccf:
4ccf  e82be1    call   sub_2dfd
4cd2  8b1e0800  mov    bx, word ptr [8]
4cd6  3a97bf45  cmp    dl, byte ptr [bx + 0x45bf]
4cda  7738      ja     loc_4d14
  loc_4cdc:
4cdc  2ad2      sub    dl, dl
4cde  a14845    mov    ax, word ptr [0x4548]
4ce1  25f80f    and    ax, 0xff8
4ce4  8b0e7905  mov    cx, word ptr [0x579]
4ce8  81e1f80f  and    cx, 0xff8
4cec  3bc1      cmp    ax, cx
4cee  7406      je     loc_4cf6
4cf0  b201      mov    dl, 1
4cf2  7202      jb     loc_4cf6
4cf4  b2ff      mov    dl, 0xff
  loc_4cf6:
4cf6  88164a45  mov    byte ptr [0x454a], dl
4cfa  803e7b0528  cmp    byte ptr [0x57b], 0x28
4cff  7213      jb     loc_4d14
4d01  833eb64506  cmp    word ptr [0x45b6], 6
4d06  750c      jne    loc_4d14
4d08  b001      mov    al, 1
4d0a  80faff    cmp    dl, 0xff
4d0d  7402      je     loc_4d11
4d0f  b0ff      mov    al, 0xff
  loc_4d11:
4d11  a24a45    mov    byte ptr [0x454a], al
  loc_4d14:
4d14  c706bc450800  mov    word ptr [0x45bc], 8
4d1a  803e534500  cmp    byte ptr [0x4553], 0
4d1f  7406      je     loc_4d27
4d21  c706bc450400  mov    word ptr [0x45bc], 4
  loc_4d27:
4d27  a14845    mov    ax, word ptr [0x4548]
4d2a  803e4a4501  cmp    byte ptr [0x454a], 1
4d2f  7315      jae    loc_4d46
4d31  e8c9e0    call   sub_2dfd
4d34  80fa10    cmp    dl, 0x10
4d37  7768      ja     loc_4da1
4d39  80e201    and    dl, 1
4d3c  7502      jne    loc_4d40
4d3e  b2ff      mov    dl, 0xff
  loc_4d40:
4d40  88164a45  mov    byte ptr [0x454a], dl
4d44  eb5b      jmp    loc_4da1
  loc_4d46:
4d46  7518      jne    loc_4d60
4d48  0306bc45  add    ax, word ptr [0x45bc]
4d4c  3d0b01    cmp    ax, 0x10b
4d4f  7227      jb     loc_4d78
4d51  b80a01    mov    ax, 0x10a
4d54  c6064a45ff  mov    byte ptr [0x454a], 0xff
4d59  c606534500  mov    byte ptr [0x4553], 0
4d5e  eb18      jmp    loc_4d78
  loc_4d60:
4d60  2b06bc45  sub    ax, word ptr [0x45bc]
4d64  7205      jb     loc_4d6b
4d66  3d2400    cmp    ax, 0x24
4d69  770d      ja     loc_4d78
  loc_4d6b:
4d6b  b82500    mov    ax, 0x25
4d6e  c6064a4501  mov    byte ptr [0x454a], 1
4d73  c606534500  mov    byte ptr [0x4553], 0
  loc_4d78:
4d78  a34845    mov    word ptr [0x4548], ax
4d7b  8306514502  add    word ptr [0x4551], 2
4d80  833e51450c  cmp    word ptr [0x4551], 0xc
4d85  7206      jb     loc_4d8d
4d87  c70651450000  mov    word ptr [0x4551], 0
  loc_4d8d:
4d8d  803e534500  cmp    byte ptr [0x4553], 0
4d92  750d      jne    loc_4da1
4d94  e866e0    call   sub_2dfd
4d97  80fa08    cmp    dl, 8
4d9a  7705      ja     loc_4da1
4d9c  c6064a4500  mov    byte ptr [0x454a], 0
  loc_4da1:
4da1  8b0e4845  mov    cx, word ptr [0x4548]
4da5  8a164b45  mov    dl, byte ptr [0x454b]
4da9  e804df    call   sub_2cb0
4dac  a3ba45    mov    word ptr [0x45ba], ax
4daf  e87b02    call   sub_502d
4db2  7301      jae    loc_4db5
4db4  c3        ret
  loc_4db5:
4db5  e81800    call   sub_4dd0
4db8  720e      jb     loc_4dc8
4dba  e88d01    call   sub_4f4a
4dbd  e85001    call   sub_4f10
4dc0  c606be4500  mov    byte ptr [0x45be], 0
4dc5  e8ad00    call   sub_4e75
  loc_4dc8:
4dc8  8b1eb645  mov    bx, word ptr [0x45b6]
4dcc  e8ec01    call   sub_4fbb
4dcf  c3        ret

; ----------------------------------------------------------------------
sub_4dd0:
4dd0  a17905    mov    ax, word ptr [0x579]
4dd3  8a167b05  mov    dl, byte ptr [0x57b]
4dd7  be1800    mov    si, 0x18
4dda  8bfe      mov    di, si
4ddc  8b1e4845  mov    bx, word ptr [0x4548]
4de0  8a364b45  mov    dh, byte ptr [0x454b]
4de4  b90e0c    mov    cx, 0xc0e
4de7  e83fe0    call   sub_2e29
4dea  7351      jae    loc_4e3d
4dec  833eb64506  cmp    word ptr [0x45b6], 6
4df1  750d      jne    loc_4e00
4df3  c606530501  mov    byte ptr [0x553], 1
4df8  e8e8c3    call   sub_11e3
4dfb  e84c01    call   sub_4f4a
4dfe  f9        stc
4dff  c3        ret
  loc_4e00:
4e00  e8e0c3    call   sub_11e3
4e03  e84401    call   sub_4f4a
4e06  e83cc3    call   sub_1145
4e09  c6065b0504  mov    byte ptr [0x55b], 4
4e0e  c606710501  mov    byte ptr [0x571], 1
4e13  c606760504  mov    byte ptr [0x576], 4
4e18  c606780508  mov    byte ptr [0x578], 8
4e1d  c606534504  mov    byte ptr [0x4553], 4
4e22  b201      mov    dl, 1
4e24  a14845    mov    ax, word ptr [0x4548]
4e27  3b067905  cmp    ax, word ptr [0x579]
4e2b  7702      ja     loc_4e2f
4e2d  b2ff      mov    dl, 0xff
  loc_4e2f:
4e2f  88164a45  mov    byte ptr [0x454a], dl
4e33  b8e40c    mov    ax, 0xce4
4e36  bb3b12    mov    bx, 0x123b
4e39  e8ff0a    call   sub_593b
4e3c  f9        stc
  loc_4e3d:
4e3d  c3        ret

; ----------------------------------------------------------------------
sub_4e3e:
4e3e  c606be4501  mov    byte ptr [0x45be], 1
4e43  a1b645    mov    ax, word ptr [0x45b6]
4e46  50        push   ax
4e47  c706b6450000  mov    word ptr [0x45b6], 0
  loc_4e4d:
4e4d  8b1eb645  mov    bx, word ptr [0x45b6]
4e51  e87901    call   sub_4fcd
4e54  833e4f4500  cmp    word ptr [0x454f], 0
4e59  750a      jne    loc_4e65
4e5b  e81700    call   sub_4e75
4e5e  8b1eb645  mov    bx, word ptr [0x45b6]
4e62  e85601    call   sub_4fbb
  loc_4e65:
4e65  ff06b645  inc    word ptr [0x45b6]
4e69  833eb64507  cmp    word ptr [0x45b6], 7
4e6e  72dd      jb     loc_4e4d
4e70  58        pop    ax
4e71  a3b645    mov    word ptr [0x45b6], ax
4e74  c3        ret

; ----------------------------------------------------------------------
sub_4e75:
4e75  b90800    mov    cx, 8
  loc_4e78:
4e78  8bd9      mov    bx, cx
4e7a  4b        dec    bx
4e7b  80bf722b00  cmp    byte ptr [bx + 0x2b72], 0
4e80  7421      je     loc_4ea3
4e82  51        push   cx
4e83  8a976a2b  mov    dl, byte ptr [bx + 0x2b6a]
4e87  d0e3      shl    bl, 1
4e89  8b875a2b  mov    ax, word ptr [bx + 0x2b5a]
4e8d  be1800    mov    si, 0x18
4e90  8bfe      mov    di, si
4e92  8b1e4845  mov    bx, word ptr [0x4548]
4e96  8a364b45  mov    dh, byte ptr [0x454b]
4e9a  b90f0c    mov    cx, 0xc0f
4e9d  e889df    call   sub_2e29
4ea0  59        pop    cx
4ea1  7203      jb     loc_4ea6
  loc_4ea3:
4ea3  e2d3      loop   loc_4e78
4ea5  c3        ret
  loc_4ea6:
4ea6  51        push   cx
4ea7  803ebe4500  cmp    byte ptr [0x45be], 0
4eac  750d      jne    loc_4ebb
4eae  e832c3    call   sub_11e3
4eb1  803ef27000  cmp    byte ptr [0x70f2], 0
4eb6  7403      je     loc_4ebb
4eb8  e87013    call   sub_622b
  loc_4ebb:
4ebb  e88c00    call   sub_4f4a
4ebe  59        pop    cx
4ebf  8bd9      mov    bx, cx
4ec1  4b        dec    bx
4ec2  c687722b00  mov    byte ptr [bx + 0x2b72], 0
4ec7  8a976a2b  mov    dl, byte ptr [bx + 0x2b6a]
4ecb  d0e3      shl    bl, 1
4ecd  8b8f5a2b  mov    cx, word ptr [bx + 0x2b5a]
4ed1  e8dcdd    call   sub_2cb0
4ed4  8bf8      mov    di, ax
4ed6  be7a2b    mov    si, 0x2b7a
4ed9  b800b8    mov    ax, 0xb800
4edc  8ec0      mov    es, ax
4ede  b9030f    mov    cx, 0xf03
4ee1  e8b9de    call   sub_2d9d
4ee4  803ebe4500  cmp    byte ptr [0x45be], 0
4ee9  750d      jne    loc_4ef8
4eeb  803ef27000  cmp    byte ptr [0x70f2], 0
4ef0  7403      je     loc_4ef5
4ef2  e80513    call   sub_61fa
  loc_4ef5:
4ef5  e84dc2    call   sub_1145
  loc_4ef8:
4ef8  2bd2      sub    dx, dx
4efa  833eb64506  cmp    word ptr [0x45b6], 6
4eff  740a      je     loc_4f0b
4f01  2ae4      sub    ah, ah
4f03  cd1a      int    0x1a
4f05  83fa00    cmp    dx, 0
4f08  7501      jne    loc_4f0b
4f0a  4a        dec    dx
  loc_4f0b:
4f0b  89164f45  mov    word ptr [0x454f], dx
4f0f  c3        ret

; ----------------------------------------------------------------------
sub_4f10:
4f10  c6064e4500  mov    byte ptr [0x454e], 0
4f15  be0045    mov    si, 0x4500
4f18  803e4a4500  cmp    byte ptr [0x454a], 0
4f1d  741f      je     loc_4f3e
4f1f  8b1e5145  mov    bx, word ptr [0x4551]
4f23  803e534500  cmp    byte ptr [0x4553], 0
4f28  7406      je     loc_4f30
4f2a  80e302    and    bl, 2
4f2d  80c30c    add    bl, 0xc
  loc_4f30:
4f30  803e4a45ff  cmp    byte ptr [0x454a], 0xff
4f35  7503      jne    loc_4f3a
4f37  83c310    add    bx, 0x10
  loc_4f3a:
4f3a  8bb7604a  mov    si, word ptr [bx + 0x4a60]
  loc_4f3e:
4f3e  8b3eba45  mov    di, word ptr [0x45ba]
4f42  893e4c45  mov    word ptr [0x454c], di
4f46  e89600    call   sub_4fdf
4f49  c3        ret

; ----------------------------------------------------------------------
sub_4f4a:
4f4a  803e4e4500  cmp    byte ptr [0x454e], 0
4f4f  7507      jne    loc_4f58
4f51  8b3e4c45  mov    di, word ptr [0x454c]
4f55  e8b000    call   sub_5008
  loc_4f58:
4f58  c3        ret

; ----------------------------------------------------------------------
sub_4f59:
4f59  c706b6450000  mov    word ptr [0x45b6], 0
  loc_4f5f:
4f5f  e89bde    call   sub_2dfd
4f62  81e27f00  and    dx, 0x7f
4f66  83c260    add    dx, 0x60
4f69  89164845  mov    word ptr [0x4548], dx
4f6d  c6064a4500  mov    byte ptr [0x454a], 0
4f72  c6064e4501  mov    byte ptr [0x454e], 1
4f77  c70651450000  mov    word ptr [0x4551], 0
4f7d  c606534500  mov    byte ptr [0x4553], 0
4f82  2bd2      sub    dx, dx
4f84  833eb64500  cmp    word ptr [0x45b6], 0
4f89  750a      jne    loc_4f95
4f8b  2ae4      sub    ah, ah
4f8d  cd1a      int    0x1a
4f8f  83fa00    cmp    dx, 0
4f92  7501      jne    loc_4f95
4f94  4a        dec    dx
  loc_4f95:
4f95  89164f45  mov    word ptr [0x454f], dx
4f99  8b1eb645  mov    bx, word ptr [0x45b6]
4f9d  8a87d42b  mov    al, byte ptr [bx + 0x2bd4]
4fa1  0403      add    al, 3
4fa3  a24b45    mov    byte ptr [0x454b], al
4fa6  e81200    call   sub_4fbb
4fa9  ff06b645  inc    word ptr [0x45b6]
4fad  833eb64507  cmp    word ptr [0x45b6], 7
4fb2  72ab      jb     loc_4f5f
4fb4  c706b6450000  mov    word ptr [0x45b6], 0
4fba  c3        ret

; ----------------------------------------------------------------------
sub_4fbb:
4fbb  1e        push   ds
4fbc  07        pop    es
4fbd  d0e3      shl    bl, 1
4fbf  fc        cld
4fc0  8bbfa845  mov    di, word ptr [bx + 0x45a8]
4fc4  be4845    mov    si, 0x4548
4fc7  b90c00    mov    cx, 0xc
4fca  f3a4      rep movsb byte ptr es:[di], byte ptr [si]
4fcc  c3        ret

; ----------------------------------------------------------------------
sub_4fcd:
4fcd  1e        push   ds
4fce  07        pop    es
4fcf  d0e3      shl    bl, 1
4fd1  fc        cld
4fd2  8bb7a845  mov    si, word ptr [bx + 0x45a8]
4fd6  bf4845    mov    di, 0x4548
4fd9  b90c00    mov    cx, 0xc
4fdc  f3a4      rep movsb byte ptr es:[di], byte ptr [si]
4fde  c3        ret

; ----------------------------------------------------------------------
sub_4fdf:
4fdf  b800b8    mov    ax, 0xb800
4fe2  8ec0      mov    es, ax
4fe4  fc        cld
4fe5  b60c      mov    dh, 0xc
  loc_4fe7:
4fe7  b90300    mov    cx, 3
  loc_4fea:
4fea  268b1d    mov    bx, word ptr es:[di]
4fed  ad        lodsw  ax, word ptr [si]
4fee  0bc3      or     ax, bx
4ff0  ab        stosw  word ptr es:[di], ax
4ff1  e2f7      loop   loc_4fea
4ff3  83ef06    sub    di, 6
4ff6  81f70020  xor    di, 0x2000
4ffa  f7c70020  test   di, 0x2000
4ffe  7503      jne    loc_5003
5000  83c750    add    di, 0x50
  loc_5003:
5003  fece      dec    dh
5005  75e0      jne    loc_4fe7
5007  c3        ret

; ----------------------------------------------------------------------
sub_5008:
5008  b800b8    mov    ax, 0xb800
500b  8ec0      mov    es, ax
500d  fc        cld
500e  b60c      mov    dh, 0xc
5010  b85555    mov    ax, 0x5555
  loc_5013:
5013  b90300    mov    cx, 3
5016  f3ab      rep stosw word ptr es:[di], ax
5018  83ef06    sub    di, 6
501b  81f70020  xor    di, 0x2000
501f  f7c70020  test   di, 0x2000
5023  7503      jne    loc_5028
5025  83c750    add    di, 0x50
  loc_5028:
5028  fece      dec    dh
502a  75e7      jne    loc_5013
502c  c3        ret

; ----------------------------------------------------------------------
sub_502d:
502d  803ef27000  cmp    byte ptr [0x70f2], 0
5032  7502      jne    loc_5036
5034  f8        clc
5035  c3        ret
  loc_5036:
5036  a1f370    mov    ax, word ptr [0x70f3]
5039  8a16f570  mov    dl, byte ptr [0x70f5]
503d  be1000    mov    si, 0x10
5040  8b1e4845  mov    bx, word ptr [0x4548]
5044  8a364b45  mov    dh, byte ptr [0x454b]
5048  bf1800    mov    di, 0x18
504b  b9080c    mov    cx, 0xc08
504e  e8d8dd    call   sub_2e29
5051  c3        ret
5052  db 00,00,00,00,00,00,00,00,00,00,00,00,00,00   ; ..............

; ----------------------------------------------------------------------
sub_5060:
5060  b800b8    mov    ax, 0xb800
5063  8ec0      mov    es, ax
5065  a17905    mov    ax, word ptr [0x579]
5068  3d1701    cmp    ax, 0x117
506b  7203      jb     loc_5070
506d  b81601    mov    ax, 0x116
  loc_5070:
5070  2d1000    sub    ax, 0x10
5073  7302      jae    loc_5077
5075  2bc0      sub    ax, ax
  loc_5077:
5077  25f00f    and    ax, 0xff0
507a  a37905    mov    word ptr [0x579], ax
507d  c6067b0514  mov    byte ptr [0x57b], 0x14
5082  2d8000    sub    ax, 0x80
5085  7302      jae    loc_5089
5087  f7d0      not    ax
  loc_5089:
5089  b103      mov    cl, 3
508b  d3e8      shr    ax, cl
508d  3d0d00    cmp    ax, 0xd
5090  7603      jbe    loc_5095
5092  b80d00    mov    ax, 0xd
  loc_5095:
5095  050200    add    ax, 2
5098  a36a4d    mov    word ptr [0x4d6a], ax
509b  c706d64d0a00  mov    word ptr [0x4dd6], 0xa
  loc_50a1:
50a1  833ed64d0a  cmp    word ptr [0x4dd6], 0xa
50a6  7403      je     loc_50ab
50a8  e8b80a    call   sub_5b63
  loc_50ab:
50ab  2ae4      sub    ah, ah
50ad  cd1a      int    0x1a
50af  8916804a  mov    word ptr [0x4a80], dx
50b3  a17905    mov    ax, word ptr [0x579]
50b6  8bc8      mov    cx, ax
50b8  81e1f00f  and    cx, 0xff0
50bc  81f98000  cmp    cx, 0x80
50c0  7504      jne    loc_50c6
50c2  8bc1      mov    ax, cx
50c4  eb0c      jmp    loc_50d2
  loc_50c6:
50c6  7206      jb     loc_50ce
50c8  2b066a4d  sub    ax, word ptr [0x4d6a]
50cc  eb04      jmp    loc_50d2
  loc_50ce:
50ce  03066a4d  add    ax, word ptr [0x4d6a]
  loc_50d2:
50d2  a37905    mov    word ptr [0x579], ax
50d5  803e7b0554  cmp    byte ptr [0x57b], 0x54
50da  7201      jb     loc_50dd
50dc  c3        ret
  loc_50dd:
50dd  80067b0508  add    byte ptr [0x57b], 8
50e2  8b0e7905  mov    cx, word ptr [0x579]
50e6  83c104    add    cx, 4
50e9  8a167b05  mov    dl, byte ptr [0x57b]
50ed  e8c0db    call   sub_2cb0
50f0  8bf8      mov    di, ax
50f2  893ed84d  mov    word ptr [0x4dd8], di
50f6  be8a4b    mov    si, 0x4b8a
50f9  bd0e00    mov    bp, 0xe
50fc  b90720    mov    cx, 0x2007
50ff  e8cadb    call   sub_2ccc
5102  8b3ed84d  mov    di, word ptr [0x4dd8]
5106  81c7f300  add    di, 0xf3
510a  be824a    mov    si, 0x4a82
510d  b9040d    mov    cx, 0xd04
5110  e88adc    call   sub_2d9d
5113  833ed64d0a  cmp    word ptr [0x4dd6], 0xa
5118  7506      jne    loc_5120
511a  e81106    call   sub_572e
511d  e8340a    call   sub_5b54
  loc_5120:
5120  e8400a    call   sub_5b63
5123  2ae4      sub    ah, ah
5125  cd1a      int    0x1a
5127  2b16804a  sub    dx, word ptr [0x4a80]
512b  3b16d64d  cmp    dx, word ptr [0x4dd6]
512f  72ef      jb     loc_5120
5131  833ed64d0a  cmp    word ptr [0x4dd6], 0xa
5136  7509      jne    loc_5141
5138  e875e7    call   sub_38b0
513b  2bdb      sub    bx, bx
513d  b40b      mov    ah, 0xb
513f  cd10      int    0x10
  loc_5141:
5141  c706d64d0200  mov    word ptr [0x4dd6], 2
5147  e957ff    jmp    loc_50a1

; ----------------------------------------------------------------------
sub_514a:
514a  b90300    mov    cx, 3
  loc_514d:
514d  bb0300    mov    bx, 3
5150  2bd9      sub    bx, cx
5152  d1e3      shl    bx, 1
5154  8b87a44d  mov    ax, word ptr [bx + 0x4da4]
5158  a36a4d    mov    word ptr [0x4d6a], ax
515b  8b87aa4d  mov    ax, word ptr [bx + 0x4daa]
515f  a36c4d    mov    word ptr [0x4d6c], ax
5162  8b87984d  mov    ax, word ptr [bx + 0x4d98]
5166  a3cc4d    mov    word ptr [0x4dcc], ax
5169  8b879e4d  mov    ax, word ptr [bx + 0x4d9e]
516d  a3ce4d    mov    word ptr [0x4dce], ax
5170  8b87b04d  mov    ax, word ptr [bx + 0x4db0]
5174  a3d04d    mov    word ptr [0x4dd0], ax
5177  8b87b64d  mov    ax, word ptr [bx + 0x4db6]
517b  a3d24d    mov    word ptr [0x4dd2], ax
517e  8b87bc4d  mov    ax, word ptr [bx + 0x4dbc]
5182  a3d44d    mov    word ptr [0x4dd4], ax
5185  8b87924d  mov    ax, word ptr [bx + 0x4d92]
5189  a3ca4d    mov    word ptr [0x4dca], ax
518c  8b87c24d  mov    ax, word ptr [bx + 0x4dc2]
5190  a3c84d    mov    word ptr [0x4dc8], ax
5193  51        push   cx
5194  e80400    call   sub_519b
5197  59        pop    cx
5198  e2b3      loop   loc_514d
519a  c3        ret

; ----------------------------------------------------------------------
sub_519b:
519b  b90800    mov    cx, 8
519e  c606914d01  mov    byte ptr [0x4d91], 1
  loc_51a3:
51a3  51        push   cx
51a4  e8bc09    call   sub_5b63
51a7  59        pop    cx
51a8  8bd9      mov    bx, cx
51aa  4b        dec    bx
51ab  d1e3      shl    bx, 1
51ad  a1cc4d    mov    ax, word ptr [0x4dcc]
51b0  89874a4d  mov    word ptr [bx + 0x4d4a], ax
51b4  a1ce4d    mov    ax, word ptr [0x4dce]
51b7  89875a4d  mov    word ptr [bx + 0x4d5a], ax
51bb  e2e6      loop   loc_51a3
51bd  b800b8    mov    ax, 0xb800
51c0  8ec0      mov    es, ax
51c2  c6066e4d00  mov    byte ptr [0x4d6e], 0
  loc_51c7:
51c7  2ae4      sub    ah, ah
51c9  cd1a      int    0x1a
51cb  8916804a  mov    word ptr [0x4a80], dx
51cf  b90800    mov    cx, 8
  loc_51d2:
51d2  51        push   cx
51d3  e88d09    call   sub_5b63
51d6  59        pop    cx
51d7  8bd9      mov    bx, cx
51d9  4b        dec    bx
51da  d1e3      shl    bx, 1
51dc  51        push   cx
51dd  53        push   bx
51de  803e914d00  cmp    byte ptr [0x4d91], 0
51e3  7405      je     loc_51ea
51e5  83f908    cmp    cx, 8
51e8  751b      jne    loc_5205
  loc_51ea:
51ea  8b8f4a4d  mov    cx, word ptr [bx + 0x4d4a]
51ee  8b975a4d  mov    dx, word ptr [bx + 0x4d5a]
51f2  e8bbda    call   sub_2cb0
51f5  8bf8      mov    di, ax
51f7  8b36ca4d  mov    si, word ptr [0x4dca]
51fb  bd0e00    mov    bp, 0xe
51fe  8b0ed44d  mov    cx, word ptr [0x4dd4]
5202  e8c7da    call   sub_2ccc
  loc_5205:
5205  5b        pop    bx
5206  59        pop    cx
5207  e82000    call   sub_522a
520a  e2c6      loop   loc_51d2
  loc_520c:
520c  e85409    call   sub_5b63
520f  2ae4      sub    ah, ah
5211  cd1a      int    0x1a
5213  2b16804a  sub    dx, word ptr [0x4a80]
5217  3b16c84d  cmp    dx, word ptr [0x4dc8]
521b  72ef      jb     loc_520c
521d  c606914d00  mov    byte ptr [0x4d91], 0
5222  803e6e4d00  cmp    byte ptr [0x4d6e], 0
5227  749e      je     loc_51c7
5229  c3        ret

; ----------------------------------------------------------------------
sub_522a:
522a  8b874a4d  mov    ax, word ptr [bx + 0x4d4a]
522e  83bf6f4d01  cmp    word ptr [bx + 0x4d6f], 1
5233  7225      jb     loc_525a
5235  7513      jne    loc_524a
5237  03066a4d  add    ax, word ptr [0x4d6a]
523b  3b06d04d  cmp    ax, word ptr [0x4dd0]
523f  7615      jbe    loc_5256
5241  a1d04d    mov    ax, word ptr [0x4dd0]
5244  fe066e4d  inc    byte ptr [0x4d6e]
5248  eb0c      jmp    loc_5256
  loc_524a:
524a  2b066a4d  sub    ax, word ptr [0x4d6a]
524e  7306      jae    loc_5256
5250  2bc0      sub    ax, ax
5252  fe066e4d  inc    byte ptr [0x4d6e]
  loc_5256:
5256  89874a4d  mov    word ptr [bx + 0x4d4a], ax
  loc_525a:
525a  8b875a4d  mov    ax, word ptr [bx + 0x4d5a]
525e  83bf7f4d01  cmp    word ptr [bx + 0x4d7f], 1
5263  7225      jb     loc_528a
5265  7513      jne    loc_527a
5267  03066c4d  add    ax, word ptr [0x4d6c]
526b  3b06d24d  cmp    ax, word ptr [0x4dd2]
526f  7615      jbe    loc_5286
5271  a1d24d    mov    ax, word ptr [0x4dd2]
5274  fe066e4d  inc    byte ptr [0x4d6e]
5278  eb0c      jmp    loc_5286
  loc_527a:
527a  2b066c4d  sub    ax, word ptr [0x4d6c]
527e  7306      jae    loc_5286
5280  2bc0      sub    ax, ax
5282  fe066e4d  inc    byte ptr [0x4d6e]
  loc_5286:
5286  89875a4d  mov    word ptr [bx + 0x4d5a], ax
  loc_528a:
528a  c3        ret

; ----------------------------------------------------------------------
sub_528b:
528b  e8c608    call   sub_5b54
528e  803e9706fd  cmp    byte ptr [0x697], 0xfd
5293  7407      je     loc_529c
5295  b40b      mov    ah, 0xb
5297  bb0101    mov    bx, 0x101
529a  cd10      int    0x10
  loc_529c:
529c  e8c1fd    call   sub_5060
529f  e8a8fe    call   sub_514a
52a2  e81a09    call   sub_5bbf
52a5  803e801f09  cmp    byte ptr [0x1f80], 9
52aa  7304      jae    loc_52b0
52ac  fe06801f  inc    byte ptr [0x1f80]
  loc_52b0:
52b0  833e080007  cmp    word ptr [8], 7
52b5  7304      jae    loc_52bb
52b7  ff060800  inc    word ptr [8]
  loc_52bb:
52bb  c70614040000  mov    word ptr [0x414], 0
52c1  2ae4      sub    ah, ah
52c3  cd1a      int    0x1a
52c5  89161204  mov    word ptr [0x412], dx
52c9  e85508    call   sub_5b21
52cc  c3        ret
52cd  db 00,00,00   ; ...

; ----------------------------------------------------------------------
sub_52d0:
52d0  803e000000  cmp    byte ptr [0], 0
52d5  743b      je     loc_5312
52d7  2ae4      sub    ah, ah
52d9  cd1a      int    0x1a
52db  3b16c452  cmp    dx, word ptr [0x52c4]
52df  7431      je     loc_5312
52e1  8916c452  mov    word ptr [0x52c4], dx
52e5  8b1ec652  mov    bx, word ptr [0x52c6]
52e9  8306c65202  add    word ptr [0x52c6], 2
52ee  8b87ca52  mov    ax, word ptr [bx + 0x52ca]
52f2  3b06c852  cmp    ax, word ptr [0x52c8]
52f6  7504      jne    loc_52fc
52f8  e82608    call   sub_5b21
52fb  c3        ret
  loc_52fc:
52fc  a3c852    mov    word ptr [0x52c8], ax
52ff  b0b6      mov    al, 0xb6
5301  e643      out    0x43, al
5303  a1c852    mov    ax, word ptr [0x52c8]
5306  e642      out    0x42, al
5308  8ac4      mov    al, ah
530a  e642      out    0x42, al
530c  e461      in     al, 0x61
530e  0c03      or     al, 3
5310  e661      out    0x61, al
  loc_5312:
5312  c3        ret

; ----------------------------------------------------------------------
sub_5313:
5313  833e080002  cmp    word ptr [8], 2
5318  724d      jb     loc_5367
531a  c70616500000  mov    word ptr [0x5016], 0
5320  2ae4      sub    ah, ah
5322  cd1a      int    0x1a
5324  8916c052  mov    word ptr [0x52c0], dx
5328  8916c252  mov    word ptr [0x52c2], dx
532c  8916c452  mov    word ptr [0x52c4], dx
5330  c706c6520000  mov    word ptr [0x52c6], 0
5336  c706c8520000  mov    word ptr [0x52c8], 0
  loc_533c:
533c  e82900    call   sub_5368
533f  813616500200  xor    word ptr [0x5016], 2
  loc_5345:
5345  e888ff    call   sub_52d0
5348  2ae4      sub    ah, ah
534a  cd1a      int    0x1a
534c  8bc2      mov    ax, dx
534e  2b06c052  sub    ax, word ptr [0x52c0]
5352  3d0500    cmp    ax, 5
5355  72ee      jb     loc_5345
5357  8916c052  mov    word ptr [0x52c0], dx
535b  2b16c252  sub    dx, word ptr [0x52c2]
535f  83fa28    cmp    dx, 0x28
5362  72d8      jb     loc_533c
5364  e8ba07    call   sub_5b21
  loc_5367:
5367  c3        ret

; ----------------------------------------------------------------------
sub_5368:
5368  b800b8    mov    ax, 0xb800
536b  8ec0      mov    es, ax
536d  8b1e0800  mov    bx, word ptr [8]
5371  d1e3      shl    bx, 1
5373  8b87ae52  mov    ax, word ptr [bx + 0x52ae]
5377  a31050    mov    word ptr [0x5010], ax
  loc_537a:
537a  8b1e1050  mov    bx, word ptr [0x5010]
537e  8b3f      mov    di, word ptr [bx]
5380  83ff00    cmp    di, 0
5383  7501      jne    loc_5386
5385  c3        ret
  loc_5386:
5386  8b5f02    mov    bx, word ptr [bx + 2]
5389  331e1650  xor    bx, word ptr [0x5016]
538d  81e30200  and    bx, 2
5391  8bb71250  mov    si, word ptr [bx + 0x5012]
5395  b90423    mov    cx, 0x2304
5398  e802da    call   sub_2d9d
539b  e832ff    call   sub_52d0
539e  8306105004  add    word ptr [0x5010], 4
53a3  ebd5      jmp    loc_537a
53a5  db 00,00,00,00,00,00,00,00,00,00,00   ; ...........

; ----------------------------------------------------------------------
sub_53b0:
53b0  803e000000  cmp    byte ptr [0], 0
53b5  743e      je     loc_53f5
53b7  2ae4      sub    ah, ah
53b9  cd1a      int    0x1a
53bb  3b162253  cmp    dx, word ptr [0x5322]
53bf  7434      je     loc_53f5
53c1  89162253  mov    word ptr [0x5322], dx
53c5  8b1e2053  mov    bx, word ptr [0x5320]
53c9  8a9f8c53  mov    bl, byte ptr [bx + 0x538c]
53cd  80fb66    cmp    bl, 0x66
53d0  740b      je     loc_53dd
53d2  2aff      sub    bh, bh
53d4  ff062053  inc    word ptr [0x5320]
53d8  83fb00    cmp    bx, 0
53db  7504      jne    loc_53e1
  loc_53dd:
53dd  e84107    call   sub_5b21
53e0  c3        ret
  loc_53e1:
53e1  b0b6      mov    al, 0xb6
53e3  e643      out    0x43, al
53e5  8b872453  mov    ax, word ptr [bx + 0x5324]
53e9  e642      out    0x42, al
53eb  8ac4      mov    al, ah
53ed  e642      out    0x42, al
53ef  e461      in     al, 0x61
53f1  0c03      or     al, 3
53f3  e661      out    0x61, al
  loc_53f5:
53f5  c3        ret
53f6  db 00,00,00,00,00,00,00,00,00,00   ; ..........

; ----------------------------------------------------------------------
sub_5400:
5400  b800b8    mov    ax, 0xb800
5403  8ec0      mov    es, ax
5405  8b1e0800  mov    bx, word ptr [8]
5409  81e30700  and    bx, 7
540d  d1e3      shl    bx, 1
540f  8bc3      mov    ax, bx
5411  8b9f0859  mov    bx, word ptr [bx + 0x5908]
5415  b103      mov    cl, 3
5417  d3e0      shl    ax, cl
5419  a31859    mov    word ptr [0x5918], ax
  loc_541c:
541c  8b3f      mov    di, word ptr [bx]
541e  81ffffff  cmp    di, 0xffff
5422  7423      je     loc_5447
5424  e8d6d9    call   sub_2dfd
5427  81e20e00  and    dx, 0xe
542b  03161859  add    dx, word ptr [0x5918]
542f  8bf2      mov    si, dx
5431  8bb48858  mov    si, word ptr [si + 0x5888]
5435  8b8c5858  mov    cx, word ptr [si + 0x5858]
5439  8bb44c58  mov    si, word ptr [si + 0x584c]
543d  53        push   bx
543e  e85cd9    call   sub_2d9d
5441  5b        pop    bx
5442  83c302    add    bx, 2
5445  ebd5      jmp    loc_541c
  loc_5447:
5447  c3        ret
5448  db 00,00,00,00,00,00,00,00   ; ........

; ----------------------------------------------------------------------
sub_5450:
5450  c6060f5b0c  mov    byte ptr [0x5b0f], 0xc
5455  c7060c5b0100  mov    word ptr [0x5b0c], 1
545b  c706125bff01  mov    word ptr [0x5b12], 0x1ff
5461  c7060a5b0f00  mov    word ptr [0x5b0a], 0xf
5467  c6060e5b01  mov    byte ptr [0x5b0e], 1
546c  c3        ret

; ----------------------------------------------------------------------
sub_546d:
546d  803e000000  cmp    byte ptr [0], 0
5472  7431      je     loc_54a5
5474  803eb81c00  cmp    byte ptr [0x1cb8], 0
5479  747d      je     loc_54f8
547b  2ae4      sub    ah, ah
547d  cd1a      int    0x1a
547f  803e0f5b00  cmp    byte ptr [0x5b0f], 0
5484  7520      jne    loc_54a6
5486  3b16105b  cmp    dx, word ptr [0x5b10]
548a  7419      je     loc_54a5
548c  8916105b  mov    word ptr [0x5b10], dx
5490  b0b6      mov    al, 0xb6
5492  e643      out    0x43, al
5494  a1125b    mov    ax, word ptr [0x5b12]
5497  25ff01    and    ax, 0x1ff
549a  05c800    add    ax, 0xc8
549d  e8e903    call   sub_5889
54a0  832e125b4b  sub    word ptr [0x5b12], 0x4b
  loc_54a5:
54a5  c3        ret
  loc_54a6:
54a6  3b16105b  cmp    dx, word ptr [0x5b10]
54aa  7408      je     loc_54b4
54ac  8916105b  mov    word ptr [0x5b10], dx
54b0  fe0e0f5b  dec    byte ptr [0x5b0f]
  loc_54b4:
54b4  fe0e0e5b  dec    byte ptr [0x5b0e]
54b8  753d      jne    loc_54f7
54ba  b001      mov    al, 1
54bc  803e9706fd  cmp    byte ptr [0x697], 0xfd
54c1  7402      je     loc_54c5
54c3  d0e0      shl    al, 1
  loc_54c5:
54c5  a20e5b    mov    byte ptr [0x5b0e], al
54c8  e832d9    call   sub_2dfd
54cb  80fa04    cmp    dl, 4
54ce  7704      ja     loc_54d4
54d0  ff060c5b  inc    word ptr [0x5b0c]
  loc_54d4:
54d4  f7060c5b0100  test   word ptr [0x5b0c], 1
54da  7405      je     loc_54e1
54dc  83060a5b07  add    word ptr [0x5b0a], 7
  loc_54e1:
54e1  b0b6      mov    al, 0xb6
54e3  e643      out    0x43, al
54e5  e815d9    call   sub_2dfd
54e8  8bc2      mov    ax, dx
54ea  23060a5b  and    ax, word ptr [0x5b0a]
54ee  25ff01    and    ax, 0x1ff
54f1  059001    add    ax, 0x190
54f4  e89203    call   sub_5889
  loc_54f7:
54f7  c3        ret
  loc_54f8:
54f8  2ae4      sub    ah, ah
54fa  cd1a      int    0x1a
54fc  803e205900  cmp    byte ptr [0x5920], 0
5501  741f      je     loc_5522
5503  3b162159  cmp    dx, word ptr [0x5921]
5507  7459      je     loc_5562
5509  89162159  mov    word ptr [0x5921], dx
550d  fe0e2059  dec    byte ptr [0x5920]
5511  740b      je     loc_551e
5513  b0b6      mov    al, 0xb6
5515  e643      out    0x43, al
5517  a12359    mov    ax, word ptr [0x5923]
551a  e86c03    call   sub_5889
551d  c3        ret
  loc_551e:
551e  e80006    call   sub_5b21
5521  c3        ret
  loc_5522:
5522  3b162559  cmp    dx, word ptr [0x5925]
5526  743a      je     loc_5562
5528  be0300    mov    si, 3
552b  a0bf1c    mov    al, byte ptr [0x1cbf]
552e  0a06075b  or     al, byte ptr [0x5b07]
5532  7515      jne    loc_5549
5534  be0100    mov    si, 1
5537  833e040000  cmp    word ptr [4], 0
553c  750b      jne    loc_5549
553e  4e        dec    si
553f  803e731600  cmp    byte ptr [0x1673], 0
5544  7403      je     loc_5549
5546  be0200    mov    si, 2
  loc_5549:
5549  8bfe      mov    di, si
554b  d1e7      shl    di, 1
554d  a08405    mov    al, byte ptr [0x584]
5550  0a06075b  or     al, byte ptr [0x5b07]
5554  750d      jne    loc_5563
5556  8bc2      mov    ax, dx
5558  2b062559  sub    ax, word ptr [0x5925]
555c  3b85f259  cmp    ax, word ptr [di + 0x59f2]
5560  7301      jae    loc_5563
  loc_5562:
5562  c3        ret
  loc_5563:
5563  89162559  mov    word ptr [0x5925], dx
5567  803ebf1c00  cmp    byte ptr [0x1cbf], 0
556c  750b      jne    loc_5579
556e  803e075b00  cmp    byte ptr [0x5b07], 0
5573  7429      je     loc_559e
5575  fe0e075b  dec    byte ptr [0x5b07]
  loc_5579:
5579  c7062e590012  mov    word ptr [0x592e], 0x1200
557f  8b1eba59  mov    bx, word ptr [0x59ba]
5583  83fb06    cmp    bx, 6
5586  7206      jb     loc_558e
5588  2bdb      sub    bx, bx
558a  891eba59  mov    word ptr [0x59ba], bx
  loc_558e:
558e  8306ba5902  add    word ptr [0x59ba], 2
5593  8b87445a  mov    ax, word ptr [bx + 0x5a44]
5597  a32a59    mov    word ptr [0x592a], ax
559a  e88b05    call   sub_5b28
559d  c3        ret
  loc_559e:
559e  83fe02    cmp    si, 2
55a1  7518      jne    loc_55bb
55a3  a07316    mov    al, byte ptr [0x1673]
55a6  2ae4      sub    ah, ah
55a8  b104      mov    cl, 4
55aa  d3e0      shl    ax, cl
55ac  050002    add    ax, 0x200
55af  a32a59    mov    word ptr [0x592a], ax
55b2  c7062e590018  mov    word ptr [0x592e], 0x1800
55b8  e9d200    jmp    loc_568d
  loc_55bb:
55bb  8b85025a  mov    ax, word ptr [di + 0x5a02]
55bf  a32e59    mov    word ptr [0x592e], ax
55c2  d02e2759  shr    byte ptr [0x5927], 1
55c6  735b      jae    loc_5623
55c8  c7062e590010  mov    word ptr [0x592e], 0x1000
55ce  c606275980  mov    byte ptr [0x5927], 0x80
55d3  fe062859  inc    byte ptr [0x5928]
55d7  a02859    mov    al, byte ptr [0x5928]
55da  2284fa59  and    al, byte ptr [si + 0x59fa]
55de  7536      jne    loc_5616
55e0  8a940a5a  mov    dl, byte ptr [si + 0x5a0a]
55e4  00162959  add    byte ptr [0x5929], dl
55e8  e812d8    call   sub_2dfd
55eb  3a940c5a  cmp    dl, byte ptr [si + 0x5a0c]
55ef  7707      ja     loc_55f8
55f1  80e207    and    dl, 7
55f4  88162d59  mov    byte ptr [0x592d], dl
  loc_55f8:
55f8  e802d8    call   sub_2dfd
55fb  81e2ff00  and    dx, 0xff
55ff  d1e2      shl    dx, 1
5601  b101      mov    cl, 1
5603  f6c202    test   dl, 2
5606  7406      je     loc_560e
5608  b1ff      mov    cl, 0xff
560a  81c20003  add    dx, 0x300
  loc_560e:
560e  89162a59  mov    word ptr [0x592a], dx
5612  880e2c59  mov    byte ptr [0x592c], cl
  loc_5616:
5616  8a262959  mov    ah, byte ptr [0x5929]
561a  22a4fc59  and    ah, byte ptr [si + 0x59fc]
561e  0ac4      or     al, ah
5620  a22859    mov    byte ptr [0x5928], al
  loc_5623:
5623  803e2c59ff  cmp    byte ptr [0x592c], 0xff
5628  7416      je     loc_5640
562a  8306545a02  add    word ptr [0x5a54], 2
562f  8b1e545a  mov    bx, word ptr [0x5a54]
5633  81e30e00  and    bx, 0xe
5637  8b87445a  mov    ax, word ptr [bx + 0x5a44]
563b  a32a59    mov    word ptr [0x592a], ax
563e  eb13      jmp    loc_5653
  loc_5640:
5640  813e2a59c800  cmp    word ptr [0x592a], 0xc8
5646  7706      ja     loc_564e
5648  c7062a590005  mov    word ptr [0x592a], 0x500
  loc_564e:
564e  832e2a5919  sub    word ptr [0x592a], 0x19
  loc_5653:
5653  803e840500  cmp    byte ptr [0x584], 0
5658  740d      je     loc_5667
565a  c7062e590020  mov    word ptr [0x592e], 0x2000
5660  c6062c59ff  mov    byte ptr [0x592c], 0xff
5665  7526      jne    loc_568d
  loc_5667:
5667  8a1e2859  mov    bl, byte ptr [0x5928]
566b  2aff      sub    bh, bh
566d  039dfe59  add    bx, word ptr [di + 0x59fe]
5671  8a87c259  mov    al, byte ptr [bx + 0x59c2]
5675  22062759  and    al, byte ptr [0x5927]
5679  7512      jne    loc_568d
567b  803e2d5900  cmp    byte ptr [0x592d], 0
5680  740e      je     loc_5690
5682  fe0e2d59  dec    byte ptr [0x592d]
5686  8b85065a  mov    ax, word ptr [di + 0x5a06]
568a  a32e59    mov    word ptr [0x592e], ax
  loc_568d:
568d  e89804    call   sub_5b28
  loc_5690:
5690  c3        ret

; ----------------------------------------------------------------------
sub_5691:
5691  e88d04    call   sub_5b21
5694  b40b      mov    ah, 0xb
5696  bb0400    mov    bx, 4
5699  cd10      int    0x10
569b  2ae4      sub    ah, ah
569d  cd1a      int    0x1a
569f  8916e25a  mov    word ptr [0x5ae2], dx
56a3  c706e45a0000  mov    word ptr [0x5ae4], 0
56a9  b002      mov    al, 2
56ab  803e9706fd  cmp    byte ptr [0x697], 0xfd
56b0  7502      jne    loc_56b4
56b2  d0e8      shr    al, 1
  loc_56b4:
56b4  a2065b    mov    byte ptr [0x5b06], al
  loc_56b7:
56b7  803e000000  cmp    byte ptr [0], 0
56bc  741a      je     loc_56d8
56be  ff06e45a  inc    word ptr [0x5ae4]
56c2  8b1ee45a  mov    bx, word ptr [0x5ae4]
56c6  8a0e065b  mov    cl, byte ptr [0x5b06]
56ca  d3eb      shr    bx, cl
56cc  81e31f00  and    bx, 0x1f
56d0  e461      in     al, 0x61
56d2  3287e65a  xor    al, byte ptr [bx + 0x5ae6]
56d6  e661      out    0x61, al
  loc_56d8:
56d8  2ae4      sub    ah, ah
56da  cd1a      int    0x1a
56dc  2b16e25a  sub    dx, word ptr [0x5ae2]
56e0  83fa02    cmp    dx, 2
56e3  72d2      jb     loc_56b7
56e5  b40b      mov    ah, 0xb
56e7  2bdb      sub    bx, bx
56e9  cd10      int    0x10
56eb  c606075b0c  mov    byte ptr [0x5b07], 0xc
56f0  e82e04    call   sub_5b21
56f3  c3        ret

; ----------------------------------------------------------------------
sub_56f4:
56f4  b80002    mov    ax, 0x200
56f7  803e9706fd  cmp    byte ptr [0x697], 0xfd
56fc  7502      jne    loc_5700
56fe  d1e0      shl    ax, 1
  loc_5700:
5700  a3d05a    mov    word ptr [0x5ad0], ax
5703  c3        ret

; ----------------------------------------------------------------------
sub_5704:
5704  ff06d05a  inc    word ptr [0x5ad0]
5708  8b1ed05a  mov    bx, word ptr [0x5ad0]
570c  8bd3      mov    dx, bx
570e  b109      mov    cl, 9
5710  d3ea      shr    dx, cl
5712  8aca      mov    cl, dl
5714  80e10f    and    cl, 0xf
5717  d3eb      shr    bx, cl
5719  81e30f00  and    bx, 0xf
571d  8a97d25a  mov    dl, byte ptr [bx + 0x5ad2]
5721  22160000  and    dl, byte ptr [0]
5725  e461      in     al, 0x61
5727  24fc      and    al, 0xfc
5729  0ac2      or     al, dl
572b  e661      out    0x61, al
572d  c3        ret

; ----------------------------------------------------------------------
sub_572e:
572e  c706cb5af401  mov    word ptr [0x5acb], 0x1f4
  loc_5734:
5734  e83700    call   sub_576e
5737  832ecb5a1e  sub    word ptr [0x5acb], 0x1e
573c  813ecb5ac800  cmp    word ptr [0x5acb], 0xc8
5742  77f0      ja     loc_5734
5744  c706cb5af401  mov    word ptr [0x5acb], 0x1f4
  loc_574a:
574a  e82100    call   sub_576e
574d  832ecb5a14  sub    word ptr [0x5acb], 0x14
5752  813ecb5a2c01  cmp    word ptr [0x5acb], 0x12c
5758  77f0      ja     loc_574a
  loc_575a:
575a  e81100    call   sub_576e
575d  8306cb5a1e  add    word ptr [0x5acb], 0x1e
5762  813ecb5a2003  cmp    word ptr [0x5acb], 0x320
5768  72f0      jb     loc_575a
576a  e8b403    call   sub_5b21
576d  c3        ret

; ----------------------------------------------------------------------
sub_576e:
576e  b90010    mov    cx, 0x1000
5771  803e9706fd  cmp    byte ptr [0x697], 0xfd
5776  7502      jne    loc_577a
5778  d1e9      shr    cx, 1
  loc_577a:
577a  e2fe      loop   loc_577a
577c  803e000000  cmp    byte ptr [0], 0
5781  7413      je     loc_5796
5783  b0b6      mov    al, 0xb6
5785  e643      out    0x43, al
5787  a1cb5a    mov    ax, word ptr [0x5acb]
578a  e642      out    0x42, al
578c  8ac4      mov    al, ah
578e  e642      out    0x42, al
5790  e461      in     al, 0x61
5792  0c03      or     al, 3
5794  e661      out    0x61, al
  loc_5796:
5796  c3        ret

; ----------------------------------------------------------------------
sub_5797:
5797  e88703    call   sub_5b21
579a  c606cf5a00  mov    byte ptr [0x5acf], 0
579f  c706cd5a0800  mov    word ptr [0x5acd], 8
57a5  c3        ret

; ----------------------------------------------------------------------
sub_57a6:
57a6  fe06cf5a  inc    byte ptr [0x5acf]
57aa  2ad2      sub    dl, dl
57ac  a0cf5a    mov    al, byte ptr [0x5acf]
57af  243f      and    al, 0x3f
57b1  7504      jne    loc_57b7
57b3  ff06cd5a  inc    word ptr [0x5acd]
  loc_57b7:
57b7  8b1ecd5a  mov    bx, word ptr [0x5acd]
57bb  b102      mov    cl, 2
57bd  d3eb      shr    bx, cl
57bf  80e31f    and    bl, 0x1f
57c2  3ac3      cmp    al, bl
57c4  7202      jb     loc_57c8
57c6  b202      mov    dl, 2
  loc_57c8:
57c8  22160000  and    dl, byte ptr [0]
57cc  e461      in     al, 0x61
57ce  24fd      and    al, 0xfd
57d0  0ac2      or     al, dl
57d2  e661      out    0x61, al
57d4  c3        ret

; ----------------------------------------------------------------------
sub_57d5:
57d5  c706855a0000  mov    word ptr [0x5a85], 0
57db  2ae4      sub    ah, ah
57dd  cd1a      int    0x1a
57df  8916835a  mov    word ptr [0x5a83], dx
57e3  c3        ret

; ----------------------------------------------------------------------
sub_57e4:
57e4  803e000000  cmp    byte ptr [0], 0
57e9  743d      je     loc_5828
57eb  2ae4      sub    ah, ah
57ed  cd1a      int    0x1a
57ef  8bc2      mov    ax, dx
57f1  2b06835a  sub    ax, word ptr [0x5a83]
57f5  3d0200    cmp    ax, 2
57f8  722e      jb     loc_5828
57fa  8916835a  mov    word ptr [0x5a83], dx
57fe  8b1e855a  mov    bx, word ptr [0x5a85]
5802  8306855a02  add    word ptr [0x5a85], 2
5807  803e520500  cmp    byte ptr [0x552], 0
580c  740d      je     loc_581b
580e  8b87a35a  mov    ax, word ptr [bx + 0x5aa3]
5812  3d0000    cmp    ax, 0
5815  7508      jne    loc_581f
5817  e80703    call   sub_5b21
581a  c3        ret
  loc_581b:
581b  8b87875a  mov    ax, word ptr [bx + 0x5a87]
  loc_581f:
581f  50        push   ax
5820  b0b6      mov    al, 0xb6
5822  e643      out    0x43, al
5824  58        pop    ax
5825  e86100    call   sub_5889
  loc_5828:
5828  c3        ret

; ----------------------------------------------------------------------
sub_5829:
5829  c706625a0000  mov    word ptr [0x5a62], 0
582f  c606825a00  mov    byte ptr [0x5a82], 0
5834  c3        ret

; ----------------------------------------------------------------------
sub_5835:
5835  803e000000  cmp    byte ptr [0], 0
583a  740a      je     loc_5846
583c  2ae4      sub    ah, ah
583e  cd1a      int    0x1a
5840  3b16805a  cmp    dx, word ptr [0x5a80]
5844  7501      jne    loc_5847
  loc_5846:
5846  c3        ret
  loc_5847:
5847  8916805a  mov    word ptr [0x5a80], dx
584b  fe06825a  inc    byte ptr [0x5a82]
584f  b0b6      mov    al, 0xb6
5851  e643      out    0x43, al
5853  8b1e625a  mov    bx, word ptr [0x5a62]
5857  f606825a01  test   byte ptr [0x5a82], 1
585c  7503      jne    loc_5861
585e  83c302    add    bx, 2
  loc_5861:
5861  8b87645a  mov    ax, word ptr [bx + 0x5a64]
5865  e82100    call   sub_5889
5868  c3        ret

; ----------------------------------------------------------------------
sub_5869:
5869  803e000000  cmp    byte ptr [0], 0
586e  7418      je     loc_5888
5870  53        push   bx
5871  50        push   ax
5872  b0b6      mov    al, 0xb6
5874  e643      out    0x43, al
5876  8b1e625a  mov    bx, word ptr [0x5a62]
587a  8306625a02  add    word ptr [0x5a62], 2
587f  8b87645a  mov    ax, word ptr [bx + 0x5a64]
5883  e80300    call   sub_5889
5886  58        pop    ax
5887  5b        pop    bx
  loc_5888:
5888  c3        ret

; ----------------------------------------------------------------------
sub_5889:
5889  e642      out    0x42, al
588b  8ac4      mov    al, ah
588d  e642      out    0x42, al
588f  e461      in     al, 0x61
5891  0c03      or     al, 3
5893  e661      out    0x61, al
5895  c3        ret

; ----------------------------------------------------------------------
sub_5896:
5896  c3        ret

; ----------------------------------------------------------------------
sub_5897:
5897  803e000000  cmp    byte ptr [0], 0
589c  741e      je     loc_58bc
589e  50        push   ax
589f  51        push   cx
58a0  52        push   dx
58a1  b0b6      mov    al, 0xb6
58a3  e643      out    0x43, al
58a5  8b1e565a  mov    bx, word ptr [0x5a56]
58a9  81e30600  and    bx, 6
58ad  8306565a02  add    word ptr [0x5a56], 2
58b2  8b875a5a  mov    ax, word ptr [bx + 0x5a5a]
58b6  e8d0ff    call   sub_5889
58b9  5a        pop    dx
58ba  59        pop    cx
58bb  58        pop    ax
  loc_58bc:
58bc  c3        ret

; ----------------------------------------------------------------------
sub_58bd:
58bd  c606275980  mov    byte ptr [0x5927], 0x80
58c2  c606285900  mov    byte ptr [0x5928], 0
58c7  c606295900  mov    byte ptr [0x5929], 0
58cc  c7062a590005  mov    word ptr [0x592a], 0x500
58d2  c6062c59ff  mov    byte ptr [0x592c], 0xff
58d7  c6062d5900  mov    byte ptr [0x592d], 0
58dc  c606205900  mov    byte ptr [0x5920], 0
58e1  c606075b00  mov    byte ptr [0x5b07], 0
58e6  c706085b0000  mov    word ptr [0x5b08], 0
58ec  c7060c5b0100  mov    word ptr [0x5b0c], 1
58f2  c6060e5b01  mov    byte ptr [0x5b0e], 1
58f7  c3        ret

; ----------------------------------------------------------------------
sub_58f8:
58f8  803ebf1c00  cmp    byte ptr [0x1cbf], 0
58fd  7509      jne    loc_5908
58ff  bb9003    mov    bx, 0x390
5902  b90018    mov    cx, 0x1800
5905  e89b00    call   sub_59a3
  loc_5908:
5908  c6067c1200  mov    byte ptr [0x127c], 0
590d  c3        ret

; ----------------------------------------------------------------------
sub_590e:
590e  803ebf1c00  cmp    byte ptr [0x1cbf], 0
5913  7509      jne    loc_591e
5915  bb0004    mov    bx, 0x400
5918  b90018    mov    cx, 0x1800
591b  e88500    call   sub_59a3
  loc_591e:
591e  c3        ret

; ----------------------------------------------------------------------
sub_591f:
591f  bbd007    mov    bx, 0x7d0
5922  b90018    mov    cx, 0x1800
5925  e87b00    call   sub_59a3
5928  bb6e0a    mov    bx, 0xa6e
592b  b90018    mov    cx, 0x1800
592e  e87200    call   sub_59a3
5931  bbec0d    mov    bx, 0xdec
5934  b90018    mov    cx, 0x1800
5937  e86900    call   sub_59a3
593a  c3        ret

; ----------------------------------------------------------------------
sub_593b:
593b  803e000000  cmp    byte ptr [0], 0
5940  741a      je     loc_595c
5942  891e2359  mov    word ptr [0x5923], bx
5946  50        push   ax
5947  b0b6      mov    al, 0xb6
5949  e643      out    0x43, al
594b  58        pop    ax
594c  e83aff    call   sub_5889
594f  c606205902  mov    byte ptr [0x5920], 2
5954  2ae4      sub    ah, ah
5956  cd1a      int    0x1a
5958  89162159  mov    word ptr [0x5921], dx
  loc_595c:
595c  c3        ret

; ----------------------------------------------------------------------
sub_595d:
595d  803e000000  cmp    byte ptr [0], 0
5962  741a      je     loc_597e
5964  803e205900  cmp    byte ptr [0x5920], 0
5969  7513      jne    loc_597e
596b  e88fd4    call   sub_2dfd
596e  8bc2      mov    ax, dx
5970  257f00    and    ax, 0x7f
5973  05aa00    add    ax, 0xaa
5976  8bd8      mov    bx, ax
5978  051e00    add    ax, 0x1e
597b  e8bdff    call   sub_593b
  loc_597e:
597e  c3        ret

; ----------------------------------------------------------------------
sub_597f:
597f  803e000000  cmp    byte ptr [0], 0
5984  741c      je     loc_59a2
5986  b80012    mov    ax, 0x1200
5989  bb1213    mov    bx, 0x1312
598c  0306085b  add    ax, word ptr [0x5b08]
5990  031e085b  add    bx, word ptr [0x5b08]
5994  8106085b5e01  add    word ptr [0x5b08], 0x15e
599a  e89eff    call   sub_593b
599d  c606075b18  mov    byte ptr [0x5b07], 0x18
  loc_59a2:
59a2  c3        ret

; ----------------------------------------------------------------------
sub_59a3:
59a3  803e000000  cmp    byte ptr [0], 0
59a8  7420      je     loc_59ca
59aa  b0b6      mov    al, 0xb6
59ac  e643      out    0x43, al
59ae  8bc3      mov    ax, bx
59b0  e642      out    0x42, al
59b2  8ac4      mov    al, ah
59b4  e642      out    0x42, al
59b6  e461      in     al, 0x61
59b8  0c03      or     al, 3
59ba  e661      out    0x61, al
59bc  803e9706fd  cmp    byte ptr [0x697], 0xfd
59c1  7502      jne    loc_59c5
59c3  d1e9      shr    cx, 1
  loc_59c5:
59c5  e2fe      loop   loc_59c5
59c7  e85701    call   sub_5b21
  loc_59ca:
59ca  c3        ret

; ----------------------------------------------------------------------
sub_59cb:
59cb  e461      in     al, 0x61
59cd  24fe      and    al, 0xfe
59cf  e661      out    0x61, al
59d1  2ae4      sub    ah, ah
59d3  cd1a      int    0x1a
59d5  8916405a  mov    word ptr [0x5a40], dx
59d9  c706425a0000  mov    word ptr [0x5a42], 0
  loc_59df:
59df  a1425a    mov    ax, word ptr [0x5a42]
59e2  b106      mov    cl, 6
59e4  d3e8      shr    ax, cl
59e6  7501      jne    loc_59e9
59e8  40        inc    ax
  loc_59e9:
59e9  8bc8      mov    cx, ax
  loc_59eb:
59eb  51        push   cx
59ec  2ae4      sub    ah, ah
59ee  cd1a      int    0x1a
59f0  59        pop    cx
59f1  2b16405a  sub    dx, word ptr [0x5a40]
59f5  83fa02    cmp    dx, 2
59f8  72f1      jb     loc_59eb
59fa  83fa07    cmp    dx, 7
59fd  7319      jae    loc_5a18
59ff  e2ea      loop   loc_59eb
5a01  e8f9d3    call   sub_2dfd
5a04  80e202    and    dl, 2
5a07  22160000  and    dl, byte ptr [0]
5a0b  e461      in     al, 0x61
5a0d  32c2      xor    al, dl
5a0f  e661      out    0x61, al
5a11  8306425a07  add    word ptr [0x5a42], 7
5a16  ebc7      jmp    loc_59df
  loc_5a18:
5a18  e80601    call   sub_5b21
5a1b  c3        ret

; ----------------------------------------------------------------------
sub_5a1c:
5a1c  803e000000  cmp    byte ptr [0], 0
5a21  7411      je     loc_5a34
5a23  e891b9    call   sub_13b7
5a26  8b1e165a  mov    bx, word ptr [0x5a16]
5a2a  2bd8      sub    bx, ax
5a2c  7207      jb     loc_5a35
5a2e  81fb6002  cmp    bx, 0x260
5a32  7701      ja     loc_5a35
  loc_5a34:
5a34  c3        ret
  loc_5a35:
5a35  a3165a    mov    word ptr [0x5a16], ax
5a38  b0b6      mov    al, 0xb6
5a3a  e643      out    0x43, al
5a3c  ff06185a  inc    word ptr [0x5a18]
5a40  8b1e185a  mov    bx, word ptr [0x5a18]
5a44  81e31e00  and    bx, 0x1e
5a48  a13c5a    mov    ax, word ptr [0x5a3c]
5a4b  25ff03    and    ax, 0x3ff
5a4e  3d8001    cmp    ax, 0x180
5a51  7206      jb     loc_5a59
5a53  b98001    mov    cx, 0x180
5a56  2bc8      sub    cx, ax
5a58  91        xchg   cx, ax
  loc_5a59:
5a59  d1e8      shr    ax, 1
5a5b  d1e8      shr    ax, 1
5a5d  03871a5a  add    ax, word ptr [bx + 0x5a1a]
5a61  bb0100    mov    bx, 1
5a64  803e9706fd  cmp    byte ptr [0x697], 0xfd
5a69  7502      jne    loc_5a6d
5a6b  d0e3      shl    bl, 1
  loc_5a6d:
5a6d  011e3e5a  add    word ptr [0x5a3e], bx
5a71  d1e3      shl    bx, 1
5a73  d1e3      shl    bx, 1
5a75  011e3c5a  add    word ptr [0x5a3c], bx
5a79  8b163e5a  mov    dx, word ptr [0x5a3e]
5a7d  b103      mov    cl, 3
5a7f  d3ea      shr    dx, cl
5a81  03c2      add    ax, dx
5a83  e642      out    0x42, al
5a85  8ac4      mov    al, ah
5a87  e642      out    0x42, al
5a89  e461      in     al, 0x61
5a8b  0c03      or     al, 3
5a8d  e661      out    0x61, al
5a8f  c3        ret

; ----------------------------------------------------------------------
sub_5a90:
5a90  803e000000  cmp    byte ptr [0], 0
5a95  740a      je     loc_5aa1
5a97  2ae4      sub    ah, ah
5a99  cd1a      int    0x1a
5a9b  3b16145a  cmp    dx, word ptr [0x5a14]
5a9f  7501      jne    loc_5aa2
  loc_5aa1:
5aa1  c3        ret
  loc_5aa2:
5aa2  8916145a  mov    word ptr [0x5a14], dx
5aa6  b0b6      mov    al, 0xb6
5aa8  e643      out    0x43, al
5aaa  e850d3    call   sub_2dfd
5aad  8bc2      mov    ax, dx
5aaf  257000    and    ax, 0x70
5ab2  050002    add    ax, 0x200
5ab5  e642      out    0x42, al
5ab7  8ac4      mov    al, ah
5ab9  e642      out    0x42, al
5abb  e461      in     al, 0x61
5abd  0c03      or     al, 3
5abf  e661      out    0x61, al
5ac1  c3        ret

; ----------------------------------------------------------------------
sub_5ac2:
5ac2  c706125a3803  mov    word ptr [0x5a12], 0x338
5ac8  2ae4      sub    ah, ah
5aca  cd1a      int    0x1a
5acc  8916105a  mov    word ptr [0x5a10], dx
5ad0  e8e4b8    call   sub_13b7
5ad3  a30e5a    mov    word ptr [0x5a0e], ax
  loc_5ad6:
5ad6  e8deb8    call   sub_13b7
5ad9  8bd0      mov    dx, ax
5adb  2b060e5a  sub    ax, word ptr [0x5a0e]
5adf  3d409c    cmp    ax, 0x9c40
5ae2  722c      jb     loc_5b10
5ae4  89160e5a  mov    word ptr [0x5a0e], dx
5ae8  803e000000  cmp    byte ptr [0], 0
5aed  7421      je     loc_5b10
5aef  b0b6      mov    al, 0xb6
5af1  e643      out    0x43, al
5af3  e807d3    call   sub_2dfd
5af6  8bc2      mov    ax, dx
5af8  25ff07    and    ax, 0x7ff
5afb  0306125a  add    ax, word ptr [0x5a12]
5aff  832e125a02  sub    word ptr [0x5a12], 2
5b04  e642      out    0x42, al
5b06  8ac4      mov    al, ah
5b08  e642      out    0x42, al
5b0a  e461      in     al, 0x61
5b0c  0c03      or     al, 3
5b0e  e661      out    0x61, al
  loc_5b10:
5b10  2ae4      sub    ah, ah
5b12  cd1a      int    0x1a
5b14  2b16105a  sub    dx, word ptr [0x5a10]
5b18  83fa02    cmp    dx, 2
5b1b  72b9      jb     loc_5ad6
5b1d  e80100    call   sub_5b21
5b20  c3        ret

; ----------------------------------------------------------------------
sub_5b21:
5b21  e461      in     al, 0x61
5b23  24fc      and    al, 0xfc
5b25  e661      out    0x61, al
5b27  c3        ret

; ----------------------------------------------------------------------
sub_5b28:
5b28  b0b6      mov    al, 0xb6
5b2a  e643      out    0x43, al
5b2c  a12a59    mov    ax, word ptr [0x592a]
5b2f  e642      out    0x42, al
5b31  8ac4      mov    al, ah
5b33  e642      out    0x42, al
5b35  e461      in     al, 0x61
5b37  0c03      or     al, 3
5b39  e661      out    0x61, al
5b3b  e879b8    call   sub_13b7
5b3e  8bc8      mov    cx, ax
  loc_5b40:
5b40  e874b8    call   sub_13b7
5b43  8bd1      mov    dx, cx
5b45  2bd0      sub    dx, ax
5b47  3b162e59  cmp    dx, word ptr [0x592e]
5b4b  72f3      jb     loc_5b40
5b4d  e461      in     al, 0x61
5b4f  24fc      and    al, 0xfc
5b51  e661      out    0x61, al
5b53  c3        ret

; ----------------------------------------------------------------------
sub_5b54:
5b54  c706be590000  mov    word ptr [0x59be], 0
5b5a  2ae4      sub    ah, ah
5b5c  cd1a      int    0x1a
5b5e  8916c059  mov    word ptr [0x59c0], dx
5b62  c3        ret

; ----------------------------------------------------------------------
sub_5b63:
5b63  803e000000  cmp    byte ptr [0], 0
5b68  740f      je     loc_5b79
5b6a  2ae4      sub    ah, ah
5b6c  cd1a      int    0x1a
5b6e  8bc2      mov    ax, dx
5b70  2b06c059  sub    ax, word ptr [0x59c0]
5b74  3d0200    cmp    ax, 2
5b77  7301      jae    loc_5b7a
  loc_5b79:
5b79  c3        ret
  loc_5b7a:
5b7a  8916c059  mov    word ptr [0x59c0], dx
5b7e  8b1ebe59  mov    bx, word ptr [0x59be]
5b82  81e3fe00  and    bx, 0xfe
5b86  81fb8600  cmp    bx, 0x86
5b8a  7206      jb     loc_5b92
5b8c  2bdb      sub    bx, bx
5b8e  891ebe59  mov    word ptr [0x59be], bx
  loc_5b92:
5b92  8306be5902  add    word ptr [0x59be], 2
5b97  8b873459  mov    ax, word ptr [bx + 0x5934]
5b9b  8b0ebc59  mov    cx, word ptr [0x59bc]
5b9f  a3bc59    mov    word ptr [0x59bc], ax
5ba2  3bc1      cmp    ax, cx
5ba4  7504      jne    loc_5baa
5ba6  e878ff    call   sub_5b21
5ba9  c3        ret
  loc_5baa:
5baa  8bc8      mov    cx, ax
5bac  b0b6      mov    al, 0xb6
5bae  e643      out    0x43, al
5bb0  8bc1      mov    ax, cx
5bb2  e642      out    0x42, al
5bb4  8ac4      mov    al, ah
5bb6  e642      out    0x42, al
5bb8  e461      in     al, 0x61
5bba  0c03      or     al, 3
5bbc  e661      out    0x61, al
5bbe  c3        ret

; ----------------------------------------------------------------------
sub_5bbf:
5bbf  803e000000  cmp    byte ptr [0], 0
5bc4  740a      je     loc_5bd0
5bc6  e89aff    call   sub_5b63
5bc9  833ebe597c  cmp    word ptr [0x59be], 0x7c
5bce  72ef      jb     loc_5bbf
  loc_5bd0:
5bd0  c3        ret
5bd1  db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00   ; ...............

; ----------------------------------------------------------------------
sub_5be0:
5be0  2ae4      sub    ah, ah
5be2  cd1a      int    0x1a
5be4  8916665f  mov    word ptr [0x5f66], dx
5be8  c706605f0000  mov    word ptr [0x5f60], 0
  loc_5bee:
5bee  b800b8    mov    ax, 0xb800
5bf1  8ec0      mov    es, ax
5bf3  8b1e605f  mov    bx, word ptr [0x5f60]
5bf7  8306605f02  add    word ptr [0x5f60], 2
5bfc  81e30200  and    bx, 2
5c00  8bb7625f  mov    si, word ptr [bx + 0x5f62]
5c04  bf740a    mov    di, 0xa74
5c07  b90444    mov    cx, 0x4404
5c0a  e890d1    call   sub_2d9d
  loc_5c0d:
5c0d  e8d4fb    call   sub_57e4
5c10  2ae4      sub    ah, ah
5c12  cd1a      int    0x1a
5c14  8bc2      mov    ax, dx
5c16  2b06665f  sub    ax, word ptr [0x5f66]
5c1a  3d0400    cmp    ax, 4
5c1d  72ee      jb     loc_5c0d
5c1f  8916665f  mov    word ptr [0x5f66], dx
5c23  833e605f04  cmp    word ptr [0x5f60], 4
5c28  750c      jne    loc_5c36
5c2a  be685f    mov    si, 0x5f68
5c2d  bf6806    mov    di, 0x668
5c30  b90410    mov    cx, 0x1004
5c33  e867d1    call   sub_2d9d
  loc_5c36:
5c36  8b1e605f  mov    bx, word ptr [0x5f60]
5c3a  83eb08    sub    bx, 8
5c3d  7212      jb     loc_5c51
5c3f  83fb06    cmp    bx, 6
5c42  730d      jae    loc_5c51
5c44  bee85f    mov    si, 0x5fe8
5c47  8bbfe460  mov    di, word ptr [bx + 0x60e4]
5c4b  b90615    mov    cx, 0x1506
5c4e  e84cd1    call   sub_2d9d
  loc_5c51:
5c51  833e605f10  cmp    word ptr [0x5f60], 0x10
5c56  7296      jb     loc_5bee
5c58  e8c6fe    call   sub_5b21
5c5b  c3        ret
5c5c  db 00,00,00,00   ; ....

; ----------------------------------------------------------------------
sub_5c60:
5c60  cd11      int    0x11
5c62  2430      and    al, 0x30
5c64  3c30      cmp    al, 0x30
5c66  752d      jne    loc_5c95
5c68  b800b8    mov    ax, 0xb800
5c6b  8ed8      mov    ds, ax
5c6d  b8aa55    mov    ax, 0x55aa
5c70  a30000    mov    word ptr [0], ax
5c73  a10000    mov    ax, word ptr [0]
5c76  3daa55    cmp    ax, 0x55aa
5c79  751b      jne    loc_5c96
5c7b  bef060    mov    si, 0x60f0
5c7e  e81d00    call   sub_5c9e
5c81  b84000    mov    ax, 0x40
5c84  8ed8      mov    ds, ax
5c86  a11000    mov    ax, word ptr [0x10]
5c89  24cf      and    al, 0xcf
5c8b  0c10      or     al, 0x10
5c8d  a31000    mov    word ptr [0x10], ax
5c90  b80400    mov    ax, 4
5c93  cd10      int    0x10
  loc_5c95:
5c95  c3        ret
  loc_5c96:
5c96  be1261    mov    si, 0x6112
5c99  e80200    call   sub_5c9e
  loc_5c9c:
5c9c  ebfe      jmp    loc_5c9c

; ----------------------------------------------------------------------
sub_5c9e:
5c9e  b81000    mov    ax, 0x10
5ca1  8ed8      mov    ds, ax
5ca3  e88501    call   sub_5e2b
5ca6  c3        ret
5ca7  db 00,00,00,00,00,00,00,00,00   ; .........

; ----------------------------------------------------------------------
sub_5cb0:
5cb0  fc        cld
5cb1  c70604000000  mov    word ptr [4], 0
5cb7  e876bb    call   sub_1830
5cba  e873c6    call   sub_2330
5cbd  e870cd    call   sub_2a30
5cc0  b800b8    mov    ax, 0xb800
5cc3  8ec0      mov    es, ax
5cc5  be5261    mov    si, 0x6152
5cc8  b90b1d    mov    cx, 0x1d0b
5ccb  bfbd00    mov    di, 0xbd
5cce  e8ccd0    call   sub_2d9d
5cd1  bed063    mov    si, 0x63d0
5cd4  b90e16    mov    cx, 0x160e
5cd7  bf9e06    mov    di, 0x69e
5cda  e8c0d0    call   sub_2d9d
5cdd  be3866    mov    si, 0x6638
5ce0  b9030c    mov    cx, 0xc03
5ce3  bf780a    mov    di, 0xa78
5ce6  e8b4d0    call   sub_2d9d
5ce9  be8066    mov    si, 0x6680
5cec  b90e08    mov    cx, 0x80e
5cef  bfa80c    mov    di, 0xca8
5cf2  e8a8d0    call   sub_2d9d
5cf5  be6067    mov    si, 0x6760
5cf8  b90c0b    mov    cx, 0xb0c
5cfb  bf6e1d    mov    di, 0x1d6e
5cfe  e89cd0    call   sub_2d9d
5d01  be6868    mov    si, 0x6868
5d04  b90408    mov    cx, 0x804
5d07  bfec1d    mov    di, 0x1dec
5d0a  e890d0    call   sub_2d9d
5d0d  c7068d6a0000  mov    word ptr [0x6a8d], 0
5d13  e82501    call   sub_5e3b
5d16  c70679050000  mov    word ptr [0x579], 0
5d1c  e8eea9    call   sub_070d
5d1f  c6067b0560  mov    byte ptr [0x57b], 0x60
5d24  c6067c0592  mov    byte ptr [0x57c], 0x92
5d29  e8c6c9    call   sub_26f2
5d2c  e8cdc9    call   sub_26fc
5d2f  c606801f09  mov    byte ptr [0x1f80], 9
5d34  c606811fff  mov    byte ptr [0x1f81], 0xff
5d39  e877c9    call   sub_26b3
5d3c  e801c1    call   sub_1e40
5d3f  c606980600  mov    byte ptr [0x698], 0
5d44  c606990600  mov    byte ptr [0x699], 0
5d49  c6068a6a00  mov    byte ptr [0x6a8a], 0
5d4e  a19306    mov    ax, word ptr [0x693]
5d51  a35061    mov    word ptr [0x6150], ax
  loc_5d54:
5d54  2ae4      sub    ah, ah
5d56  cd1a      int    0x1a
5d58  89168b6a  mov    word ptr [0x6a8b], dx
5d5c  89162253  mov    word ptr [0x5322], dx
5d60  8916936a  mov    word ptr [0x6a93], dx
5d64  83ea30    sub    dx, 0x30
5d67  8916886a  mov    word ptr [0x6a88], dx
5d6b  c70620530000  mov    word ptr [0x5320], 0
  loc_5d71:
5d71  2ae4      sub    ah, ah
5d73  cd1a      int    0x1a
5d75  8bc2      mov    ax, dx
5d77  2b06936a  sub    ax, word ptr [0x6a93]
5d7b  3d2400    cmp    ax, 0x24
5d7e  7209      jb     loc_5d89
5d80  8916936a  mov    word ptr [0x6a93], dx
5d84  52        push   dx
5d85  e8b300    call   sub_5e3b
5d88  5a        pop    dx
  loc_5d89:
5d89  2b168b6a  sub    dx, word ptr [0x6a8b]
5d8d  a1da56    mov    ax, word ptr [0x56da]
5d90  803e1a0400  cmp    byte ptr [0x41a], 0
5d95  7409      je     loc_5da0
5d97  054800    add    ax, 0x48
5d9a  3bd0      cmp    dx, ax
5d9c  73b6      jae    loc_5d54
5d9e  eb07      jmp    loc_5da7
  loc_5da0:
5da0  050600    add    ax, 6
5da3  3bd0      cmp    dx, ax
5da5  772c      ja     loc_5dd3
  loc_5da7:
5da7  e806f6    call   sub_53b0
5daa  e82700    call   sub_5dd4
5dad  803e9b0600  cmp    byte ptr [0x69b], 0
5db2  7416      je     loc_5dca
5db4  ba0102    mov    dx, 0x201
5db7  ec        in     al, dx
5db8  2410      and    al, 0x10
5dba  7407      je     loc_5dc3
5dbc  c6068a6a01  mov    byte ptr [0x6a8a], 1
5dc1  eb07      jmp    loc_5dca
  loc_5dc3:
5dc3  803e8a6a00  cmp    byte ptr [0x6a8a], 0
5dc8  7509      jne    loc_5dd3
  loc_5dca:
5dca  a15061    mov    ax, word ptr [0x6150]
5dcd  3b069306  cmp    ax, word ptr [0x693]
5dd1  749e      je     loc_5d71
  loc_5dd3:
5dd3  c3        ret

; ----------------------------------------------------------------------
sub_5dd4:
5dd4  833e790520  cmp    word ptr [0x579], 0x20
5dd9  7707      ja     loc_5de2
5ddb  c606980601  mov    byte ptr [0x698], 1
5de0  eb3a      jmp    loc_5e1c
  loc_5de2:
5de2  813e79052001  cmp    word ptr [0x579], 0x120
5de8  7207      jb     loc_5df1
5dea  c6069806ff  mov    byte ptr [0x698], 0xff
5def  eb2b      jmp    loc_5e1c
  loc_5df1:
5df1  2ae4      sub    ah, ah
5df3  cd1a      int    0x1a
5df5  8bc2      mov    ax, dx
5df7  2b06886a  sub    ax, word ptr [0x6a88]
5dfb  3d1200    cmp    ax, 0x12
5dfe  721c      jb     loc_5e1c
5e00  8916886a  mov    word ptr [0x6a88], dx
5e04  e8f6cf    call   sub_2dfd
5e07  c606980600  mov    byte ptr [0x698], 0
5e0c  80faa0    cmp    dl, 0xa0
5e0f  770b      ja     loc_5e1c
5e11  80e201    and    dl, 1
5e14  7502      jne    loc_5e18
5e16  b2ff      mov    dl, 0xff
  loc_5e18:
5e18  88169806  mov    byte ptr [0x698], dl
  loc_5e1c:
5e1c  e8b9b5    call   sub_13d8
5e1f  7409      je     loc_5e2a
5e21  c70672050400  mov    word ptr [0x572], 4
5e27  e8bbaa    call   sub_08e5
  loc_5e2a:
5e2a  c3        ret

; ----------------------------------------------------------------------
sub_5e2b:
5e2b  ac        lodsb  al, byte ptr [si]
5e2c  3c00      cmp    al, 0
5e2e  740a      je     loc_5e3a
5e30  56        push   si
5e31  b302      mov    bl, 2
5e33  b40e      mov    ah, 0xe
5e35  cd10      int    0x10
5e37  5e        pop    si
5e38  ebf1      jmp    loc_5e2b
  loc_5e3a:
5e3a  c3        ret

; ----------------------------------------------------------------------
sub_5e3b:
5e3b  b800b8    mov    ax, 0xb800
5e3e  8ec0      mov    es, ax
5e40  83068d6a02  add    word ptr [0x6a8d], 2
5e45  8b1e8d6a  mov    bx, word ptr [0x6a8d]
5e49  81e30200  and    bx, 2
5e4d  8bb78f6a  mov    si, word ptr [bx + 0x6a8f]
5e51  b90a0c    mov    cx, 0xc0a
5e54  bf381d    mov    di, 0x1d38
5e57  e843cf    call   sub_2d9d
5e5a  c3        ret

; ----------------------------------------------------------------------
sub_5e5b:
5e5b  b200      mov    dl, 0
5e5d  8afa      mov    bh, dl
5e5f  b402      mov    ah, 2
5e61  cd10      int    0x10
5e63  c3        ret
5e64  db 00,00,00,00,00,00,00,00,00,00,00,00   ; ............

; ----------------------------------------------------------------------
sub_5e70:
5e70  e8aefc    call   sub_5b21
5e73  2ae4      sub    ah, ah
5e75  cd1a      int    0x1a
5e77  8916fc6d  mov    word ptr [0x6dfc], dx
5e7b  890efe6d  mov    word ptr [0x6dfe], cx
5e7f  1e        push   ds
5e80  1e        push   ds
5e81  07        pop    es
5e82  b800b8    mov    ax, 0xb800
5e85  8ed8      mov    ds, ax
5e87  beca0d    mov    si, 0xdca
5e8a  bf0e00    mov    di, 0xe
5e8d  b92010    mov    cx, 0x1020
5e90  e837cf    call   sub_2dca
5e93  1f        pop    ds
5e94  ba050b    mov    dx, 0xb05
5e97  b700      mov    bh, 0
5e99  b402      mov    ah, 2
5e9b  cd10      int    0x10
5e9d  be916d    mov    si, 0x6d91
5ea0  fc        cld
5ea1  e887ff    call   sub_5e2b
5ea4  ba050c    mov    dx, 0xc05
5ea7  b700      mov    bh, 0
5ea9  b402      mov    ah, 2
5eab  cd10      int    0x10
5ead  beb26d    mov    si, 0x6db2
5eb0  803e9b0600  cmp    byte ptr [0x69b], 0
5eb5  7403      je     loc_5eba
5eb7  bed36d    mov    si, 0x6dd3
  loc_5eba:
5eba  fc        cld
5ebb  e86dff    call   sub_5e2b
5ebe  e8d600    call   sub_5f97
5ec1  b800b8    mov    ax, 0xb800
5ec4  8ec0      mov    es, ax
5ec6  be0e00    mov    si, 0xe
5ec9  bfca0d    mov    di, 0xdca
5ecc  b92010    mov    cx, 0x1020
5ecf  e8cbce    call   sub_2d9d
5ed2  b401      mov    ah, 1
5ed4  8b0efe6d  mov    cx, word ptr [0x6dfe]
5ed8  8b16fc6d  mov    dx, word ptr [0x6dfc]
5edc  cd1a      int    0x1a
5ede  a19306    mov    ax, word ptr [0x693]
5ee1  a3006e    mov    word ptr [0x6e00], ax
5ee4  c3        ret

; ----------------------------------------------------------------------
sub_5ee5:
5ee5  e839fc    call   sub_5b21
  loc_5ee8:
5ee8  e8e200    call   sub_5fcd
5eeb  c7068f6d0000  mov    word ptr [0x6d8f], 0
5ef1  e8bd00    call   sub_5fb1
  loc_5ef4:
5ef4  a19306    mov    ax, word ptr [0x693]
  loc_5ef7:
5ef7  3b069306  cmp    ax, word ptr [0x693]
5efb  74fa      je     loc_5ef7
5efd  f606c10680  test   byte ptr [0x6c1], 0x80
5f02  740e      je     loc_5f12
5f04  f606c20680  test   byte ptr [0x6c2], 0x80
5f09  75e9      jne    loc_5ef4
5f0b  c6069b0600  mov    byte ptr [0x69b], 0
5f10  eb0a      jmp    loc_5f1c
  loc_5f12:
5f12  e8d000    call   sub_5fe5
5f15  72d1      jb     loc_5ee8
5f17  c6069b0601  mov    byte ptr [0x69b], 1
  loc_5f1c:
5f1c  b90500    mov    cx, 5
  loc_5f1f:
5f1f  51        push   cx
5f20  e88e00    call   sub_5fb1
5f23  59        pop    cx
5f24  e2f9      loop   loc_5f1f
  loc_5f26:
5f26  a19306    mov    ax, word ptr [0x693]
  loc_5f29:
5f29  3b069306  cmp    ax, word ptr [0x693]
5f2d  74fa      je     loc_5f29
5f2f  2bc0      sub    ax, ax
5f31  f606c30680  test   byte ptr [0x6c3], 0x80
5f36  7418      je     loc_5f50
5f38  40        inc    ax
5f39  f606c40680  test   byte ptr [0x6c4], 0x80
5f3e  7410      je     loc_5f50
5f40  40        inc    ax
5f41  f606c50680  test   byte ptr [0x6c5], 0x80
5f46  7408      je     loc_5f50
5f48  40        inc    ax
5f49  f606c60680  test   byte ptr [0x6c6], 0x80
5f4e  75d6      jne    loc_5f26
  loc_5f50:
5f50  a3f86d    mov    word ptr [0x6df8], ax
5f53  b90500    mov    cx, 5
  loc_5f56:
5f56  51        push   cx
5f57  e85700    call   sub_5fb1
5f5a  59        pop    cx
5f5b  e2f9      loop   loc_5f56
5f5d  803e9b0600  cmp    byte ptr [0x69b], 0
5f62  741a      je     loc_5f7e
5f64  c7068f6d2000  mov    word ptr [0x6d8f], 0x20
5f6a  e84400    call   sub_5fb1
5f6d  e84100    call   sub_5fb1
5f70  c7068f6d1800  mov    word ptr [0x6d8f], 0x18
5f76  e83800    call   sub_5fb1
5f79  e83500    call   sub_5fb1
5f7c  eb15      jmp    loc_5f93
  loc_5f7e:
5f7e  c7068f6d1c00  mov    word ptr [0x6d8f], 0x1c
5f84  e82a00    call   sub_5fb1
5f87  e82700    call   sub_5fb1
5f8a  c7068f6d1600  mov    word ptr [0x6d8f], 0x16
5f90  e81e00    call   sub_5fb1
  loc_5f93:
5f93  e80100    call   sub_5f97
5f96  c3        ret

; ----------------------------------------------------------------------
sub_5f97:
5f97  803e9b0600  cmp    byte ptr [0x69b], 0
5f9c  7409      je     loc_5fa7
  loc_5f9e:
5f9e  ba0102    mov    dx, 0x201
5fa1  ec        in     al, dx
5fa2  2410      and    al, 0x10
5fa4  75f8      jne    loc_5f9e
5fa6  c3        ret
  loc_5fa7:
5fa7  a19306    mov    ax, word ptr [0x693]
  loc_5faa:
5faa  3b069306  cmp    ax, word ptr [0x693]
5fae  74fa      je     loc_5faa
5fb0  c3        ret

; ----------------------------------------------------------------------
sub_5fb1:
5fb1  8b1e8f6d  mov    bx, word ptr [0x6d8f]
5fb5  8b97636d  mov    dx, word ptr [bx + 0x6d63]
5fb9  e89ffe    call   sub_5e5b
5fbc  8b1e8f6d  mov    bx, word ptr [0x6d8f]
5fc0  83068f6d02  add    word ptr [0x6d8f], 2
5fc5  8bb7376d  mov    si, word ptr [bx + 0x6d37]
5fc9  e85ffe    call   sub_5e2b
5fcc  c3        ret

; ----------------------------------------------------------------------
sub_5fcd:
5fcd  fc        cld
5fce  b800b8    mov    ax, 0xb800
5fd1  8ec0      mov    es, ax
5fd3  2bc0      sub    ax, ax
5fd5  8bf8      mov    di, ax
5fd7  b9a00f    mov    cx, 0xfa0
5fda  f3ab      rep stosw word ptr es:[di], ax
5fdc  bf0020    mov    di, 0x2000
5fdf  b9a00f    mov    cx, 0xfa0
5fe2  f3ab      rep stosw word ptr es:[di], ax
5fe4  c3        ret

; ----------------------------------------------------------------------
sub_5fe5:
5fe5  cd11      int    0x11
5fe7  a90010    test   ax, 0x1000
5fea  740a      je     loc_5ff6
5fec  e82000    call   sub_600f
5fef  731d      jae    loc_600e
5ff1  e81b00    call   sub_600f
5ff4  7318      jae    loc_600e
  loc_5ff6:
5ff6  c7068f6d2400  mov    word ptr [0x6d8f], 0x24
5ffc  b90400    mov    cx, 4
  loc_5fff:
5fff  e8afff    call   sub_5fb1
6002  e2fb      loop   loc_5fff
6004  a19306    mov    ax, word ptr [0x693]
  loc_6007:
6007  3b069306  cmp    ax, word ptr [0x693]
600b  74fa      je     loc_6007
600d  f9        stc
  loc_600e:
600e  c3        ret

; ----------------------------------------------------------------------
sub_600f:
600f  ba0102    mov    dx, 0x201
6012  ee        out    dx, al
6013  2ae4      sub    ah, ah
6015  cd1a      int    0x1a
6017  8916fa6d  mov    word ptr [0x6dfa], dx
  loc_601b:
601b  ba0102    mov    dx, 0x201
601e  ec        in     al, dx
601f  a803      test   al, 3
6021  7502      jne    loc_6025
6023  f8        clc
6024  c3        ret
  loc_6025:
6025  2ae4      sub    ah, ah
6027  cd1a      int    0x1a
6029  2b16fa6d  sub    dx, word ptr [0x6dfa]
602d  83fa12    cmp    dx, 0x12
6030  72e9      jb     loc_601b
6032  f9        stc
6033  c3        ret
6034  db 00,00,00,00,00,00,00,00,00,00,00,00   ; ............

; ----------------------------------------------------------------------
sub_6040:
6040  fc        cld
6041  1e        push   ds
6042  07        pop    es
6043  bf0e00    mov    di, 0xe
6046  b92400    mov    cx, 0x24
6049  2bc0      sub    ax, ax
604b  f3ab      rep stosw word ptr es:[di], ax
604d  c706246f2500  mov    word ptr [0x6f24], 0x25
6053  b800b8    mov    ax, 0xb800
6056  8ec0      mov    es, ax
  loc_6058:
6058  e87db3    call   sub_13d8
605b  74fb      je     loc_6058
605d  be0e00    mov    si, 0xe
6060  8b3e246f  mov    di, word ptr [0x6f24]
6064  b9030c    mov    cx, 0xc03
6067  e833cd    call   sub_2d9d
606a  8106246fe001  add    word ptr [0x6f24], 0x1e0
6070  be106e    mov    si, 0x6e10
6073  8b3e246f  mov    di, word ptr [0x6f24]
6077  b9030c    mov    cx, 0xc03
607a  e820cd    call   sub_2d9d
  loc_607d:
607d  2ae4      sub    ah, ah
607f  cd1a      int    0x1a
6081  3b16266f  cmp    dx, word ptr [0x6f26]
6085  74f6      je     loc_607d
6087  8916266f  mov    word ptr [0x6f26], dx
608b  803e000000  cmp    byte ptr [0], 0
6090  7415      je     loc_60a7
6092  b0b6      mov    al, 0xb6
6094  e643      out    0x43, al
6096  a1246f    mov    ax, word ptr [0x6f24]
6099  d1e8      shr    ax, 1
609b  e642      out    0x42, al
609d  8ac4      mov    al, ah
609f  e642      out    0x42, al
60a1  e461      in     al, 0x61
60a3  0c03      or     al, 3
60a5  e661      out    0x61, al
  loc_60a7:
60a7  813e246f401a  cmp    word ptr [0x6f24], 0x1a40
60ad  72a9      jb     loc_6058
60af  be586e    mov    si, 0x6e58
60b2  8b3e246f  mov    di, word ptr [0x6f24]
60b6  b90611    mov    cx, 0x1106
60b9  e8e1cc    call   sub_2d9d
  loc_60bc:
60bc  2ae4      sub    ah, ah
60be  cd1a      int    0x1a
60c0  3b16286f  cmp    dx, word ptr [0x6f28]
60c4  74f6      je     loc_60bc
60c6  8916286f  mov    word ptr [0x6f28], dx
60ca  803e000000  cmp    byte ptr [0], 0
60cf  7415      je     loc_60e6
60d1  b0b6      mov    al, 0xb6
60d3  e643      out    0x43, al
60d5  b8000c    mov    ax, 0xc00
60d8  f6c201    test   dl, 1
60db  7403      je     loc_60e0
60dd  b8540b    mov    ax, 0xb54
  loc_60e0:
60e0  e642      out    0x42, al
60e2  8ac4      mov    al, ah
60e4  e642      out    0x42, al
  loc_60e6:
60e6  2b16266f  sub    dx, word ptr [0x6f26]
60ea  83fa12    cmp    dx, 0x12
60ed  72cd      jb     loc_60bc
60ef  e82ffa    call   sub_5b21
60f2  c3        ret
60f3  db 00,00,00,00,00,00,00,00,00,00,00,00,00   ; .............

; ----------------------------------------------------------------------
sub_6100:
6100  c606f27000  mov    byte ptr [0x70f2], 0
6105  c3        ret

; ----------------------------------------------------------------------
sub_6106:
6106  2ae4      sub    ah, ah
6108  cd1a      int    0x1a
610a  3b16ee70  cmp    dx, word ptr [0x70ee]
610e  7501      jne    loc_6111
6110  c3        ret
  loc_6111:
6111  8916ee70  mov    word ptr [0x70ee], dx
6115  e88e01    call   sub_62a6
6118  730f      jae    loc_6129
611a  e8c6b0    call   sub_11e3
611d  e80b01    call   sub_622b
6120  e822b0    call   sub_1145
6123  c606f27000  mov    byte ptr [0x70f2], 0
6128  c3        ret
  loc_6129:
6129  803ef27000  cmp    byte ptr [0x70f2], 0
612e  756e      jne    loc_619e
  loc_6130:
6130  e8cacc    call   sub_2dfd
6133  8bda      mov    bx, dx
6135  81e31f00  and    bx, 0x1f
6139  80fb10    cmp    bl, 0x10
613c  7228      jb     loc_6166
613e  80eb10    sub    bl, 0x10
6141  80fb09    cmp    bl, 9
6144  77ea      ja     loc_6130
6146  b201      mov    dl, 1
6148  80fb05    cmp    bl, 5
614b  7202      jb     loc_614f
614d  b2ff      mov    dl, 0xff
  loc_614f:
614f  8816f670  mov    byte ptr [0x70f6], dl
6153  c606f57006  mov    byte ptr [0x70f5], 6
6158  d0e3      shl    bl, 1
615a  8b87b870  mov    ax, word ptr [bx + 0x70b8]
615e  050400    add    ax, 4
6161  a3f370    mov    word ptr [0x70f3], ax
6164  eb22      jmp    loc_6188
  loc_6166:
6166  b80c00    mov    ax, 0xc
6169  b201      mov    dl, 1
616b  f6c308    test   bl, 8
616e  7405      je     loc_6175
6170  b82001    mov    ax, 0x120
6173  b2ff      mov    dl, 0xff
  loc_6175:
6175  a3f370    mov    word ptr [0x70f3], ax
6178  8816f670  mov    byte ptr [0x70f6], dl
617c  80e307    and    bl, 7
617f  8a87b070  mov    al, byte ptr [bx + 0x70b0]
6183  0408      add    al, 8
6185  a2f570    mov    byte ptr [0x70f5], al
  loc_6188:
6188  c606f27001  mov    byte ptr [0x70f2], 1
618d  c606f77001  mov    byte ptr [0x70f7], 1
6192  c706f0700000  mov    word ptr [0x70f0], 0
6198  c706ec70ffff  mov    word ptr [0x70ec], 0xffff
  loc_619e:
619e  813ef070a000  cmp    word ptr [0x70f0], 0xa0
61a4  7305      jae    loc_61ab
61a6  8306f07004  add    word ptr [0x70f0], 4
  loc_61ab:
61ab  8006f57002  add    byte ptr [0x70f5], 2
61b0  803ef570bf  cmp    byte ptr [0x70f5], 0xbf
61b5  771d      ja     loc_61d4
61b7  803ef67001  cmp    byte ptr [0x70f6], 1
61bc  7409      je     loc_61c7
61be  832ef37005  sub    word ptr [0x70f3], 5
61c3  720f      jb     loc_61d4
61c5  eb16      jmp    loc_61dd
  loc_61c7:
61c7  8306f37005  add    word ptr [0x70f3], 5
61cc  813ef3702c01  cmp    word ptr [0x70f3], 0x12c
61d2  7209      jb     loc_61dd
  loc_61d4:
61d4  c606f27000  mov    byte ptr [0x70f2], 0
61d9  e84f00    call   sub_622b
61dc  c3        ret
  loc_61dd:
61dd  8b0ef370  mov    cx, word ptr [0x70f3]
61e1  8a16f570  mov    dl, byte ptr [0x70f5]
61e5  e8c8ca    call   sub_2cb0
61e8  a3fa70    mov    word ptr [0x70fa], ax
61eb  e8b800    call   sub_62a6
61ee  72e4      jb     loc_61d4
61f0  e85200    call   sub_6245
61f3  e83500    call   sub_622b
61f6  e80100    call   sub_61fa
61f9  c3        ret

; ----------------------------------------------------------------------
sub_61fa:
61fa  b800b8    mov    ax, 0xb800
61fd  8ec0      mov    es, ax
61ff  c606f77000  mov    byte ptr [0x70f7], 0
6204  a1f070    mov    ax, word ptr [0x70f0]
6207  25e001    and    ax, 0x1e0
620a  05306f    add    ax, 0x6f30
620d  803ef670ff  cmp    byte ptr [0x70f6], 0xff
6212  7403      je     loc_6217
6214  05c000    add    ax, 0xc0
  loc_6217:
6217  8bf0      mov    si, ax
6219  8b3efa70  mov    di, word ptr [0x70fa]
621d  893ef870  mov    word ptr [0x70f8], di
6221  bdcc70    mov    bp, 0x70cc
6224  b90208    mov    cx, 0x802
6227  e8a2ca    call   sub_2ccc
622a  c3        ret

; ----------------------------------------------------------------------
sub_622b:
622b  803ef77000  cmp    byte ptr [0x70f7], 0
6230  7512      jne    loc_6244
6232  b800b8    mov    ax, 0xb800
6235  8ec0      mov    es, ax
6237  becc70    mov    si, 0x70cc
623a  8b3ef870  mov    di, word ptr [0x70f8]
623e  b90208    mov    cx, 0x802
6241  e859cb    call   sub_2d9d
  loc_6244:
6244  c3        ret

; ----------------------------------------------------------------------
sub_6245:
6245  a0f570    mov    al, byte ptr [0x70f5]
6248  2c08      sub    al, 8
624a  24f8      and    al, 0xf8
624c  b90700    mov    cx, 7
  loc_624f:
624f  8bd9      mov    bx, cx
6251  4b        dec    bx
6252  3a87d42b  cmp    al, byte ptr [bx + 0x2bd4]
6256  7403      je     loc_625b
6258  e2f5      loop   loc_624f
  loc_625a:
625a  c3        ret
  loc_625b:
625b  a1f370    mov    ax, word ptr [0x70f3]
625e  b104      mov    cl, 4
6260  d3e8      shr    ax, cl
6262  2d0200    sub    ax, 2
6265  72f3      jb     loc_625a
6267  3d1000    cmp    ax, 0x10
626a  73ee      jae    loc_625a
626c  8bf8      mov    di, ax
626e  8a97db2b  mov    dl, byte ptr [bx + 0x2bdb]
6272  2af6      sub    dh, dh
6274  03c2      add    ax, dx
6276  3b06ec70  cmp    ax, word ptr [0x70ec]
627a  74de      je     loc_625a
627c  a3ec70    mov    word ptr [0x70ec], ax
627f  8bf0      mov    si, ax
6281  80b4e22b02  xor    byte ptr [si + 0x2be2], 2
6286  8a84e22b  mov    al, byte ptr [si + 0x2be2]
628a  2ae4      sub    ah, ah
628c  d1e7      shl    di, 1
628e  8b8dfc70  mov    cx, word ptr [di + 0x70fc]
6292  8a972071  mov    dl, byte ptr [bx + 0x7120]
6296  50        push   ax
6297  51        push   cx
6298  52        push   dx
6299  e88fff    call   sub_622b
629c  5a        pop    dx
629d  59        pop    cx
629e  5b        pop    bx
629f  e841ce    call   sub_30e3
62a2  e855ff    call   sub_61fa
62a5  c3        ret

; ----------------------------------------------------------------------
sub_62a6:
62a6  803ef27000  cmp    byte ptr [0x70f2], 0
62ab  7502      jne    loc_62af
62ad  f8        clc
62ae  c3        ret
  loc_62af:
62af  a1f370    mov    ax, word ptr [0x70f3]
62b2  8a16f570  mov    dl, byte ptr [0x70f5]
62b6  be1000    mov    si, 0x10
62b9  8b1e7905  mov    bx, word ptr [0x579]
62bd  8a367b05  mov    dh, byte ptr [0x57b]
62c1  bf1800    mov    di, 0x18
62c4  b9080e    mov    cx, 0xe08
62c7  e85fcb    call   sub_2e29
62ca  731e      jae    loc_62ea
62cc  c606710501  mov    byte ptr [0x571], 1
62d1  c606760502  mov    byte ptr [0x576], 2
62d6  c606780520  mov    byte ptr [0x578], 0x20
62db  c6065b0508  mov    byte ptr [0x55b], 8
62e0  b81d09    mov    ax, 0x91d
62e3  bbe40c    mov    bx, 0xce4
62e6  e852f6    call   sub_593b
62e9  f9        stc
  loc_62ea:
62ea  c3        ret
