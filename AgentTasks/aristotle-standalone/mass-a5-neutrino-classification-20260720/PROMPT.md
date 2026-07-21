# Strategy/classification + lemma job: neutrino mass operators (gate A5)

Type: operator classification + a self-contained Mathlib-only lemma. AFPL
origin-of-mass gate A5. Source anchors: Weinberg 1979 dimension-5 operator
`(L H)(L H)/Lambda` (the effective Majorana mass; Neo4j 4B4VURM2) and
Connes et al. "Gravity and the standard model with neutrino mixing"
(arXiv:hep-th/0610241) for the seesaw inside one Dirac operator.

## Context (repo mass encoding)

The program encodes a Dirac fermion mass as a chirality-ODD off-diagonal block
`M : V_R -> V_L` (the `Y (x) 1_spin` turn on a graded space `V = V_L (+) V_R`).
A Majorana mass is a symmetric bilinear `psi^T C M psi` on a single chirality,
legal only for a real/pseudoreal representation.

## Deliverable (one operator classification covering all four)

1. **No minimal-content neutrino mass.** Prove: with only a left-handed Weyl
   field (no right-handed singlet), there is NO chirality-odd Dirac turn block
   of the requested form (the `V_R` slot is absent) AND no gauge-invariant
   renormalizable Majorana bilinear (the left neutrino carries hypercharge). A
   concrete finite model: a one-dimensional `V_L` with empty `V_R` admits no
   nonzero odd block. Kernel lemma: on `V = V_L (+) 0`, every chirality-odd
   block is zero.
2. **Right-handed singlet enables a Dirac mass.** Adding a singlet `nu_R`
   (a one-dimensional `V_R`) makes a nonzero odd Dirac block available; exhibit
   the nonzero witness.
3. **Majorana/Weinberg branch and its cost.** The dimension-5 Weinberg operator
   `(L H)(L H)/Lambda` gives a Majorana mass after electroweak breaking; state
   its symmetry cost (lepton-number violation by two units) and that it is
   non-renormalizable (needs the scale `Lambda`). Distinguish it from the Dirac
   branch by the fermion-number grading.
4. **Finite seesaw as a Schur complement.** For the block mass matrix
   `[[0, m_D],[m_D^T, M_R]]` on `nu_L (+) nu_R` with `M_R` invertible, prove the
   light effective mass is the Schur complement `-m_D M_R^{-1} m_D^T`, and give
   the controlled small-`m_D/M_R` approximation. This is a concrete finite
   linear-algebra theorem (Schur complement of a `2 x 2` block matrix).

## Constraints

Mathlib only; no new `axiom`/`opaque`/`unsafe`; no `native_decide`; standard
axioms. Report axioms. Success: the four-branch classification with at least the
seesaw Schur-complement lemma and the no-minimal-content lemma proved concretely.
