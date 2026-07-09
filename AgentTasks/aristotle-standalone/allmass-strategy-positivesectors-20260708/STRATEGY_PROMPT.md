# Strategy + proof: classify which finite Krein carriers have a positive mass sector (program step 2)

## Context (blind to the wider repo)

A finite null-edge Dirac program builds carriers over a **Krein** (indefinite) inner
product: the full space is NOT born with a positive Hilbert metric; positivity appears
only after constraints/quotients/sector selection. A concrete two-edge `Cl(4)` carrier
escapes a small-model positivity obstruction and produces a genuine **positive squared
mass** (`T2_positive_mass`, kernel-checked): its sector form `M6 = 1 + BᴴB` is
positive-definite (aperture dominance), so the least Rayleigh eigenvalue is a positive
mass. A separate no-go shows the *single-doublet* witness is too balanced (the closure
form is balanced/indefinite on the physical sector) — the `Cl(4)` carrier escapes by
**separating the relevant gradings** (letting closure be signed while aperture
stabilizes).

The frontier is to turn this from example to **theorem**:

**Classify which finite Krein null-edge carriers have a nontrivial positive physical
sector whose ground eigenvalue is positive.**

## Your task (strategy + proof)

Work out the structural condition, over the natural variables: aperture strength,
closure strength, grading separation (does the closure bivector `b = σz⊗1` coincide
with or differ from the chirality `Γ`?), Gauss/BRST quotient data, and Clifford
dimension. Targets:

1. **A sufficient positivity criterion (theorem).** Prove a condition — e.g.
   *aperture dominance* `Q_A ≻ (signed channels)` on the physical sector, or *grading
   separation* (closure bivector distinct from chirality so closure can be signed
   without balancing aperture) — under which a finite Krein carrier has a
   positive-definite physical sector (hence a positive mass gap). Generalize the
   `M6 = 1 + BᴴB` mechanism beyond the specific `Cl(4)` witness.
2. **The obstruction/no-go side.** Prove or characterize when NO positive sector
   exists (the "too balanced" regime — the closure grading balances aperture too, as
   in the single-doublet case). Identify the exact grading/dimension threshold that
   separates the two.
3. **The dream statement (state even if only partial):** a trichotomy for a family of
   multi-edge carriers — an open **massive** phase, a **critical/balanced** boundary,
   and an **indefinite** region — as a function of the structural variables. A finite
   phase diagram for the *existence* of physical mass.

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only. Start with small explicit carriers (1–2 edges, low
Clifford dim) where the classification is a finite computation, then state what
generalizes. Deliver Lean file(s) + `ARISTOTLE_SUMMARY.md`: the positivity criterion
(the design principle "enough Clifford room to let closure be signed while aperture
stabilizes", made precise), the no-go threshold, and an honest boundary of what is
proved vs conjectured.
