
(import (rnrs)
        (gl)
        (glut)
        (agave glamour window)
        (agave glamour misc))

(initialize-glut)

(window (size 250 250)
        (title "Hello")
        (reshape (width height)
                 (lambda (w h)
                   (glLoadIdentity)
                   (glOrtho 0.0 1.0 0.0 1.0 -1.0 1.0))))

(buffered-display-procedure
 (lambda ()
   (background 0.0)
   (glColor3d 1.0 1.0 1.0)
   (gl-begin GL_POLYGON
     (glVertex3d 0.25 0.25 0.0)
     (glVertex3d 0.75 0.25 0.0)
     (glVertex3d 0.75 0.75 0.0)
     (glVertex3d 0.25 0.75 0.0))))

(glutMainLoop)