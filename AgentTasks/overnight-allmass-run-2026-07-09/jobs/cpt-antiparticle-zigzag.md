# claude-cpt-antiparticle-zigzag — the antiparticle is the CPT-mirror zigzag (matter/antimatter as null-edge orientation)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Companion to the "slowed-down light" line and the finite CPT theorem. If a massive fermion is a
zigzag of two null Weyl pieces coupled by mass, its ANTIparticle should be the CPT-conjugate
zigzag: the antiunitary `Theta = C . Gamma_rev . #` swaps left<->right Weyl and conjugates, so
particle and antiparticle are the two CPT-orientations of the SAME null-edge pair, with
conjugate-paired spectra. Prove the finite statement.

## The model (explicit 4x4, real or explicit-complex; reuse the zigzag + CPT structure)

Chiral basis: Weyl blocks `KL, KR`, chirality `gamma5 = diag(+1,+1,-1,-1)`, Dirac `D(m)`.
CPT operator `Theta v = R * conj v` with `R = Gamma . J` (antiunitary), as in the finite CPT
carrier. The two null Weyl components `psiL` (chirality +1) and `psiR` (chirality -1).

## Targets

1. `theta_antiunitary`: `Theta` is antilinear and an involution (`Theta (Theta v) = v`) --
   reuse the finite CPT structure (state on your explicit `R`).
2. `theta_swaps_weyl` (payload): `Theta` maps the +1-chirality (left) Weyl subspace to the
   -1-chirality (right) Weyl subspace and back (`gamma5 (Theta v) = - Theta (gamma5 v)`, i.e.
   `Theta` is chirality-odd) -- so CPT exchanges the two null pieces of the zigzag: the
   antiparticle's left piece is the particle's right piece and vice versa.
3. `spectrum_conjugate_paired`: if `D(m) v = lambda v` (v != 0) then `D(m) (Theta v) = conj lambda
   (Theta v)` with `Theta v != 0` -- particle and antiparticle energies are conjugate-paired (the
   antiparticle is the CPT mirror), from antilinearity + `Theta D Theta^{-1} = D^#` and `D^# = D`.
4. `antiparticle_verdict`: package -- matter and antimatter are the two CPT-orientations of the
   same null-edge (Weyl) pair; CPT swaps the two null pieces and conjugates the spectrum; the mass
   coupling is CPT-even (same `m` for both). So particle/antiparticle is the orientation of the
   null-edge zigzag, and matter-antimatter asymmetry is a state/initial-condition question, not a
   law asymmetry. Honest scope: a finite one-carrier CPT statement, not a baryogenesis mechanism.

MANDATORY non-degeneracy: explicit rational/complex-constant `R, D(m)`; exhibit `Theta` is
chirality-odd on an explicit nonzero vector; exhibit a concrete eigenpair and its conjugate mirror
`(lambda, Theta v)` with both nonzero, stated in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Explicit 4x4 matrices, REAL preferred (else explicit complex constants
-- the CPT conjugation needs `star`/`conj` but on CONCRETE entries, keep it finite); ring/norm_num/
decide/fin_cases; NO symbolic Complex analysis, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build
under 3 min. Deliver RequestProject/Main.lean (namespace CPTAntiparticleZigzag) + ARISTOTLE_SUMMARY.md.
