/-
# Certify the T2 carrier: the hand-typed HAC/Jmet ARE the Cl(4) Kronecker assembly

Proof job (Aristotle). Mathlib-only. This closes an audit gap (2026-07-08): in the
all-mass program, the flagship `T2_positive_mass` proves a positive squared mass
of a `12×12` Krein form `HAC` and metric `Jmet` that are entered as **hand-typed
literal matrices**. Their Clifford provenance — that they are the two-edge `Cl(4)`
carrier's `J(Q_A+Q_C)` and fundamental symmetry `J = Js⊗I3` — is currently only in
docstrings + an oracle, NOT kernel-certified. Your job: build the Clifford
assembly from Pauli-Kronecker products and prove it EQUALS the hand-typed matrices
(or, if it does not, report the exact discrepancy — a real convention bug would be
a valuable finding).

## The Clifford recipe (conventions, aperture strength lam = 2)

- Pauli: `sx = !![0,1;1,0]`, `sy = !![0,-I;I,0]`, `sz = !![1,0;0,-1]` (I = Complex.I).
- Hermitian gammas on `C^4 = C^2 ⊗ C^2` (use `Matrix.kroneckerMap (·*·)` / `⊗ₖ`):
  `g1 = sx ⊗ I2`, `g2 = sy ⊗ I2`, `g3 = sz ⊗ sx`, `g4 = sz ⊗ sy`.
- `omega = g1 * g2`, `Js = Complex.I • (g3 * g4)`  (both `4×4`).
- Krein metric `J_cl = Js ⊗ I3`  (`12×12`).
- aperture `Q_A = I4 ⊗ ((2 : ℂ) • I3)`  (`12×12`).
- closure `Q_C = omega ⊗ K` with `K = !![0,1,0; -1,0,0; 0,0,0]`  (`12×12`).
- assembly `HAC_cl = J_cl * (Q_A + Q_C)`  (`12×12`).

## Targets (prove kernel-clean, no `sorry`; or report the exact mismatch)

Let `HAC` and `Jmet` be the hand-typed matrices below (copied verbatim from
`SectorGroundMassWitness`).

- **Jmet_eq_clifford:** `Js ⊗ I3 = Jmet` (i.e. `J_cl = Jmet`).
- **HAC_eq_clifford:** `J_cl * (Q_A + Q_C) = HAC`.
- If either equality is false as stated, prove instead the corrected identity you
  find (e.g. a sign/basis-order fix) and REPORT precisely which convention differs
  (which gamma sign, Kronecker factor order, or `K` orientation). The deliverable
  is a kernel proof that the hand-typed `HAC`/`Jmet` are the Clifford assembly
  under an explicitly stated convention, OR a precise no-go showing they are not.

Proof style: define the pieces, then `ext i j; fin_cases i <;> fin_cases j <;>
simp [...] ` / `decide`-level on the explicit `12×12` entries (Kronecker of
explicit matrices is explicit). Report semantic alignment: the load-bearing content
is "the hand-typed T2 carrier IS the Cl(4) Kronecker assembly, in the kernel."

Run `lake env lean AllMassClifford/Core.lean`. Commit + push.
Provenance: all-mass solo run 2026-07-08 [orig]; closes the T2 Clifford-provenance
audit gap.
-/

import Mathlib

namespace AllMassClifford

open Matrix Complex
open scoped Kronecker

/-- Hand-typed Krein form (target), verbatim from `SectorGroundMassWitness.HAC`. -/
def HAC : Matrix (Fin 12) (Fin 12) ℂ :=
  !![ (-2 : ℂ), -Complex.I, 0,  0, 0, 0,   0, 0, 0,   0, 0, 0;
      Complex.I, -2, 0,          0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, -2,                  0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 0,   (2 : ℂ), Complex.I, 0,     0, 0, 0,   0, 0, 0;
      0, 0, 0,   -Complex.I, 2, 0,          0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 2,                   0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 0,   (-2 : ℂ), Complex.I, 0,    0, 0, 0;
      0, 0, 0,   0, 0, 0,   -Complex.I, -2, 0,         0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, -2,                  0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   (2 : ℂ), -Complex.I, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   Complex.I, 2, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   0, 0, 2]

/-- Hand-typed Krein metric (target), verbatim from `SectorGroundMassWitness.Jmet`. -/
def Jmet : Matrix (Fin 12) (Fin 12) ℂ :=
  Matrix.diagonal ![(-1 : ℂ), -1, -1, 1, 1, 1, -1, -1, -1, 1, 1, 1]

/-- Placeholder. Replace with the Clifford construction (`sx,sy,sz,g1..g4,omega,
Js,J_cl,Q_A,Q_C,K`) and the targets `Jmet_eq_clifford`, `HAC_eq_clifford`, kernel
-clean; or the corrected identities + a precise convention report. -/
theorem package_ok : True := trivial

end AllMassClifford
