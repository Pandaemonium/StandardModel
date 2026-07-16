import Mathlib

/-!
# Standard Model charge moments versus oriented boundary-channel counts

This standalone seed records the project hypercharge convention.  The
Aristotle task asks for an exact ledger distinguishing anomaly coefficients
from the unweighted boundary transport count.
-/

namespace AnomalyIndexLedger

abbrev Charge := Rat

def yQ : Charge := 1 / 3
def yL : Charge := -1
def yU : Charge := -4 / 3
def yD : Charge := 2 / 3
def yE : Charge := 2

theorem gravitational_moment :
    6 * yQ + 2 * yL + 3 * yU + 3 * yD + yE = 0 := by
  norm_num [yQ, yL, yU, yD, yE]

theorem cubic_moment :
    6 * yQ ^ 3 + 2 * yL ^ 3 + 3 * yU ^ 3 + 3 * yD ^ 3 + yE ^ 3 = 0 := by
  norm_num [yQ, yL, yU, yD, yE]

end AnomalyIndexLedger
