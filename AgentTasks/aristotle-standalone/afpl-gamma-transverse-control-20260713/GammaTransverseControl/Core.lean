import Mathlib

/-!
# Gamma-coupled transverse control

This finite control replaces a commuting transverse-plus-tangential sum by an
anticommuting Clifford coupling.  The intended result is an exact square and a
full complement gap, followed by an honest chirality audit: the kernel sector
is expected to carry a paired four-component massless Dirac symbol rather than
one isolated Weyl species.
-/

namespace GammaTransverseControl

open Matrix

noncomputable section

abbrev TSite := Fin 3
abbrev Qubit := Fin 2
abbrev Spin4 := Qubit × Qubit

def M : Matrix TSite TSite Complex := !![0, 1, 0; 1, 0, 2; 0, 2, 0]
def w : TSite -> Complex := ![2, 0, -1]

def sx : Matrix Qubit Qubit Complex := !![0, 1; 1, 0]
def sy : Matrix Qubit Qubit Complex := !![0, -Complex.I; Complex.I, 0]
def sz : Matrix Qubit Qubit Complex := !![1, 0; 0, -1]

def gamma1 : Matrix Spin4 Spin4 Complex := kroneckerMap (fun a b => a * b) sx sx
def gamma2 : Matrix Spin4 Spin4 Complex := kroneckerMap (fun a b => a * b) sx sy
def gamma3 : Matrix Spin4 Spin4 Complex := kroneckerMap (fun a b => a * b) sx sz
def gamma4 : Matrix Spin4 Spin4 Complex :=
  kroneckerMap (fun a b => a * b) sz (1 : Matrix Qubit Qubit Complex)

def tangent (kx ky kz : Real) : Matrix Spin4 Spin4 Complex :=
  (kx : Complex) • gamma1 + (ky : Complex) • gamma2 + (kz : Complex) • gamma3

def H (kx ky kz : Real) :
    Matrix (TSite × Spin4) (TSite × Spin4) Complex :=
  kroneckerMap (fun a b => a * b) M gamma4 +
    kroneckerMap (fun a b => a * b) (1 : Matrix TSite TSite Complex)
      (tangent kx ky kz)

def embed (e : Spin4 -> Complex) : TSite × Spin4 -> Complex :=
  fun p => w p.1 * e p.2

theorem M_mulVec_w : M *ᵥ w = 0 := by
  sorry

theorem gamma_sq (a : Fin 4) :
    ![gamma1, gamma2, gamma3, gamma4] a * ![gamma1, gamma2, gamma3, gamma4] a = 1 := by
  sorry

theorem gamma_anticommute (a b : Fin 4) (hab : a != b) :
    ![gamma1, gamma2, gamma3, gamma4] a * ![gamma1, gamma2, gamma3, gamma4] b +
      ![gamma1, gamma2, gamma3, gamma4] b * ![gamma1, gamma2, gamma3, gamma4] a = 0 := by
  sorry

/-- Exact Clifford square: transverse and tangential cross terms vanish. -/
theorem H_sq (kx ky kz : Real) :
    H kx ky kz * H kx ky kz =
      kroneckerMap (fun a b => a * b) (M * M)
        (1 : Matrix Spin4 Spin4 Complex) +
      ((kx ^ 2 + ky ^ 2 + kz ^ 2 : Real) : Complex) •
        (1 : Matrix (TSite × Spin4) (TSite × Spin4) Complex) := by
  sorry

/-- The transverse kernel sector carries the massless four-component tangent
symbol exactly. -/
theorem kernel_restriction (kx ky kz : Real) (e : Spin4 -> Complex) :
    H kx ky kz *ᵥ embed e = embed (tangent kx ky kz *ᵥ e) := by
  sorry

end


end GammaTransverseControl
