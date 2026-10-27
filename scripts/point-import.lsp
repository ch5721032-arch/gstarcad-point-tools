;; point-import.lsp - Insert points from a CSV file (X,Y,Z with a header row)
;; Command: PIMPORT
(defun gsc-split-csv ( s / pos out )
  (setq out nil)
  (while (setq pos (vl-string-position (ascii ",") s))
    (setq out (cons (substr s 1 pos) out))
    (setq s (substr s (+ pos 2)))
  )
  (reverse (cons s out))
)

(defun c:PIMPORT ( / file f line parts n )
  (setq file (getfiled "Select point CSV" "" "csv" 0))
  (if file
    (progn
      (setq f (open file "r") n 0)
      (if f
        (progn
          (read-line f)
          (while (setq line (read-line f))
            (setq parts (gsc-split-csv line))
            (if (>= (length parts) 2)
              (progn
                (command "_.POINT"
                         (list (atof (nth 0 parts))
                               (atof (nth 1 parts))
                               (if (nth 2 parts) (atof (nth 2 parts)) 0.0)))
                (setq n (1+ n))
              )
            )
          )
          (close f)
          (princ (strcat "\nPoints inserted: " (itoa n)))
        )
        (princ "\nCould not open file.")
      )
    )
  )
  (princ)
)
