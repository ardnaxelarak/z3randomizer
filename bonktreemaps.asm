Overworld_LoadBonkTiles:
{
    SEP #$30
    LDA.l OWFlags+1 : AND.b #$02 : BEQ .return
        PHB

        ; Set the data bank to $7E.
        LDA.b #$7E : PHA : PLB
        REP #$30
        ; Use it as an index into a jump table.
        LDA.b OverworldIndex : CMP.w #$0080 : !BGE .noData
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
}

return:
RTS

map00: ; Map00/Map01/Map08/Map09
{
LDA.l OverworldEventDataWRAM+$00 : BIT.w #$0010 : BNE +
    LDA.w #$0364 : STA.w $31D0
    LDA.w #$0365 : STA.w $31D2
    LDA.w #$0366 : STA.w $31D4
    LDA.w #$0367 : STA.w $31D6
    LDA.w #$0368 : STA.w $3250
    LDA.w #$0369 : STA.w $3252
    LDA.w #$036A : STA.w $3254
    LDA.w #$036B : STA.w $3256
    LDA.w #$036E : STA.w $32D0
    LDA.w #$036F : STA.w $32D2
    LDA.w #$0370 : STA.w $32D4
    LDA.w #$0371 : STA.w $32D6
    LDA.w #$0375 : STA.w $3350
    LDA.w #$0376 : STA.w $3352
    LDA.w #$0377 : STA.w $3354
    LDA.w #$0378 : STA.w $3356

+ RTS
}

map0a: ; Map10
{
LDA.l OverworldEventDataWRAM+$0a : BIT.w #$0010 : BNE +
    ; north tree
    PHA
    LDA.w #$0364 : STA.w $2118
    LDA.w #$0365 : STA.w $211A
    LDA.w #$0366 : STA.w $211C
    LDA.w #$0367 : STA.w $211E
    LDA.w #$0368 : STA.w $2198
    LDA.w #$0369 : STA.w $219A
    LDA.w #$036A : STA.w $219C
    LDA.w #$036B : STA.w $219E
    LDA.w #$036E : STA.w $2218
    LDA.w #$036F : STA.w $221A
    LDA.w #$0370 : STA.w $221C
    LDA.w #$0371 : STA.w $221E
    LDA.w #$0375 : STA.w $2298
    LDA.w #$0376 : STA.w $229A
    LDA.w #$0377 : STA.w $229C
    LDA.w #$0378 : STA.w $229E
    PLA

+ BIT.w #$0008 : BNE +
    ; south tree
    LDA.w #$0364 : STA.w $2C30
    LDA.w #$0365 : STA.w $2C32
    LDA.w #$0366 : STA.w $2C34
    LDA.w #$0367 : STA.w $2C36
    LDA.w #$0368 : STA.w $2CB0
    LDA.w #$0369 : STA.w $2CB2
    LDA.w #$036A : STA.w $2CB4
    LDA.w #$036B : STA.w $2CB6
    LDA.w #$036E : STA.w $2D30
    LDA.w #$036F : STA.w $2D32
    LDA.w #$0370 : STA.w $2D34
    LDA.w #$0371 : STA.w $2D36
    LDA.w #$0375 : STA.w $2DB0
    LDA.w #$0376 : STA.w $2DB2
    LDA.w #$0377 : STA.w $2DB4
    LDA.w #$0378 : STA.w $2DB6

+ RTS
}

map10: ; Map16
{
LDA.l OverworldEventDataWRAM+$10 : BIT.w #$0010 : BNE +
    ; west tree
    PHA
    LDA.w #$0364 : STA.w $250C
    LDA.w #$0365 : STA.w $250E
    LDA.w #$0366 : STA.w $2510
    LDA.w #$0367 : STA.w $2512
    LDA.w #$0368 : STA.w $258C
    LDA.w #$0369 : STA.w $258E
    LDA.w #$036A : STA.w $2590
    LDA.w #$036B : STA.w $2592
    LDA.w #$036E : STA.w $260C
    LDA.w #$036F : STA.w $260E
    LDA.w #$0370 : STA.w $2610
    LDA.w #$0371 : STA.w $2612
    LDA.w #$0375 : STA.w $268C
    LDA.w #$0376 : STA.w $268E
    LDA.w #$0377 : STA.w $2690
    LDA.w #$0378 : STA.w $2692
    PLA

+ BIT.w #$0008 : BNE +
    ; east tree
    LDA.w #$0364 : STA.w $26AC
    LDA.w #$0365 : STA.w $26AE
    LDA.w #$0366 : STA.w $26B0
    LDA.w #$0367 : STA.w $26B2
    LDA.w #$0368 : STA.w $272C
    LDA.w #$0369 : STA.w $272E
    LDA.w #$036A : STA.w $2730
    LDA.w #$036B : STA.w $2732
    LDA.w #$036E : STA.w $27AC
    LDA.w #$036F : STA.w $27AE
    LDA.w #$0370 : STA.w $27B0
    LDA.w #$0371 : STA.w $27B2
    LDA.w #$0375 : STA.w $282C
    LDA.w #$0376 : STA.w $282E
    LDA.w #$0377 : STA.w $2830
    LDA.w #$0378 : STA.w $2832

+ RTS
}

map12: ; Map18
{
LDA.l OverworldEventDataWRAM+$12 : BIT.w #$0010 : BNE +
    LDA.w #$0364 : STA.w $2426
    LDA.w #$0365 : STA.w $2428
    LDA.w #$064F : STA.w $242A
    LDA.w #$0652 : STA.w $242C
    LDA.w #$0368 : STA.w $24A6
    LDA.w #$0369 : STA.w $24A8
    LDA.w #$036A : STA.w $24AA
    LDA.w #$0655 : STA.w $24AC
    LDA.w #$036E : STA.w $2526
    LDA.w #$036F : STA.w $2528
    LDA.w #$0370 : STA.w $252A
    LDA.w #$0371 : STA.w $252C
    LDA.w #$0375 : STA.w $25A6
    LDA.w #$0376 : STA.w $25A8
    LDA.w #$0377 : STA.w $25AA
    LDA.w #$0378 : STA.w $25AC

+ RTS
}

map13: ; Map19
{
LDA.l OverworldEventDataWRAM+$13 : BIT.w #$0010 : BNE +
    ; ledge tree
    PHA
    LDA.w #$0364 : STA.w $250C
    LDA.w #$0365 : STA.w $250E
    LDA.w #$0366 : STA.w $2510
    LDA.w #$0367 : STA.w $2512
    LDA.w #$0368 : STA.w $258C
    LDA.w #$0369 : STA.w $258E
    LDA.w #$036A : STA.w $2590
    LDA.w #$036B : STA.w $2592
    LDA.w #$036E : STA.w $260C
    LDA.w #$036F : STA.w $260E
    LDA.w #$0370 : STA.w $2610
    LDA.w #$0371 : STA.w $2612
    LDA.w #$0375 : STA.w $268C
    LDA.w #$0376 : STA.w $268E
    LDA.w #$0377 : STA.w $2690
    LDA.w #$0378 : STA.w $2692
    PLA

+ BIT.w #$0008 : BEQ + ; BEQ because tree is already colored
    ; east tree
    LDA.w #$00AE : STA.w $23AE
    LDA.w #$00AF : STA.w $23B0
    LDA.w #$007E : STA.w $23B2
    LDA.w #$007F : STA.w $23B4
    LDA.w #$00B0 : STA.w $242E
    LDA.w #$0014 : STA.w $2430
    LDA.w #$0015 : STA.w $2432
    LDA.w #$00A8 : STA.w $2434
    LDA.w #$0089 : STA.w $24AE
    LDA.w #$001C : STA.w $24B0
    LDA.w #$001D : STA.w $24B2
    LDA.w #$0076 : STA.w $24B4
    LDA.w #$00F1 : STA.w $252E
    LDA.w #$004E : STA.w $2530
    LDA.w #$004F : STA.w $2532
    LDA.w #$00D9 : STA.w $2534
+

; west tree
LDA.w #$00AE : STA.w $23A2
LDA.w #$00AF : STA.w $23A4
LDA.w #$007E : STA.w $23A6
LDA.w #$007F : STA.w $23A8
LDA.w #$00B0 : STA.w $2422
LDA.w #$0014 : STA.w $2424
LDA.w #$0015 : STA.w $2426
LDA.w #$00A8 : STA.w $2428
LDA.w #$0089 : STA.w $24A2
LDA.w #$001C : STA.w $24A4
LDA.w #$001D : STA.w $24A6
LDA.w #$0076 : STA.w $24A8
LDA.w #$00F1 : STA.w $2522
LDA.w #$004E : STA.w $2524
LDA.w #$004F : STA.w $2526
LDA.w #$00D9 : STA.w $2528

RTS
}

map15: ; Map21
{
LDA.l OverworldEventDataWRAM+$15 : BIT.w #$0010 : BNE +
    ; southwest tree
    PHA
    LDA.w #$0364 : STA.w $2C06
    LDA.w #$0365 : STA.w $2C08
    LDA.w #$0366 : STA.w $2C0A
    LDA.w #$0367 : STA.w $2C0C
    LDA.w #$0368 : STA.w $2C86
    LDA.w #$0369 : STA.w $2C88
    LDA.w #$036A : STA.w $2C8A
    LDA.w #$036B : STA.w $2C8C
    LDA.w #$036E : STA.w $2D06
    LDA.w #$036F : STA.w $2D08
    LDA.w #$0370 : STA.w $2D0A
    LDA.w #$0371 : STA.w $2D0C
    LDA.w #$0375 : STA.w $2D86
    LDA.w #$0376 : STA.w $2D88
    LDA.w #$0377 : STA.w $2D8A
    LDA.w #$0378 : STA.w $2D8C
    PLA

+ BIT.w #$0008 : BNE +
    ; east bank tree
    LDA.w #$0364 : STA.w $26B4
    LDA.w #$0365 : STA.w $26B6
    LDA.w #$0366 : STA.w $26B8
    LDA.w #$0367 : STA.w $26BA
    LDA.w #$0368 : STA.w $2734
    LDA.w #$0369 : STA.w $2736
    LDA.w #$036A : STA.w $2738
    LDA.w #$036B : STA.w $273A
    LDA.w #$036E : STA.w $27B4
    LDA.w #$036F : STA.w $27B6
    LDA.w #$0370 : STA.w $27B8
    LDA.w #$0371 : STA.w $27BA
    LDA.w #$0375 : STA.w $2834
    LDA.w #$0376 : STA.w $2836
    LDA.w #$0377 : STA.w $2838
    LDA.w #$0378 : STA.w $283A

+ RTS
}

map16: ; Map22
{
LDA.w #$00AE : STA.w $281E
LDA.w #$00AF : STA.w $2820
LDA.w #$007E : STA.w $2822
LDA.w #$007F : STA.w $2824
LDA.w #$00B0 : STA.w $289E
LDA.w #$0014 : STA.w $28A0
LDA.w #$0015 : STA.w $28A2
LDA.w #$00A8 : STA.w $28A4
LDA.w #$0089 : STA.w $291E
LDA.w #$001C : STA.w $2920
LDA.w #$001D : STA.w $2922
LDA.w #$0076 : STA.w $2924
LDA.w #$00F1 : STA.w $299E
LDA.w #$004E : STA.w $29A0
LDA.w #$004F : STA.w $29A2
LDA.w #$00D9 : STA.w $29A4
RTS
}

map18: ; Map24/Map25/Map32/Map33
{
LDA.l OverworldEventDataWRAM+$18 : BIT.w #$0010 : BNE +
    ; northwest tree
    PHA
    LDA.w #$0364 : STA.w $242C
    LDA.w #$0365 : STA.w $242E
    LDA.w #$0366 : STA.w $2430
    LDA.w #$0367 : STA.w $2432
    LDA.w #$0368 : STA.w $24AC
    LDA.w #$0369 : STA.w $24AE
    LDA.w #$036A : STA.w $24B0
    LDA.w #$036B : STA.w $24B2
    LDA.w #$036E : STA.w $252C
    LDA.w #$036F : STA.w $252E
    LDA.w #$0370 : STA.w $2530
    LDA.w #$0371 : STA.w $2532
    LDA.w #$0375 : STA.w $25AC
    LDA.w #$0376 : STA.w $25AE
    LDA.w #$0377 : STA.w $25B0
    LDA.w #$0378 : STA.w $25B2
    PLA

+ BIT.w #$0008 : BNE +
    ; southeast tree
    LDA.w #$0364 : STA.w $38EA
    LDA.w #$0365 : STA.w $38EC
    LDA.w #$0366 : STA.w $38EE
    LDA.w #$0367 : STA.w $38F0
    LDA.w #$0368 : STA.w $396A
    LDA.w #$0369 : STA.w $396C
    LDA.w #$036A : STA.w $396E
    LDA.w #$036B : STA.w $3970
    LDA.w #$036E : STA.w $39EA
    LDA.w #$036F : STA.w $39EC
    LDA.w #$0370 : STA.w $39EE
    LDA.w #$0371 : STA.w $39F0
    LDA.w #$0375 : STA.w $3A6A
    LDA.w #$0376 : STA.w $3A6C
    LDA.w #$0377 : STA.w $3A6E
    LDA.w #$0378 : STA.w $3A70

+ RTS
}

map1a: ; Map26
{
LDA.l OverworldEventDataWRAM+$1a : BIT.w #$0010 : BNE +
    ; southwest tree
    PHA
    LDA.w #$0364 : STA.w $2B10
    LDA.w #$0365 : STA.w $2B12
    LDA.w #$0366 : STA.w $2B14
    LDA.w #$0367 : STA.w $2B16
    LDA.w #$0368 : STA.w $2B90
    LDA.w #$0369 : STA.w $2B92
    LDA.w #$036A : STA.w $2B94
    LDA.w #$036B : STA.w $2B96
    LDA.w #$036E : STA.w $2C10
    LDA.w #$036F : STA.w $2C12
    LDA.w #$0370 : STA.w $2C14
    LDA.w #$0371 : STA.w $2C16
    LDA.w #$0375 : STA.w $2C90
    LDA.w #$0376 : STA.w $2C92
    LDA.w #$0377 : STA.w $2C94
    LDA.w #$0378 : STA.w $2C96
    PLA

+ BIT.w #$0008 : BNE +
    ; central tree
    LDA.w #$0364 : STA.w $2798
    LDA.w #$0365 : STA.w $279A
    LDA.w #$0366 : STA.w $279C
    LDA.w #$0367 : STA.w $279E
    LDA.w #$0368 : STA.w $2818
    LDA.w #$0369 : STA.w $281A
    LDA.w #$036A : STA.w $281C
    LDA.w #$036B : STA.w $281E
    LDA.w #$036E : STA.w $2898
    LDA.w #$036F : STA.w $289A
    LDA.w #$0370 : STA.w $289C
    LDA.w #$0371 : STA.w $289E
    LDA.w #$0375 : STA.w $2918
    LDA.w #$0376 : STA.w $291A
    LDA.w #$0377 : STA.w $291C
    LDA.w #$0378 : STA.w $291E

+ RTS
}

map1b: ; Map27/Map28/Map35/Map36
{
LDA.l OverworldEventDataWRAM+$1b : BIT.w #$0010 : BNE +
    LDA.w #$0364 : STA.w $29AA
    LDA.w #$0365 : STA.w $29AC
    LDA.w #$0366 : STA.w $29AE
    LDA.w #$0367 : STA.w $29B0
    LDA.w #$0368 : STA.w $2A2A
    LDA.w #$0369 : STA.w $2A2C
    LDA.w #$036A : STA.w $2A2E
    LDA.w #$036B : STA.w $2A30
    LDA.w #$036E : STA.w $2AAA
    LDA.w #$036F : STA.w $2AAC
    LDA.w #$0370 : STA.w $2AAE
    LDA.w #$0371 : STA.w $2AB0
    LDA.w #$0375 : STA.w $2B2A
    LDA.w #$0376 : STA.w $2B2C
    LDA.w #$0377 : STA.w $2B2E
    LDA.w #$0378 : STA.w $2B30

+ RTS
}

map1d: ; Map29
{
LDA.l OverworldEventDataWRAM+$1d : BIT.w #$0010 : BNE +
    LDA.w #$0364 : STA.w $2212
    LDA.w #$0365 : STA.w $2214
    LDA.w #$0366 : STA.w $2216
    LDA.w #$0367 : STA.w $2218
    LDA.w #$0368 : STA.w $2292
    LDA.w #$0369 : STA.w $2294
    LDA.w #$036A : STA.w $2296
    LDA.w #$036B : STA.w $2298
    LDA.w #$036E : STA.w $2312
    LDA.w #$036F : STA.w $2314
    LDA.w #$0370 : STA.w $2316
    LDA.w #$0371 : STA.w $2318
    LDA.w #$0375 : STA.w $2392
    LDA.w #$0376 : STA.w $2394
    LDA.w #$0377 : STA.w $2396
    LDA.w #$0378 : STA.w $2398

+ RTS
}

map1e: ; Map30/Map31/Map38/Map39
{
; two northeast trees
LDA.w #$00AE : STA.w $36E6 : STA.w $375E
LDA.w #$00AF : STA.w $36E8 : STA.w $3760
LDA.w #$007E : STA.w $36EA : STA.w $3762
LDA.w #$007F : STA.w $36EC : STA.w $3764
LDA.w #$00B0 : STA.w $3766 : STA.w $37DE
LDA.w #$0014 : STA.w $3768 : STA.w $37E0
LDA.w #$0015 : STA.w $376A : STA.w $37E2
LDA.w #$00A8 : STA.w $376C : STA.w $37E4
LDA.w #$0089 : STA.w $37E6 : STA.w $385E
LDA.w #$001C : STA.w $37E8 : STA.w $3860
LDA.w #$001D : STA.w $37EA : STA.w $3862
LDA.w #$0076 : STA.w $37EC : STA.w $3864
LDA.w #$00F1 : STA.w $3866 : STA.w $38DE
LDA.w #$004E : STA.w $3868 : STA.w $38E0
LDA.w #$004F : STA.w $386A : STA.w $38E2
LDA.w #$00D9 : STA.w $386C : STA.w $38E4

; tree cluster
LDA.w #$0000 : STA.w $3954 : STA.w $395A : STA.w $3C54
LDA.w #$0001 : STA.w $3950 : STA.w $3956 : STA.w $3C50
LDA.w #$0002 : STA.w $3952 : STA.w $3958 : STA.w $3C52
LDA.w #$0006 : STA.w $3B4E
LDA.w #$0007 : STA.w $3B50
LDA.w #$0009 : STA.w $3B54
LDA.w #$000A : STA.w $39D4
LDA.w #$000B : STA.w $39D0 : STA.w $39D6
LDA.w #$000C : STA.w $39D2
LDA.w #$000D : STA.w $39D8
LDA.w #$0011 : STA.w $38D0 : STA.w $38D6 : STA.w $3BD0
LDA.w #$0012 : STA.w $38D2 : STA.w $38D8 : STA.w $3BD2
LDA.w #$0013 : STA.w $38D4 : STA.w $38DA : STA.w $3BD4
LDA.w #$0014 : STA.w $3A4E : STA.w $3A54
LDA.w #$0015 : STA.w $3A50 : STA.w $3A56
LDA.w #$0016 : STA.w $3A52
LDA.w #$001C : STA.w $3ACE : STA.w $3AD4
LDA.w #$001D : STA.w $3AD0 : STA.w $3AD6
LDA.w #$001E : STA.w $3AD2
LDA.w #$0025 : STA.w $3CD2
LDA.w #$0026 : STA.w $3852 : STA.w $3858 : STA.w $3B52
LDA.w #$0031 : STA.w $3B56
LDA.w #$0076 : STA.w $3AD8
LDA.w #$0078 : STA.w $3854 : STA.w $385A
LDA.w #$0079 : STA.w $385C
LDA.w #$007B : STA.w $38DC
LDA.w #$007C : STA.w $395C : STA.w $3C56
LDA.w #$0082 : STA.w $39DA : STA.w $3CD4
LDA.w #$0083 : STA.w $3CD0
LDA.w #$0089 : STA.w $3ACC
LDA.w #$0094 : STA.w $3BD6
LDA.w #$00A8 : STA.w $3A58
LDA.w #$00AE : STA.w $39CC
LDA.w #$00AF : STA.w $39CE
LDA.w #$00B0 : STA.w $3A4C
LDA.w #$00B5 : STA.w $384E
LDA.w #$00B6 : STA.w $3850 : STA.w $3856
LDA.w #$00B9 : STA.w $38CE
LDA.w #$00BE : STA.w $394E : STA.w $3C4E
LDA.w #$00D9 : STA.w $3B58
LDA.w #$00DE : STA.w $3BCE
LDA.w #$00F1 : STA.w $3B4C


LDA.l OverworldEventDataWRAM+$1e : BIT.w #$0010 : BEQ + ; BEQ because tree is already colored
    ; bonk tree
    LDA.w #$00AE : STA.w $3AC2
    LDA.w #$00AF : STA.w $3AC4
    LDA.w #$007E : STA.w $3AC6
    LDA.w #$007F : STA.w $3AC8
    LDA.w #$00B0 : STA.w $3B42
    LDA.w #$0014 : STA.w $3B44
    LDA.w #$0015 : STA.w $3B46
    LDA.w #$00A8 : STA.w $3B48
    LDA.w #$0089 : STA.w $3BC2
    LDA.w #$001C : STA.w $3BC4
    LDA.w #$001D : STA.w $3BC6
    LDA.w #$0076 : STA.w $3BC8
    LDA.w #$00F1 : STA.w $3C42
    LDA.w #$004E : STA.w $3C44
    LDA.w #$004F : STA.w $3C46
    LDA.w #$00D9 : STA.w $3C48

+ RTS
}

map2a: ; Map42
{
LDA.l OverworldEventDataWRAM+$2a : BIT.w #$0010 : BNE +
    ; south tree
    PHA
    LDA.w #$0364 : STA.w $2B1C
    LDA.w #$0365 : STA.w $2B1E
    LDA.w #$0366 : STA.w $2B20
    LDA.w #$0367 : STA.w $2B22
    LDA.w #$0368 : STA.w $2B9C
    LDA.w #$0369 : STA.w $2B9E
    LDA.w #$036A : STA.w $2BA0
    LDA.w #$036B : STA.w $2BA2
    LDA.w #$036E : STA.w $2C1C
    LDA.w #$036F : STA.w $2C1E
    LDA.w #$0370 : STA.w $2C20
    LDA.w #$0371 : STA.w $2C22
    LDA.w #$0375 : STA.w $2C9C
    LDA.w #$0376 : STA.w $2C9E
    LDA.w #$0377 : STA.w $2CA0
    LDA.w #$0378 : STA.w $2CA2
    PLA

+ BIT.w #$0008 : BNE +
    ; southeast tree
    LDA.w #$0364 : STA.w $2928
    LDA.w #$0365 : STA.w $292A
    LDA.w #$0366 : STA.w $292C
    LDA.w #$0367 : STA.w $292E
    LDA.w #$0368 : STA.w $29A8
    LDA.w #$0369 : STA.w $29AA
    LDA.w #$036A : STA.w $29AC
    LDA.w #$036B : STA.w $29AE
    LDA.w #$036E : STA.w $2A28
    LDA.w #$036F : STA.w $2A2A
    LDA.w #$0370 : STA.w $2A2C
    LDA.w #$0371 : STA.w $2A2E
    LDA.w #$0375 : STA.w $2AA8
    LDA.w #$0376 : STA.w $2AAA
    LDA.w #$0377 : STA.w $2AAC
    LDA.w #$0378 : STA.w $2AAE

+ RTS
}

map2b: ; Map43
{
LDA.l OverworldEventDataWRAM+$2b : BIT.w #$0010 : BNE +
    LDA.w #$0364 : STA.w $25AA
    LDA.w #$0365 : STA.w $25AC
    LDA.w #$0366 : STA.w $25AE
    LDA.w #$0367 : STA.w $25B0
    LDA.w #$0368 : STA.w $262A
    LDA.w #$0369 : STA.w $262C
    LDA.w #$036A : STA.w $262E
    LDA.w #$036B : STA.w $2630
    LDA.w #$036E : STA.w $26AA
    LDA.w #$036F : STA.w $26AC
    LDA.w #$0370 : STA.w $26AE
    LDA.w #$0371 : STA.w $26B0
    LDA.w #$0375 : STA.w $272A
    LDA.w #$0376 : STA.w $272C
    LDA.w #$0377 : STA.w $272E
    LDA.w #$0378 : STA.w $2730

+ RTS
}

map2e: ; Map46
{
LDA.l OverworldEventDataWRAM+$2e : BIT.w #$0010 : BNE +
    ; tree 2
    PHA
    LDA.w #$0364 : STA.w $2396
    LDA.w #$0365 : STA.w $2398
    LDA.w #$0366 : STA.w $239A
    LDA.w #$0367 : STA.w $239C
    LDA.w #$0368 : STA.w $2416
    LDA.w #$0369 : STA.w $2418
    LDA.w #$036A : STA.w $241A
    LDA.w #$036B : STA.w $241C
    LDA.w #$036E : STA.w $2496
    LDA.w #$036F : STA.w $2498
    LDA.w #$0370 : STA.w $249A
    LDA.w #$0371 : STA.w $249C
    LDA.w #$0375 : STA.w $2516
    LDA.w #$0376 : STA.w $2518
    LDA.w #$0377 : STA.w $251A
    LDA.w #$0378 : STA.w $251C
    PLA

+ BIT.w #$0008 : BNE +
    ; tree 4
    LDA.w #$0364 : STA.w $24A6
    LDA.w #$0365 : STA.w $24A8
    LDA.w #$0366 : STA.w $24AA
    LDA.w #$0367 : STA.w $24AC
    LDA.w #$0368 : STA.w $2526
    LDA.w #$0369 : STA.w $2528
    LDA.w #$036A : STA.w $252A
    LDA.w #$036B : STA.w $252C
    LDA.w #$036E : STA.w $25A6
    LDA.w #$036F : STA.w $25A8
    LDA.w #$0370 : STA.w $25AA
    LDA.w #$0371 : STA.w $25AC
    LDA.w #$0375 : STA.w $2626
    LDA.w #$0376 : STA.w $2628
    LDA.w #$0377 : STA.w $262A
    LDA.w #$0378 : STA.w $262C

+ RTS
}

map32: ; Map50
{
LDA.l OverworldEventDataWRAM+$32 : BIT.w #$0010 : BNE +
    ; southeast tree
    PHA
    LDA.w #$0364 : STA.w $2830
    LDA.w #$0365 : STA.w $2832
    LDA.w #$0366 : STA.w $2834
    LDA.w #$0367 : STA.w $2836
    LDA.w #$0368 : STA.w $28B0
    LDA.w #$0369 : STA.w $28B2
    LDA.w #$036A : STA.w $28B4
    LDA.w #$036B : STA.w $28B6
    LDA.w #$036E : STA.w $2930
    LDA.w #$036F : STA.w $2932
    LDA.w #$0370 : STA.w $2934
    LDA.w #$0371 : STA.w $2936
    LDA.w #$0375 : STA.w $29B0
    LDA.w #$0376 : STA.w $29B2
    LDA.w #$0377 : STA.w $29B4
    LDA.w #$0378 : STA.w $29B6
    PLA

+ BIT.w #$0008 : BNE +
    ; northeast tree
    LDA.w #$0364 : STA.w $23B2
    LDA.w #$0365 : STA.w $23B4
    LDA.w #$0366 : STA.w $23B6
    LDA.w #$0367 : STA.w $23B8
    LDA.w #$0368 : STA.w $2432
    LDA.w #$0369 : STA.w $2434
    LDA.w #$036A : STA.w $2436
    LDA.w #$036B : STA.w $2438
    LDA.w #$036E : STA.w $24B2
    LDA.w #$036F : STA.w $24B4
    LDA.w #$0370 : STA.w $24B6
    LDA.w #$0371 : STA.w $24B8
    LDA.w #$0375 : STA.w $2532
    LDA.w #$0376 : STA.w $2534
    LDA.w #$0377 : STA.w $2536
    LDA.w #$0378 : STA.w $2538

+ RTS
}

map42: ; Map02
{
LDA.l OverworldEventDataWRAM+$42 : BIT.w #$0010 : BNE +
    LDA.w #$0364 : STA.w $2A0A
    LDA.w #$0365 : STA.w $2A0C
    LDA.w #$0366 : STA.w $2A0E
    LDA.w #$0367 : STA.w $2A10
    LDA.w #$0368 : STA.w $2A8A
    LDA.w #$0369 : STA.w $2A8C
    LDA.w #$036A : STA.w $2A8E
    LDA.w #$036B : STA.w $2A90
    LDA.w #$036E : STA.w $2B0A
    LDA.w #$036F : STA.w $2B0C
    LDA.w #$0370 : STA.w $2B0E
    LDA.w #$0371 : STA.w $2B10
    LDA.w #$0375 : STA.w $2B8A
    LDA.w #$0376 : STA.w $2B8C
    LDA.w #$0377 : STA.w $2B8E
    LDA.w #$0378 : STA.w $2B90

+ RTS
}

map53: ; Map19
{
LDA.w #$00AE : STA.w $2422 : STA.w $242E
LDA.w #$00AF : STA.w $2424 : STA.w $2430
LDA.w #$007E : STA.w $2426 : STA.w $2432
LDA.w #$007F : STA.w $2428 : STA.w $2434
LDA.w #$00B0 : STA.w $24A2 : STA.w $24AE
LDA.w #$0014 : STA.w $24A4 : STA.w $24B0
LDA.w #$0015 : STA.w $24A6 : STA.w $24B2
LDA.w #$00A8 : STA.w $24A8 : STA.w $24B4
LDA.w #$0089 : STA.w $2522 : STA.w $252E
LDA.w #$001C : STA.w $2524 : STA.w $2530
LDA.w #$001D : STA.w $2526 : STA.w $2532
LDA.w #$0076 : STA.w $2528 : STA.w $2534
LDA.w #$00F1 : STA.w $25A2 : STA.w $25AE
LDA.w #$004E : STA.w $25A4 : STA.w $25B0
LDA.w #$004F : STA.w $25A6 : STA.w $25B2
LDA.w #$00D9 : STA.w $25A8 : STA.w $25B4
RTS
}

map55: ; Map21
{
LDA.l OverworldEventDataWRAM+$55 : BIT.w #$0010 : BNE +
    ; west bank tree
    PHA
    LDA.w #$0364 : STA.w $2C12
    LDA.w #$0365 : STA.w $2C14
    LDA.w #$0366 : STA.w $2C16
    LDA.w #$0367 : STA.w $2C18
    LDA.w #$0368 : STA.w $2C92
    LDA.w #$0369 : STA.w $2C94
    LDA.w #$036A : STA.w $2C96
    LDA.w #$036B : STA.w $2C98
    LDA.w #$036E : STA.w $2D12
    LDA.w #$036F : STA.w $2D14
    LDA.w #$0370 : STA.w $2D16
    LDA.w #$0371 : STA.w $2D18
    LDA.w #$0375 : STA.w $2D92
    LDA.w #$0376 : STA.w $2D94
    LDA.w #$0377 : STA.w $2D96
    LDA.w #$0378 : STA.w $2D98
    PLA

+ BIT.w #$0008 : BNE +
    ; east bank tree
    LDA.w #$0364 : STA.w $26B4
    LDA.w #$0365 : STA.w $26B6
    LDA.w #$0366 : STA.w $26B8
    LDA.w #$0367 : STA.w $26BA
    LDA.w #$0368 : STA.w $2734
    LDA.w #$0369 : STA.w $2736
    LDA.w #$036A : STA.w $2738
    LDA.w #$036B : STA.w $273A
    LDA.w #$036E : STA.w $27B4
    LDA.w #$036F : STA.w $27B6
    LDA.w #$0370 : STA.w $27B8
    LDA.w #$0371 : STA.w $27BA
    LDA.w #$0375 : STA.w $2834
    LDA.w #$0376 : STA.w $2836
    LDA.w #$0377 : STA.w $2838
    LDA.w #$0378 : STA.w $283A

+ RTS
}

map56: ; Map22
{
LDA.l OverworldEventDataWRAM+$56 : BIT.w #$0010 : BNE +
    LDA.w #$0640 : STA.w $2604
    LDA.w #$0641 : STA.w $2606
    LDA.w #$0642 : STA.w $2608
    LDA.w #$0643 : STA.w $260A
    LDA.w #$0644 : STA.w $260C
    LDA.w #$0645 : STA.w $2684
    LDA.w #$0646 : STA.w $2686
    LDA.w #$0647 : STA.w $2688
    LDA.w #$0648 : STA.w $268A
    LDA.w #$0649 : STA.w $268C
    LDA.w #$064A : STA.w $2704
    LDA.w #$064B : STA.w $2706
    LDA.w #$064C : STA.w $2708
    LDA.w #$064D : STA.w $270A
    LDA.w #$064E : STA.w $270C
    LDA.w #$0662 : STA.w $2786
    LDA.w #$0663 : STA.w $2788
    LDA.w #$0653 : STA.w $278A

+ RTS
}

map58: ; Map24/Map25/Map32/Map33
{
LDA.w #$00AE : STA.w $242C : STA.w $38EA
LDA.w #$00AF : STA.w $242E : STA.w $38EC
LDA.w #$007E : STA.w $2430 : STA.w $38EE
LDA.w #$007F : STA.w $2432 : STA.w $38F0
LDA.w #$00B0 : STA.w $24AC : STA.w $396A
LDA.w #$0014 : STA.w $24AE : STA.w $396C
LDA.w #$0015 : STA.w $24B0 : STA.w $396E
LDA.w #$00A8 : STA.w $24B2 : STA.w $3970
LDA.w #$0089 : STA.w $252C : STA.w $39EA
LDA.w #$001C : STA.w $252E : STA.w $39EC
LDA.w #$001D : STA.w $2530 : STA.w $39EE
LDA.w #$0076 : STA.w $2532 : STA.w $39F0
LDA.w #$00F1 : STA.w $25AC : STA.w $3A6A
LDA.w #$004E : STA.w $25AE : STA.w $3A6C
LDA.w #$004F : STA.w $25B0 : STA.w $3A6E
LDA.w #$00D9 : STA.w $25B2 : STA.w $3A70
RTS
}

map5b: ; Map27/Map28/Map35/Map36
{
; east tree
LDA.w #$00AE : STA.w $344C
LDA.w #$00AF : STA.w $344E
LDA.w #$007E : STA.w $3450
LDA.w #$007F : STA.w $3452
LDA.w #$00B0 : STA.w $34CC
LDA.w #$0014 : STA.w $34CE
LDA.w #$0015 : STA.w $34D0
LDA.w #$00A8 : STA.w $34D2
LDA.w #$0089 : STA.w $354C
LDA.w #$001C : STA.w $354E
LDA.w #$001D : STA.w $3550
LDA.w #$0076 : STA.w $3552
LDA.w #$00F1 : STA.w $35CC
LDA.w #$004E : STA.w $35CE
LDA.w #$004F : STA.w $35D0
LDA.w #$00D9 : STA.w $35D2

LDA.l OverworldEventDataWRAM+$5b : BIT.w #$0010 : BEQ + ; BEQ because tree is already colored
    ; west tree
    LDA.w #$00AE : STA.w $342C
    LDA.w #$00AF : STA.w $342E
    LDA.w #$007E : STA.w $3430
    LDA.w #$007F : STA.w $3432
    LDA.w #$00B0 : STA.w $34AC
    LDA.w #$0014 : STA.w $34AE
    LDA.w #$0015 : STA.w $34B0
    LDA.w #$00A8 : STA.w $34B2
    LDA.w #$0089 : STA.w $352C
    LDA.w #$001C : STA.w $352E
    LDA.w #$001D : STA.w $3530
    LDA.w #$0076 : STA.w $3532
    LDA.w #$00F1 : STA.w $35AC
    LDA.w #$004E : STA.w $35AE
    LDA.w #$004F : STA.w $35B0
    LDA.w #$00D9 : STA.w $35B2

+ RTS
}

map5e: ; Map30/Map31/Map38/Map39
{
; non-bonk trees
LDA.w #$0000 : STA.w $3954 : STA.w $395A : STA.w $3C54
LDA.w #$0001 : STA.w $3950 : STA.w $3956 : STA.w $3C50
LDA.w #$0002 : STA.w $3952 : STA.w $3958 : STA.w $3C52
LDA.w #$0006 : STA.w $3B4E
LDA.w #$0007 : STA.w $3B50
LDA.w #$0009 : STA.w $3B54
LDA.w #$000A : STA.w $39D4
LDA.w #$000B : STA.w $39D0 : STA.w $39D6
LDA.w #$000C : STA.w $39D2
LDA.w #$000D : STA.w $39D8
LDA.w #$0011 : STA.w $38D0 : STA.w $38D6 : STA.w $3BD0
LDA.w #$0012 : STA.w $38D2 : STA.w $38D8 : STA.w $3BD2
LDA.w #$0013 : STA.w $38D4 : STA.w $38DA : STA.w $3BD4
LDA.w #$0014 : STA.w $3768 : STA.w $3A4E : STA.w $3A54 : STA.w $3B44
LDA.w #$0015 : STA.w $376A : STA.w $3A50 : STA.w $3A56 : STA.w $3B46
LDA.w #$0016 : STA.w $3A52
LDA.w #$001C : STA.w $37E8 : STA.w $3ACE : STA.w $3AD4 : STA.w $3BC4
LDA.w #$001D : STA.w $37EA : STA.w $3AD0 : STA.w $3AD6 : STA.w $3BC6
LDA.w #$001E : STA.w $3AD2
LDA.w #$0025 : STA.w $3CD2
LDA.w #$0026 : STA.w $3852 : STA.w $3858 : STA.w $3B52
LDA.w #$0031 : STA.w $3B56
LDA.w #$004E : STA.w $3868 : STA.w $3C44
LDA.w #$004F : STA.w $386A : STA.w $3C46
LDA.w #$0076 : STA.w $37EC : STA.w $3AD8 : STA.w $3BC8
LDA.w #$0078 : STA.w $3854 : STA.w $385A
LDA.w #$0079 : STA.w $385C
LDA.w #$007B : STA.w $38DC
LDA.w #$007C : STA.w $395C : STA.w $3C56
LDA.w #$007E : STA.w $36EA : STA.w $3AC6
LDA.w #$007F : STA.w $36EC : STA.w $3AC8
LDA.w #$0082 : STA.w $39DA : STA.w $3CD4
LDA.w #$0083 : STA.w $3CD0
LDA.w #$0089 : STA.w $37E6 : STA.w $3ACC : STA.w $3BC2
LDA.w #$0094 : STA.w $3BD6
LDA.w #$00A8 : STA.w $376C : STA.w $3A58 : STA.w $3B48
LDA.w #$00AE : STA.w $36E6 : STA.w $39CC : STA.w $3AC2
LDA.w #$00AF : STA.w $36E8 : STA.w $39CE : STA.w $3AC4
LDA.w #$00B0 : STA.w $3766 : STA.w $3A4C : STA.w $3B42
LDA.w #$00B5 : STA.w $384E
LDA.w #$00B6 : STA.w $3850 : STA.w $3856
LDA.w #$00B9 : STA.w $38CE
LDA.w #$00BE : STA.w $394E : STA.w $3C4E
LDA.w #$00D9 : STA.w $386C : STA.w $3B58 : STA.w $3C48
LDA.w #$00DE : STA.w $3BCE
LDA.w #$00F1 : STA.w $3866 : STA.w $3B4C : STA.w $3C42

LDA.l OverworldEventDataWRAM+$5e : BIT.w #$0010 : BEQ + ; BEQ because tree is already colored
    ; bonk tree
    LDA.w #$00AE : STA.w $375E
    LDA.w #$00AF : STA.w $3760
    LDA.w #$007E : STA.w $3762
    LDA.w #$007F : STA.w $3764
    LDA.w #$00B0 : STA.w $37DE
    LDA.w #$0014 : STA.w $37E0
    LDA.w #$0015 : STA.w $37E2
    LDA.w #$00A8 : STA.w $37E4
    LDA.w #$0089 : STA.w $385E
    LDA.w #$001C : STA.w $3860
    LDA.w #$001D : STA.w $3862
    LDA.w #$0076 : STA.w $3864
    LDA.w #$00F1 : STA.w $38DE
    LDA.w #$004E : STA.w $38E0
    LDA.w #$004F : STA.w $38E2
    LDA.w #$00D9 : STA.w $38E4

+ RTS
}

map6e: ; Map46
{
LDA.l OverworldEventDataWRAM+$6e : BIT.w #$0010 : BNE +
    ; tree 2
    PHA
    LDA.w #$0364 : STA.w $2396
    LDA.w #$0365 : STA.w $2398
    LDA.w #$0366 : STA.w $239A
    LDA.w #$0367 : STA.w $239C
    LDA.w #$0368 : STA.w $2416
    LDA.w #$0369 : STA.w $2418
    LDA.w #$036A : STA.w $241A
    LDA.w #$036B : STA.w $241C
    LDA.w #$036E : STA.w $2496
    LDA.w #$036F : STA.w $2498
    LDA.w #$0370 : STA.w $249A
    LDA.w #$0371 : STA.w $249C
    LDA.w #$0375 : STA.w $2516
    LDA.w #$0376 : STA.w $2518
    LDA.w #$0377 : STA.w $251A
    LDA.w #$0378 : STA.w $251C
    PLA

+ BIT.w #$0008 : BNE +
    ; tree 3
    PHA
    LDA.w #$0364 : STA.w $241E
    LDA.w #$0365 : STA.w $2420
    LDA.w #$0366 : STA.w $2422
    LDA.w #$0367 : STA.w $2424
    LDA.w #$0368 : STA.w $249E
    LDA.w #$0369 : STA.w $24A0
    LDA.w #$036A : STA.w $24A2
    LDA.w #$036B : STA.w $24A4
    LDA.w #$036E : STA.w $251E
    LDA.w #$036F : STA.w $2520
    LDA.w #$0370 : STA.w $2522
    LDA.w #$0371 : STA.w $2524
    LDA.w #$0375 : STA.w $259E
    LDA.w #$0376 : STA.w $25A0
    LDA.w #$0377 : STA.w $25A2
    LDA.w #$0378 : STA.w $25A4
    PLA

+ BIT.w #$0004 : BNE +
    ; tree 4
    LDA.w #$0364 : STA.w $24A6
    LDA.w #$0365 : STA.w $24A8
    LDA.w #$0366 : STA.w $24AA
    LDA.w #$0367 : STA.w $24AC
    LDA.w #$0368 : STA.w $2526
    LDA.w #$0369 : STA.w $2528
    LDA.w #$036A : STA.w $252A
    LDA.w #$036B : STA.w $252C
    LDA.w #$036E : STA.w $25A6
    LDA.w #$036F : STA.w $25A8
    LDA.w #$0370 : STA.w $25AA
    LDA.w #$0371 : STA.w $25AC
    LDA.w #$0375 : STA.w $2626
    LDA.w #$0376 : STA.w $2628
    LDA.w #$0377 : STA.w $262A
    LDA.w #$0378 : STA.w $262C

+ RTS
}
