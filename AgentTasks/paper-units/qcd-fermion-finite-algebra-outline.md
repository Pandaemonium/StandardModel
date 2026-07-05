# Paper Unit Outline: Finite Grassmann / Clifford / Wilson-Fermion Algebra (QMF3-QMF4)

Date: 2026-07-05
Run: `AgentTasks/fourday-ym-run-2026-07-05`
Status: outline only; draft Lean inventory, not a promotion request.

## Working scope

This unit collects the FINITE, algebraic fermion-formalism results produced on
the QCD-mass-formalism (QMF) ladder
(`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` section 15). It is
deliberately GAUGE-INDEPENDENT: every result here is pure finite linear /
multilinear algebra over a commutative ring or the complexes, with NO analysis,
NO continuum, and NO physical mass claim. It is publishable independent of the
Yang-Mills / reflection-positivity stack.

The safest current headline:

> A kernel-checked finite formalism for the fermionic-determinant algebra of
> lattice gauge theory: the Grassmann/Berezin Gaussian integral equals a
> determinant (Matthews-Salam, finite form); the Euclidean Clifford algebra and
> chirality matrix for concrete gamma matrices; and (pending) gamma5-hermiticity
> of the finite lattice Wilson-Dirac operator with reality of its determinant.

Do NOT claim: any continuum limit, any physical fermion or hadron mass, any
spectral statement, or that this is a formalization of full lattice QCD. The
Wilson regulator (doubler) mass is a lattice artifact and is kept OUT of every
physical reading (mass taxonomy, program-doc section 13.2 / 15).

## Theorem inventory

Finite Grassmann / Berezin (QMF3):

- `PhysicsSM/Draft/NullEdge/GateYM/BerezinMatthewsSalam.lean`
  - `shuffleSign`, `GrassmannElem`, `gmul`, `gone`, `gpow`, `bilinear`, `gexp`,
    `berezinGaussian` (the finite Grassmann-algebra model and the Berezin
    Gaussian integral)
  - `berezinGaussian_eq_det` : `berezinGaussian M = M.det` (the finite
    Matthews-Salam identity, arbitrary `n`, over a characteristic-zero
    commutative ring)
  - `n = 1` / `n = 2` regression theorems confirming the oracle-pinned
    convention (`n = 2` gives `a*d - b*c`)
  - Provenance: Aristotle project `70966fef`; convention pinned by
    `Scripts/oracle/validate_berezin.py` (12/12); axioms
    `[propext, Classical.choice, Quot.sound]`; `s o r r y`-free.

Euclidean Clifford algebra / chirality (QMF4a):

- `PhysicsSM/Draft/NullEdge/GateYM/EuclideanGamma.lean`
  - concrete `γ1..γ4`, `γ5 = γ1 γ2 γ3 γ4`, indexed `γ`
  - `γ_sq`, `γ_anticomm` (`{γ_mu, γ_nu} = 2 δ_{mu nu} I`), `γ_herm`
  - `γ5_sq`, `γ5_herm`, `γ5_anticomm`
  - Convention: EUCLIDEAN (all `γ_mu` Hermitian), distinct from the repo's
    Minkowski `PhysicsSM/Clifford/GammaMatrices.lean` stub - this is the
    lattice-field-theory convention and the module says so.
  - Provenance: Aristotle project `0752425e`; convention pinned by
    `Scripts/oracle/validate_wilson_dirac.py` (21/21); axioms
    `[propext, Classical.choice, Quot.sound]`; `s o r r y`-free. Build-cost note:
    ~1 min leaf module (256-entry concrete-matrix Clifford table).

Wilson-Dirac operator (QMF4b - PROVED + INTEGRATED 2026-07-05):

- `PhysicsSM/Draft/NullEdge/GateYM/WilsonDiracOperator.lean` (Aristotle project
  `7a2a0f40`; independently verified, axioms `[propext, Classical.choice,
  Quot.sound]`, sorry-free; wired into the GateYM aggregate)
  - `wilsonDirac` (finite lattice Wilson-Dirac operator, Euclidean, `r = 1`,
    unitary links), `Γ5` (lifted chirality)
  - `gamma5_hermiticity` : `Γ5 D Γ5 = Dᴴ`
  - `det_wilsonDirac_real` : `(wilsonDirac m U).det.im = 0`
  - `pairedFlavor_det_nonneg` : mass-degenerate two-flavor determinant `>= 0`
  - Convention pinned by the same Wilson-Dirac oracle. Note (from the Aristotle
    triage): gamma5-hermiticity does NOT require link unitarity - it is purely a
    property of the gamma structure; unitarity is retained in the signature for
    physical fidelity only. UPDATE THIS ROW on harvest with the verified axiom
    footprint and any definition changes.

## Oracles (convention pins, not proof)

- `Scripts/oracle/validate_berezin.py` - from-scratch finite Grassmann algebra
  vs independent Leibniz determinant, `n = 1..4`, plus a sign-sensitivity
  control; 12/12.
- `Scripts/oracle/validate_wilson_dirac.py` - Euclidean Clifford relations +
  gamma5, and Wilson-Dirac gamma5-hermiticity / paired-flavor positivity / det
  real for U(1) and SU(2) at several masses, plus an imaginary-mass
  sign-problem sensitivity control; 21/21.

These pin conventions independently of the Lean; they are regression guards, not
theorems.

## Provenance and source boundaries

- The Matthews-Salam identity and the Wilson-fermion action are standard lattice
  field theory; the FINITE forms here are the repo's clean-room formalizations,
  not a formalization of any specific paper's theorem.
- Menotti-Pelissetto 1987 (Wilson-fermion reflection positivity) is
  bibliographically source-checked (T12) and is the intended QMF5 target, NOT
  yet formalized here.
- The one-flavor sign problem is RECORDED (paired-flavor positivity is stated for
  the degenerate pair; single-flavor `det D` can be negative), not worked around.

## Remaining gaps (to close the unit / feed QMF5+)

- QMF4b integration + independent verification: DONE (2026-07-05).
- The concrete Ursell/Mayer coefficient tie-in (this unit uses the Grassmann
  Gaussian = det directly; the polymer/Ursell side lives in the separate KP
  paper unit).
- QMF5 (fermionic reflection positivity) and beyond are NOT part of this unit;
  this unit is the finite-algebra substrate they build on.
- No physical mass, spectrum, or continuum statement is in scope here; those are
  QMF6/QMF7 (hadron sectors) and permanently-out QMF8 (continuum), respectively.

## Verification record to cite

Use command records from the run ledger, not memory. Known records:
`lake env lean` clean and `#print axioms` standard for `berezinGaussian_eq_det`
and the six `EuclideanGamma` lemmas; aggregate `GateYM` build green with both
modules wired in; oracles `validate_berezin.py` 12/12 and
`validate_wilson_dirac.py` 21/21. Re-run and record fresh output before drafting
paper prose.
