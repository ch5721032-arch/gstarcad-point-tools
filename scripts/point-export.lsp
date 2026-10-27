;; point-export.lsp - Export all points to a CSV file
;; Command: PEXPORT
(defun c:PEXPORT ( / ss i en p f file )
  (setq ss (ssget "_X" '((0 . "POINT"))))
  (if ss
    (progn
      (setq file (getfiled "Save point list as CSV" "points" "csv" 1))
      (if file
        (progn
          (setq f (open file "w"))
          (write-line "X,Y,Z" f)
          (setq i 0)
          (repeat (sslength ss)
            (setq en (ssname ss i))
            (setq p (cdr (assoc 10 (entget en))))
            (write-line (strcat (rtos (car p) 2 6) ","
                                (rtos (cadr p) 2 6) ","
                                (rtos (caddr p) 2 6)) f)
            (setq i (1+ i))
          )
          (close f)
          (princ (strcat "\n" (itoa (sslength ss)) " points written to " file))
        )
      )
    )
    (princ "\nNo points found.")
  )
  (princ)
)
