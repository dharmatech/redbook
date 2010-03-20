
(import (rnrs)
        (gl)
        (glut)
        (agave glamour window)
        (agave glamour misc))

(initialize-glut)

(window (size 250 250)
        (title "Double")
        (reshape (width height)
                 (lambda (w h)
                   (glLoadIdentity)
                   (glOrtho -50.0 50.0 -50.0 50.0 -1.0 1.0))))

(define spin 0.0)

(define (spin-display)
  (set! spin (+ spin 0.04))
  (if (> spin 360.0)
      (set! spin (- spin 360.0)))
  (glutPostRedisplay))

(buffered-display-procedure
 (lambda ()
   (background 0.0)
   (gl-matrix-excursion
    (glRotatef spin 0.0 0.0 1.0)
    (glColor3f 1.0 1.0 1.0)
    (glRectf -25.0 -25.0 25.0 25.0))))

(glutMouseFunc

 (lambda (button state x y)

   (cond ((= button GLUT_LEFT_BUTTON)
          (glutIdleFunc spin-display))
         ((= button GLUT_MIDDLE_BUTTON)
          (glutIdleFunc (lambda () #t))))))

(glutMainLoop)