Overworld_LoadBonkTiles:
{
    SEP #$30
    LDA.l OWFlags+1 : AND.b #$02 : BEQ .return
        PHB

        ; Set the data bank to $7E.
        LDA.b #$7E : PHA : PLB
        REP #$30
        ; Use it as an index into a jump table.
        LDA.b $8A : CMP #$0080 : !BGE .noData
            ASL A : TAX : JSR (Overworld_BonkTilesTable, X)
        
        .noData
        PLB

    .return
    REP #$30
    RTL
}


Overworld_BonkTilesTable:
{
;LW
    ;00      01      02      03      04      05      06      07
dw  map00, return, return, return, return, return, return, return
    ;08      09      10      11      12      13      14      15
dw return, return,  map0a, return, return, return, return, return
    ;16      17      18      19      20      21      22      23
dw  map10, return,  map12,  map13, return,  map15,  map16, return
    ;24      25      26      27      28      29      30      31
dw  map18, return,  map1a,  map1b, return,  map1d,  map1e, return
    ;32      33      34      35      36      37      38      39
dw return, return, return, return, return, return, return, return
    ;40      41      42      43      44      45      46      47
dw return, return,  map2a,  map2b, return, return,  map2e, return
    ;48      49      50      51      52      53      54      55
dw return, return,  map32, return, return, return, return, return
    ;56      57      58      59      60      61      62      63
dw return, return, return, return, return, return, return, return
;DW
    ;64      65      66      67      68      69      70      71
dw return, return,  map42, return, return, return, return, return
    ;72      73      74      75      76      77      78      79
dw return, return, return, return, return, return, return, return
    ;80      81      82      83      84      85      86      87
dw return, return, return,  map53, return,  map55,  map56, return
    ;88      89      90      91      92      93      94      95
dw  map58, return, return,  map5b, return, return,  map5e, return
    ;96      97      98      99     100     101     102     103
dw return, return, return, return, return, return, return, return
    ;104     105    106     107     108     109     110     111
dw return, return, return, return, return, return,  map6e, return
    ;112     113    114     115     116     117     118     119
dw return, return, return, return, return, return, return, return
    ;120     121    122     123     124     125     126     127
dw return, return, return, return, return, return, return, return


map00: ; Map00/Map01/Map08/Map09
{
LDA.l OverworldEventDataWRAM+$00 : BIT.w #$0010 : BNE +
    LDA #$0364 : STA $31D0
    LDA #$0365 : STA $31D2
    LDA #$0366 : STA $31D4
    LDA #$0367 : STA $31D6
    LDA #$0368 : STA $3250
    LDA #$0369 : STA $3252
    LDA #$036A : STA $3254
    LDA #$036B : STA $3256
    LDA #$036E : STA $32D0
    LDA #$036F : STA $32D2
    LDA #$0370 : STA $32D4
    LDA #$0371 : STA $32D6
    LDA #$0375 : STA $3350
    LDA #$0376 : STA $3352
    LDA #$0377 : STA $3354
    LDA #$0378 : STA $3356

+ RTS
}

map0a: ; Map10
{
LDA.l OverworldEventDataWRAM+$0a : BIT.w #$0010 : BNE +
    ; north tree
    PHA
    LDA #$0364 : STA $2118
    LDA #$0365 : STA $211A
    LDA #$0366 : STA $211C
    LDA #$0367 : STA $211E
    LDA #$0368 : STA $2198
    LDA #$0369 : STA $219A
    LDA #$036A : STA $219C
    LDA #$036B : STA $219E
    LDA #$036E : STA $2218
    LDA #$036F : STA $221A
    LDA #$0370 : STA $221C
    LDA #$0371 : STA $221E
    LDA #$0375 : STA $2298
    LDA #$0376 : STA $229A
    LDA #$0377 : STA $229C
    LDA #$0378 : STA $229E
    PLA

+ BIT.w #$0008 : BNE +
    ; south tree
    LDA #$0364 : STA $2C30
    LDA #$0365 : STA $2C32
    LDA #$0366 : STA $2C34
    LDA #$0367 : STA $2C36
    LDA #$0368 : STA $2CB0
    LDA #$0369 : STA $2CB2
    LDA #$036A : STA $2CB4
    LDA #$036B : STA $2CB6
    LDA #$036E : STA $2D30
    LDA #$036F : STA $2D32
    LDA #$0370 : STA $2D34
    LDA #$0371 : STA $2D36
    LDA #$0375 : STA $2DB0
    LDA #$0376 : STA $2DB2
    LDA #$0377 : STA $2DB4
    LDA #$0378 : STA $2DB6

+ RTS
}

map10: ; Map16
{
LDA.l OverworldEventDataWRAM+$10 : BIT.w #$0010 : BNE +
    ; west tree
    PHA
    LDA #$0364 : STA $250C
    LDA #$0365 : STA $250E
    LDA #$0366 : STA $2510
    LDA #$0367 : STA $2512
    LDA #$0368 : STA $258C
    LDA #$0369 : STA $258E
    LDA #$036A : STA $2590
    LDA #$036B : STA $2592
    LDA #$036E : STA $260C
    LDA #$036F : STA $260E
    LDA #$0370 : STA $2610
    LDA #$0371 : STA $2612
    LDA #$0375 : STA $268C
    LDA #$0376 : STA $268E
    LDA #$0377 : STA $2690
    LDA #$0378 : STA $2692
    PLA

+ BIT.w #$0008 : BNE +
    ; east tree
    LDA #$0364 : STA $26AC
    LDA #$0365 : STA $26AE
    LDA #$0366 : STA $26B0
    LDA #$0367 : STA $26B2
    LDA #$0368 : STA $272C
    LDA #$0369 : STA $272E
    LDA #$036A : STA $2730
    LDA #$036B : STA $2732
    LDA #$036E : STA $27AC
    LDA #$036F : STA $27AE
    LDA #$0370 : STA $27B0
    LDA #$0371 : STA $27B2
    LDA #$0375 : STA $282C
    LDA #$0376 : STA $282E
    LDA #$0377 : STA $2830
    LDA #$0378 : STA $2832

+ RTS
}

map12: ; Map18
{
LDA.l OverworldEventDataWRAM+$12 : BIT.w #$0010 : BNE +
    LDA #$0364 : STA $2426
    LDA #$0365 : STA $2428
    LDA #$064F : STA $242A
    LDA #$0652 : STA $242C
    LDA #$0368 : STA $24A6
    LDA #$0369 : STA $24A8
    LDA #$036A : STA $24AA
    LDA #$0655 : STA $24AC
    LDA #$036E : STA $2526
    LDA #$036F : STA $2528
    LDA #$0370 : STA $252A
    LDA #$0371 : STA $252C
    LDA #$0375 : STA $25A6
    LDA #$0376 : STA $25A8
    LDA #$0377 : STA $25AA
    LDA #$0378 : STA $25AC

+ RTS
}

map13: ; Map19
{
LDA.l OverworldEventDataWRAM+$13 : BIT.w #$0010 : BNE +
    ; ledge tree
    PHA
    LDA #$0364 : STA $250C
    LDA #$0365 : STA $250E
    LDA #$0366 : STA $2510
    LDA #$0367 : STA $2512
    LDA #$0368 : STA $258C
    LDA #$0369 : STA $258E
    LDA #$036A : STA $2590
    LDA #$036B : STA $2592
    LDA #$036E : STA $260C
    LDA #$036F : STA $260E
    LDA #$0370 : STA $2610
    LDA #$0371 : STA $2612
    LDA #$0375 : STA $268C
    LDA #$0376 : STA $268E
    LDA #$0377 : STA $2690
    LDA #$0378 : STA $2692
    PLA

+ BIT.w #$0008 : BEQ + ; BEQ because tree is already colored
    ; east tree
    LDA #$00AE : STA $23AE
    LDA #$00AF : STA $23B0
    LDA #$007E : STA $23B2
    LDA #$007F : STA $23B4
    LDA #$00B0 : STA $242E
    LDA #$0014 : STA $2430
    LDA #$0015 : STA $2432
    LDA #$00A8 : STA $2434
    LDA #$0089 : STA $24AE
    LDA #$001C : STA $24B0
    LDA #$001D : STA $24B2
    LDA #$0076 : STA $24B4
    LDA #$00F1 : STA $252E
    LDA #$004E : STA $2530
    LDA #$004F : STA $2532
    LDA #$00D9 : STA $2534
+

; west tree
LDA #$00AE : STA $23A2
LDA #$00AF : STA $23A4
LDA #$007E : STA $23A6
LDA #$007F : STA $23A8
LDA #$00B0 : STA $2422
LDA #$0014 : STA $2424
LDA #$0015 : STA $2426
LDA #$00A8 : STA $2428
LDA #$0089 : STA $24A2
LDA #$001C : STA $24A4
LDA #$001D : STA $24A6
LDA #$0076 : STA $24A8
LDA #$00F1 : STA $2522
LDA #$004E : STA $2524
LDA #$004F : STA $2526
LDA #$00D9 : STA $2528

RTS
}

map15: ; Map21
{
LDA.l OverworldEventDataWRAM+$15 : BIT.w #$0010 : BNE +
    ; southwest tree
    PHA
    LDA #$0364 : STA $2C06
    LDA #$0365 : STA $2C08
    LDA #$0366 : STA $2C0A
    LDA #$0367 : STA $2C0C
    LDA #$0368 : STA $2C86
    LDA #$0369 : STA $2C88
    LDA #$036A : STA $2C8A
    LDA #$036B : STA $2C8C
    LDA #$036E : STA $2D06
    LDA #$036F : STA $2D08
    LDA #$0370 : STA $2D0A
    LDA #$0371 : STA $2D0C
    LDA #$0375 : STA $2D86
    LDA #$0376 : STA $2D88
    LDA #$0377 : STA $2D8A
    LDA #$0378 : STA $2D8C
    PLA

+ BIT.w #$0008 : BNE +
    ; east bank tree
    LDA #$0364 : STA $26B4
    LDA #$0365 : STA $26B6
    LDA #$0366 : STA $26B8
    LDA #$0367 : STA $26BA
    LDA #$0368 : STA $2734
    LDA #$0369 : STA $2736
    LDA #$036A : STA $2738
    LDA #$036B : STA $273A
    LDA #$036E : STA $27B4
    LDA #$036F : STA $27B6
    LDA #$0370 : STA $27B8
    LDA #$0371 : STA $27BA
    LDA #$0375 : STA $2834
    LDA #$0376 : STA $2836
    LDA #$0377 : STA $2838
    LDA #$0378 : STA $283A

+ RTS
}

map16: ; Map22
{
LDA #$00AE : STA $281E
LDA #$00AF : STA $2820
LDA #$007E : STA $2822
LDA #$007F : STA $2824
LDA #$00B0 : STA $289E
LDA #$0014 : STA $28A0
LDA #$0015 : STA $28A2
LDA #$00A8 : STA $28A4
LDA #$0089 : STA $291E
LDA #$001C : STA $2920
LDA #$001D : STA $2922
LDA #$0076 : STA $2924
LDA #$00F1 : STA $299E
LDA #$004E : STA $29A0
LDA #$004F : STA $29A2
LDA #$00D9 : STA $29A4
RTS
}

map18: ; Map24/Map25/Map32/Map33
{
LDA.l OverworldEventDataWRAM+$18 : BIT.w #$0010 : BNE +
    ; northwest tree
    PHA
    LDA #$0364 : STA $242C
    LDA #$0365 : STA $242E
    LDA #$0366 : STA $2430
    LDA #$0367 : STA $2432
    LDA #$0368 : STA $24AC
    LDA #$0369 : STA $24AE
    LDA #$036A : STA $24B0
    LDA #$036B : STA $24B2
    LDA #$036E : STA $252C
    LDA #$036F : STA $252E
    LDA #$0370 : STA $2530
    LDA #$0371 : STA $2532
    LDA #$0375 : STA $25AC
    LDA #$0376 : STA $25AE
    LDA #$0377 : STA $25B0
    LDA #$0378 : STA $25B2
    PLA

+ BIT.w #$0008 : BNE +
    ; southeast tree
    LDA #$0364 : STA $38EA
    LDA #$0365 : STA $38EC
    LDA #$0366 : STA $38EE
    LDA #$0367 : STA $38F0
    LDA #$0368 : STA $396A
    LDA #$0369 : STA $396C
    LDA #$036A : STA $396E
    LDA #$036B : STA $3970
    LDA #$036E : STA $39EA
    LDA #$036F : STA $39EC
    LDA #$0370 : STA $39EE
    LDA #$0371 : STA $39F0
    LDA #$0375 : STA $3A6A
    LDA #$0376 : STA $3A6C
    LDA #$0377 : STA $3A6E
    LDA #$0378 : STA $3A70

+ RTS
}

map1a: ; Map26
{
LDA.l OverworldEventDataWRAM+$1a : BIT.w #$0010 : BNE +
    ; southwest tree
    PHA
    LDA #$0364 : STA $2B10
    LDA #$0365 : STA $2B12
    LDA #$0366 : STA $2B14
    LDA #$0367 : STA $2B16
    LDA #$0368 : STA $2B90
    LDA #$0369 : STA $2B92
    LDA #$036A : STA $2B94
    LDA #$036B : STA $2B96
    LDA #$036E : STA $2C10
    LDA #$036F : STA $2C12
    LDA #$0370 : STA $2C14
    LDA #$0371 : STA $2C16
    LDA #$0375 : STA $2C90
    LDA #$0376 : STA $2C92
    LDA #$0377 : STA $2C94
    LDA #$0378 : STA $2C96
    PLA

+ BIT.w #$0008 : BNE +
    ; central tree
    LDA #$0364 : STA $2798
    LDA #$0365 : STA $279A
    LDA #$0366 : STA $279C
    LDA #$0367 : STA $279E
    LDA #$0368 : STA $2818
    LDA #$0369 : STA $281A
    LDA #$036A : STA $281C
    LDA #$036B : STA $281E
    LDA #$036E : STA $2898
    LDA #$036F : STA $289A
    LDA #$0370 : STA $289C
    LDA #$0371 : STA $289E
    LDA #$0375 : STA $2918
    LDA #$0376 : STA $291A
    LDA #$0377 : STA $291C
    LDA #$0378 : STA $291E

+ RTS
}

map1b: ; Map27/Map28/Map35/Map36
{
LDA.l OverworldEventDataWRAM+$1b : BIT.w #$0010 : BNE +
    LDA #$0364 : STA $29AA
    LDA #$0365 : STA $29AC
    LDA #$0366 : STA $29AE
    LDA #$0367 : STA $29B0
    LDA #$0368 : STA $2A2A
    LDA #$0369 : STA $2A2C
    LDA #$036A : STA $2A2E
    LDA #$036B : STA $2A30
    LDA #$036E : STA $2AAA
    LDA #$036F : STA $2AAC
    LDA #$0370 : STA $2AAE
    LDA #$0371 : STA $2AB0
    LDA #$0375 : STA $2B2A
    LDA #$0376 : STA $2B2C
    LDA #$0377 : STA $2B2E
    LDA #$0378 : STA $2B30

+ RTS
}

map1d: ; Map29
{
LDA.l OverworldEventDataWRAM+$1d : BIT.w #$0010 : BNE +
    LDA #$0364 : STA $2212
    LDA #$0365 : STA $2214
    LDA #$0366 : STA $2216
    LDA #$0367 : STA $2218
    LDA #$0368 : STA $2292
    LDA #$0369 : STA $2294
    LDA #$036A : STA $2296
    LDA #$036B : STA $2298
    LDA #$036E : STA $2312
    LDA #$036F : STA $2314
    LDA #$0370 : STA $2316
    LDA #$0371 : STA $2318
    LDA #$0375 : STA $2392
    LDA #$0376 : STA $2394
    LDA #$0377 : STA $2396
    LDA #$0378 : STA $2398

+ RTS
}

map1e: ; Map30/Map31/Map38/Map39
{
; two northeast trees
LDA #$00AE : STA $36E6 : STA $375E
LDA #$00AF : STA $36E8 : STA $3760
LDA #$007E : STA $36EA : STA $3762
LDA #$007F : STA $36EC : STA $3764
LDA #$00B0 : STA $3766 : STA $37DE
LDA #$0014 : STA $3768 : STA $37E0
LDA #$0015 : STA $376A : STA $37E2
LDA #$00A8 : STA $376C : STA $37E4
LDA #$0089 : STA $37E6 : STA $385E
LDA #$001C : STA $37E8 : STA $3860
LDA #$001D : STA $37EA : STA $3862
LDA #$0076 : STA $37EC : STA $3864
LDA #$00F1 : STA $3866 : STA $38DE
LDA #$004E : STA $3868 : STA $38E0
LDA #$004F : STA $386A : STA $38E2
LDA #$00D9 : STA $386C : STA $38E4

; tree cluster
LDA #$0000 : STA $3954 : STA $395A : STA $3C54
LDA #$0001 : STA $3950 : STA $3956 : STA $3C50
LDA #$0002 : STA $3952 : STA $3958 : STA $3C52
LDA #$0006 : STA $3B4E
LDA #$0007 : STA $3B50
LDA #$0009 : STA $3B54
LDA #$000A : STA $39D4
LDA #$000B : STA $39D0 : STA $39D6
LDA #$000C : STA $39D2
LDA #$000D : STA $39D8
LDA #$0011 : STA $38D0 : STA $38D6 : STA $3BD0
LDA #$0012 : STA $38D2 : STA $38D8 : STA $3BD2
LDA #$0013 : STA $38D4 : STA $38DA : STA $3BD4
LDA #$0014 : STA $3A4E : STA $3A54
LDA #$0015 : STA $3A50 : STA $3A56
LDA #$0016 : STA $3A52
LDA #$001C : STA $3ACE : STA $3AD4
LDA #$001D : STA $3AD0 : STA $3AD6
LDA #$001E : STA $3AD2
LDA #$0025 : STA $3CD2
LDA #$0026 : STA $3852 : STA $3858 : STA $3B52
LDA #$0031 : STA $3B56
LDA #$0076 : STA $3AD8
LDA #$0078 : STA $3854 : STA $385A
LDA #$0079 : STA $385C
LDA #$007B : STA $38DC
LDA #$007C : STA $395C : STA $3C56
LDA #$0082 : STA $39DA : STA $3CD4
LDA #$0083 : STA $3CD0
LDA #$0089 : STA $3ACC
LDA #$0094 : STA $3BD6
LDA #$00A8 : STA $3A58
LDA #$00AE : STA $39CC
LDA #$00AF : STA $39CE
LDA #$00B0 : STA $3A4C
LDA #$00B5 : STA $384E
LDA #$00B6 : STA $3850 : STA $3856
LDA #$00B9 : STA $38CE
LDA #$00BE : STA $394E : STA $3C4E
LDA #$00D9 : STA $3B58
LDA #$00DE : STA $3BCE
LDA #$00F1 : STA $3B4C


LDA.l OverworldEventDataWRAM+$1e : BIT.w #$0010 : BEQ + ; BEQ because tree is already colored
    ; bonk tree
    LDA #$00AE : STA $3AC2
    LDA #$00AF : STA $3AC4
    LDA #$007E : STA $3AC6
    LDA #$007F : STA $3AC8
    LDA #$00B0 : STA $3B42
    LDA #$0014 : STA $3B44
    LDA #$0015 : STA $3B46
    LDA #$00A8 : STA $3B48
    LDA #$0089 : STA $3BC2
    LDA #$001C : STA $3BC4
    LDA #$001D : STA $3BC6
    LDA #$0076 : STA $3BC8
    LDA #$00F1 : STA $3C42
    LDA #$004E : STA $3C44
    LDA #$004F : STA $3C46
    LDA #$00D9 : STA $3C48

+ RTS
}

map2a: ; Map42
{
LDA.l OverworldEventDataWRAM+$2a : BIT.w #$0010 : BNE +
    ; south tree
    PHA
    LDA #$0364 : STA $2B1C
    LDA #$0365 : STA $2B1E
    LDA #$0366 : STA $2B20
    LDA #$0367 : STA $2B22
    LDA #$0368 : STA $2B9C
    LDA #$0369 : STA $2B9E
    LDA #$036A : STA $2BA0
    LDA #$036B : STA $2BA2
    LDA #$036E : STA $2C1C
    LDA #$036F : STA $2C1E
    LDA #$0370 : STA $2C20
    LDA #$0371 : STA $2C22
    LDA #$0375 : STA $2C9C
    LDA #$0376 : STA $2C9E
    LDA #$0377 : STA $2CA0
    LDA #$0378 : STA $2CA2
    PLA

+ BIT.w #$0008 : BNE +
    ; southeast tree
    LDA #$0364 : STA $2928
    LDA #$0365 : STA $292A
    LDA #$0366 : STA $292C
    LDA #$0367 : STA $292E
    LDA #$0368 : STA $29A8
    LDA #$0369 : STA $29AA
    LDA #$036A : STA $29AC
    LDA #$036B : STA $29AE
    LDA #$036E : STA $2A28
    LDA #$036F : STA $2A2A
    LDA #$0370 : STA $2A2C
    LDA #$0371 : STA $2A2E
    LDA #$0375 : STA $2AA8
    LDA #$0376 : STA $2AAA
    LDA #$0377 : STA $2AAC
    LDA #$0378 : STA $2AAE

+ RTS
}

map2b: ; Map43
{
LDA.l OverworldEventDataWRAM+$2b : BIT.w #$0010 : BNE +
    LDA #$0364 : STA $25AA
    LDA #$0365 : STA $25AC
    LDA #$0366 : STA $25AE
    LDA #$0367 : STA $25B0
    LDA #$0368 : STA $262A
    LDA #$0369 : STA $262C
    LDA #$036A : STA $262E
    LDA #$036B : STA $2630
    LDA #$036E : STA $26AA
    LDA #$036F : STA $26AC
    LDA #$0370 : STA $26AE
    LDA #$0371 : STA $26B0
    LDA #$0375 : STA $272A
    LDA #$0376 : STA $272C
    LDA #$0377 : STA $272E
    LDA #$0378 : STA $2730

+ RTS
}

map2e: ; Map46
{
LDA.l OverworldEventDataWRAM+$2e : BIT.w #$0010 : BNE +
    ; tree 2
    PHA
    LDA #$0364 : STA $2396
    LDA #$0365 : STA $2398
    LDA #$0366 : STA $239A
    LDA #$0367 : STA $239C
    LDA #$0368 : STA $2416
    LDA #$0369 : STA $2418
    LDA #$036A : STA $241A
    LDA #$036B : STA $241C
    LDA #$036E : STA $2496
    LDA #$036F : STA $2498
    LDA #$0370 : STA $249A
    LDA #$0371 : STA $249C
    LDA #$0375 : STA $2516
    LDA #$0376 : STA $2518
    LDA #$0377 : STA $251A
    LDA #$0378 : STA $251C
    PLA

+ BIT.w #$0008 : BNE +
    ; tree 4
    LDA #$0364 : STA $24A6
    LDA #$0365 : STA $24A8
    LDA #$0366 : STA $24AA
    LDA #$0367 : STA $24AC
    LDA #$0368 : STA $2526
    LDA #$0369 : STA $2528
    LDA #$036A : STA $252A
    LDA #$036B : STA $252C
    LDA #$036E : STA $25A6
    LDA #$036F : STA $25A8
    LDA #$0370 : STA $25AA
    LDA #$0371 : STA $25AC
    LDA #$0375 : STA $2626
    LDA #$0376 : STA $2628
    LDA #$0377 : STA $262A
    LDA #$0378 : STA $262C

+ RTS
}

map32: ; Map50
{
LDA.l OverworldEventDataWRAM+$32 : BIT.w #$0010 : BNE +
    ; southeast tree
    PHA
    LDA #$0364 : STA $2830
    LDA #$0365 : STA $2832
    LDA #$0366 : STA $2834
    LDA #$0367 : STA $2836
    LDA #$0368 : STA $28B0
    LDA #$0369 : STA $28B2
    LDA #$036A : STA $28B4
    LDA #$036B : STA $28B6
    LDA #$036E : STA $2930
    LDA #$036F : STA $2932
    LDA #$0370 : STA $2934
    LDA #$0371 : STA $2936
    LDA #$0375 : STA $29B0
    LDA #$0376 : STA $29B2
    LDA #$0377 : STA $29B4
    LDA #$0378 : STA $29B6
    PLA

+ BIT.w #$0008 : BNE +
    ; northeast tree
    LDA #$0364 : STA $23B2
    LDA #$0365 : STA $23B4
    LDA #$0366 : STA $23B6
    LDA #$0367 : STA $23B8
    LDA #$0368 : STA $2432
    LDA #$0369 : STA $2434
    LDA #$036A : STA $2436
    LDA #$036B : STA $2438
    LDA #$036E : STA $24B2
    LDA #$036F : STA $24B4
    LDA #$0370 : STA $24B6
    LDA #$0371 : STA $24B8
    LDA #$0375 : STA $2532
    LDA #$0376 : STA $2534
    LDA #$0377 : STA $2536
    LDA #$0378 : STA $2538

+ RTS
}

map42: ; Map02
{
LDA.l OverworldEventDataWRAM+$42 : BIT.w #$0010 : BNE +
    LDA #$0364 : STA $2A0A
    LDA #$0365 : STA $2A0C
    LDA #$0366 : STA $2A0E
    LDA #$0367 : STA $2A10
    LDA #$0368 : STA $2A8A
    LDA #$0369 : STA $2A8C
    LDA #$036A : STA $2A8E
    LDA #$036B : STA $2A90
    LDA #$036E : STA $2B0A
    LDA #$036F : STA $2B0C
    LDA #$0370 : STA $2B0E
    LDA #$0371 : STA $2B10
    LDA #$0375 : STA $2B8A
    LDA #$0376 : STA $2B8C
    LDA #$0377 : STA $2B8E
    LDA #$0378 : STA $2B90

+ RTS
}

map53: ; Map19
{
LDA #$00AE : STA $2422 : STA $242E
LDA #$00AF : STA $2424 : STA $2430
LDA #$007E : STA $2426 : STA $2432
LDA #$007F : STA $2428 : STA $2434
LDA #$00B0 : STA $24A2 : STA $24AE
LDA #$0014 : STA $24A4 : STA $24B0
LDA #$0015 : STA $24A6 : STA $24B2
LDA #$00A8 : STA $24A8 : STA $24B4
LDA #$0089 : STA $2522 : STA $252E
LDA #$001C : STA $2524 : STA $2530
LDA #$001D : STA $2526 : STA $2532
LDA #$0076 : STA $2528 : STA $2534
LDA #$00F1 : STA $25A2 : STA $25AE
LDA #$004E : STA $25A4 : STA $25B0
LDA #$004F : STA $25A6 : STA $25B2
LDA #$00D9 : STA $25A8 : STA $25B4
RTS
}

map55: ; Map21
{
LDA.l OverworldEventDataWRAM+$55 : BIT.w #$0010 : BNE +
    ; west bank tree
    PHA
    LDA #$0364 : STA $2C12
    LDA #$0365 : STA $2C14
    LDA #$0366 : STA $2C16
    LDA #$0367 : STA $2C18
    LDA #$0368 : STA $2C92
    LDA #$0369 : STA $2C94
    LDA #$036A : STA $2C96
    LDA #$036B : STA $2C98
    LDA #$036E : STA $2D12
    LDA #$036F : STA $2D14
    LDA #$0370 : STA $2D16
    LDA #$0371 : STA $2D18
    LDA #$0375 : STA $2D92
    LDA #$0376 : STA $2D94
    LDA #$0377 : STA $2D96
    LDA #$0378 : STA $2D98
    PLA

+ BIT.w #$0008 : BNE +
    ; east bank tree
    LDA #$0364 : STA $26B4
    LDA #$0365 : STA $26B6
    LDA #$0366 : STA $26B8
    LDA #$0367 : STA $26BA
    LDA #$0368 : STA $2734
    LDA #$0369 : STA $2736
    LDA #$036A : STA $2738
    LDA #$036B : STA $273A
    LDA #$036E : STA $27B4
    LDA #$036F : STA $27B6
    LDA #$0370 : STA $27B8
    LDA #$0371 : STA $27BA
    LDA #$0375 : STA $2834
    LDA #$0376 : STA $2836
    LDA #$0377 : STA $2838
    LDA #$0378 : STA $283A

+ RTS
}

map56: ; Map22
{
LDA.l OverworldEventDataWRAM+$56 : BIT.w #$0010 : BNE +
    LDA #$0640 : STA $2604
    LDA #$0641 : STA $2606
    LDA #$0642 : STA $2608
    LDA #$0643 : STA $260A
    LDA #$0644 : STA $260C
    LDA #$0645 : STA $2684
    LDA #$0646 : STA $2686
    LDA #$0647 : STA $2688
    LDA #$0648 : STA $268A
    LDA #$0649 : STA $268C
    LDA #$064A : STA $2704
    LDA #$064B : STA $2706
    LDA #$064C : STA $2708
    LDA #$064D : STA $270A
    LDA #$064E : STA $270C
    LDA #$0662 : STA $2786
    LDA #$0663 : STA $2788
    LDA #$0653 : STA $278A

+ RTS
}

map58: ; Map24/Map25/Map32/Map33
{
LDA #$00AE : STA $242C : STA $38EA
LDA #$00AF : STA $242E : STA $38EC
LDA #$007E : STA $2430 : STA $38EE
LDA #$007F : STA $2432 : STA $38F0
LDA #$00B0 : STA $24AC : STA $396A
LDA #$0014 : STA $24AE : STA $396C
LDA #$0015 : STA $24B0 : STA $396E
LDA #$00A8 : STA $24B2 : STA $3970
LDA #$0089 : STA $252C : STA $39EA
LDA #$001C : STA $252E : STA $39EC
LDA #$001D : STA $2530 : STA $39EE
LDA #$0076 : STA $2532 : STA $39F0
LDA #$00F1 : STA $25AC : STA $3A6A
LDA #$004E : STA $25AE : STA $3A6C
LDA #$004F : STA $25B0 : STA $3A6E
LDA #$00D9 : STA $25B2 : STA $3A70
RTS
}

map5b: ; Map27/Map28/Map35/Map36
{
; east tree
LDA #$00AE : STA $344C
LDA #$00AF : STA $344E
LDA #$007E : STA $3450
LDA #$007F : STA $3452
LDA #$00B0 : STA $34CC
LDA #$0014 : STA $34CE
LDA #$0015 : STA $34D0
LDA #$00A8 : STA $34D2
LDA #$0089 : STA $354C
LDA #$001C : STA $354E
LDA #$001D : STA $3550
LDA #$0076 : STA $3552
LDA #$00F1 : STA $35CC
LDA #$004E : STA $35CE
LDA #$004F : STA $35D0
LDA #$00D9 : STA $35D2

LDA.l OverworldEventDataWRAM+$5b : BIT.w #$0010 : BEQ + ; BEQ because tree is already colored
    ; west tree
    LDA #$00AE : STA $342C
    LDA #$00AF : STA $342E
    LDA #$007E : STA $3430
    LDA #$007F : STA $3432
    LDA #$00B0 : STA $34AC
    LDA #$0014 : STA $34AE
    LDA #$0015 : STA $34B0
    LDA #$00A8 : STA $34B2
    LDA #$0089 : STA $352C
    LDA #$001C : STA $352E
    LDA #$001D : STA $3530
    LDA #$0076 : STA $3532
    LDA #$00F1 : STA $35AC
    LDA #$004E : STA $35AE
    LDA #$004F : STA $35B0
    LDA #$00D9 : STA $35B2

+ RTS
}

map5e: ; Map30/Map31/Map38/Map39
{
; non-bonk trees
LDA #$0000 : STA $3954 : STA $395A : STA $3C54
LDA #$0001 : STA $3950 : STA $3956 : STA $3C50
LDA #$0002 : STA $3952 : STA $3958 : STA $3C52
LDA #$0006 : STA $3B4E
LDA #$0007 : STA $3B50
LDA #$0009 : STA $3B54
LDA #$000A : STA $39D4
LDA #$000B : STA $39D0 : STA $39D6
LDA #$000C : STA $39D2
LDA #$000D : STA $39D8
LDA #$0011 : STA $38D0 : STA $38D6 : STA $3BD0
LDA #$0012 : STA $38D2 : STA $38D8 : STA $3BD2
LDA #$0013 : STA $38D4 : STA $38DA : STA $3BD4
LDA #$0014 : STA $3768 : STA $3A4E : STA $3A54 : STA $3B44
LDA #$0015 : STA $376A : STA $3A50 : STA $3A56 : STA $3B46
LDA #$0016 : STA $3A52
LDA #$001C : STA $37E8 : STA $3ACE : STA $3AD4 : STA $3BC4
LDA #$001D : STA $37EA : STA $3AD0 : STA $3AD6 : STA $3BC6
LDA #$001E : STA $3AD2
LDA #$0025 : STA $3CD2
LDA #$0026 : STA $3852 : STA $3858 : STA $3B52
LDA #$0031 : STA $3B56
LDA #$004E : STA $3868 : STA $3C44
LDA #$004F : STA $386A : STA $3C46
LDA #$0076 : STA $37EC : STA $3AD8 : STA $3BC8
LDA #$0078 : STA $3854 : STA $385A
LDA #$0079 : STA $385C
LDA #$007B : STA $38DC
LDA #$007C : STA $395C : STA $3C56
LDA #$007E : STA $36EA : STA $3AC6
LDA #$007F : STA $36EC : STA $3AC8
LDA #$0082 : STA $39DA : STA $3CD4
LDA #$0083 : STA $3CD0
LDA #$0089 : STA $37E6 : STA $3ACC : STA $3BC2
LDA #$0094 : STA $3BD6
LDA #$00A8 : STA $376C : STA $3A58 : STA $3B48
LDA #$00AE : STA $36E6 : STA $39CC : STA $3AC2
LDA #$00AF : STA $36E8 : STA $39CE : STA $3AC4
LDA #$00B0 : STA $3766 : STA $3A4C : STA $3B42
LDA #$00B5 : STA $384E
LDA #$00B6 : STA $3850 : STA $3856
LDA #$00B9 : STA $38CE
LDA #$00BE : STA $394E : STA $3C4E
LDA #$00D9 : STA $386C : STA $3B58 : STA $3C48
LDA #$00DE : STA $3BCE
LDA #$00F1 : STA $3866 : STA $3B4C : STA $3C42

LDA.l OverworldEventDataWRAM+$5e : BIT.w #$0010 : BEQ + ; BEQ because tree is already colored
    ; bonk tree
    LDA #$00AE : STA $375E
    LDA #$00AF : STA $3760
    LDA #$007E : STA $3762
    LDA #$007F : STA $3764
    LDA #$00B0 : STA $37DE
    LDA #$0014 : STA $37E0
    LDA #$0015 : STA $37E2
    LDA #$00A8 : STA $37E4
    LDA #$0089 : STA $385E
    LDA #$001C : STA $3860
    LDA #$001D : STA $3862
    LDA #$0076 : STA $3864
    LDA #$00F1 : STA $38DE
    LDA #$004E : STA $38E0
    LDA #$004F : STA $38E2
    LDA #$00D9 : STA $38E4

+ RTS
}

map6e: ; Map46
{
LDA.l OverworldEventDataWRAM+$6e : BIT.w #$0010 : BNE +
    ; tree 2
    PHA
    LDA #$0364 : STA $2396
    LDA #$0365 : STA $2398
    LDA #$0366 : STA $239A
    LDA #$0367 : STA $239C
    LDA #$0368 : STA $2416
    LDA #$0369 : STA $2418
    LDA #$036A : STA $241A
    LDA #$036B : STA $241C
    LDA #$036E : STA $2496
    LDA #$036F : STA $2498
    LDA #$0370 : STA $249A
    LDA #$0371 : STA $249C
    LDA #$0375 : STA $2516
    LDA #$0376 : STA $2518
    LDA #$0377 : STA $251A
    LDA #$0378 : STA $251C
    PLA

+ BIT.w #$0008 : BNE +
    ; tree 3
    PHA
    LDA #$0364 : STA $241E
    LDA #$0365 : STA $2420
    LDA #$0366 : STA $2422
    LDA #$0367 : STA $2424
    LDA #$0368 : STA $249E
    LDA #$0369 : STA $24A0
    LDA #$036A : STA $24A2
    LDA #$036B : STA $24A4
    LDA #$036E : STA $251E
    LDA #$036F : STA $2520
    LDA #$0370 : STA $2522
    LDA #$0371 : STA $2524
    LDA #$0375 : STA $259E
    LDA #$0376 : STA $25A0
    LDA #$0377 : STA $25A2
    LDA #$0378 : STA $25A4
    PLA

+ BIT.w #$0004 : BNE +
    ; tree 4
    LDA #$0364 : STA $24A6
    LDA #$0365 : STA $24A8
    LDA #$0366 : STA $24AA
    LDA #$0367 : STA $24AC
    LDA #$0368 : STA $2526
    LDA #$0369 : STA $2528
    LDA #$036A : STA $252A
    LDA #$036B : STA $252C
    LDA #$036E : STA $25A6
    LDA #$036F : STA $25A8
    LDA #$0370 : STA $25AA
    LDA #$0371 : STA $25AC
    LDA #$0375 : STA $2626
    LDA #$0376 : STA $2628
    LDA #$0377 : STA $262A
    LDA #$0378 : STA $262C

+ RTS
}
