# Strategy/no-go job: Pluecker-to-Yukawa legality and selection (gate A2)

Type: classification + no-go analysis (deliverable is a rigorous analysis report
plus any self-contained Lean lemma or counterexample you can prove with
Mathlib only). This is an INDEPENDENT cross-family review job for the AFPL
origin-of-mass program; do not assume the program's uniqueness claim is true.

## Exact repository objects (verbatim, convention-locked)

Over `Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ` with `Γ5F n = 1 ⊗ₖ γ5`
(chirality involution, `Γ5F^2 = 1`), the program defines:

- `chiralOddF A  = (1/2) • (A - Γ5F * A * Γ5F)`  (chirality-preserving / transport)
- `chiralEvenF A = (1/2) • (A + Γ5F * A * Γ5F)`  (chirality-mixing / "turn" / mass)
- `flavorMassTerm Y = Y ⊗ₖ (1 : Matrix (Fin 4) (Fin 4) ℂ)`  (Yukawa mass term)
- `flavorTransport n μ = (1 : Matrix (Fin n) (Fin n) ℂ) ⊗ₖ γ μ`
- `flavorVertex Y μ = flavorMassTerm Y - flavorTransport n μ`
- `turnAmplitude Y μ = chiralEvenF (flavorVertex Y μ)`

Landed facts (kernel-checked): `turnAmplitude Y μ = flavorMassTerm Y` and
`turnAmplitude Y μ = 0 ↔ Y = 0`.

## The problem

At this level `Y : Matrix (Fin n) (Fin n) ℂ` is a COMPLETELY FREE complex
matrix: every `Y` yields a legal chirality-even turn, with the only constraint
being `Y ≠ 0` for a nonzero mass. So the claim "the physical turn map is
uniquely represented by the Pluecker rest operator" (gate A2) is FALSE as stated
without additional symmetry constraints. The genuine question is a moduli
problem.

Impose the physical constraints and classify the survivors:

1. **Gauge equivariance.** Let a compact gauge group act on the flavor factor
   `Fin n` by a unitary representation `ρ`, splitting `Fin n` into left- and
   right-chiral irreducible blocks with, in general, DIFFERENT representations
   `ρ_L`, `ρ_R` (the Standard Model case: `Y` intertwines a left doublet and a
   right singlet, so `Y` must satisfy `ρ_L(g) Y = Y ρ_R(g)` — an intertwiner
   condition). Classify the space of admissible `Y` as
   `Hom_G(ρ_R, ρ_L)` by Schur's lemma.
2. **Grading compatibility.** The turn must map the right sector to the left
   sector and be chirality-odd-vs-even consistent with `Γ5F`. State precisely
   which Kronecker blocks (`Y ⊗ 1`, `1 ⊗ γμ`, `Y ⊗ γ5`, off-diagonal flavor)
   are FORBIDDEN and which survive, with explicit nonzero witnesses for the
   surviving blocks and explicit vanishing controls for the forbidden ones.
3. **Pluecker selection.** The program's Pluecker rest operator supplies a
   specific rank/structure datum (a complex Pluecker coordinate whose modulus
   is a rest gap). Determine whether that datum SELECTS A POINT in the admissible
   `Hom_G(ρ_R, ρ_L)` moduli space, selects a lower-dimensional subvariety, or
   leaves a positive-dimensional family unconstrained.

## Success criteria (any one is a complete result)

- A moduli/classification theorem: `admissible Y = Hom_G(ρ_R,ρ_L)` with its
  dimension, plus whether Pluecker data cuts it to a point.
- A uniqueness theorem under explicitly stated extra hypotheses (name every
  hypothesis; a freely supplied arbitrary matrix relabeled as derived does NOT
  count).
- A decisive counterexample: two gauge-inequivalent admissible `Y` with the same
  Pluecker datum, proving additional physical input is unavoidable.

Deliverable: the analysis with exact statements, forbidden/surviving block
table, and any Mathlib-only Lean lemma or counterexample you can prove
standalone (e.g. a Schur-lemma intertwiner-dimension computation for a concrete
small `ρ_L, ρ_R`). Report axioms for anything proved. Do NOT modify or assume
access to the repository's private modules; work from the definitions above.
