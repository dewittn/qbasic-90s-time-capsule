'HI all! Remember that little Spinball game I posted a couple of days ago??
'Well, I'm thinking about makeing a better version of it..REAL graphics for the
'backgroud instead of text..smooth scrolling background that is bigger. So far
'this is all i've made today..I sample of a scrolling background..THIS MUST BE
'COMPILED or it won't work..because it pokes above the 32767 barrier thing..Use
'the keypad keys (up, down, left and right) to move it. Numlock MUST be on.
'This is just a simple thing that i spent a couple of hours on, so you can't
'press more than one key..it uses that old INKEY$..Hope this helps someone out
'there!! Also, the file LEVEL1.DAT is the level data file. It's in ASCII so you
'could edit it with EDIT, just like the levels in my Spinball Game.
                            
 DEFINT A-Z:DIM SHARED K,S,B&,Z&:V1 'Created by PostIt! 7.2
 SUB V1:OPEN "O",1,"SCROLL.ZIP",4^6:Z&=1758:?STRING$(50,177);
U"%up()%9%'%R-%,K&]ELx<jy((.%%M/%%%/%%%%xh%wtqq%SgfxN&%<>\r]5w5]=
U"N=H*b/E^nSnKTdj6d)G##ys;1QV>Tuwd&AXC1JUYd%$3yrf2h65C3HZlwL;DE$k
U"oWBaEWD30.TC1=T=h]JLPtid1VwVUe)f-^j7Kv-:o,iprN7A/b&Xx>ajC+=$WWf
U"Bb&q,7,m,InRuwvSq+Sbj(NYFt3f1><F,4]i>Th.Bos/ksP<p>&X)iK-2o9_W83
U"/7-?X\F<=6<r)ul_04iBK^e*'&IGOe0_l,o'?.[FOj-12NrZ[+rUg,Zh:?b#B.C
U"+2w4'oPx2jFb9DAhvD>v/0Ye1M%A5k_#TDX4f)oxIwhWuCVpV5VuYi6Uz=;Ad8H
U"aqji)T<NX[>3o(.2QQn5z-/uHlVCnumCjEuL]jdEC-r=up*ob?48t^V(*tVtQ<U
U"?J5^:b)%^lbnY>YwNq0ky[JVAT_RwZT%%i6PV=<b_7zKBooRNrB)eC:qNSS./po
U"+2&1YWo=u\xkIY-&_NTIK,L=bIq<Pn;XYT)):t9%6BSoY\_gFsVJ3Ol0/trpt&c
U"7H4ikOb[KQ5*zGM6zv>]37zmDB.7OzhL^&jN+^ev[rM&Un1nm9xu+RjT]qY9W]O
U"h6;?V[u\#cs2u)F-P),91?K?=1ha6b(>7Wm25\?r[C<KTcB]>/Q'FE03m3\)D(X
U"^aJ?hXDi%C4/YlFU??;?D0bi\8](*X/)N$Yu.Qn-qx)v%WEhso\(eQ=[6fG?[kV
U"GQJ_/EE:Ja>t1Bd1:^ahtgp_Bs=hb/NK*-4\;wBJ2Ut4+1Z)6#x9VrE8^bVp6nJ
U")?6Ic,?MvEQ60%A_N3my]6OO3EPb:Xb%tVUzFLGO)V8]C&Z$9eDBDL1$KT\GY:e
U"8RF.viBOPGEIb#s't';#?9mn7CUrAUYT,=D<9\3\ch*p[h)23:M[oe>bupdaC>*
U"i_m*\??tO1keD2+cST-'<I+(K1$I;9+XQyBCoyCGgK[?i663<$2G>Cz]lM9$]DK
U"qxIgDyeH+lb+%]TcbuqmWL/BDRW,^6/*cJfxQ.gtt2axS4-XD=qMDu+Nq:Ug33L
U"N&igTokKr$=HEBCv0Sv-'&?BQKrq$4]&Lt.[JLBo*Af0a?[m-+MOcriYj0*VY='
U"U0\2Tv_;Yf6IS3_0d9?Omq_gn9Xx?D6jiQI/&>7gXI[bLH\g8dH48Khx8NpXn1V
U"vexp\Iqm:Qcm4RthN(6_nN]VkxEn+Aidu%p()9%%'%-I%NI]FEoL9&?u&%%%H+%
U"%%,%%%%gqp%SvuhB^wf=]=U-5alkDs;Td^?KDg?7Z(ftnrLO:?WWdSJ\$[&HaU<
U"78sbWXKJ4tHOCi:2O4bNO+$U%UARvM65e6\<YBJJZjFIX&b>#8N*j=5>uiYwV8E
U"*ud7ZG[(%&o^-#k5W[Qi51<IP2O#KgSUCn)iz,hZ&6$k;jdp$4$%1\dc49LY)sT
U"cCuKUG*MyEw8ol20Aywz];UmN\FFpZ]U5IH093KuV/ns&<8=7cSG_N/BAgt*%bl
U"'w).al,Nd;Od?1&8\(00cAC#Bg=sdHiR4A0=q#)bWNFFS8Z^t1NRLAE2ijm?2I)
U"8J((;I5\o4WQOtlh\=W:L5L2G#qB[O,4T%C_NjqGL\OveGl=2;=(J*tt.HS9)nQ
U"[N4<#,AhXm=:dchH7j;wpALI.-jmX3KuNSm_j?K(xQ2,^NCubsqw9sqP4%up()%
U"9%'%#-%HLS]EFB7HQ(%7%%<1%%%/%%%%qj&%jqV%Sify-fOV3&TE1+6YVS$]m%1
U"kd78(4u5>Jl?X^>e#y5DcK-1SN:V1K4.0=\[n9W,N8nzTjC#zK;\iG4k_pHeESB
U"c+-W=a6/H'ppq;lgku0G(-T=v[%Sfa:<H6g57EZZ^/96>t,hd4TNq?dsb,Y2(Y:
U"Ox2M0f$-.0QcvA.1ZO>=R34X^>w9wit;g6nqBFZlbK.bAG#hC>gSKm(H/v4nQPu
U"N1GG<#-+LW4u%p&'9%%9%'[%-%,)K]ELjxjy(#(%%M%/%%/%%%%%%%%%&%%E%%%
U"%%%%%%xhw%tqqS%gfxu%p&'9%%9%'%%-%N_I]Eo1L9?u%&%%H%+%%,%%%%%%%%%
U"&%%E%%+%P(%%%gqp%Svuh%up&'%9%9%%'%-%1HL]E*FBHQ'(%%%'<1%%%/%%%%%
U"%%%%&%E%%%%q*%%%qj&%jqV%Sify%up*+%%%%%%(%(%&t%%%%H+%%%%%
 END SUB
 CLOSE:IF S=78AND B&=Z&THEN?" :) Ok!"ELSE?" :( Bad!
 SUB U(A$):FOR A=1TO LEN(A$):C=ASC(MID$(A$,A))-37:IF C<0THEN C=91+C*32
 IF K<4THEN K=C+243ELSE?#1,CHR$(C+(K MOD 3)*86);:K=K\3:B&=B&+1
 S=(S+C)AND 255:NEXT:LOCATE,1:?STRING$(B&*50\Z&,219);:END SUB
