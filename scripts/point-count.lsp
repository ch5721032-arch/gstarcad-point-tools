;; point-count.lsp - Count every point in the drawing
;; Command: PCOUNT
(defun c:PCOUNT ( / ss )
  (setq ss (ssget "_X" '((0 . "POINT"))))
  (if ss
    (princ (strcat "\nPoints in drawing: " (itoa (sslength ss))))
    (princ "\nNo points found.")
  )
  (princ)
)
