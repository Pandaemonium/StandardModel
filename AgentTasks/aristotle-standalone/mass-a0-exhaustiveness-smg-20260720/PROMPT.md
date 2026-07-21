# Strategy job: origin-of-mass exhaustiveness relative to a response class, and the symmetric-mass-generation boundary

Type: classification + exhaustiveness analysis (deliverable is a rigorous report
plus any self-contained Mathlib-only Lean lemma you can prove). Independent
cross-family synthesis for the AFPL origin-of-mass program (gate A0).

## Context: the candidate response-operator class

The program models each mass mechanism as a response operator on a graded finite
complex Hilbert space `V = V_L ⊕ V_R` (chirality grading `Γ`), obstructing
gapless null transport. The declared mechanism rows and their response operators
are:

1. Fermion mass — chirality-ODD-complement "turn": off-diagonal block
   `M : V_R → V_L`, i.e. the `Γ`-anticommuting part of a bilinear vertex
   (`turnAmplitude = Y ⊗ 1_spin`).
2. Gauge-boson mass — vacuum-orbit stiffness: a positive-semidefinite Gram
   matrix `G_{ab} = ⟨T_a H0, T_b H0⟩` of generator images of one vacuum vector,
   with kernel = unbroken stabilizer.
3. Higgs radial mass — potential Hessian: a positive second derivative
   `2 λ v^2` of a quartic potential at its minimum.
4. Neutrino Dirac/Majorana — a legal `Γ`-odd map on an extended field content,
   possibly a Schur complement (seesaw).
5. Composite/binding mass — a transfer-operator spectral gap / correlation-decay
   rate on a gauge-invariant sector.

## The two questions

### Q1 (exhaustiveness relative to a displayed class)

Fix the operator class C = { Hermitian or symmetry-constrained response
operators on `V` that are either (a) a `Γ`-odd off-diagonal bilinear block,
(b) a positive-semidefinite quadratic form of vacuum-orbit images, (c) a
positive Hessian of an invariant potential, or (d) a transfer/correlation
spectral gap }. Is the list of rows 1-5 EXHAUSTIVE relative to C? Precisely:
prove that any element of C is unitarily/gauge equivalent to a member of rows
1-5, OR exhibit an element of C not covered by any row (the minimal missing
class). State the non-double-counting / overlap law: prove that the `Γ`-odd
turn block, the PSD orbit Gram, and the potential Hessian act on DISTINGUISHABLE
graded data so they cannot double-count one contribution (e.g. the turn block is
`Γ`-odd while the Gram and Hessian are `Γ`-even, hence orthogonal in the
Hilbert-Schmidt inner product).

### Q2 (the symmetric-mass-generation boundary)

Symmetric mass generation (SMG; arXiv:2412.19691 Li-Wang, arXiv:2101.01026
Butt-Catterall et al., propagator zeros arXiv:2311.12790) gaps fermions WITHOUT
any symmetry-breaking bilinear condensate, via anomaly-constrained interactions,
producing a self-energy with a PROPAGATOR ZERO rather than a mass pole. Determine
whether SMG is:

- a genuinely MISSING row of class C (an interaction-induced symmetric gap that
  is not any single bilinear/quadratic response operator), so A0's exhaustiveness
  must either add it or restrict the class; or
- SCOPED OUT by an explicit hypothesis (e.g. the class C is bilinear-response
  only, and SMG requires a quartic/anomaly-free-multiplet condition outside C).

State the minimal precise scope hypothesis under which rows 1-5 ARE exhaustive,
naming SMG as the boundary case. This directly complements the kernel-checked
finite fact `gap_does_not_fix_pole` (a spectral gap need not carry a physical
pole).

## Success criteria (any one)

- An exhaustiveness theorem relative to a displayed class + the orthogonality
  (non-overlap) law, with SMG classified as either a new row or an explicit
  out-of-scope case.
- A counterexample element of C outside rows 1-5.
- A precise minimal scope hypothesis making rows 1-5 exhaustive, with SMG the
  named boundary.

Deliverable: the analysis with exact statements and any Mathlib-only Lean lemma
(e.g. the Hilbert-Schmidt orthogonality of `Γ`-odd and `Γ`-even blocks for
concrete small `V`). Report axioms for anything proved.
