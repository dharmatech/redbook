
(import (rnrs)
        (gl)
        (glut)
        (agave glu)
        (agave glamour window)
        (agave glamour misc))

(initialize-glut)

(window (size 500 500)
        (title "Cube")
        (reshape (width height)
          (lambda (w h)
            (glLoadIdentity)
            (glFrustum -1.0 1.0 -1.0 1.0 1.5 20.0))))

(buffered-display-procedure
 (lambda ()
   (background 0.0)
   (gluLookAt 0.0 0.0 5.0 0.0 0.0 0.0 0.0 1.0 0.0)
   (glScaled 1.0 2.0 1.0)
   (glColor3d 1.0 1.0 1.0)
   (glutWireCube 1.0)))

(glutMainLoop)
