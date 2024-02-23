pushpc

org $8683B5
JSL MaybeDoCachedSprites  ; JSL ExecuteCachedSprites

org $9DE9DA
ExecuteCachedSprites:

pullpc

MaybeDoCachedSprites:
  LDA.l EnemizerFlag_Randomize_Sprites
  BNE .enemizer

  JML ExecuteCachedSprites ; what we copied over

.enemizer
  RTL