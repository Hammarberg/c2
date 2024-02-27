	ORG $1000

label0
	adca #$ff
label1
	adca <$ff
label2
	adca >$ff
label3
	adca $ffff
label4
	adca label4,x
label5
	adca label5,u
label6
	adca [label6,x]
label7
	adca [label7,u]
label8
	adca ,x
label9
	adca ,u
label10
	adca [,x]
label11
	adca [,u]
label12
	adca b,u
label13
	adca [b,u]
label14
	adca ,x+
label15
	adca ,u+
label16
	adca ,x++
label17
	adca ,u++
label18
	adca [,x++]
label19
	adca [,u++]
label20
	adca ,-x
label21
	adca ,-u
label22
	adca ,--x
label23
	adca ,--u
label24
	adca [,--x]
label25
	adca [,--u]
label26
	adca 0,pc
label27
	adca [0,pc]
label28
	adca label28,pcr
label29
	adca [label29,pcr]
label30
	adca [label30]
label31
	adcb #$ff
label32
	adcb <$ff
label33
	adcb >$ff
label34
	adcb $ffff
label35
	adcb label35,x
label36
	adcb label36,u
label37
	adcb [label37,x]
label38
	adcb [label38,u]
label39
	adcb ,x
label40
	adcb ,u
label41
	adcb [,x]
label42
	adcb [,u]
label43
	adcb b,u
label44
	adcb [b,u]
label45
	adcb ,x+
label46
	adcb ,u+
label47
	adcb ,x++
label48
	adcb ,u++
label49
	adcb [,x++]
label50
	adcb [,u++]
label51
	adcb ,-x
label52
	adcb ,-u
label53
	adcb ,--x
label54
	adcb ,--u
label55
	adcb [,--x]
label56
	adcb [,--u]
label57
	adcb 0,pc
label58
	adcb [0,pc]
label59
	adcb label59,pcr
label60
	adcb [label60,pcr]
label61
	adcb [label61]
label62
	adda #$ff
label63
	adda <$ff
label64
	adda >$ff
label65
	adda $ffff
label66
	adda label66,x
label67
	adda label67,u
label68
	adda [label68,x]
label69
	adda [label69,u]
label70
	adda ,x
label71
	adda ,u
label72
	adda [,x]
label73
	adda [,u]
label74
	adda b,u
label75
	adda [b,u]
label76
	adda ,x+
label77
	adda ,u+
label78
	adda ,x++
label79
	adda ,u++
label80
	adda [,x++]
label81
	adda [,u++]
label82
	adda ,-x
label83
	adda ,-u
label84
	adda ,--x
label85
	adda ,--u
label86
	adda [,--x]
label87
	adda [,--u]
label88
	adda 0,pc
label89
	adda [0,pc]
label90
	adda label90,pcr
label91
	adda [label91,pcr]
label92
	adda [label92]
label93
	addb #$ff
label94
	addb <$ff
label95
	addb >$ff
label96
	addb $ffff
label97
	addb label97,x
label98
	addb label98,u
label99
	addb [label99,x]
label100
	addb [label100,u]
label101
	addb ,x
label102
	addb ,u
label103
	addb [,x]
label104
	addb [,u]
label105
	addb b,u
label106
	addb [b,u]
label107
	addb ,x+
label108
	addb ,u+
label109
	addb ,x++
label110
	addb ,u++
label111
	addb [,x++]
label112
	addb [,u++]
label113
	addb ,-x
label114
	addb ,-u
label115
	addb ,--x
label116
	addb ,--u
label117
	addb [,--x]
label118
	addb [,--u]
label119
	addb 0,pc
label120
	addb [0,pc]
label121
	addb label121,pcr
label122
	addb [label122,pcr]
label123
	addb [label123]
label124
	addd #$ff
label125
	addd <$ff
label126
	addd >$ff
label127
	addd $ffff
label128
	addd label128,x
label129
	addd label129,u
label130
	addd [label130,x]
label131
	addd [label131,u]
label132
	addd ,x
label133
	addd ,u
label134
	addd [,x]
label135
	addd [,u]
label136
	addd b,u
label137
	addd [b,u]
label138
	addd ,x+
label139
	addd ,u+
label140
	addd ,x++
label141
	addd ,u++
label142
	addd [,x++]
label143
	addd [,u++]
label144
	addd ,-x
label145
	addd ,-u
label146
	addd ,--x
label147
	addd ,--u
label148
	addd [,--x]
label149
	addd [,--u]
label150
	addd 0,pc
label151
	addd [0,pc]
label152
	addd label152,pcr
label153
	addd [label153,pcr]
label154
	addd [label154]
label155
	anda #$ff
label156
	anda <$ff
label157
	anda >$ff
label158
	anda $ffff
label159
	anda label159,x
label160
	anda label160,u
label161
	anda [label161,x]
label162
	anda [label162,u]
label163
	anda ,x
label164
	anda ,u
label165
	anda [,x]
label166
	anda [,u]
label167
	anda b,u
label168
	anda [b,u]
label169
	anda ,x+
label170
	anda ,u+
label171
	anda ,x++
label172
	anda ,u++
label173
	anda [,x++]
label174
	anda [,u++]
label175
	anda ,-x
label176
	anda ,-u
label177
	anda ,--x
label178
	anda ,--u
label179
	anda [,--x]
label180
	anda [,--u]
label181
	anda 0,pc
label182
	anda [0,pc]
label183
	anda label183,pcr
label184
	anda [label184,pcr]
label185
	anda [label185]
label186
	andb #$ff
label187
	andb <$ff
label188
	andb >$ff
label189
	andb $ffff
label190
	andb label190,x
label191
	andb label191,u
label192
	andb [label192,x]
label193
	andb [label193,u]
label194
	andb ,x
label195
	andb ,u
label196
	andb [,x]
label197
	andb [,u]
label198
	andb b,u
label199
	andb [b,u]
label200
	andb ,x+
label201
	andb ,u+
label202
	andb ,x++
label203
	andb ,u++
label204
	andb [,x++]
label205
	andb [,u++]
label206
	andb ,-x
label207
	andb ,-u
label208
	andb ,--x
label209
	andb ,--u
label210
	andb [,--x]
label211
	andb [,--u]
label212
	andb 0,pc
label213
	andb [0,pc]
label214
	andb label214,pcr
label215
	andb [label215,pcr]
label216
	andb [label216]
label217
	andcc #$ff
label218
	asr <$ff
label219
	asr >$ff
label220
	asr $ffff
label221
	asr label221,x
label222
	asr label222,u
label223
	asr [label223,x]
label224
	asr [label224,u]
label225
	asr ,x
label226
	asr ,u
label227
	asr [,x]
label228
	asr [,u]
label229
	asr b,u
label230
	asr [b,u]
label231
	asr ,x+
label232
	asr ,u+
label233
	asr ,x++
label234
	asr ,u++
label235
	asr [,x++]
label236
	asr [,u++]
label237
	asr ,-x
label238
	asr ,-u
label239
	asr ,--x
label240
	asr ,--u
label241
	asr [,--x]
label242
	asr [,--u]
label243
	asr 0,pc
label244
	asr [0,pc]
label245
	asr label245,pcr
label246
	asr [label246,pcr]
label247
	asr [label247]
label248
	beq label248
label249
	lbeq label249
label250
	bge label250
label251
	lbge label251
label252
	bgt label252
label253
	lbgt label253
label254
	bhi label254
label255
	lbhi label255
label256
	bhs label256
label257
	lbhs label257
label258
	bita #$ff
label259
	bita <$ff
label260
	bita >$ff
label261
	bita $ffff
label262
	bita label262,x
label263
	bita label263,u
label264
	bita [label264,x]
label265
	bita [label265,u]
label266
	bita ,x
label267
	bita ,u
label268
	bita [,x]
label269
	bita [,u]
label270
	bita b,u
label271
	bita [b,u]
label272
	bita ,x+
label273
	bita ,u+
label274
	bita ,x++
label275
	bita ,u++
label276
	bita [,x++]
label277
	bita [,u++]
label278
	bita ,-x
label279
	bita ,-u
label280
	bita ,--x
label281
	bita ,--u
label282
	bita [,--x]
label283
	bita [,--u]
label284
	bita 0,pc
label285
	bita [0,pc]
label286
	bita label286,pcr
label287
	bita [label287,pcr]
label288
	bita [label288]
label289
	bitb #$ff
label290
	bitb <$ff
label291
	bitb >$ff
label292
	bitb $ffff
label293
	bitb label293,x
label294
	bitb label294,u
label295
	bitb [label295,x]
label296
	bitb [label296,u]
label297
	bitb ,x
label298
	bitb ,u
label299
	bitb [,x]
label300
	bitb [,u]
label301
	bitb b,u
label302
	bitb [b,u]
label303
	bitb ,x+
label304
	bitb ,u+
label305
	bitb ,x++
label306
	bitb ,u++
label307
	bitb [,x++]
label308
	bitb [,u++]
label309
	bitb ,-x
label310
	bitb ,-u
label311
	bitb ,--x
label312
	bitb ,--u
label313
	bitb [,--x]
label314
	bitb [,--u]
label315
	bitb 0,pc
label316
	bitb [0,pc]
label317
	bitb label317,pcr
label318
	bitb [label318,pcr]
label319
	bitb [label319]
label320
	ble label320
label321
	lble label321
label322
	blo label322
label323
	lblo label323
label324
	bls label324
label325
	lbls label325
label326
	blt label326
label327
	lblt label327
label328
	bmi label328
label329
	lbmi label329
label330
	bne label330
label331
	lbne label331
label332
	bpl label332
label333
	lbpl label333
label334
	bra label334
label335
	lbra label335
label336
	brn label336
label337
	lbrn label337
label338
	bsr label338
label339
	lbsr label339
label340
	bvc label340
label341
	lbvc label341
label342
	bvs label342
label343
	lbvs label343
label344
	clr <$ff
label345
	clr >$ff
label346
	clr $ffff
label347
	clr label347,x
label348
	clr label348,u
label349
	clr [label349,x]
label350
	clr [label350,u]
label351
	clr ,x
label352
	clr ,u
label353
	clr [,x]
label354
	clr [,u]
label355
	clr b,u
label356
	clr [b,u]
label357
	clr ,x+
label358
	clr ,u+
label359
	clr ,x++
label360
	clr ,u++
label361
	clr [,x++]
label362
	clr [,u++]
label363
	clr ,-x
label364
	clr ,-u
label365
	clr ,--x
label366
	clr ,--u
label367
	clr [,--x]
label368
	clr [,--u]
label369
	clr 0,pc
label370
	clr [0,pc]
label371
	clr label371,pcr
label372
	clr [label372,pcr]
label373
	clr [label373]
label374
	cmpa #$ff
label375
	cmpa <$ff
label376
	cmpa >$ff
label377
	cmpa $ffff
label378
	cmpa label378,x
label379
	cmpa label379,u
label380
	cmpa [label380,x]
label381
	cmpa [label381,u]
label382
	cmpa ,x
label383
	cmpa ,u
label384
	cmpa [,x]
label385
	cmpa [,u]
label386
	cmpa b,u
label387
	cmpa [b,u]
label388
	cmpa ,x+
label389
	cmpa ,u+
label390
	cmpa ,x++
label391
	cmpa ,u++
label392
	cmpa [,x++]
label393
	cmpa [,u++]
label394
	cmpa ,-x
label395
	cmpa ,-u
label396
	cmpa ,--x
label397
	cmpa ,--u
label398
	cmpa [,--x]
label399
	cmpa [,--u]
label400
	cmpa 0,pc
label401
	cmpa [0,pc]
label402
	cmpa label402,pcr
label403
	cmpa [label403,pcr]
label404
	cmpa [label404]
label405
	cmpb #$ff
label406
	cmpb <$ff
label407
	cmpb >$ff
label408
	cmpb $ffff
label409
	cmpb label409,x
label410
	cmpb label410,u
label411
	cmpb [label411,x]
label412
	cmpb [label412,u]
label413
	cmpb ,x
label414
	cmpb ,u
label415
	cmpb [,x]
label416
	cmpb [,u]
label417
	cmpb b,u
label418
	cmpb [b,u]
label419
	cmpb ,x+
label420
	cmpb ,u+
label421
	cmpb ,x++
label422
	cmpb ,u++
label423
	cmpb [,x++]
label424
	cmpb [,u++]
label425
	cmpb ,-x
label426
	cmpb ,-u
label427
	cmpb ,--x
label428
	cmpb ,--u
label429
	cmpb [,--x]
label430
	cmpb [,--u]
label431
	cmpb 0,pc
label432
	cmpb [0,pc]
label433
	cmpb label433,pcr
label434
	cmpb [label434,pcr]
label435
	cmpb [label435]
label436
	cmpd #$ff
label437
	cmpd <$ff
label438
	cmpd >$ff
label439
	cmpd $ffff
label440
	cmpd label440,x
label441
	cmpd label441,u
label442
	cmpd [label442,x]
label443
	cmpd [label443,u]
label444
	cmpd ,x
label445
	cmpd ,u
label446
	cmpd [,x]
label447
	cmpd [,u]
label448
	cmpd b,u
label449
	cmpd [b,u]
label450
	cmpd ,x+
label451
	cmpd ,u+
label452
	cmpd ,x++
label453
	cmpd ,u++
label454
	cmpd [,x++]
label455
	cmpd [,u++]
label456
	cmpd ,-x
label457
	cmpd ,-u
label458
	cmpd ,--x
label459
	cmpd ,--u
label460
	cmpd [,--x]
label461
	cmpd [,--u]
label462
	cmpd 0,pc
label463
	cmpd [0,pc]
label464
	cmpd label464,pcr
label465
	cmpd [label465,pcr]
label466
	cmpd [label466]
label467
	cmps #$ff
label468
	cmps <$ff
label469
	cmps >$ff
label470
	cmps $ffff
label471
	cmps label471,x
label472
	cmps label472,u
label473
	cmps [label473,x]
label474
	cmps [label474,u]
label475
	cmps ,x
label476
	cmps ,u
label477
	cmps [,x]
label478
	cmps [,u]
label479
	cmps b,u
label480
	cmps [b,u]
label481
	cmps ,x+
label482
	cmps ,u+
label483
	cmps ,x++
label484
	cmps ,u++
label485
	cmps [,x++]
label486
	cmps [,u++]
label487
	cmps ,-x
label488
	cmps ,-u
label489
	cmps ,--x
label490
	cmps ,--u
label491
	cmps [,--x]
label492
	cmps [,--u]
label493
	cmps 0,pc
label494
	cmps [0,pc]
label495
	cmps label495,pcr
label496
	cmps [label496,pcr]
label497
	cmps [label497]
label498
	cmpu #$ff
label499
	cmpu <$ff
label500
	cmpu >$ff
label501
	cmpu $ffff
label502
	cmpu label502,x
label503
	cmpu label503,u
label504
	cmpu [label504,x]
label505
	cmpu [label505,u]
label506
	cmpu ,x
label507
	cmpu ,u
label508
	cmpu [,x]
label509
	cmpu [,u]
label510
	cmpu b,u
label511
	cmpu [b,u]
label512
	cmpu ,x+
label513
	cmpu ,u+
label514
	cmpu ,x++
label515
	cmpu ,u++
label516
	cmpu [,x++]
label517
	cmpu [,u++]
label518
	cmpu ,-x
label519
	cmpu ,-u
label520
	cmpu ,--x
label521
	cmpu ,--u
label522
	cmpu [,--x]
label523
	cmpu [,--u]
label524
	cmpu 0,pc
label525
	cmpu [0,pc]
label526
	cmpu label526,pcr
label527
	cmpu [label527,pcr]
label528
	cmpu [label528]
label529
	cmpx #$ff
label530
	cmpx <$ff
label531
	cmpx >$ff
label532
	cmpx $ffff
label533
	cmpx label533,x
label534
	cmpx label534,u
label535
	cmpx [label535,x]
label536
	cmpx [label536,u]
label537
	cmpx ,x
label538
	cmpx ,u
label539
	cmpx [,x]
label540
	cmpx [,u]
label541
	cmpx b,u
label542
	cmpx [b,u]
label543
	cmpx ,x+
label544
	cmpx ,u+
label545
	cmpx ,x++
label546
	cmpx ,u++
label547
	cmpx [,x++]
label548
	cmpx [,u++]
label549
	cmpx ,-x
label550
	cmpx ,-u
label551
	cmpx ,--x
label552
	cmpx ,--u
label553
	cmpx [,--x]
label554
	cmpx [,--u]
label555
	cmpx 0,pc
label556
	cmpx [0,pc]
label557
	cmpx label557,pcr
label558
	cmpx [label558,pcr]
label559
	cmpx [label559]
label560
	cmpy #$ff
label561
	cmpy <$ff
label562
	cmpy >$ff
label563
	cmpy $ffff
label564
	cmpy label564,x
label565
	cmpy label565,u
label566
	cmpy [label566,x]
label567
	cmpy [label567,u]
label568
	cmpy ,x
label569
	cmpy ,u
label570
	cmpy [,x]
label571
	cmpy [,u]
label572
	cmpy b,u
label573
	cmpy [b,u]
label574
	cmpy ,x+
label575
	cmpy ,u+
label576
	cmpy ,x++
label577
	cmpy ,u++
label578
	cmpy [,x++]
label579
	cmpy [,u++]
label580
	cmpy ,-x
label581
	cmpy ,-u
label582
	cmpy ,--x
label583
	cmpy ,--u
label584
	cmpy [,--x]
label585
	cmpy [,--u]
label586
	cmpy 0,pc
label587
	cmpy [0,pc]
label588
	cmpy label588,pcr
label589
	cmpy [label589,pcr]
label590
	cmpy [label590]
label591
	com <$ff
label592
	com >$ff
label593
	com $ffff
label594
	com label594,x
label595
	com label595,u
label596
	com [label596,x]
label597
	com [label597,u]
label598
	com ,x
label599
	com ,u
label600
	com [,x]
label601
	com [,u]
label602
	com b,u
label603
	com [b,u]
label604
	com ,x+
label605
	com ,u+
label606
	com ,x++
label607
	com ,u++
label608
	com [,x++]
label609
	com [,u++]
label610
	com ,-x
label611
	com ,-u
label612
	com ,--x
label613
	com ,--u
label614
	com [,--x]
label615
	com [,--u]
label616
	com 0,pc
label617
	com [0,pc]
label618
	com label618,pcr
label619
	com [label619,pcr]
label620
	com [label620]
label621
	cwai #5
label622
	cwai #4
label623
	dec <$ff
label624
	dec >$ff
label625
	dec $ffff
label626
	dec label626,x
label627
	dec label627,u
label628
	dec [label628,x]
label629
	dec [label629,u]
label630
	dec ,x
label631
	dec ,u
label632
	dec [,x]
label633
	dec [,u]
label634
	dec b,u
label635
	dec [b,u]
label636
	dec ,x+
label637
	dec ,u+
label638
	dec ,x++
label639
	dec ,u++
label640
	dec [,x++]
label641
	dec [,u++]
label642
	dec ,-x
label643
	dec ,-u
label644
	dec ,--x
label645
	dec ,--u
label646
	dec [,--x]
label647
	dec [,--u]
label648
	dec 0,pc
label649
	dec [0,pc]
label650
	dec label650,pcr
label651
	dec [label651,pcr]
label652
	dec [label652]
label653
	eora #$ff
label654
	eora <$ff
label655
	eora >$ff
label656
	eora $ffff
label657
	eora label657,x
label658
	eora label658,u
label659
	eora [label659,x]
label660
	eora [label660,u]
label661
	eora ,x
label662
	eora ,u
label663
	eora [,x]
label664
	eora [,u]
label665
	eora b,u
label666
	eora [b,u]
label667
	eora ,x+
label668
	eora ,u+
label669
	eora ,x++
label670
	eora ,u++
label671
	eora [,x++]
label672
	eora [,u++]
label673
	eora ,-x
label674
	eora ,-u
label675
	eora ,--x
label676
	eora ,--u
label677
	eora [,--x]
label678
	eora [,--u]
label679
	eora 0,pc
label680
	eora [0,pc]
label681
	eora label681,pcr
label682
	eora [label682,pcr]
label683
	eora [label683]
label684
	eorb #$ff
label685
	eorb <$ff
label686
	eorb >$ff
label687
	eorb $ffff
label688
	eorb label688,x
label689
	eorb label689,u
label690
	eorb [label690,x]
label691
	eorb [label691,u]
label692
	eorb ,x
label693
	eorb ,u
label694
	eorb [,x]
label695
	eorb [,u]
label696
	eorb b,u
label697
	eorb [b,u]
label698
	eorb ,x+
label699
	eorb ,u+
label700
	eorb ,x++
label701
	eorb ,u++
label702
	eorb [,x++]
label703
	eorb [,u++]
label704
	eorb ,-x
label705
	eorb ,-u
label706
	eorb ,--x
label707
	eorb ,--u
label708
	eorb [,--x]
label709
	eorb [,--u]
label710
	eorb 0,pc
label711
	eorb [0,pc]
label712
	eorb label712,pcr
label713
	eorb [label713,pcr]
label714
	eorb [label714]
label715
	exg x,y
label716
	exg a,b
label717
	inc <$ff
label718
	inc >$ff
label719
	inc $ffff
label720
	inc label720,x
label721
	inc label721,u
label722
	inc [label722,x]
label723
	inc [label723,u]
label724
	inc ,x
label725
	inc ,u
label726
	inc [,x]
label727
	inc [,u]
label728
	inc b,u
label729
	inc [b,u]
label730
	inc ,x+
label731
	inc ,u+
label732
	inc ,x++
label733
	inc ,u++
label734
	inc [,x++]
label735
	inc [,u++]
label736
	inc ,-x
label737
	inc ,-u
label738
	inc ,--x
label739
	inc ,--u
label740
	inc [,--x]
label741
	inc [,--u]
label742
	inc 0,pc
label743
	inc [0,pc]
label744
	inc label744,pcr
label745
	inc [label745,pcr]
label746
	inc [label746]
label747
	jmp <$ff
label748
	jmp >$ff
label749
	jmp $ffff
label750
	jmp label750,x
label751
	jmp label751,u
label752
	jmp [label752,x]
label753
	jmp [label753,u]
label754
	jmp ,x
label755
	jmp ,u
label756
	jmp [,x]
label757
	jmp [,u]
label758
	jmp b,u
label759
	jmp [b,u]
label760
	jmp ,x+
label761
	jmp ,u+
label762
	jmp ,x++
label763
	jmp ,u++
label764
	jmp [,x++]
label765
	jmp [,u++]
label766
	jmp ,-x
label767
	jmp ,-u
label768
	jmp ,--x
label769
	jmp ,--u
label770
	jmp [,--x]
label771
	jmp [,--u]
label772
	jmp 0,pc
label773
	jmp [0,pc]
label774
	jmp label774,pcr
label775
	jmp [label775,pcr]
label776
	jmp [label776]
label777
	jsr <$ff
label778
	jsr >$ff
label779
	jsr $ffff
label780
	jsr label780,x
label781
	jsr label781,u
label782
	jsr [label782,x]
label783
	jsr [label783,u]
label784
	jsr ,x
label785
	jsr ,u
label786
	jsr [,x]
label787
	jsr [,u]
label788
	jsr b,u
label789
	jsr [b,u]
label790
	jsr ,x+
label791
	jsr ,u+
label792
	jsr ,x++
label793
	jsr ,u++
label794
	jsr [,x++]
label795
	jsr [,u++]
label796
	jsr ,-x
label797
	jsr ,-u
label798
	jsr ,--x
label799
	jsr ,--u
label800
	jsr [,--x]
label801
	jsr [,--u]
label802
	jsr 0,pc
label803
	jsr [0,pc]
label804
	jsr label804,pcr
label805
	jsr [label805,pcr]
label806
	jsr [label806]
label807
	lda #$ff
label808
	lda <$ff
label809
	lda >$ff
label810
	lda $ffff
label811
	lda label811,x
label812
	lda label812,u
label813
	lda [label813,x]
label814
	lda [label814,u]
label815
	lda ,x
label816
	lda ,u
label817
	lda [,x]
label818
	lda [,u]
label819
	lda b,u
label820
	lda [b,u]
label821
	lda ,x+
label822
	lda ,u+
label823
	lda ,x++
label824
	lda ,u++
label825
	lda [,x++]
label826
	lda [,u++]
label827
	lda ,-x
label828
	lda ,-u
label829
	lda ,--x
label830
	lda ,--u
label831
	lda [,--x]
label832
	lda [,--u]
label833
	lda 0,pc
label834
	lda [0,pc]
label835
	lda label835,pcr
label836
	lda [label836,pcr]
label837
	lda [label837]
label838
	ldb #$ff
label839
	ldb <$ff
label840
	ldb >$ff
label841
	ldb $ffff
label842
	ldb label842,x
label843
	ldb label843,u
label844
	ldb [label844,x]
label845
	ldb [label845,u]
label846
	ldb ,x
label847
	ldb ,u
label848
	ldb [,x]
label849
	ldb [,u]
label850
	ldb b,u
label851
	ldb [b,u]
label852
	ldb ,x+
label853
	ldb ,u+
label854
	ldb ,x++
label855
	ldb ,u++
label856
	ldb [,x++]
label857
	ldb [,u++]
label858
	ldb ,-x
label859
	ldb ,-u
label860
	ldb ,--x
label861
	ldb ,--u
label862
	ldb [,--x]
label863
	ldb [,--u]
label864
	ldb 0,pc
label865
	ldb [0,pc]
label866
	ldb label866,pcr
label867
	ldb [label867,pcr]
label868
	ldb [label868]
label869
	ldd #$ff
label870
	ldd <$ff
label871
	ldd >$ff
label872
	ldd $ffff
label873
	ldd label873,x
label874
	ldd label874,u
label875
	ldd [label875,x]
label876
	ldd [label876,u]
label877
	ldd ,x
label878
	ldd ,u
label879
	ldd [,x]
label880
	ldd [,u]
label881
	ldd b,u
label882
	ldd [b,u]
label883
	ldd ,x+
label884
	ldd ,u+
label885
	ldd ,x++
label886
	ldd ,u++
label887
	ldd [,x++]
label888
	ldd [,u++]
label889
	ldd ,-x
label890
	ldd ,-u
label891
	ldd ,--x
label892
	ldd ,--u
label893
	ldd [,--x]
label894
	ldd [,--u]
label895
	ldd 0,pc
label896
	ldd [0,pc]
label897
	ldd label897,pcr
label898
	ldd [label898,pcr]
label899
	ldd [label899]
label900
	lds #$ff
label901
	lds <$ff
label902
	lds >$ff
label903
	lds $ffff
label904
	lds label904,x
label905
	lds label905,u
label906
	lds [label906,x]
label907
	lds [label907,u]
label908
	lds ,x
label909
	lds ,u
label910
	lds [,x]
label911
	lds [,u]
label912
	lds b,u
label913
	lds [b,u]
label914
	lds ,x+
label915
	lds ,u+
label916
	lds ,x++
label917
	lds ,u++
label918
	lds [,x++]
label919
	lds [,u++]
label920
	lds ,-x
label921
	lds ,-u
label922
	lds ,--x
label923
	lds ,--u
label924
	lds [,--x]
label925
	lds [,--u]
label926
	lds 0,pc
label927
	lds [0,pc]
label928
	lds label928,pcr
label929
	lds [label929,pcr]
label930
	lds [label930]
label931
	ldu #$ff
label932
	ldu <$ff
label933
	ldu >$ff
label934
	ldu $ffff
label935
	ldu label935,x
label936
	ldu label936,u
label937
	ldu [label937,x]
label938
	ldu [label938,u]
label939
	ldu ,x
label940
	ldu ,u
label941
	ldu [,x]
label942
	ldu [,u]
label943
	ldu b,u
label944
	ldu [b,u]
label945
	ldu ,x+
label946
	ldu ,u+
label947
	ldu ,x++
label948
	ldu ,u++
label949
	ldu [,x++]
label950
	ldu [,u++]
label951
	ldu ,-x
label952
	ldu ,-u
label953
	ldu ,--x
label954
	ldu ,--u
label955
	ldu [,--x]
label956
	ldu [,--u]
label957
	ldu 0,pc
label958
	ldu [0,pc]
label959
	ldu label959,pcr
label960
	ldu [label960,pcr]
label961
	ldu [label961]
label962
	ldx #$ff
label963
	ldx <$ff
label964
	ldx >$ff
label965
	ldx $ffff
label966
	ldx label966,x
label967
	ldx label967,u
label968
	ldx [label968,x]
label969
	ldx [label969,u]
label970
	ldx ,x
label971
	ldx ,u
label972
	ldx [,x]
label973
	ldx [,u]
label974
	ldx b,u
label975
	ldx [b,u]
label976
	ldx ,x+
label977
	ldx ,u+
label978
	ldx ,x++
label979
	ldx ,u++
label980
	ldx [,x++]
label981
	ldx [,u++]
label982
	ldx ,-x
label983
	ldx ,-u
label984
	ldx ,--x
label985
	ldx ,--u
label986
	ldx [,--x]
label987
	ldx [,--u]
label988
	ldx 0,pc
label989
	ldx [0,pc]
label990
	ldx label990,pcr
label991
	ldx [label991,pcr]
label992
	ldx [label992]
label993
	ldy #$ff
label994
	ldy <$ff
label995
	ldy >$ff
label996
	ldy $ffff
label997
	ldy label997,x
label998
	ldy label998,u
label999
	ldy [label999,x]
label1000
	ldy [label1000,u]
label1001
	ldy ,x
label1002
	ldy ,u
label1003
	ldy [,x]
label1004
	ldy [,u]
label1005
	ldy b,u
label1006
	ldy [b,u]
label1007
	ldy ,x+
label1008
	ldy ,u+
label1009
	ldy ,x++
label1010
	ldy ,u++
label1011
	ldy [,x++]
label1012
	ldy [,u++]
label1013
	ldy ,-x
label1014
	ldy ,-u
label1015
	ldy ,--x
label1016
	ldy ,--u
label1017
	ldy [,--x]
label1018
	ldy [,--u]
label1019
	ldy 0,pc
label1020
	ldy [0,pc]
label1021
	ldy label1021,pcr
label1022
	ldy [label1022,pcr]
label1023
	ldy [label1023]
label1024
	leas label1024,x
label1025
	leas label1025,u
label1026
	leas [label1026,x]
label1027
	leas [label1027,u]
label1028
	leas ,x
label1029
	leas ,u
label1030
	leas [,x]
label1031
	leas [,u]
label1032
	leas b,u
label1033
	leas [b,u]
label1034
	leas ,x+
label1035
	leas ,u+
label1036
	leas ,x++
label1037
	leas ,u++
label1038
	leas [,x++]
label1039
	leas [,u++]
label1040
	leas ,-x
label1041
	leas ,-u
label1042
	leas ,--x
label1043
	leas ,--u
label1044
	leas [,--x]
label1045
	leas [,--u]
label1046
	leas 0,pc
label1047
	leas [0,pc]
label1048
	leas label1048,pcr
label1049
	leas [label1049,pcr]
label1050
	leas [label1050]
label1051
	leau label1051,x
label1052
	leau label1052,u
label1053
	leau [label1053,x]
label1054
	leau [label1054,u]
label1055
	leau ,x
label1056
	leau ,u
label1057
	leau [,x]
label1058
	leau [,u]
label1059
	leau b,u
label1060
	leau [b,u]
label1061
	leau ,x+
label1062
	leau ,u+
label1063
	leau ,x++
label1064
	leau ,u++
label1065
	leau [,x++]
label1066
	leau [,u++]
label1067
	leau ,-x
label1068
	leau ,-u
label1069
	leau ,--x
label1070
	leau ,--u
label1071
	leau [,--x]
label1072
	leau [,--u]
label1073
	leau 0,pc
label1074
	leau [0,pc]
label1075
	leau label1075,pcr
label1076
	leau [label1076,pcr]
label1077
	leau [label1077]
label1078
	leax label1078,x
label1079
	leax label1079,u
label1080
	leax [label1080,x]
label1081
	leax [label1081,u]
label1082
	leax ,x
label1083
	leax ,u
label1084
	leax [,x]
label1085
	leax [,u]
label1086
	leax b,u
label1087
	leax [b,u]
label1088
	leax ,x+
label1089
	leax ,u+
label1090
	leax ,x++
label1091
	leax ,u++
label1092
	leax [,x++]
label1093
	leax [,u++]
label1094
	leax ,-x
label1095
	leax ,-u
label1096
	leax ,--x
label1097
	leax ,--u
label1098
	leax [,--x]
label1099
	leax [,--u]
label1100
	leax 0,pc
label1101
	leax [0,pc]
label1102
	leax label1102,pcr
label1103
	leax [label1103,pcr]
label1104
	leax [label1104]
label1105
	leay label1105,x
label1106
	leay label1106,u
label1107
	leay [label1107,x]
label1108
	leay [label1108,u]
label1109
	leay ,x
label1110
	leay ,u
label1111
	leay [,x]
label1112
	leay [,u]
label1113
	leay b,u
label1114
	leay [b,u]
label1115
	leay ,x+
label1116
	leay ,u+
label1117
	leay ,x++
label1118
	leay ,u++
label1119
	leay [,x++]
label1120
	leay [,u++]
label1121
	leay ,-x
label1122
	leay ,-u
label1123
	leay ,--x
label1124
	leay ,--u
label1125
	leay [,--x]
label1126
	leay [,--u]
label1127
	leay 0,pc
label1128
	leay [0,pc]
label1129
	leay label1129,pcr
label1130
	leay [label1130,pcr]
label1131
	leay [label1131]
label1132
	lsl <$ff
label1133
	lsl >$ff
label1134
	lsl $ffff
label1135
	lsl label1135,x
label1136
	lsl label1136,u
label1137
	lsl [label1137,x]
label1138
	lsl [label1138,u]
label1139
	lsl ,x
label1140
	lsl ,u
label1141
	lsl [,x]
label1142
	lsl [,u]
label1143
	lsl b,u
label1144
	lsl [b,u]
label1145
	lsl ,x+
label1146
	lsl ,u+
label1147
	lsl ,x++
label1148
	lsl ,u++
label1149
	lsl [,x++]
label1150
	lsl [,u++]
label1151
	lsl ,-x
label1152
	lsl ,-u
label1153
	lsl ,--x
label1154
	lsl ,--u
label1155
	lsl [,--x]
label1156
	lsl [,--u]
label1157
	lsl 0,pc
label1158
	lsl [0,pc]
label1159
	lsl label1159,pcr
label1160
	lsl [label1160,pcr]
label1161
	lsl [label1161]
label1162
	lsr <$ff
label1163
	lsr >$ff
label1164
	lsr $ffff
label1165
	lsr label1165,x
label1166
	lsr label1166,u
label1167
	lsr [label1167,x]
label1168
	lsr [label1168,u]
label1169
	lsr ,x
label1170
	lsr ,u
label1171
	lsr [,x]
label1172
	lsr [,u]
label1173
	lsr b,u
label1174
	lsr [b,u]
label1175
	lsr ,x+
label1176
	lsr ,u+
label1177
	lsr ,x++
label1178
	lsr ,u++
label1179
	lsr [,x++]
label1180
	lsr [,u++]
label1181
	lsr ,-x
label1182
	lsr ,-u
label1183
	lsr ,--x
label1184
	lsr ,--u
label1185
	lsr [,--x]
label1186
	lsr [,--u]
label1187
	lsr 0,pc
label1188
	lsr [0,pc]
label1189
	lsr label1189,pcr
label1190
	lsr [label1190,pcr]
label1191
	lsr [label1191]
label1192
	neg <$ff
label1193
	neg >$ff
label1194
	neg $ffff
label1195
	neg label1195,x
label1196
	neg label1196,u
label1197
	neg [label1197,x]
label1198
	neg [label1198,u]
label1199
	neg ,x
label1200
	neg ,u
label1201
	neg [,x]
label1202
	neg [,u]
label1203
	neg b,u
label1204
	neg [b,u]
label1205
	neg ,x+
label1206
	neg ,u+
label1207
	neg ,x++
label1208
	neg ,u++
label1209
	neg [,x++]
label1210
	neg [,u++]
label1211
	neg ,-x
label1212
	neg ,-u
label1213
	neg ,--x
label1214
	neg ,--u
label1215
	neg [,--x]
label1216
	neg [,--u]
label1217
	neg 0,pc
label1218
	neg [0,pc]
label1219
	neg label1219,pcr
label1220
	neg [label1220,pcr]
label1221
	neg [label1221]
label1222
	ora #$ff
label1223
	ora <$ff
label1224
	ora >$ff
label1225
	ora $ffff
label1226
	ora label1226,x
label1227
	ora label1227,u
label1228
	ora [label1228,x]
label1229
	ora [label1229,u]
label1230
	ora ,x
label1231
	ora ,u
label1232
	ora [,x]
label1233
	ora [,u]
label1234
	ora b,u
label1235
	ora [b,u]
label1236
	ora ,x+
label1237
	ora ,u+
label1238
	ora ,x++
label1239
	ora ,u++
label1240
	ora [,x++]
label1241
	ora [,u++]
label1242
	ora ,-x
label1243
	ora ,-u
label1244
	ora ,--x
label1245
	ora ,--u
label1246
	ora [,--x]
label1247
	ora [,--u]
label1248
	ora 0,pc
label1249
	ora [0,pc]
label1250
	ora label1250,pcr
label1251
	ora [label1251,pcr]
label1252
	ora [label1252]
label1253
	orb #$ff
label1254
	orb <$ff
label1255
	orb >$ff
label1256
	orb $ffff
label1257
	orb label1257,x
label1258
	orb label1258,u
label1259
	orb [label1259,x]
label1260
	orb [label1260,u]
label1261
	orb ,x
label1262
	orb ,u
label1263
	orb [,x]
label1264
	orb [,u]
label1265
	orb b,u
label1266
	orb [b,u]
label1267
	orb ,x+
label1268
	orb ,u+
label1269
	orb ,x++
label1270
	orb ,u++
label1271
	orb [,x++]
label1272
	orb [,u++]
label1273
	orb ,-x
label1274
	orb ,-u
label1275
	orb ,--x
label1276
	orb ,--u
label1277
	orb [,--x]
label1278
	orb [,--u]
label1279
	orb 0,pc
label1280
	orb [0,pc]
label1281
	orb label1281,pcr
label1282
	orb [label1282,pcr]
label1283
	orb [label1283]
label1284
	orcc #$ff
label1285
	pshs cc,dp,x,u
label1286
	pshs x
label1287
	pshs #4
label1288
	pshu cc,dp,x,s
label1289
	pshu x
label1290
	pshu #4
label1291
	puls cc,dp,x,u
label1292
	puls x
label1293
	puls #4
label1294
	pulu cc,dp,x,s
label1295
	pulu x
label1296
	pulu #4
label1297
	rol <$ff
label1298
	rol >$ff
label1299
	rol $ffff
label1300
	rol label1300,x
label1301
	rol label1301,u
label1302
	rol [label1302,x]
label1303
	rol [label1303,u]
label1304
	rol ,x
label1305
	rol ,u
label1306
	rol [,x]
label1307
	rol [,u]
label1308
	rol b,u
label1309
	rol [b,u]
label1310
	rol ,x+
label1311
	rol ,u+
label1312
	rol ,x++
label1313
	rol ,u++
label1314
	rol [,x++]
label1315
	rol [,u++]
label1316
	rol ,-x
label1317
	rol ,-u
label1318
	rol ,--x
label1319
	rol ,--u
label1320
	rol [,--x]
label1321
	rol [,--u]
label1322
	rol 0,pc
label1323
	rol [0,pc]
label1324
	rol label1324,pcr
label1325
	rol [label1325,pcr]
label1326
	rol [label1326]
label1327
	ror <$ff
label1328
	ror >$ff
label1329
	ror $ffff
label1330
	ror label1330,x
label1331
	ror label1331,u
label1332
	ror [label1332,x]
label1333
	ror [label1333,u]
label1334
	ror ,x
label1335
	ror ,u
label1336
	ror [,x]
label1337
	ror [,u]
label1338
	ror b,u
label1339
	ror [b,u]
label1340
	ror ,x+
label1341
	ror ,u+
label1342
	ror ,x++
label1343
	ror ,u++
label1344
	ror [,x++]
label1345
	ror [,u++]
label1346
	ror ,-x
label1347
	ror ,-u
label1348
	ror ,--x
label1349
	ror ,--u
label1350
	ror [,--x]
label1351
	ror [,--u]
label1352
	ror 0,pc
label1353
	ror [0,pc]
label1354
	ror label1354,pcr
label1355
	ror [label1355,pcr]
label1356
	ror [label1356]
label1357
	sbca #$ff
label1358
	sbca <$ff
label1359
	sbca >$ff
label1360
	sbca $ffff
label1361
	sbca label1361,x
label1362
	sbca label1362,u
label1363
	sbca [label1363,x]
label1364
	sbca [label1364,u]
label1365
	sbca ,x
label1366
	sbca ,u
label1367
	sbca [,x]
label1368
	sbca [,u]
label1369
	sbca b,u
label1370
	sbca [b,u]
label1371
	sbca ,x+
label1372
	sbca ,u+
label1373
	sbca ,x++
label1374
	sbca ,u++
label1375
	sbca [,x++]
label1376
	sbca [,u++]
label1377
	sbca ,-x
label1378
	sbca ,-u
label1379
	sbca ,--x
label1380
	sbca ,--u
label1381
	sbca [,--x]
label1382
	sbca [,--u]
label1383
	sbca 0,pc
label1384
	sbca [0,pc]
label1385
	sbca label1385,pcr
label1386
	sbca [label1386,pcr]
label1387
	sbca [label1387]
label1388
	sbcb #$ff
label1389
	sbcb <$ff
label1390
	sbcb >$ff
label1391
	sbcb $ffff
label1392
	sbcb label1392,x
label1393
	sbcb label1393,u
label1394
	sbcb [label1394,x]
label1395
	sbcb [label1395,u]
label1396
	sbcb ,x
label1397
	sbcb ,u
label1398
	sbcb [,x]
label1399
	sbcb [,u]
label1400
	sbcb b,u
label1401
	sbcb [b,u]
label1402
	sbcb ,x+
label1403
	sbcb ,u+
label1404
	sbcb ,x++
label1405
	sbcb ,u++
label1406
	sbcb [,x++]
label1407
	sbcb [,u++]
label1408
	sbcb ,-x
label1409
	sbcb ,-u
label1410
	sbcb ,--x
label1411
	sbcb ,--u
label1412
	sbcb [,--x]
label1413
	sbcb [,--u]
label1414
	sbcb 0,pc
label1415
	sbcb [0,pc]
label1416
	sbcb label1416,pcr
label1417
	sbcb [label1417,pcr]
label1418
	sbcb [label1418]
label1419
	sta <$ff
label1420
	sta >$ff
label1421
	sta $ffff
label1422
	sta label1422,x
label1423
	sta label1423,u
label1424
	sta [label1424,x]
label1425
	sta [label1425,u]
label1426
	sta ,x
label1427
	sta ,u
label1428
	sta [,x]
label1429
	sta [,u]
label1430
	sta b,u
label1431
	sta [b,u]
label1432
	sta ,x+
label1433
	sta ,u+
label1434
	sta ,x++
label1435
	sta ,u++
label1436
	sta [,x++]
label1437
	sta [,u++]
label1438
	sta ,-x
label1439
	sta ,-u
label1440
	sta ,--x
label1441
	sta ,--u
label1442
	sta [,--x]
label1443
	sta [,--u]
label1444
	sta 0,pc
label1445
	sta [0,pc]
label1446
	sta label1446,pcr
label1447
	sta [label1447,pcr]
label1448
	sta [label1448]
label1449
	stb <$ff
label1450
	stb >$ff
label1451
	stb $ffff
label1452
	stb label1452,x
label1453
	stb label1453,u
label1454
	stb [label1454,x]
label1455
	stb [label1455,u]
label1456
	stb ,x
label1457
	stb ,u
label1458
	stb [,x]
label1459
	stb [,u]
label1460
	stb b,u
label1461
	stb [b,u]
label1462
	stb ,x+
label1463
	stb ,u+
label1464
	stb ,x++
label1465
	stb ,u++
label1466
	stb [,x++]
label1467
	stb [,u++]
label1468
	stb ,-x
label1469
	stb ,-u
label1470
	stb ,--x
label1471
	stb ,--u
label1472
	stb [,--x]
label1473
	stb [,--u]
label1474
	stb 0,pc
label1475
	stb [0,pc]
label1476
	stb label1476,pcr
label1477
	stb [label1477,pcr]
label1478
	stb [label1478]
label1479
	std <$ff
label1480
	std >$ff
label1481
	std $ffff
label1482
	std label1482,x
label1483
	std label1483,u
label1484
	std [label1484,x]
label1485
	std [label1485,u]
label1486
	std ,x
label1487
	std ,u
label1488
	std [,x]
label1489
	std [,u]
label1490
	std b,u
label1491
	std [b,u]
label1492
	std ,x+
label1493
	std ,u+
label1494
	std ,x++
label1495
	std ,u++
label1496
	std [,x++]
label1497
	std [,u++]
label1498
	std ,-x
label1499
	std ,-u
label1500
	std ,--x
label1501
	std ,--u
label1502
	std [,--x]
label1503
	std [,--u]
label1504
	std 0,pc
label1505
	std [0,pc]
label1506
	std label1506,pcr
label1507
	std [label1507,pcr]
label1508
	std [label1508]
label1509
	sts <$ff
label1510
	sts >$ff
label1511
	sts $ffff
label1512
	sts label1512,x
label1513
	sts label1513,u
label1514
	sts [label1514,x]
label1515
	sts [label1515,u]
label1516
	sts ,x
label1517
	sts ,u
label1518
	sts [,x]
label1519
	sts [,u]
label1520
	sts b,u
label1521
	sts [b,u]
label1522
	sts ,x+
label1523
	sts ,u+
label1524
	sts ,x++
label1525
	sts ,u++
label1526
	sts [,x++]
label1527
	sts [,u++]
label1528
	sts ,-x
label1529
	sts ,-u
label1530
	sts ,--x
label1531
	sts ,--u
label1532
	sts [,--x]
label1533
	sts [,--u]
label1534
	sts 0,pc
label1535
	sts [0,pc]
label1536
	sts label1536,pcr
label1537
	sts [label1537,pcr]
label1538
	sts [label1538]
label1539
	stu <$ff
label1540
	stu >$ff
label1541
	stu $ffff
label1542
	stu label1542,x
label1543
	stu label1543,u
label1544
	stu [label1544,x]
label1545
	stu [label1545,u]
label1546
	stu ,x
label1547
	stu ,u
label1548
	stu [,x]
label1549
	stu [,u]
label1550
	stu b,u
label1551
	stu [b,u]
label1552
	stu ,x+
label1553
	stu ,u+
label1554
	stu ,x++
label1555
	stu ,u++
label1556
	stu [,x++]
label1557
	stu [,u++]
label1558
	stu ,-x
label1559
	stu ,-u
label1560
	stu ,--x
label1561
	stu ,--u
label1562
	stu [,--x]
label1563
	stu [,--u]
label1564
	stu 0,pc
label1565
	stu [0,pc]
label1566
	stu label1566,pcr
label1567
	stu [label1567,pcr]
label1568
	stu [label1568]
label1569
	stx <$ff
label1570
	stx >$ff
label1571
	stx $ffff
label1572
	stx label1572,x
label1573
	stx label1573,u
label1574
	stx [label1574,x]
label1575
	stx [label1575,u]
label1576
	stx ,x
label1577
	stx ,u
label1578
	stx [,x]
label1579
	stx [,u]
label1580
	stx b,u
label1581
	stx [b,u]
label1582
	stx ,x+
label1583
	stx ,u+
label1584
	stx ,x++
label1585
	stx ,u++
label1586
	stx [,x++]
label1587
	stx [,u++]
label1588
	stx ,-x
label1589
	stx ,-u
label1590
	stx ,--x
label1591
	stx ,--u
label1592
	stx [,--x]
label1593
	stx [,--u]
label1594
	stx 0,pc
label1595
	stx [0,pc]
label1596
	stx label1596,pcr
label1597
	stx [label1597,pcr]
label1598
	stx [label1598]
label1599
	sty <$ff
label1600
	sty >$ff
label1601
	sty $ffff
label1602
	sty label1602,x
label1603
	sty label1603,u
label1604
	sty [label1604,x]
label1605
	sty [label1605,u]
label1606
	sty ,x
label1607
	sty ,u
label1608
	sty [,x]
label1609
	sty [,u]
label1610
	sty b,u
label1611
	sty [b,u]
label1612
	sty ,x+
label1613
	sty ,u+
label1614
	sty ,x++
label1615
	sty ,u++
label1616
	sty [,x++]
label1617
	sty [,u++]
label1618
	sty ,-x
label1619
	sty ,-u
label1620
	sty ,--x
label1621
	sty ,--u
label1622
	sty [,--x]
label1623
	sty [,--u]
label1624
	sty 0,pc
label1625
	sty [0,pc]
label1626
	sty label1626,pcr
label1627
	sty [label1627,pcr]
label1628
	sty [label1628]
label1629
	suba #$ff
label1630
	suba <$ff
label1631
	suba >$ff
label1632
	suba $ffff
label1633
	suba label1633,x
label1634
	suba label1634,u
label1635
	suba [label1635,x]
label1636
	suba [label1636,u]
label1637
	suba ,x
label1638
	suba ,u
label1639
	suba [,x]
label1640
	suba [,u]
label1641
	suba b,u
label1642
	suba [b,u]
label1643
	suba ,x+
label1644
	suba ,u+
label1645
	suba ,x++
label1646
	suba ,u++
label1647
	suba [,x++]
label1648
	suba [,u++]
label1649
	suba ,-x
label1650
	suba ,-u
label1651
	suba ,--x
label1652
	suba ,--u
label1653
	suba [,--x]
label1654
	suba [,--u]
label1655
	suba 0,pc
label1656
	suba [0,pc]
label1657
	suba label1657,pcr
label1658
	suba [label1658,pcr]
label1659
	suba [label1659]
label1660
	subb #$ff
label1661
	subb <$ff
label1662
	subb >$ff
label1663
	subb $ffff
label1664
	subb label1664,x
label1665
	subb label1665,u
label1666
	subb [label1666,x]
label1667
	subb [label1667,u]
label1668
	subb ,x
label1669
	subb ,u
label1670
	subb [,x]
label1671
	subb [,u]
label1672
	subb b,u
label1673
	subb [b,u]
label1674
	subb ,x+
label1675
	subb ,u+
label1676
	subb ,x++
label1677
	subb ,u++
label1678
	subb [,x++]
label1679
	subb [,u++]
label1680
	subb ,-x
label1681
	subb ,-u
label1682
	subb ,--x
label1683
	subb ,--u
label1684
	subb [,--x]
label1685
	subb [,--u]
label1686
	subb 0,pc
label1687
	subb [0,pc]
label1688
	subb label1688,pcr
label1689
	subb [label1689,pcr]
label1690
	subb [label1690]
label1691
	subd #$ff
label1692
	subd <$ff
label1693
	subd >$ff
label1694
	subd $ffff
label1695
	subd label1695,x
label1696
	subd label1696,u
label1697
	subd [label1697,x]
label1698
	subd [label1698,u]
label1699
	subd ,x
label1700
	subd ,u
label1701
	subd [,x]
label1702
	subd [,u]
label1703
	subd b,u
label1704
	subd [b,u]
label1705
	subd ,x+
label1706
	subd ,u+
label1707
	subd ,x++
label1708
	subd ,u++
label1709
	subd [,x++]
label1710
	subd [,u++]
label1711
	subd ,-x
label1712
	subd ,-u
label1713
	subd ,--x
label1714
	subd ,--u
label1715
	subd [,--x]
label1716
	subd [,--u]
label1717
	subd 0,pc
label1718
	subd [0,pc]
label1719
	subd label1719,pcr
label1720
	subd [label1720,pcr]
label1721
	subd [label1721]
label1722
	tfr x,y
label1723
	tfr a,b
label1724
	tst <$ff
label1725
	tst >$ff
label1726
	tst $ffff
label1727
	tst label1727,x
label1728
	tst label1728,u
label1729
	tst [label1729,x]
label1730
	tst [label1730,u]
label1731
	tst ,x
label1732
	tst ,u
label1733
	tst [,x]
label1734
	tst [,u]
label1735
	tst b,u
label1736
	tst [b,u]
label1737
	tst ,x+
label1738
	tst ,u+
label1739
	tst ,x++
label1740
	tst ,u++
label1741
	tst [,x++]
label1742
	tst [,u++]
label1743
	tst ,-x
label1744
	tst ,-u
label1745
	tst ,--x
label1746
	tst ,--u
label1747
	tst [,--x]
label1748
	tst [,--u]
label1749
	tst 0,pc
label1750
	tst [0,pc]
label1751
	tst label1751,pcr
label1752
	tst [label1752,pcr]
label1753
	tst [label1753]
