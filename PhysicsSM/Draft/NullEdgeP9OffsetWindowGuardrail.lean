import Mathlib.Tactic

/-!
# P9 offset-window guardrail

This draft module isolates a finite-algebra warning from the P9 coarse-map
pilot. A fixed block average, or even a family of shifted block averages, can
annihilate nonzero modes for purely arithmetic reasons. Such modes should not
be interpreted as physically invisible unless the coarse map is geometrically
or observationally forced.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail

/-- Eight fine cells on a toy cyclic readout. -/
structure Vec8 where
  x0 : Real
  x1 : Real
  x2 : Real
  x3 : Real
  x4 : Real
  x5 : Real
  x6 : Real
  x7 : Real

/-- Four-cell window sum at offset `0`. -/
def w0 (x : Vec8) : Real := x.x0 + x.x1 + x.x2 + x.x3

/-- Four-cell window sum at offset `1`. -/
def w1 (x : Vec8) : Real := x.x1 + x.x2 + x.x3 + x.x4

/-- Four-cell window sum at offset `2`. -/
def w2 (x : Vec8) : Real := x.x2 + x.x3 + x.x4 + x.x5

/-- Four-cell window sum at offset `3`. -/
def w3 (x : Vec8) : Real := x.x3 + x.x4 + x.x5 + x.x6

/-- Four-cell window sum at offset `4`. -/
def w4 (x : Vec8) : Real := x.x4 + x.x5 + x.x6 + x.x7

/-- Four-cell window sum at offset `5`, cyclically wrapped. -/
def w5 (x : Vec8) : Real := x.x5 + x.x6 + x.x7 + x.x0

/-- Four-cell window sum at offset `6`, cyclically wrapped. -/
def w6 (x : Vec8) : Real := x.x6 + x.x7 + x.x0 + x.x1

/-- Four-cell window sum at offset `7`, cyclically wrapped. -/
def w7 (x : Vec8) : Real := x.x7 + x.x0 + x.x1 + x.x2

/-- Block-average trace at offset `0`, using the `1 / sqrt(4)` normalization. -/
def trace0 (x : Vec8) : Real := (w0 x / 2) ^ 2

/-- Block-average trace at offset `1`, using the `1 / sqrt(4)` normalization. -/
def trace1 (x : Vec8) : Real := (w1 x / 2) ^ 2

/-- Block-average trace at offset `2`, using the `1 / sqrt(4)` normalization. -/
def trace2 (x : Vec8) : Real := (w2 x / 2) ^ 2

/-- Block-average trace at offset `3`, using the `1 / sqrt(4)` normalization. -/
def trace3 (x : Vec8) : Real := (w3 x / 2) ^ 2

/-- Block-average trace at offset `4`, using the `1 / sqrt(4)` normalization. -/
def trace4 (x : Vec8) : Real := (w4 x / 2) ^ 2

/-- Block-average trace at offset `5`, using the `1 / sqrt(4)` normalization. -/
def trace5 (x : Vec8) : Real := (w5 x / 2) ^ 2

/-- Block-average trace at offset `6`, using the `1 / sqrt(4)` normalization. -/
def trace6 (x : Vec8) : Real := (w6 x / 2) ^ 2

/-- Block-average trace at offset `7`, using the `1 / sqrt(4)` normalization. -/
def trace7 (x : Vec8) : Real := (w7 x / 2) ^ 2

/-- A single aligned zero window need not be offset-invariant. -/
theorem single_window_zero_not_offset_invariant :
    Exists fun x : Vec8 => w0 x = 0 /\ Not (w1 x = 0) := by
  refine Exists.intro (Vec8.mk 1 (-1) 1 (-1) 0 0 0 0) ?_
  constructor
  case left =>
    norm_num [w0]
  case right =>
    norm_num [w1]

/--
There are nonzero modes annihilated by every four-cell cyclic block average.
This shows that even an all-offset sweep can miss high-frequency coarse-map
null modes unless the map is geometrically or observationally justified.
-/
theorem nonzero_mode_all_window_traces_zero :
    Exists fun x : Vec8 =>
      Not (x.x0 = 0) /\
      trace0 x = 0 /\ trace1 x = 0 /\ trace2 x = 0 /\ trace3 x = 0 /\
      trace4 x = 0 /\ trace5 x = 0 /\ trace6 x = 0 /\ trace7 x = 0 := by
  refine Exists.intro (Vec8.mk 1 (-1) 1 (-1) 1 (-1) 1 (-1)) ?_
  repeat' constructor <;>
    norm_num [trace0, trace1, trace2, trace3, trace4, trace5, trace6, trace7,
      w0, w1, w2, w3, w4, w5, w6, w7]

/-- If all window sums vanish, then all corresponding window traces vanish. -/
theorem all_window_sums_zero_implies_all_traces_zero
    (x : Vec8)
    (h0 : w0 x = 0) (h1 : w1 x = 0) (h2 : w2 x = 0) (h3 : w3 x = 0)
    (h4 : w4 x = 0) (h5 : w5 x = 0) (h6 : w6 x = 0) (h7 : w7 x = 0) :
    trace0 x = 0 /\ trace1 x = 0 /\ trace2 x = 0 /\ trace3 x = 0 /\
    trace4 x = 0 /\ trace5 x = 0 /\ trace6 x = 0 /\ trace7 x = 0 := by
  repeat' constructor <;>
    simp [trace0, trace1, trace2, trace3, trace4, trace5, trace6, trace7,
      h0, h1, h2, h3, h4, h5, h6, h7]

end PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail

end
