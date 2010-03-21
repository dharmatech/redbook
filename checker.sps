
(import (rnrs)
        (gl)
        (glut)
        (agave glu compat)
        (agave glamour window)
        (agave glamour misc))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define check-image-width  64)
(define check-image-height 64)
(define check-image-depth   4)

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
  (do ((i 0 (+ i 1))) ((>= i check-image-height))
    (do ((j 0 (+ j 1))) ((>= j check-image-width))
      (let ((c (* (bitwise-xor (if (= (bitwise-and i #x8) 0) 1 0)
                               (if (= (bitwise-and j #x8) 0) 1 0))
                  255)))
        (check-image-set! i j 0 c)
        (check-image-set! i j 1 c)
        (check-image-set! i j 2 c)
        (check-image-set! i j 3 255)))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(initialize-glut)

(window (size 250 250)
        (title "image.sps")
        (reshape (width height)
                 (lambda (w h)
                   (glLoadIdentity)
                   (gluPerspective 60.0 (inexact (/ w h)) 1.0 30.0))))

(glShadeModel GL_FLAT)
(glEnable GL_DEPTH_TEST)

(make-check-image)

(glPixelStorei GL_UNPACK_ALIGNMENT 1)

(define tex-name (make-bytevector 4))

(glGenTextures 1 tex-name)

(glBindTexture GL_TEXTURE_2D (bytevector-u32-native-ref tex-name 0))

(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_REPEAT)
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_REPEAT)
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_NEAREST)
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_NEAREST)
(glTexImage2D GL_TEXTURE_2D
              0
              GL_RGBA
              check-image-width
              check-image-height
              0
              GL_RGBA
              GL_UNSIGNED_BYTE
              check-image)

(buffered-display-procedure
 (lambda ()
   (glTranslatef 0.0 0.0 -3.6)
   (background 0.0)
   (glClear GL_DEPTH_BUFFER_BIT)

   (glEnable GL_TEXTURE_2D)
   ;; (glTexEnvf GL_TEXTURE_ENV GL_TEXTURE_ENV_MODE GL_DECAL)
   (glTexEnvi GL_TEXTURE_ENV GL_TEXTURE_ENV_MODE GL_DECAL)

   (glBindTexture GL_TEXTURE_2D (bytevector-u32-native-ref tex-name 0))

   (gl-begin GL_QUADS

     (glTexCoord2f 0.0 0.0) (glVertex3f -2.0 -1.0 0.0)
     (glTexCoord2f 0.0 1.0) (glVertex3f -2.0  1.0 0.0)
     (glTexCoord2f 1.0 1.0) (glVertex3f  0.0  1.0 0.0)
     (glTexCoord2f 1.0 0.0) (glVertex3f  0.0 -1.0 0.0)

     (glTexCoord2f 0.0 0.0) (glVertex3f 1.0     -1.0  0.0)
     (glTexCoord2f 0.0 1.0) (glVertex3f 1.0      1.0  0.0)
     (glTexCoord2f 1.0 1.0) (glVertex3f 2.41421  1.0 -1.41421)
     (glTexCoord2f 1.0 0.0) (glVertex3f 2.41421 -1.0 -1.41421))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutMainLoop)

