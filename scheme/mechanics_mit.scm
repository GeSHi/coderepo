#| -*-Scheme-*-

$Id: copyright.scm,v 1.5 2005/09/25 01:28:17 cph Exp $

Copyright 2005 Massachusetts Institute of Technology

This file is part of MIT/GNU Scheme.

MIT/GNU Scheme is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

MIT/GNU Scheme is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with MIT/GNU Scheme; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301,
USA.

|#


(define ((adjoint s) DCs)
  (define ((adjoint-function DC) DH) (* DH DC))
  ((D (adjoint-function DCs)) (compatible-shape s)))

#|
(define (T v)
  (* (down (up 'a 'c) (up 'b 'd)) v))

(pe (T (up 'x 'y)))
(up (+ (* a x) (* b y)) (+ (* c x) (* d y)))

(pe (* (* (down 'p_x 'p_y) ((D T) (up 'x 'y))) (up 'v_x 'v_y)))
(+ (* a p_x v_x) (* b p_x v_y) (* c p_y v_x) (* d p_y v_y))


(pe (* (down 'p_x 'p_y) (* ((D T) (up 'x 'y)) (up 'v_x 'v_y))))
(+ (* a p_x v_x) (* b p_x v_y) (* c p_y v_x) (* d p_y v_y))

(pe (* (* ((adjoint (up 'x 'y)) ((D T) (up 'x 'y)))
	  (down 'p_x 'p_y))
       (up 'v_x 'v_y)))
(+ (* a p_x v_x) (* b p_x v_y) (* c p_y v_x) (* d p_y v_y))

;;; But strangely enough...
(pe (* (* (down 'p_x 'p_y)
	  ((adjoint (up 'x 'y)) ((D T) (up 'x 'y))))
       (up 'v_x 'v_y)))
(+ (* a p_x v_x) (* b p_x v_y) (* c p_y v_x) (* d p_y v_y))
|#

(define ((time-independent-c? C) s)
  (let ((J ((D J-func) (compatible-shape s))))
    (- J
       (* ((D C) s)
          (* J
             ((adjoint s) ((D C) s)))))))


(define ((adjoint shapeDH) DCs)
  (define ((adjoint-function DC) DH) (* DH DC))
  ((D (adjoint-function DCs)) shapeDH))

(define ((time-independent-c? C) s)
  (let ((J ((D J-func) (compatible-shape s))))
    (- J
       (* ((D C) s)
          (* J
             ((adjoint (compatible-shape s)) ((D C) s)))))))

#|
(pe (* (* ((adjoint (compatible-shape (up 'x 'y)))
	   ((D T) (up 'x 'y)))
	  (down 'p_x 'p_y))
       (up 'v_x 'v_y)))
|#

