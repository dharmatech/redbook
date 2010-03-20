
(import (rnrs)
        (gl)
        (glut)
        (agave glamour window)
        (agave glamour misc))

(define rasters
  #vu8(#xc0 #x00 #xc0 #x00 #xc0 #x00 #xc0 #x00 #xc0 #x00
       #xff #x00 #xff #x00 #xc0 #x00 #xc0 #x00 #xc0 #x00
       #xff #xc0 #xff #xc0))

(initialize-glut)

(window (size 100 100)
        (title "drawf.sps")
        (reshape (width height)))

(glPixelStorei GL_UNPACK_ALIGNMENT 1)

(buffered-display-procedure
 (lambda ()
   (background 0.0)
   (glColor3d 1.0 1.0 1.0)
   (glRasterPos2i 20 20)
   (glBitmap 10 12 0.0 0.0 11.0 0.0 rasters)
   (glBitmap 10 12 0.0 0.0 11.0 0.0 rasters)
   (glBitmap 10 12 0.0 0.0 11.0 0.0 rasters)))

(glutMainLoop)