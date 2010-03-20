
(import (rnrs)
        (gl)
        (glut)
        (dharmalab indexable-sequence f32-vector)
        (agave glamour window)
        (agave glamour misc))

(initialize-glut)

(window (size 500 500)
        (title "light.sps")
        (reshape (width height)
          (lambda (w h)
            (glLoadIdentity)
            (if (> h w)
              (glOrtho -1.5 1.5 (* -1.5 (/ h w)) (* 1.5 (/ h w)) -10.0 10.0)
              (glOrtho -1.5 1.5 (* -1.5 (/ w h)) (* 1.5 (/ w h)) -10.0 10.0))
            )))

(define mat-specular (f32-vector 1.0 1.0 1.0 1.0))
(define mat-shininess (f32-vector 50.0))
(define light-position (f32-vector 1.0 1.0 1.0 0.0))

(glShadeModel GL_SMOOTH)

(glMaterialfv GL_FRONT GL_SPECULAR  mat-specular)
(glMaterialfv GL_FRONT GL_SHININESS mat-shininess)

(glLightfv GL_LIGHT0 GL_POSITION light-position)

(glEnable GL_LIGHTING)
(glEnable GL_LIGHT0)
(glEnable GL_DEPTH_TEST)

(buffered-display-procedure
 (lambda ()
   (background 0.0)
   (glClear GL_DEPTH_BUFFER_BIT)
   (glutSolidSphere 1.0 20 16)))

(glutMainLoop)