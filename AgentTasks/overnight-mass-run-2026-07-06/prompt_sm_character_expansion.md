Formalize the FINITE-GROUP character orthogonality + strong-coupling CHARACTER
EXPANSION of the Wilson weight - the building block of the convergent
character/polymer expansion that the recent RP construction of 4D SU(N)
Yang-Mills with mass gap (arXiv 2606.19362) and the Kotecky-Preiss /
Fernandez-Procacci convergence theory (math-ph/0605041) both rest on. The project
flagged Peter-Weyl as absent from Mathlib; the FINITE-group case is the tractable
entry and is what the Z2/finite lattice rungs actually need.

Create a NEW module `PhysicsSM/Draft/NullEdge/GateYM/CharacterExpansion.lean`.
Check with `lake env lean`. If broader `lake build` stalls, SKIP.

## Build on the existing tree (reuse, do not redefine)

`WilsonWeightPositivity.reChar rho g` (= Re tr rho g), `wilsonKernel beta rho`,
`reChar_one`, `reChar_inv_of_unitary`, `reCharGram_posSemidef`;
`FusionTransferSpectrum.character_inv_eq_conj`; `FusionConvolution` (its one-step
fusion lemma is "supplied by character orthogonality" - now prove that input).
Mathlib: `MonoidAlgebra`, `Matrix.trace`, finite-group representation theory
(`FDRep`, `Rep`), and finite character sums.

## Deliverables (choose the strongest you can prove)

1. **Finite-group character orthogonality (first relation).** For a finite group
   `G` and finite-dim irreps `R, S` (unitary matrix reps), prove
   `(1/|G|) * sum_{g in G} chi_R(g) * conj(chi_S(g)) = if R iso S then 1 else 0`
   (or the projector/idempotent form `(1/|G|) sum_g rho_R(g) A rho_R(g)^{-1}` =
   averaged intertwiner). For `Z2` and finite ABELIAN `G` (1-dim irreps =
   characters) this is elementary and fully closable; state the general finite-G
   version and prove at least the abelian case + the Schur-orthogonality skeleton.
2. **Character expansion of the plaquette Wilson weight.** Expand
   `exp(beta * reChar rho U)` (or the class function `g |-> exp(beta Re chi(g))`)
   in the character basis: `= sum_R c_R(beta) chi_R(U)` with
   `c_R(beta) = (1/|G|) sum_g exp(beta Re chi(g)) conj(chi_R(g))` (finite Fourier
   on the group). Prove the coefficients are real and that at STRONG coupling the
   trivial-rep coefficient dominates (`c_triv >= |c_R|`), the input the strong-
   coupling expansion needs. Do `Z2` explicitly (2 characters), then finite
   abelian.
3. **(bridge) Tie to `reCharGram_posSemidef` / the fusion lemma:** show the
   character expansion gives the FusionConvolution one-step lemma its
   orthogonality input.

## Constraints

- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. Prove the
  finite-abelian/Z2 case fully (`s o r r y`-free, standard axioms); the general
  finite-G Schur orthogonality may use a documented handoff `s o r r y` if
  Mathlib's rep theory does not give it directly - but SEARCH Mathlib first
  (`FDRep`, `char`, orthogonality) before assuming it is absent.
- Claim label: finite identity / character expansion (draft). If `lake build`
  stalls, SKIP; return the module source + what is proved vs handoff.
