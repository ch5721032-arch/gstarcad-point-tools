# GstarCAD Point Tools

Count every point in the drawing, export XYZ coordinates to CSV, and insert points from a CSV file.

Works with **GSTARCAD**, AutoCAD, ZWCAD, and BricsCAD.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Contents

- [About](#about)
- [Scripts Overview](#scripts-overview)
- [Quick Start](#quick-start)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## About

Survey and coordinate work lives and dies by points. These commands count every POINT in the drawing, export their X, Y and Z to a CSV file, and import a CSV of coordinates back into the drawing as new points, so data can move between CAD and spreadsheets without retyping.

Everything here is free to use with GstarCAD. Download the latest GstarCAD
release from the [official GstarCAD website](https://www.gstarcad.net). All
scripts are tested with **[GSTARCAD](https://www.gstarcad.net)** and major
DWG-based CAD platforms.

## Scripts Overview

| File | Description |
|------|-------------|
| `scripts/point-count.lsp` | ;; point-count.lsp - Count every point in the drawing
;; Command: PCOUNT
(defun c:PCOUNT ( / ss )
  (setq ss (ssget "_X" '((0 . "POINT"))))
  (if ss
    (princ (strcat "\nPoints in drawing: " (itoa (sslength ss))))
    (princ "\nNo points found.")
  )
  (princ)
)
 |
| `scripts/point-export.lsp` | ;; point-export.lsp - Export all points to a CSV file
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
 |
| `scripts/point-import.lsp` | ;; point-import.lsp - Insert points from a CSV file (X,Y,Z with a header row)
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
 |

## Quick Start

1. Download the `.lsp` (or `.lin`) file you need
2. In your CAD software, run `APPLOAD`
3. Load the file and type the matching command name shown in the table above

## Compatibility

Tested on GstarCAD 2026/2027 and similar DWG-based platforms. Scripts use
standard AutoLISP functions only, so they work without extra plugins.

For step-by-step [tutorials and drafting guides](https://www.gstarcad.net/cad/),
visit the GstarCAD learning center. New tips are published regularly on the
[GSTARCAD Blog](https://blog.gstarcad.net).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see the [LICENSE](LICENSE) file.
