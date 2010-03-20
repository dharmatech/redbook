
(import (rnrs)
        (gl)
        (glut)
        (agave glamour window)
        (agave glamour misc))

(define check-image-width  64)
(define check-image-height 64)
(define check-image-depth   3)

(define check-image
  (make-bytevector
   (* check-image-width
      check-image-height
      check-image-depth)))

(define (check-image-set! i j k val)
  (bytevector-u8-set! check-image
                      (+ (* i check-image-width check-image-depth)
                         (* j check-image-depth)
                         k)
                      val))

(define (make-check-image)
  (do ((i 0 (+ i 1)))
      ((>= i check-image-height))
    (do ((j 0 (+ j 1)))
        ((>= j check-image-width))
      (let ((c (* (bitwise-xor (if (= (bitwise-and i #x8) 0) 1 0)
                               (if (= (bitwise-and j #x8) 0) 1 0))
                  255)))
        (check-image-set! i j 0 c)
        (check-image-set! i j 1 c)
        (check-image-set! i j 2 c)))))

(define zoom-factor 1.0)

(initialize-glut)

(window (size 250 250)
        (title "image.sps")
        (reshape (width height)))

(make-check-image)
(glPixelStorei GL_UNPACK_ALIGNMENT 1)

(buffered-display-procedure
 (lambda ()
   (background 0.0)
   (glRasterPos2i 0 0)
   (glDrawPixels check-image-width
                 check-image-height
                 GL_RGB
                 GL_UNSIGNED_BYTE
                 check-image)))

(glutMotionFunc
 (let ((screen-y 0))
   (lambda (x y)
     (set! screen-y (- height y))
     (glRasterPos2i x screen-y)
     (glPixelZoom zoom-factor zoom-factor)
     (glCopyPixels 0 0 check-image-width check-image-height GL_COLOR)
     (glPixelZoom 1.0 1.0)
     (glutSwapBuffers))))

(glutKeyboardFunc
 (lambda (key x y)
   (case (integer->char key)
     ((#\r) (set! zoom-factor 1.0))
     ((#\a) (set! zoom-factor (min (+ zoom-factor 0.5) 3.0)))
     ((#\z) (set! zoom-factor (max (- zoom-factor 0.5) 0.5)))
     ((#\q) (exit 0)))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutMainLoop)

