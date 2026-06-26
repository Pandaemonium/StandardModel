# The Plücker–Sorkin Exterior-History Theorem

## A finite result for the null-edge program

### Status

This note develops a candidate new theorem cluster. The underlying ingredients—Cauchy–Binet, Plücker coordinates, Sorkin-grade set functions, strong positivity, and determinantal subset weights—are established mathematics. The proposed novelty is their combination in the null-spinor mass setting, especially the strong-positivity obstruction and the canonical pair-history lift.

## 1. Setup

Let `E` be a finite type of labeled null-edge alternatives. Assign to each `e : E` a Weyl spinor

\[
\psi_e\in \mathbb C^2.
\]

Define its rank-one future-null Hermitian momentum

\[
p_e=\psi_e\psi_e^\dagger.
\]

For an event `A ⊆ E`, define cumulative momentum and invariant mass capacity

\[
P_A=\sum_{e\in A}p_e,
\qquad
M(A)=\det P_A.
\]

Write

\[
z_{ef}=\psi_e\wedge\psi_f,
\qquad
q_{ef}=|z_{ef}|^2.
\]

## 2. Main theorem: mass is a pure second-order capacity

### Theorem 2.1 — Plücker–Sorkin identity

For every `A ⊆ E`,

\[
\boxed{
M(A)=\sum_{\{e,f\}\subseteq A}q_{ef}.
}
\]

Consequently:

1. `M(∅)=0` and `M(A) ≥ 0`.
2. `M` is monotone: `A ⊆ B` implies `M(A) ≤ M(B)`.
3. `M({e})=0` for every single null edge.
4. `M(A)=0` iff all nonzero spinors in `A` are collinear.
5. The Möbius transform of `M` is supported exactly on two-element subsets:

\[
\widehat M(U)=
\begin{cases}
q_{ef},&U=\{e,f\},\\
0,&|U|\ne2.
\end{cases}
\]

### Proof

Let `V_A` be the `2 × |A|` matrix whose columns are the spinors in `A`. Then

\[
P_A=V_AV_A^\dagger.
\]

Cauchy–Binet gives

\[
\det(V_AV_A^\dagger)
=
\sum_{\{e,f\}\subseteq A}
\det(V_{ef})\overline{\det(V_{ef})}
=
\sum_{\{e,f\}\subseteq A}|\psi_e\wedge\psi_f|^2.
\]

The remaining claims follow immediately from the nonnegative pair expansion and uniqueness of the finite Möbius transform. ∎

## 3. Exact Sorkin interference law

For disjoint events `A,B`, define

\[
I_2^M(A,B)=M(A\cup B)-M(A)-M(B).
\]

Then

\[
\boxed{
I_2^M(A,B)
=
\sum_{e\in A}\sum_{f\in B}|\psi_e\wedge\psi_f|^2
\ge0.
}
\]

For pairwise disjoint `A,B,C`, define

\[
\begin{aligned}
I_3^M(A,B,C)={}&M(A\cup B\cup C)
-M(A\cup B)-M(A\cup C)-M(B\cup C)\\
&+M(A)+M(B)+M(C).
\end{aligned}
\]

Then

\[
\boxed{I_3^M(A,B,C)=0.}
\]

Thus invariant mass squared is a positive, monotone, pure grade-2 capacity on the edge-event algebra. Its only irreducible coefficients are pairwise Plücker spreads.

## 4. Lorentzian polarization

Define the determinant polarization on `2 × 2` Hermitian matrices:

\[
g(P,Q)=\frac12\bigl(\operatorname{tr}P\operatorname{tr}Q-\operatorname{tr}(PQ)\bigr).
\]

Then

\[
g(P,P)=\det P.
\]

Define the mass bimeasure

\[
\mathfrak M(A,B)=g(P_A,P_B).
\]

It is separately additive, symmetric, and satisfies

\[
M(A)=\mathfrak M(A,A).
\]

For null-edge bundles,

\[
\boxed{
\mathfrak M(A,B)
=
\frac12\sum_{e\in A}\sum_{f\in B}|\psi_e\wedge\psi_f|^2.
}
\]

The second-order interference is therefore

\[
I_2^M(A,B)=2\mathfrak M(A,B).
\]

The form `g` is the Lorentzian inner product on `H_2(C)` under the Pauli/Hermitian correspondence. It is diagonally nonnegative on future-causal momentum matrices, but is not a Hilbert inner product.

## 5. Strong-positivity obstruction

### Theorem 5.1 — No edge-level strongly positive decoherence representation

Assume `D` is a finitely additive, Hermitian, strongly positive decoherence functional on the event algebra `P(E)` and

\[
D(A,A)=M(A)
\]

for every event `A`. Then

\[
M\equiv0.
\]

In particular, if two edges have nonzero Plücker spread, no such `D` exists.

### Proof

For every singleton `e`,

\[
D(\{e\},\{e\})=M(\{e\})=0.
\]

Strong positivity applied to the two events `\{e\}` and `B` says

\[
\begin{pmatrix}
0&D(\{e\},B)\\
\overline{D(\{e\},B)}&M(B)
\end{pmatrix}
\]

is positive semidefinite. Its determinant is `-|D({e},B)|²`, hence

\[
D(\{e\},B)=0.
\]

Finite additivity in the first argument gives `D(A,B)=0` for all `A,B`, hence `M(A)=D(A,A)=0`. ∎

### Minimal witness

Take

\[
\psi_1=(1,0),\qquad \psi_2=(0,1).
\]

Then

\[
M(\{1\})=M(\{2\})=0,
\qquad
M(\{1,2\})=1.
\]

A strongly positive decoherence functional with zero singleton diagonals would force its off-diagonal singleton entry to vanish, contradicting the nonzero two-edge mass.

### Interpretation

The Plücker mass capacity is grade-2, but it is not the diagonal of a nontrivial standard strongly positive decoherence functional whose atomic histories are individual null edges. It should therefore be treated either as an observable on edge histories or as a genuine measure on a relational history space.

## 6. Canonical pair-history lift

Let

\[
\Pi_2(E)=\{\{e,f\}\subseteq E:e\ne f\}
\]

be the unordered pair-history space. Define the additive measure

\[
\nu(S)=\sum_{p\in S}q_p,
\qquad S\subseteq\Pi_2(E).
\]

For an edge event `A`, define its pair incidence event

\[
C_2(A)=\{p\in\Pi_2(E):p\subseteq A\}.
\]

Then

\[
\boxed{M(A)=\nu(C_2(A)).}
\]

### Theorem 6.1 — Uniqueness

The additive pair measure `ν` is the unique additive measure on `P(Π₂(E))` satisfying

\[
M(A)=\nu(C_2(A))
\]

for every edge event `A`.

### Proof

For `A={e,f}`, the pair-incidence event is the singleton `{{e,f}}`. Hence every such lift must assign

\[
\nu(\{\{e,f\}\})=M(\{e,f\})=q_{ef}.
\]

Additivity then fixes `ν` uniquely. ∎

### Consequence

Mass has relational order exactly two whenever some Plücker bracket is nonzero. It cannot be decomposed into nonnegative one-edge weights, but it has a canonical decomposition into nonnegative two-edge weights.

## 7. Coherent pair histories and induced higher-order edge interference

Let `K` be a positive-semidefinite Hermitian matrix indexed by `Π₂(E)`. Define, for pair events `S,T`,

\[
D_K(S,T)
=
\sum_{p\in S}\sum_{q\in T}
\overline{z_p}K_{pq}z_q.
\]

This is a strongly positive decoherence functional on the pair-history algebra. Pull it back to edge events:

\[
\mu_K(A)=D_K(C_2(A),C_2(A)).
\]

### Theorem 7.1 — Interference-degree bound

The finite Möbius expansion of `μ_K` has support only on subsets of cardinality `2`, `3`, or `4`:

\[
\mu_K(A)=\sum_{U\subseteq A}c_U,
\]

where

\[
\boxed{
c_U=
\sum_{\substack{p,q\in\Pi_2(E)\\p\cup q=U}}
\overline{z_p}K_{pq}z_q
}
\]

and `c_U=0` for `|U|<2` or `|U|>4`.

Therefore all fifth- and higher-order edge interference vanishes.

Additional cases:

1. If `K` is diagonal, only `|U|=2` survives, and `μ_K` reduces to the Plücker mass capacity when `K_pp=1`.
2. If `K_pq=0` whenever `p∩q=∅`, then `|U|=4` vanishes; only second- and third-order edge interference can occur.
3. Third-order coefficients measure coherence between pair histories sharing one strand.
4. Fourth-order coefficients measure coherence between disjoint pair histories.

### Proof

Write `1_{p⊆A}` for the pair-incidence indicator. Then

\[
\mu_K(A)
=
\sum_{p,q}
\overline{z_p}K_{pq}z_q
1_{p\subseteq A}1_{q\subseteq A}.
\]

But

\[
1_{p\subseteq A}1_{q\subseteq A}=1_{p\cup q\subseteq A}.
\]

Grouping terms by `U=p∪q` gives the stated Möbius expansion. Since `p` and `q` each contain two elements, `2≤|p∪q|≤4`. ∎

### Explicit three-edge example

Take

\[
\psi_1=(1,0),\qquad
\psi_2=(0,1),\qquad
\psi_3=\frac1{\sqrt2}(1,1).
\]

Then

\[
z_{12}=1,
\qquad
z_{13}=\frac1{\sqrt2},
\qquad
z_{23}=-\frac1{\sqrt2}.
\]

Let `K` be the rank-one all-ones matrix on the three pair histories. Then `D_K` is strongly positive, but its edge pullback satisfies

\[
\mu_K(12)=1,
\quad
\mu_K(13)=\mu_K(23)=\frac12,
\quad
\mu_K(123)=1,
\]

so

\[
I_3(1,2,3)=-1.
\]

This is not fundamental post-quantum interference. It is ordinary pair-history quantum coherence viewed through the nonlinear incidence map `A ↦ C₂(A)`.

## 7.2 Abelian holonomy-phase corollary

Suppose each pair history `p` is also a causal diamond carrying a gauge-invariant Abelian holonomy phase

\[
h_p=e^{i\theta_p}\in U(1).
\]

Replace the Plücker amplitude by

\[
a_p=h_p z_p.
\]

Then the diagonal pair weights are unchanged:

\[
|a_p|^2=|z_p|^2.
\]

Hence a fully decohered pair family has the same invariant mass capacity regardless of the Abelian diamond phase. By contrast, every off-diagonal coherence term acquires the relative phase

\[
\overline{a_p}K_{pq}a_q
=
\overline{z_p}K_{pq}z_q e^{i(\theta_q-\theta_p)}.
\]

Therefore:

> Abelian curvature phase is invisible to diagonal Plücker mass but visible to coherent three- and four-edge interference.

This gives a precise finite bridge between the program's Plücker/Bargmann phase layer and its causal-diamond holonomy layer. It also supplies a clean falsifier: if the proposed history dynamics has no stable off-diagonal pair coherence, gauge holonomy cannot influence the mass-history sector through this channel.

## 8. General exterior-rank theorem

Let `v_e∈C^d` and define

\[
M_d(A)=\det\left(\sum_{e\in A}v_ev_e^\dagger\right).
\]

Then

\[
\boxed{
M_d(A)=
\sum_{\substack{S\subseteq A\\|S|=d}}
|\det V_S|^2.
}
\]

Consequently:

1. `M_d` is a pure grade-`d` capacity: its Möbius transform is supported on `d`-element subsets.
2. Its canonical additive lift lives on the `d`-subset history space.
3. If `d>1` and `M_d` is nonzero, it cannot be the diagonal of a strongly positive decoherence functional on the original singleton history algebra.
4. A coherent decoherence kernel on `d`-subset histories induces base-event interference degree at most `2d`.

The physical null-spinor mass theorem is the `d=2` case.

## 9. Physical consequence for consistent histories

The consistent-histories null-edge program should use two related but distinct history levels:

1. **One-history level:** null paths/edges carry propagation amplitudes and class operators.
2. **Two-history level:** unordered edge or path pairs carry Plücker mass amplitudes and causal-diamond holonomy data.

Invariant mass is not a probability weight of an individual null edge. It is the additive weight of a relational two-history sector. This matches the independent fact that gauge curvature on a causal DAG is detected by comparing two paths across a diamond.

A sharpened principle is therefore:

> The first nontrivial local observables of the null-edge program live on two-histories: Plücker spread measures timelike mass, while path-pair holonomy measures gauge curvature.

## 10. Lean formalization plan

Suggested module:

```text
PhysicsSM/NullStrand/Histories/ExteriorMassMeasure.lean
```

Priority theorem surface:

```lean
massCapacity_eq_sum_pairWeights
massCapacity_nonneg
massCapacity_mono
massCapacity_singleton_eq_zero
massCapacity_i2_eq_crossPlucker
massCapacity_i3_eq_zero
massCapacity_mobius_support_eq_pairs

massBimeasure_apply
massBimeasure_diag_eq_massCapacity
massBimeasure_cross_eq_half_crossPlucker
massBimeasure_sl2_invariant

stronglyPositive_zeroDiagonal_row
massCapacity_not_stronglyPositiveDiagonal_of_noncollinear

pairIncidenceMeasure
pairLift_recovers_massCapacity
pairLift_unique
massCapacity_relationalOrder_eq_two

pairDecoherence_stronglyPositive
pairPullback_mobiusCoefficient
pairPullback_support_card_le_four
pairPullback_diagonal_recovers_massCapacity
pairPullback_no_fourthInterference_of_intersectionLocal
threeEdge_pairCoherence_has_nonzero_I3
```

Generalization module:

```text
PhysicsSM/NullStrand/Histories/ExteriorRankMeasure.lean
```

```lean
detCapacity_eq_sum_subdetSq
detCapacity_mobius_support_card_eq_rank
detCapacity_gradeD
detCapacity_uniqueExteriorLift
coherentExteriorLift_interferenceDegree_le_two_mul_rank
```

## 11. Novelty boundary

Not new individually:

- Cauchy–Binet and squared-minor subset weights;
- Plücker coordinates;
- Sorkin-grade set functions;
- strong positivity of decoherence functionals;
- determinant/volume sampling.

Potentially new as a combined result:

- invariant null-spinor mass as a pure grade-2 capacity;
- the explicit Lorentzian mass bimeasure;
- the strong-positivity obstruction on single-edge histories;
- the unique pair-history lift;
- the topology-controlled `2/3/4` interference hierarchy for coherent pair histories;
- the conclusion that mass and causal-diamond curvature naturally share a two-history layer.

A preliminary literature search did not locate this complete theorem package, but that is not a guarantee of priority.
