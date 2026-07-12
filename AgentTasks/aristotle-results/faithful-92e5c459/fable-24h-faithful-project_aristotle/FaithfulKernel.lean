import Mathlib

/-!
# Kernel-only re-proof of `faithful` (`Bz * Kz = 5 • Vz`)

This file re-proves the single 28×28 GaussianInt matrix product identity
`faithful` from `context/PairSpectrumFixture.lean` using only kernel-checked
tactics (no `native_decide` / `Lean.ofReduceBool`).  The matrices `Bz`, `Kz`,
`Vz` and the `5 •` scaling are copied verbatim from the fixture.
-/

noncomputable section

namespace FaithfulKernel

/-- Gaussian-integer constructor helper `g a b = a + b·i`. -/
def g (a b : ℤ) : GaussianInt := ⟨a, b⟩

/-- `C5 = 5 · coin`: the per-site `3-4-5` coin cleared of its denominator. -/
def C5 : Matrix (Fin 8) (Fin 8) GaussianInt := !![g 4 0,g 0 (-3),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 (-3),g 4 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 4 0,g 0 (-3),g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 (-3),g 4 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 4 0,g 0 (-3),g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-3),g 4 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 4 0,g 0 (-3);
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-3),g 4 0]

/-- The ring shift `S` (moving shift: `coin 0 ↦ site+1`, `coin 1 ↦ site-1`). -/
def Sp : Matrix (Fin 8) (Fin 8) GaussianInt := !![g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 1 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 1 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 1 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0]

/-- `Az = 5 · U1 = S · (5·coin)`: the integer one-particle walk. -/
def Az : Matrix (Fin 8) (Fin 8) GaussianInt := Sp * C5

/-- First index of the antisymmetric pair enumeration `i < j` over `Fin 8`. -/
def pf : Fin 28 → Fin 8 := ![0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,3,3,3,3,4,4,4,5,5,6]

/-- Second index of the antisymmetric pair enumeration `i < j` over `Fin 8`. -/
def ps : Fin 28 → Fin 8 := ![1,2,3,4,5,6,7,2,3,4,5,6,7,3,4,5,6,7,4,5,6,7,5,6,7,6,7,7]

/-- `Bz = 25 · U2`: the `28×28` determinant-minor (Plücker) lift of `Az`. -/
def Bz : Matrix (Fin 28) (Fin 28) GaussianInt := fun i j =>
  Az (pf i) (pf j) * Az (ps i) (ps j) - Az (pf i) (ps j) * Az (ps i) (pf j)

/-- `Kz = 5 · K2`: the kick, identity except the `2×2` block coupling the
occupation pairs `(0, 1)` (index `0`) and `(2, 3)` (index `13`). -/
def Kz : Matrix (Fin 28) (Fin 28) GaussianInt := !![g 4 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-3),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 (-3),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 4 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 5 0]

/-- `Vz = 25 · V`: the explicit composed interacting step (exact integer form). -/
def Vz : Matrix (Fin 28) (Fin 28) GaussianInt := !![g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g (-16) 0,g 0 12,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 25 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 12,g 9 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 15,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-20) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 20 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-15),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 (-12),g 16 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-25) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 (-12),g 16 0,g 0 0,g 0 0,g (-9) 0,g 0 (-12),g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 16 0,g 0 (-12),g 0 0,g 0 0,g 0 (-12),g (-9) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 9 0,g 0 12,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 9 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 12,g (-16) 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0;
g 0 0,g 0 0,g 0 0,g 0 12,g 9 0,g 0 0,g 0 0,g 0 0,g 0 0,g (-16) 0,g 0 12,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0,g 0 0]

set_option maxHeartbeats 4000000 in
/-- Kernel-checked (via `decide`) re-proof of faithfulness: the literal matrix
`Vz` is exactly the determinant-minor lift composed with the kick: `Bz · Kz = 5 • Vz`
(equivalently `25·U2 · 5·K2 = 125·V`).

This is the kernel-only counterpart of `PairSpectrumFixture.faithful` (which used
`native_decide`).  The single `28×28` GaussianInt matrix product identity is
proved entrywise: `Matrix.ext` reduces to the `784` scalar goals
`(Bz * Kz) i j = 5 • Vz i j`, each discharged by `decide` (kernel-checked
`Decidable` evaluation of `GaussianInt` arithmetic — no `native_decide`, hence no
`Lean.ofReduceBool` in the axiom footprint). -/
theorem faithful : Bz * Kz = (5 : GaussianInt) • Vz := by
  refine Matrix.ext (fun i j => ?_)
  fin_cases i <;> fin_cases j <;> decide

#print axioms faithful

end FaithfulKernel
