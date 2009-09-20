; code by Jess Johnson (http://grok-code.com)

; calculate the sum of all integers divisible by 3 or 5 between 1 and limit
(defn e1 [limit]
  (reduce + (filter #(or (zero? (mod % 3))
						 (zero? (mod % 5)))
					(range 1 (- limit 1)))))

(e1 1000)


; calculate the sum of even members of the Fibonacci sequence between 1 and limit
(def fibs (lazy-cat [0 1]
                    (map + fibs (rest fibs))))

(defn e2 [limit]
  (filter #(and (< % limit)
				(zero? (mod % 2)))
		  fibs))

(e2 4000000)


; calculate the greatest prime factor of num
(defn factor [num cur]
  (if (= num cur)
	num
	(if (zero? (mod num cur))
	  (factor (/ num cur) cur)
	  (factor num (inc cur)))))

(factor 600851475143 2)










