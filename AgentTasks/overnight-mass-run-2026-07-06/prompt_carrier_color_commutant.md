Deliver a self-contained Lean 4 (Mathlib) file proving the [H2] CONSTRAINT that
realizes Fable-5's reframe of `OctonionMassCoupling`: the physically-allowed mass
operators on the color triplet are exactly the COLOR COMMUTANT, and for the
irreducible fundamental that commutant is the SCALARS. See
AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md sec 5.4 / [H2].

Create a NEW module `PhysicsSM/Draft/NullEdge/Carrier/ColorCommutantScalar.lean`
(namespace `PhysicsSM.Draft.NullEdge.Carrier`). Check with `lake env lean <yourfile>`.
If a broader `lake build` stalls, SKIP and return source. NO `sorry`/`admit`/`axiom`/
`native_decide` in the final theorems.

## Mathematical content

Work with `M := Matrix (Fin 3) (Fin 3) ℂ` acting on the color triplet `ℂ³`. Use the
STANDARD su(3) fundamental generators. You MAY either:
  (a) reuse the exact color generators already defined in the repo module
      `PhysicsSM.Algebra.Furey.OctonionMassCoupling` (the Cartan generators `H23`,
      `H13` and the six ladders `T12, T21, T13, T31, T23, T32`), or
  (b) define the eight Gell-Mann matrices `λ₁..λ₈` (or an equivalent generating set of
      the fundamental su(3) action) freshly.
Whichever you pick, define `colorGens : Set M` (or a `Finset`/list) as the chosen
generating set and note that it generates the fundamental su(3) action on `ℂ³`.

Prove:

1. `color_commutant_eq_scalars` (THE headline): a matrix `Mx : M` commutes with every
   color generator iff it is a scalar multiple of the identity:
     `(∀ g ∈ colorGens, Mx * g = g * Mx) ↔ ∃ c : ℂ, Mx = c • (1 : M)`.
   (This is Schur's lemma made concrete for the irreducible fundamental; it is a finite
   linear-algebra fact - the commutation constraints force off-diagonal entries to 0 and
   all diagonal entries equal. A direct entrywise computation with `Matrix.ext` +
   `Fin.cases`/`decide`-style case analysis, or Mathlib's Schur-lemma API if convenient,
   both work. Do NOT use `native_decide`.)

2. `scalar_mass_is_color_exact` (the easy direction, stated separately for clarity): for
   any `c`, `c • (1 : M)` commutes with every color generator.

3. `nonscalar_mass_not_color_exact` (the CONSTRAINT corollary - the honest reading of
   `mass_grading_not_central`): a diagonal mass `Matrix.diagonal ![m0, m1, m2]` commutes
   with every color generator iff `m0 = m1 ∧ m1 = m2` (i.e. iff it is color-blind). In
   particular a non-degenerate `diagonal ![1,2,3]` does NOT commute with the color action,
   so it is not a physical (color-exact) mass operator.

## Honesty / scope (module docstring)

State plainly: this makes the [H2] audit precise. `OctonionMassCoupling` proved a
non-degenerate diagonal grading fails to commute with color; read as physics that is a
CONSTRAINT (color is exact, so such a grading is NOT a physical mass), and this file
proves the positive companion: the color-commutant on the single triplet is exactly the
scalars, so the only color-exact mass on one triplet is a color-blind scalar. The place
where genuine flavor/Yukawa structure can live is the commutant on the FULL reducible
internal space (multiplicity spaces, per Schur) - NOT computed here; this file is the
single-irreducible-triplet base case. Finite linear algebra, draft-trust.

## Deliverable

Self-contained file + report: exact theorem names, PROVED vs OPEN (the full-internal-
space commutant is OPEN/out of scope), and the axiom footprint.
