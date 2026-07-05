import Mathlib

/-!
# NE-U5: "mass without mass" - a kernel-checked positive gap with zero primitive mass

The crown rung of the null-edge mass unification ladder
(`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`): an
explicit finite model with a STRICTLY POSITIVE mass (a transfer-operator spectral
gap) and ZERO primitive mass input. This is the finite, kernel-checked heart of
the null-edge thesis that mass need not be a primitive quantity - here it is
purely the closure/aperture obstruction of a closed gauge-flux loop.

## The model (pure-gauge Z2 single-plaquette temporal transfer)

Link variables `+-1`; one plaquette; two flux states (trivial / flipped). The
temporal transfer operator on the 2-dimensional flux Hilbert space at inverse
coupling `beta` is

    T = !![ e^beta, e^{-beta} ; e^{-beta}, e^beta ].

It is real symmetric; its eigenvectors are `(1,1)` (symmetric vacuum) and
`(1,-1)` (flux-loop excitation) with eigenvalues `lambda_+ = 2 cosh beta` and
`lambda_- = 2 sinh beta` (here written unnormalized as `a + b` and `a - b` with
`a = e^beta`, `b = e^{-beta}`). The **glueball mass** - the category-(3)
Yang-Mills gap, i.e. the minimal transfer energy of the closed flux loop - is

    m_glue = log(lambda_plus over lambda_minus) = log coth beta > 0
    for every beta > 0.

## Why this is the HONEST "mass without mass" (and a fermionic toy is not)

Design provenance: Aristotle strategy job `d1e7bece` (QMF5 design; prompt
`AgentTasks/aristotle-prompts/qmf5-fermionic-rp-strategy-20260705.prompt.md`),
which recommended this pure-gauge object over a fermionic one and supplied the
gap proof skeleton; the proofs below are re-derived and INDEPENDENTLY verified
on this project's pinned toolchain. The design's key honesty point (the
"regulator trap"): a 2-site Wilson-quark model with `quarkMassParameter = 0`
would still show a gap `~ log(1 + 4r)`, but that is ENTIRELY the category-(2)
Wilson regulator mass (a doubler-removal lattice artifact), not a physical or
composite mass - reporting it as "mass without mass" is exactly the
F-YM-CONFLATE taxonomy error (2) == (1)/(3). The pure-gauge model sidesteps this
by having NO fermions at all: `quarkMassParameter := 0` holds vacuously and
exactly, so the positive gap can ONLY be the category-(3) closure channel.

In null-edge terms: the glueball is a CLOSED flux composite (the (C) closure
obstruction, cf. `GateYM/ClosureObstruction.lean` - an open gauge edge has no
gauge-invariant state); its transfer gap is the cost of closure; and no
primitive ("turn"/(T)) mass is inserted anywhere. Mass here is pure obstruction
geometry.

## Claim discipline

Claim label: **finite identity** (an explicit `2 x 2` transfer operator; no
continuum, no numerics). This is a TOY: it is a category-(3) gap in the smallest
possible closed-flux model, NOT the physical Yang-Mills mass gap and NOT lattice
QCD. Draft-trust, kernel-checked, `s o r r y`-free. Prerequisites: Mathlib only.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace MassWithoutMass

/-- The symmetric `2 x 2` transfer operator `!![a, b; b, a]`. For the Z2
single-plaquette temporal transfer, `a = e^beta`, `b = e^{-beta}`. -/
noncomputable def transfer2 (a b : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![a, b; b, a]

/-- The (unnormalized) spectral gap `log((a + b)/(a - b))`. For the Z2 model this
is `log coth beta`, the glueball mass. -/
noncomputable def gap2 (a b : ℝ) : ℝ := Real.log ((a + b) / (a - b))

/-- `(1,1)` is an eigenvector with eigenvalue `a + b` (the symmetric vacuum
branch, `lambda_+`). -/
theorem transfer2_mulVec_sym (a b : ℝ) :
    (transfer2 a b) *ᵥ (fun _ => (1 : ℝ)) = fun _ => a + b := by
  funext i
  fin_cases i <;>
    simp [transfer2, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> ring

/-- `(1,-1)` is an eigenvector with eigenvalue `a - b` (the flux-loop excitation
branch, `lambda_-`). -/
theorem transfer2_mulVec_antisym (a b : ℝ) :
    (transfer2 a b) *ᵥ (![1, -1] : Fin 2 → ℝ) = fun i => (a - b) * (![1, -1] : Fin 2 → ℝ) i := by
  funext i
  fin_cases i <;>
    simp [transfer2, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> ring

/-- The transfer operator is symmetric (so its spectrum is real and the two
eigenvalue branches above genuinely are its spectrum). -/
theorem transfer2_transpose (a b : ℝ) : (transfer2 a b)ᵀ = transfer2 a b := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [transfer2, Matrix.transpose_apply]

/-- **Strictly positive spectral gap** whenever `0 < b < a` (nonzero coupling):
the two transfer eigenvalues `a + b > a - b > 0` are distinct and positive, so
`gap2 a b = log((a+b)/(a-b)) > 0`. -/
theorem transfer2_gap_pos {a b : ℝ} (hb : 0 < b) (hba : b < a) : 0 < gap2 a b := by
  have h1 : 0 < a - b := by linarith
  have h2 : a - b < a + b := by linarith
  have hgt1 : (1 : ℝ) < (a + b) / (a - b) := (one_lt_div h1).mpr h2
  simpa [gap2] using Real.log_pos hgt1

/-- The bare quark mass of the pure-gauge model: identically zero, since the
model has no fermions. Named as a def so the taxonomy row-1 quantity is explicit
and provably `0` in the headline. -/
noncomputable def quarkMassParameter : ℝ := 0

/-- The Z2 single-plaquette glueball mass `log coth beta = gap2 (e^beta)
(e^{-beta})`, the category-(3) Yang-Mills gap of the closed flux loop. -/
noncomputable def z2GlueballMass (β : ℝ) : ℝ := gap2 (Real.exp β) (Real.exp (-β))

/-- The Z2 glueball mass is strictly positive for every finite `beta > 0`. -/
theorem z2GlueballMass_pos {β : ℝ} (hβ : 0 < β) : 0 < z2GlueballMass β := by
  refine transfer2_gap_pos (Real.exp_pos _) ?_
  exact Real.exp_lt_exp.mpr (by linarith)

/-- **HEADLINE ("mass without mass").** In the pure-gauge Z2 single-plaquette
model at any coupling `beta > 0`: the primitive (bare quark) mass is exactly
zero, yet the glueball transfer gap is strictly positive. A strictly positive
physical mass with zero primitive mass input - the mass is entirely the
category-(3) closure/aperture obstruction of the closed flux loop, with no
possibility of taxonomy conflation (there are no fermions, so no Wilson
regulator and no bare fermion mass to borrow from). -/
theorem massWithoutMass {β : ℝ} (hβ : 0 < β) :
    quarkMassParameter = 0 ∧ 0 < z2GlueballMass β :=
  ⟨rfl, z2GlueballMass_pos hβ⟩

end MassWithoutMass
end PhysicsSM.Draft.NullEdge.GateI1
